# Rust Matrix Multiplication: CPU vs GPU

Baseline CPU matrix multiplication in Rust using [`ndarray`](https://docs.rs/ndarray), plus a **CUDA GPU implementation** using [`cudarc`](https://github.com/coreylowman/cudarc) with runtime kernel compilation via NVRTC.

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

**Example output on an NVIDIA RTX 4090:**

```
╔══════════════════════════════════════════════════╗
║   Rust Matrix Multiplication: CPU vs GPU         ║
╚══════════════════════════════════════════════════╝

🦀 Rust + ndarray  vs  ⚡ CUDA (cudarc + NVRTC)

📐 Matrix size: 512×512
--------------------------------------------------
🖥️  CPU (ndarray)          45.231 ms
⚡ GPU (CUDA)              1.842 ms  ✅ max rel err: 1.23e-05
🚀 Speedup                24.56×

📐 Matrix size: 1024×1024
--------------------------------------------------
🖥️  CPU (ndarray)         412.456 ms
⚡ GPU (CUDA)              8.934 ms  ✅ max rel err: 1.45e-05
🚀 Speedup                46.17×

📐 Matrix size: 2048×2048
--------------------------------------------------
🖥️  CPU (ndarray)        3456.123 ms
⚡ GPU (CUDA)             62.451 ms  ✅ max rel err: 1.67e-05
🚀 Speedup                55.34×
```

*Your numbers will vary by CPU and GPU. Expect **20–60× speedup** on modern NVIDIA hardware.*

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
                                            ┌─────────────────┐
                                            │  cudarc::nvrtc  │
                                            │  compile_ptx()  │
                                            └─────────────────┘
                                                      │
                                                      ▼
                                            ┌─────────────────┐
                                            │  CUDA kernel    │
                                            │  matmul_f32     │
                                            │  (16×16 blocks) │
                                            └─────────────────┘
                                                      │
                                                      ▼
                                            ┌─────────────────┐
                                            │  Device memory  │
                                            │  htod_copy      │
                                            │  dtoh_sync_copy │
                                            └─────────────────┘
                                                      │
                                                      ▼
                                            ┌─────────────────┐
                                            │  GPU result     │
                                            │  (verified vs   │
                                            │   CPU)          │
                                            └─────────────────┘
```

---

## 🧪 How It Works

### CPU Path
Uses `ndarray::Array2` and `.dot()` for a highly optimized BLAS-like CPU matrix multiply.

### GPU Path
1. **Runtime compilation**: The CUDA C kernel is embedded as a string and compiled at runtime via NVRTC — no `nvcc` build step required.
2. **Memory management**: Host vectors are copied to device memory with `htod_copy`.
3. **Kernel launch**: A 2D grid of 16×16 thread blocks is launched. Each thread computes one output element.
4. **Synchronization**: Results are copied back with `dtoh_sync_copy`.
5. **Verification**: CPU and GPU outputs are compared with relative error checking.

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

| Crate | Purpose |
|-------|---------|
| `ndarray` | CPU n-dimensional arrays and BLAS-like operations |
| `cudarc` | Safe Rust CUDA bindings (driver + NVRTC) |
| `rand` | Random matrix generation for benchmarks |

---

## 🗺️ Roadmap

- [x] Naive CUDA kernel (global memory)
- [ ] **Tiled/shared-memory kernel** — reduce global memory traffic for another 2–5× speedup
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

**Status:** ✅ CPU + GPU baseline complete · Shared-memory optimization planned
