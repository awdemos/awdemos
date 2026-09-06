# TensorZero demo — LLM gateway observability on a self-hosted stack

A production-style TensorZero deployment: the [TensorZero gateway](https://github.com/tensorzero/tensorzero)
routes named functions over local vLLM models through a [Switchyard](https://github.com/NousResearch/switchyard)
proxy, records every inference and raw model call in Postgres, and the TensorZero UI
renders observability, traces, and a working playground over that data.

## What this demo covers

| Feature          | Where it lands                                                              |
| ---------------- | --------------------------------------------------------------------------- |
| Observability    | Postgres store; UI → `Observability → Inferences / Episodes / Models`         |
| Traces           | Per-inference raw request/response, latency, token usage, cached flag          |
| Playground       | UI → `Playground` — runs real inferences through the same function config      |
| Cost tracking    | Optional per-provider `cost` entries → dollars in the usage API (`/internal/models/usage`); left unset here — no authoritative price sheet for relayed self-hosted models, so rows keep `cost: null` |
| OTel export      | Wired for any OTLP endpoint (Jaeger, Grafana Tempo, …); off until a collector exists |
| A/B routing      | `router_chat` function splits traffic across three model variants with fallback |
| Rate limiting    | Per-API-key cap backed by Postgres                                            |
| Feedback         | Boolean metric (`useful`) + comment feedback on any inference                  |

## Layout

```
tensorzero-gateway/
├── config/tensorzero.toml        # gateway config (models, functions, rate limits, metrics, export)
├── systemd/tz-postgres.service   # Postgres 17 on :5433
├── systemd/tz-gateway.service    # gateway on :3000 (migrations run as ExecStartPre)
├── systemd/tz-ui.service         # UI on :8181, plus optional caddy reverse proxy
├── etc/caddy/Caddyfile           # TLS-terminating reverse proxy for the UI (optional)
├── bin/tz-ui-run.sh              # UI launcher (loopback bind or behind caddy)
└── README.md
```

## Topology

```
client ──► TensorZero gateway :3000 ──► Switchyard :4000 ──► vLLM fleet
                │
                ├── Postgres :5433 (inferences, model calls, feedback)
                └── UI :8181 ──gateway internal API──► dashboard over the same store
```

## Quick start

```bash
# 1. env file with credentials (never commit) — gateway auth + Postgres
cat > secrets/tz-postgres.env <<'EOF'
TENSORZERO_API_KEY=<generate: openssl rand -hex 32>
DATABASE_URL=postgres://postgres:postgres@127.0.0.1:5433/tensorzero
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
EOF
chmod 600 secrets/tz-postgres.env

# 2. bring up the stack
cp systemd/*.service ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now tz-postgres tz-gateway tz-ui

# 3. verify
curl -s localhost:3000/status
curl -s localhost:8181/api/tensorzero/status    # via SSH tunnel for loopback UI
```

## Run an inference

```bash
source secrets/tz-postgres.env
curl -s -X POST localhost:3000/inference \
  -H "Authorization: Bearer $TENSORZERO_API_KEY" \
  -H 'Content-Type: application/json' \
  -d '{"function_name":"router_chat","input":{"messages":[{"role":"user","content":[{"type":"text","text":"Reply with exactly the word: pong"}]}]}}'
```

The response names the chosen variant (`glm`, `flash_next`, or `qwen27b`); the traffic
split is `0.45 / 0.33 / 0.22`, falling back to `auto` if all candidates fail.

Then open the UI: `Observability → Inferences` shows the row,
and the detail view carries the full model-call trace (raw request/response).

## API gotchas that cost me time (so they don't cost you)

- **The UI's internal inference route is form-encoded.** `POST /api/tensorzero/inference`
  wants `application/x-www-form-urlencoded` with a `data` field containing the JSON
  string — a raw-JSON POST returns `Unexpected Server Error`. Same shape for
  `POST /internal/action` (needs `snapshot_hash` and a `tag` object).
- **Bare internal paths don't exist.** `/internal/functions` is a module path, not a
  route — the real ones are suffixed: `/internal/inferences/count` (POST),
  `/internal/feedback/timeseries?function_name=…&metric_name=…&time_window=…`,
  `/internal/models/usage?time_window=…&max_periods=…`.
- **No curl in the UI image.** Debug from inside the container with node fetch.
- **The gateway image's default user has no passwd entry.** Use `podman exec --user 0`.
- **`export.otlp.traces` validates strictly.** The 2026.6.0 gateway only accepts
  `enabled`, `format`, `extra_headers`, `include_content` — there is no `protocol`
  key (older docs use it); an unknown key makes the gateway exit on boot. Pre-flight
  a new config with a throwaway container before restarting the real gateway.

## Common traps

- **"No datasets found" / empty Evaluations are real states** — the pages render
  correctly with zero rows when you haven't created datasets or run evaluations yet.
- **Loopback-only UI can look "unreachable from my laptop."** Bind the UI to your
  tailnet/host IP (edit `bin/tz-ui-run.sh` publish port) or front it with the provided
  caddy config — don't poke a hole through the gateway.
- **`du` over NFS-backed pgdata hangs** — check disk usage another way.
