# Rust Matrix Multiplication: CPU vs GPU

Baseline CPU matrix multiplication in Rust using [`ndarray`](https://docs.rs/ndarray), plus a **CUDA GPU implementation** using [`cudarc`](https://github.com/coreylowman/cudarc) with runtime kernel compilation via NVRTC.

This is a runnable starting point, not a published benchmark result. Run it on your own hardware to get numbers; see [BENCHMARKS.md](../../../BENCHMARKS.md) for the evidence template required before claiming a speedup.

## 🚀 Quick Start

### Requirements

- **Rust** toolchain (stable)
- **NVIDIA GPU** with CUDA drivers installed
- **CUDA Toolkit** (for NVRTC runtime compilation)

### Run

```bash
cd demos/rust/rust_matrix_multiplication
cargo run --release
```

Without a usable GPU the program prints `GPU skipped` and still runs the CPU path. Example output shape (numbers are illustrative; no specific hardware or run is asserted here):

```
╔══════════════════════════════════════════════════╗
║   Rust Matrix Multiplication: CPU vs GPU         ║
╚══════════════════════════════════════════════════╝

🦀 Rust + ndarray  vs  ⚡ CUDA (cudarc + NVRTC)

📐 Matrix size: 512×512
--------------------------------------------------
🖥️  CPU (ndarray)         <measured> ms
⚡ GPU kernel only        <measured> ms  ✅ max rel err: <measured>
🔁 GPU + transfers       <measured> ms  (H2D + kernel + D2H)
🚀 Speedup (kernel)      <measured>×
```

Report results with the hardware, driver/toolkit versions, commit, exact command, and raw output. Do not treat the numbers above as a claim about any specific device.

---

## 🏗️ Architecture

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  Random     │────▶│   ndarray   │────▶│   CPU result│
│  matrices   │     │   .dot()    │     │   (baseline)│
└─────────────┘     └─────────────┘     └─────────────┘
       │
       └──────────────────────────────────────────────┐
                                                      ▼
                                            ┌──────────────────┐
                                            │  ONE-TIME SETUP  │
                                            │  CudaDevice::new │
                                            │  NVRTC compile   │
                                            │  load_ptx        │
                                            └──────────────────┘
                                                      │
                                    (reused, never timed)
                                                      │
                                                      ▼
                                            ┌──────────────────┐
                                            │  TIMED REGION    │
                                            │  kernel launch   │
                                            │  synchronize     │
                                            └──────────────────┘
```

---

## 🧪 How It Works

### CPU Path

Uses `ndarray::Array2` and `.dot()` for a BLAS-backed CPU matrix multiply.

### GPU Path

1. **One-time setup (untimed):** create the CUDA device, compile the embedded CUDA C kernel with NVRTC, and load the PTX module. This is done once in `GpuMatmul::new()` and reused for every matrix size.
2. **Inputs (untimed for kernel-only):** copy host vectors to device buffers with `htod_copy`.
3. **Timed region:** launch a 2D grid of 16×16 thread blocks and call `synchronize()`. Each thread computes one output element. Only this span is reported as "GPU kernel only".
4. **Result (untimed for kernel-only):** copy the output back with `dtoh_sync_copy` and compare it against the CPU result with relative error checking.
5. **End-to-end timing:** a separate measurement wraps allocation, H2D copy, launch, sync, and D2H copy so transfer overhead is visible rather than hidden.

A single untimed warm-up run precedes each size to keep first-use driver effects out of the reported numbers. These are single-run timings for illustration, not a statistically rigorous benchmark. A Criterion.rs suite is on the roadmap.

### CUDA Kernel

```cuda
__global__ void matmul_f32(const float* a, const float* b, float* c, int n) {
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;

    if (row < n && col < n) {
        float sum = 0.0f;
        for (int k = 0; k < n; k++) {
            sum += a[row * n + k] * b[k * n + col];
        }
        c[row * n + col] = sum;
    }
}
```

---

## 📦 Dependencies

| Crate     | Purpose                                           |
| --------- | ------------------------------------------------- |
| `ndarray` | CPU n-dimensional arrays and BLAS-like operations |
| `cudarc`  | Safe Rust CUDA bindings (driver + NVRTC)          |
| `rand`    | Random matrix generation for benchmarks           |

---

## 🗺️ Roadmap

- [x] Naive CUDA kernel (global memory)
- [x] Timing that excludes device setup, NVRTC compilation, and transfers from the kernel number
- [ ] **Tiled/shared-memory kernel** — reduce global memory traffic (measure with the same methodology)
- [ ] **cuBLAS backend** — call `cublasSgemm` for vendor-optimized performance
- [ ] **Criterion.rs benchmark suite** — statistical benchmarking with plots
- [ ] **Half-precision (FP16)** — test `__half` tensor core throughput on Ampere+

---

## 📚 Resources

- [cudarc docs](https://docs.rs/cudarc)
- [ndarray docs](https://docs.rs/ndarray)
- [CUDA C Programming Guide — Matrix Multiplication](https://docs.nvidia.com/cuda/cuda-c-programming-guide/index.html#shared-memory)
- [NVIDIA cuBLAS](https://docs.nvidia.com/cuda/cublas/)

---

**Status:** CPU + GPU baseline with separated setup/compute/transfer timings. Shared-memory optimization planned.
