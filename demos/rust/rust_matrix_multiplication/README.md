# Rust Matrix Multiplication

Baseline CPU matrix multiplication in Rust using [`ndarray`](https://docs.rs/ndarray). This is a foundational learning project toward GPU-accelerated linear algebra with CUDA bindings.

## 🎯 Current State

Pure Rust CPU implementation using `ndarray::Array2` and `.dot()` for general matrix multiplication.

## 🚀 Run It

```bash
cd demos/rust/rust_matrix_multiplication
cargo run
```

**Output:**
```
Matrix A:
1.00 2.00 3.00
4.00 5.00 6.00

Matrix B:
7.00 8.00
9.00 10.00
11.00 12.00

Result of A * B:
58.00 64.00
139.00 154.00
```

## 📐 Extending to GPU (Roadmap)

| Step | Approach | Crate |
|------|----------|-------|
| 1 | **CUDA kernels in Rust** | [`cust`](https://github.com/Rust-GPU/Rust-CUDA) or [`cudarc`](https://github.com/coreylowman/cudarc) |
| 2 | **CuBLAS bindings** | [`cublas-sys`](https://docs.rs/cublas-sys) for vendor-optimized BLAS |
| 3 | **Benchmark suite** | [`criterion.rs`](https://github.com/bheisler/criterion.rs) for CPU vs GPU comparison |
| 4 | **Batch operations** | Test throughput at 1024×1024, 4096×4096, and beyond |

### Example: Future CUDA Kernel Structure

```rust
// With cudarc: allocate device buffers, launch kernel, copy back
let dev = CudaDevice::new(0)?;
let a_dev = dev.htod_copy(a_vec)?;
let b_dev = dev.htod_copy(b_vec)?;
let mut c_dev = dev.alloc_zeros::<f32>(m * n)?;

// Launch custom matmul kernel or call cuBLAS
// ...

let c_host = dev.sync_reclaim(c_dev)?;
```

## 🧪 Benchmarking

Once GPU code is added, compare against the CPU baseline:

```bash
cargo bench  # criterion.rs benchmark comparing ndarray vs CUDA
```

## 📚 Resources

- [ndarray docs](https://docs.rs/ndarray)
- [Rust CUDA Working Group](https://github.com/Rust-GPU)
- [NVIDIA cuBLAS](https://docs.nvidia.com/cuda/cublas/)

---

**Status:** CPU baseline complete · CUDA extension planned
