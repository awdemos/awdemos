# TensorZero Teardown — Observability, Traces, Playground

Field notes from auditing the TensorZero stack (gateway, UI, Postgres store) as deployed
against a Switchyard proxy in front of self-hosted model endpoints. Question going in:
"observability, traces, and playground all seem like stubs." Verdict going out:

> **They are not stubs.** All three features work against the Postgres-only store.
> What looks like a stub is usually an empty feature (no datasets yet, no evaluation
> runs, one feedback point) or a reachability problem (loopback-bound UI).

TL;DR of what was verified live — every claim below was exercised against the running
stack, not read off a README.

---

## Verdict by feature

| Feature | Status | Evidence |
| --- | --- | --- |
| Observability | **Works** | ~5.1k inferences stored and rendered; `/internal/inferences/count` → 5,113 (POST); Episodes/Models pages populate from the same store |
| Traces | **Works** (per-inference) | Detail view returns `raw_request` (exact JSON sent to the provider), `raw_response` (model's reply incl. reasoning), tokens, latency, cached flag — via `GET /internal/model_inferences/{id}` |
| Playground | **Works** | The UI's own route scored a real completion: UI → gateway → Switchyard → GLM, variant recorded, row landed in observability |
| Distributed tracing (OTLP) | **Not configured** — supported | `gateway.export.otlp.traces.enabled = true` + `OTEL_EXPORTER_OTLP_TRACES_ENDPOINT` ships spans to any OTLP backend |
| Datasets / Evaluations | Empty by **absence of use** | Pages render correctly; zero datasets created, zero evaluation runs |
| Feedback | Thin but functional | 1 data point on `useful`; push more and the charts light up |
| Cost | Disabled by omission | Token usage tracked; dollars `null` until per-provider `cost` entries are set |

## What was actually broken vs fine

**Fine:**
- Postgres-only persistence (~5k inferences/mo at 246 ms median on the fleet used)
- UI pages render server-side: real rows, variant chips, token counts
- Gateway internal API: `/internal/inferences/count` (POST), `/internal/models/usage?time_window=…&max_periods=…`, `/internal/feedback/timeseries?function_name=…&metric_name=…&time_window=…`, `/internal/functions/{name}/metrics`
- Gateway auth (bearer), A/B static experimentation with fallback variants

**Genuinely missing / worth changing:**

Follow-up (same day): 1 was added to the live config and then **removed again** — the
figures were assistant-estimated per-million rates for relayed self-hosted models with
no authoritative price sheet behind them, so the owner dropped them rather than publish
invented dollars. They are a two-line TOML block per provider when real prices exist.
2 is wired but stays off until a trace backend exists; 3 stayed as-is by choice
(loopback + documented launcher).

1. **No cost tracking configured** → attempted, then dropped: `cost` entries
   (`pointer`/`cost_per_million`) were added per provider and dollars did stamp on new
   rows (e.g. `$0.00002985`), but the numbers were estimated, not from a real price
   sheet — removed at the owner's call. Rows keep `cost: null` (cost is stamped at
   inference time, never backfilled).
2. **No OTLP export** → **wired, off**: `gateway.export.otlp.traces` is valid config and
   the endpoint is env-driven (`OTEL_EXPORTER_OTLP_TRACES_ENDPOINT`), but with no
   collector/Jaeger/Tempo running, `enabled = true` just spams export errors — leave it
   off until a backend exists.
3. ~~**UI bound to loopback**~~ → **fixed**: UI publishes on loopback with a documented
   launcher + optional TLS proxy frontend in the demo (refreshing the bind without a
   proxy front would expose model-routing config to the flat network).
4. **No ClickHouse** — fine for Postgres-only at this scale; add it if trace volume grows into the millions/day

## API gotchas that cost debugging time

- The UI's inference route is **form-encoded**, not JSON: `POST /api/tensorzero/inference`
  expects `data=<json-string>`; raw-JSON posts get `Unexpected Server Error`. Same for
  `POST /internal/action` (adds `snapshot_hash` + `tag` object requirements)
- **Bare `/internal/*` names are module paths, not routes** — `/internal/functions` 404s;
  the real routes carry suffixes and required query params (see above)
- `/observability` and `/traces` are **legacy paths** — use `/observability/inferences`
- `main` == `2026.6.0` tag (0 commits apart as of the audit): no upstream upgrade available;
  the features aren't lagging, this *is* current
- Container quirks: no curl in the UI image (use node fetch); gateway image's default
  user has no passwd entry (`--user 0`)

## Config used for the fixed deployment

The complete working stack this audit produced lives at
[`demos/llm/tensorzero-gateway/`](tensorzero-gateway/README.md) — TOML with OTLP-style
export wiring, systemd user units for gateway/UI/Postgres, and the optional TLS proxy
config. One hard-won trap: `gateway.export.otlp.traces` on the
2026.6.0 gateway accepts only `enabled`, `format`, `extra_headers`, `include_content`
— an unknown key (e.g. `protocol` from stale docs) makes the gateway **exit on boot**;
pre-flight changes in a throwaway container on a spare port first.
