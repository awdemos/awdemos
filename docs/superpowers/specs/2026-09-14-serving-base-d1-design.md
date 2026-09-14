# D1 · serving-base — Design

**Date:** 2026-09-14
**Status:** approved design, pending spec review
**Parent spec:** [2026-09-14-inference-platform-demos-design.md](./2026-09-14-inference-platform-demos-design.md) — that document governs arc-level decisions; this spec only adds D1 detail and defers what later demos own.

## Purpose

Stand up Ternary-Bonsai-1.7B-Q2_0 under `llama-server` on single-node k3s, with health checks, Prometheus scrape, and a reproducible public latency report. D1 also creates the shared harness that D2–D5 reuse.

## Environment facts (verified 2026-09-14 on target machine)

- Fedora 44 **Toolbx** container (kernel/host shared; systemd is init here); hostname `toolbx`.
- GPU: **NVIDIA GeForce RTX 4060 Ti, 16380 MiB**, driver 610.57.04; `/dev/nvidia*` nodes visible.
- k3s v1.32.3 binary present at `~/.local/bin/k3s`, **not initialized**.
- kubectl present; **docker daemon unavailable**; **podman available** (`/usr/bin/podman`); `nvidia-ctk` present; cmake, go, curl, python3 present.
- **No nvcc** — fork must build inside a CUDA-devel container stage.
- huggingface.co reachable; model file resolves.

## Components

### 1. `shared/llama-server/` — runtime image

- Multi-stage Dockerfile:
  - Stage 1 `nvidia/cuda:12.8-devel`: clone `PrismML-Eng/llama.cpp`, checkout `FORK_COMMIT` (pinned in `FORK_COMMIT` file), `cmake -B build -DGGML_CUDA=ON`, build `llama-server`.
  - Stage 2 `nvidia/cuda:12.8-runtime`: copy `llama-server` binary + required libs.
- `build.sh`: podman build → `podman save` → `k3s ctr images import`.
- Base image versions and fork pin recorded in this directory (arc spec: pin lives here).

### 2. `shared/deploy/` — k8s manifests

- Namespace `inference`.
- Deployment `llama-server`: container args `-m /models/Ternary-Bonsai-1.7B-Q2_0.gguf -c 8192 --metrics -np 4`; resource limit `nvidia.com/gpu: 1`; model volume as hostPath (base manifest uses `/models`; per-machine kustomize patch points it at the real directory, default `$HOME/inference-platform/models`); readiness/liveness probes on `/health`.
- Service (ClusterIP) on llama-server port.
- Prometheus Deployment + scrape config targeting pod annotations; pods carry `prometheus.io/scrape` annotations. Prometheus image version pinned in the manifest.
- Kustomize base here; per-demo overlays come later (D5 model swap).

### 3. `shared/platctl/` — Go CLI (D1-minimal)

- `platctl probe --suite <yaml> --out <dir>`: runs fixed prompt suite against the OpenAI-compatible `/v1/chat/completions` endpoint, single stream, concurrency 1.
- Measures from the SSE stream: TTFT, per-token ITL, output tok/s; aggregates p50/p95/p99; writes latency JSON + rendered Markdown report.
- Report header includes: fork commit, model file sha256, GPU model, driver version, timestamp, suite config hash.
- Seams for later: load-profile interface (D2 sweeps), OTel span hooks (D3) — interfaces defined, not implemented.

### 4. `shared/prompts/latency-suite.yaml`

- Fixed prompt set (≥10 prompts, varied lengths), pinned generation settings (temperature/top-p/top-k per vendor recommendation), max tokens, seeds where applicable.

### 5. `serving-base/`

- `README.md`: what it is, bring-up order, how to regenerate the report.
- `reports/`: generated artifacts (JSON + Markdown), committed.
- Bring-up scripts (also at arc root or here — decision: `serving-base/scripts/`):
  - `00-setup-k3s.sh` — systemd unit for k3s server, start, wait Ready.
  - `10-setup-nvidia-runtime.sh` — write k3s containerd `config.toml.tmpl` from nvidia-container-toolkit template.
  - `20-build-image.sh` — delegates to `shared/llama-server/build.sh`.
  - `30-apply-manifests.sh` — fetch model (pinned revision + sha256 verify) into /models, kubectl apply.
  - `40-report.sh` — port-forward, run platctl probe, write reports.

## Data flow

`platctl` → Service → llama-server (single stream, SSE) → TTFT/ITL measured client-side → JSON+Markdown artifacts → committed under `serving-base/reports/`.

## Error handling

- Model fetch: sha256 mismatch → fail loudly, never serve unverified weights.
- Probe: non-200 or malformed SSE → abort run, no partial report artifacts committed.
- Bring-up scripts: `set -euo pipefail`, each step idempotent where practical.

## Testing / verification

1. `kubectl get nodes` → Ready; `kubectl -n inference get pods` → Running/Ready.
2. `/health` returns 200; `/metrics` exposes llama-server Prometheus metrics.
3. `platctl probe` completes; report JSON + Markdown regenerated and committed.
4. From clean checkout: scripts 00→40 in order reproduce 1–3.

## Out of scope (deferred per arc spec)

- Load sweeps/saturation (D2), dashboards/alerts/tracing (D3), cost instrumentation (D4), quant ladder + evals (D5).
- Multi-node, auth, TLS.
- Committing model weights to the repo (hostPath only; fetch script pins revision + hash).

## Risks

| Risk | Mitigation |
|---|---|
| k3s-in-toolbx quirks (cgroups, iptables, sandboxing) | scripts use documented flags (`--disable traefik` etc.); fallback notes in README |
| nvidia containerd template drift across k3s/toolkit versions | template generated from installed `nvidia-container-toolkit` at setup time, not committed |
| llama-server `--metrics`/`--health` flag differences in fork | verify at image build time; fail build if flags unrecognized |
| Eval/report variance | pinned suite, settings, and fork commit; report records suite config hash |
