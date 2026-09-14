# Inference Platform Demo Arc — Design

**Date:** 2026-09-14
**Status:** approved design, pending spec review
**Level:** arc-level spec. Each demo (D1–D5) gets its own spec → plan → implementation cycle. This document is the shared reference those specs derive from.

## Goal and audience

Build a five-demo arc inside `awdemos` that demonstrates production LLM inference engineering on a single local GPU. Two audiences:

- **Senior/staff IC roles** — depth signals: saturation behavior, instrumentation, honest benchmarking.
- **Consulting / B2B** — production-readiness signals: cost visibility, observability, reproducibility.

Portfolio axiom from the original ideation: *talk is cheap; a live, instrumented serving stack is the portfolio.* "Public" means reproducible committed artifacts, not a live endpoint (single local GPU, no hosting assumption).

## Hard constraints

- **One local GPU:** RTX 4080 / 4070 Ti Super class, **16 GB VRAM**, CUDA.
- Ruled out by that constraint: multi-node serving, MIG partitioning, cloud spot fallback, FP8 deep-dive, multi-region failover, distributed training. (These remain future demos only if hardware changes.)
- Repo conventions: self-contained demos, code over YAML, kebab-case dirs, mermaid diagrams, no committed secrets, no GitHub Actions.

## Model decision

**Ternary-Bonsai-1.7B** ([model card](https://huggingface.co/prism-ml/Ternary-Bonsai-1.7B-gguf)):

- Base: Qwen3-1.7B, 1.72B params, Apache-2.0, 32k context.
- Weights: ternary (1.58-bit, values in {-1, 0, +1}) packed as GGUF Q2_0 g128 — 2.125 bpw, 442 MB.
- Ships two files: `Ternary-Bonsai-1.7B-Q2_0.gguf` (442 MB, recommended) and `Ternary-Bonsai-1.7B-F16.gguf` (3.44 GB, FP16 baseline / re-quantization source).
- Vendor claims of interest: Q2_0 near-lossless vs FP16 for ternary weights (KL ≈ 0, PPL ratio 1.0048 on wikitext-2), and a published eval table (avg 58.47 vs Qwen3-1.7B's 66.57 on their EvalScope suite). These are *different* claims — representational fidelity vs downstream quality — and D5 re-measures both classes independently.

## Runtime decision

**llama.cpp, PrismML fork** — not vLLM:

- Ternary Q2_0 has no mainline llama.cpp CUDA support yet (CPU/Metal merged upstream; CUDA still in migration as of 2026-09) and vLLM's GGUF path cannot run ternary blocks. CUDA requires building `PrismML-Eng/llama.cpp` (`prism` branch) with `GGML_CUDA=ON`.
- Proven on consumer NVIDIA silicon (third-party RTX testing of ternary Q2_0 via the fork).
- Consequences, stated honestly:
  - Serving is `llama-server` (OpenAI-compatible API), commit-pinned fork build.
  - No native OTel server spans → tracing is client-side from `platctl` + server logs (queue/prefill/decode still observable via the SSE stream).
  - Server-side metrics via llama-server's Prometheus endpoint.

## Arc decomposition

Five demos in dependency order. D1 is built first and owns creation of the shared harness.

### D1 · `serving-base` — self-hosted serving + public latency report

- llama-server (fork build) on single-node k3s, Q2_0 model, health probes, Prometheus scrape.
- Report generator: fixed prompt suite, pinned seeds/settings → latency/throughput JSON + rendered Markdown committed to repo.
- Out of scope: multi-node, auth.

### D2 · `batching-loadtest` — saturation lab

- Go traffic generator (`platctl`) sweeping concurrency; find the knee where TTFT/ITL degrade.
- Honest scoping: a 442 MB model will not exhaust 16 GB VRAM. Saturation is measured on parallel-slot scaling and context-length pressure, not KV-cache exhaustion. The knee location is the finding, wherever it lands.
- Out of scope: chaos, long-soak.

### D3 · `observability-spine` — traces, dashboards, alerts

- Client-side OTel traces (queue → prefill → decode) emitted by `platctl`; Grafana dashboards; alert rules on TTFT-p99 drift and error spikes.
- Demonstrated artifact: a report showing a triggered alert from D2-induced saturation.
- Out of scope: full SLO doc (see `sre/`).

### D4 · `cost-dashboard` — cost per token

- GPU util + power via NVML exporter (DCGM is datacenter-only; GeForce needs the NVML path).
- $/1M tokens computed from measured wall power × electricity rate, per model/route; CPU path (`-ngl 0`) enables a CPU-vs-GPU cost comparison for a 436 MB model.
- Out of scope: billing integration.

### D5 · `quant-bakeoff` — quantized serving teardown (capstone)

- Same weights across the quant spectrum: Q2_0 ternary vs Q8_0 vs Q4_K_M (re-quantized from the F16 file) vs FP16, one runtime.
- Quality: pinned eval subset (short MMLU/GSM8K slice) at fixed generation settings.
- **Vendor-claims reproduction:** independently re-measure 2–3 published numbers (PPL ratio; 1–2 eval rows). "Reproduced N/M vendor claims on a 4080" is the headline artifact.
- This demo doubles as the arc's public benchmark teardown (original idea #15).
- Out of scope: FP8 (limited on Ada; future work).

### Queued sixth (not in this arc)

Speculative decoding: Prism ships a DSpark drafter for these models; llama.cpp supports draft-model speculation. Natural follow-on once the platform exists.

## Shared harness (built in D1, reused by D2–D5)

- `shared/llama-server/` — pinned-fork build script + container image.
- `shared/deploy/` — k3s base manifests + Kustomize overlays (monitoring, model swap).
- `shared/platctl/` — Go CLI: load profiles → latency JSON + Markdown report; OTel trace emission lives here.
- `shared/prompts/` — fixed prompt suites, eval config, pinned seeds/generation settings.

## Repo layout

```
demos/llm/inference-platform/
├── README.md               # arc story, mermaid diagram, status table, report index
├── shared/
│   ├── llama-server/
│   ├── deploy/
│   ├── platctl/
│   └── prompts/
├── serving-base/           # D1
├── batching-loadtest/      # D2
├── observability-spine/    # D3
├── cost-dashboard/         # D4
└── quant-bakeoff/          # D5
```

Each demo self-contained per repo convention; `shared/` is the only coupling.

## Publishing

- Reports committed per-demo under `reports/` (JSON + Markdown). Central index in the arc README.
- One linking line from root `BENCHMARKS.md` (no content duplication; it is currently static tables).
- JSON artifacts are shaped so a live status page could be added later without rework.

## Risks

| Risk | Mitigation |
|---|---|
| Fork drift vs upstream llama.cpp | Commit pin; documented upstream-migration watch in arc README |
| llama.cpp metrics maturity vs vLLM | Client-side tracing from `platctl`; server logs as secondary source |
| Eval variance | Pinned generation settings and seeds in `shared/prompts/` |
| Single-GPU demo looks small | Frame correctly: the artifact is reproducibility + instrumentation depth, not fleet size |

## Success criteria for the arc

- D1: latency report regenerates from clean checkout; probes green.
- D2: saturation curve published with knee identified and explained.
- D3: dashboard + alert rules; at least one real triggered alert captured in a report.
- D4: $/1M tokens computed from measured power, broken down per route, with CPU-vs-GPU comparison.
- D5: full teardown including the vendor-claims reproduction box.

## Build order

D1 → D2 → D3 → D4 → D5. Rationale: every later demo consumes the harness and instrumentation of the earlier ones; D5 is cheapest last because it reuses D2's harness and D3/D4's plumbing.
