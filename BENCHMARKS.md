# Performance Benchmarks & Evidence

This repository contains **runnable starting points** for performance work. It does not publish performance numbers as facts unless the raw evidence is checked in alongside them.

A number without a reproducible record is an anecdote. This page explains the record I expect before a measurement is presented as a result, and points to the demos where you can produce your own.

---

## Current status

| Area | Runnable code | Published, attributable results |
|------|---------------|---------------------------------|
| CPU vs GPU matrix multiply (`ndarray` vs `cudarc`/NVRTC) | [`demos/rust/rust_matrix_multiplication/`](demos/rust/rust_matrix_multiplication/) | None yet |
| Embedding / output-head interventions | [`demos/llm/vocab_surgery/`](demos/llm/vocab_surgery/) | None yet |
| Single-GPU serving stack (llama-server, Prometheus) | [`demos/llm/inference-platform/`](demos/llm/inference-platform/) | None yet |
| Container-native CI | [`demos/dagger-go-ci/`](demos/dagger-go-ci/) | None yet |

"No published results" is deliberate. I do not have a controlled, attributable measurement for these demos in this repository, so I do not present one here. If you run them, your numbers will depend on your hardware, drivers, and workload.

---

## Evidence template

To add a result to this page, include all of the following in a committed file under `benchmarks/<YYYY-MM-DD>-<topic>/`:

1. **Claim** - one sentence stating exactly what changed and what metric moved.
2. **Hardware** - CPU model, GPU model, memory, and (for cloud) instance type and region.
3. **Software** - OS and kernel, driver version, CUDA/toolkit version, language/runtime version, and dependency versions or lockfile.
4. **Commit** - the exact git SHA the measurement was taken at.
5. **Command** - the exact command(s), including any env vars and warm-up steps.
6. **Method** - baseline definition, number of iterations, warm-up policy, load pattern, and how variance was handled.
7. **Raw output** - unedited logs, captured to `raw/` (`.txt`, `.json`, or `.csv`).
8. **Analysis** - how the summary number was derived from the raw output.

Example record shape (structure only; no values are asserted):

```markdown
# Claim
<metric> improved from <baseline> to <candidate> on <workload>.

# Environment
- commit: <sha>
- hardware: <cpu>, <gpu>, <ram>
- software: <os/kernel>, <driver>, <cuda>, <runtime>
- dependencies: <lockfile or pinned versions>

# Command
<exact command>

# Method
baseline: <definition>
iterations: <n>   warm-up: <n>   load: <description>

# Raw output
see raw/<file>

# Analysis
<derivation of the summary number from raw output>
```

A chart or summary table is welcome only as a pointer back to this record, never as a substitute for it.

---

## Timing methodology

For GPU measurements, keep setup out of the timed region:

- Device initialization, NVRTC/JIT compilation, module loading, and buffer allocation are **setup**, not benchmark time.
- Host-to-device and device-to-host transfers are real costs. Report them **separately** from kernel time rather than folding them into a "kernel" number or hiding them.
- Include an untimed warm-up and state the policy explicitly.
- Prefer distributions (median and p95) over a single run where feasible; state what you used.

`demos/rust/rust_matrix_multiplication/` implements this split explicitly: "GPU kernel only" measures launch plus synchronization, while "GPU + transfers" measures the full path including copies. See its [README](demos/rust/rust_matrix_multiplication/README.md).

---

## Work in progress

The following are candidates for future, properly recorded measurements:

- **Serving throughput and p95 latency** across quantization formats using the inference-platform harness.
- **Matrix multiply kernels** (naive, tiled/shared-memory, cuBLAS) with Criterion.rs statistics.
- **Container image size and build time** with reproducible Dockerfiles and cached builds.

These are plans, not results. They are listed so the direction is clear and so a reviewer can check whether the evidence eventually arrives.

---

## Get in touch

If you want to reproduce or extend any of this work, open an issue in [awdemos/awdemos](https://github.com/awdemos/awdemos/issues), or reach out via [Vibe Coding Agency](https://vibecodingagency.com/).
