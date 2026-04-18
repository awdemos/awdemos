use ndarray::Array2;
use rand::Rng;
use std::time::Instant;

// ─── CUDA Kernel Source ───────────────────────────────────────────────────────
// A simple square matrix multiplication kernel in CUDA C.
// Each thread computes one element of the output matrix.
const KERNEL_SRC: &str = r#"
extern "C" __global__ void matmul_f32(
    const float* a,
    const float* b,
    float* c,
    int n
) {
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
"#;

// ─── CPU Implementation ───────────────────────────────────────────────────────
fn cpu_matmul(a: &Array2<f32>, b: &Array2<f32>) -> Array2<f32> {
    a.dot(b)
}

// ─── GPU Implementation ───────────────────────────────────────────────────────
fn gpu_matmul(a: &[f32], b: &[f32], n: usize) -> Result<Vec<f32>, Box<dyn std::error::Error>> {
    use cudarc::driver::{CudaDevice, LaunchAsync, LaunchConfig};
    use cudarc::nvrtc::compile_ptx;

    let dev = CudaDevice::new(0)?;

    // Compile the kernel at runtime via NVRTC
    let ptx = compile_ptx(KERNEL_SRC)?;
    dev.load_ptx(ptx, "matmul", &["matmul_f32"])?;

    let kernel = dev.get_func("matmul", "matmul_f32").unwrap();

    // Allocate device memory and copy inputs
    let a_dev = dev.htod_copy(a.to_vec())?;
    let b_dev = dev.htod_copy(b.to_vec())?;
    let mut c_dev = dev.alloc_zeros::<f32>(n * n)?;

    // Launch configuration: 16×16 threads per block
    let block_size = 16u32;
    let grid_size = ((n as u32) + block_size - 1) / block_size;
    let cfg = LaunchConfig {
        grid_dim: (grid_size, grid_size, 1),
        block_dim: (block_size, block_size, 1),
        shared_mem_bytes: 0,
    };

    // Launch kernel
    let n_i32 = n as i32;
    unsafe {
        kernel.launch(cfg, (&a_dev, &b_dev, &mut c_dev, n_i32))?;
    }

    // Copy result back to host
    let c_host = dev.dtoh_sync_copy(&c_dev)?;
    Ok(c_host)
}

// ─── Helpers ──────────────────────────────────────────────────────────────────
fn random_matrix(n: usize) -> Vec<f32> {
    let mut rng = rand::thread_rng();
    (0..n * n).map(|_| rng.gen::<f32>()).collect()
}

fn vec_to_array2(vec: Vec<f32>, n: usize) -> Array2<f32> {
    Array2::from_shape_vec((n, n), vec).unwrap()
}

fn max_relative_error(a: &[f32], b: &[f32]) -> f32 {
    a.iter()
        .zip(b.iter())
        .map(|(x, y)| ((x - y).abs() / y.abs().max(1e-6)))
        .fold(0.0f32, |max, err| max.max(err))
}

// ─── Benchmark ────────────────────────────────────────────────────────────────
fn benchmark_size(n: usize) {
    println!("\n📐 Matrix size: {}×{}", n, n);
    println!("{:-<50}", "");

    let a_vec = random_matrix(n);
    let b_vec = random_matrix(n);

    // ── CPU (ndarray) ──
    let a_arr = vec_to_array2(a_vec.clone(), n);
    let b_arr = vec_to_array2(b_vec.clone(), n);

    let t0 = Instant::now();
    let c_cpu = cpu_matmul(&a_arr, &b_arr);
    let cpu_ms = t0.elapsed().as_secs_f64() * 1000.0;
    println!("🖥️  CPU (ndarray)      {:>10.3} ms", cpu_ms);

    // ── GPU (CUDA) ──
    match gpu_matmul(&a_vec, &b_vec, n) {
        Ok(c_gpu_vec) => {
            let c_gpu = vec_to_array2(c_gpu_vec, n);
            // Note: gpu_matmul returns immediately after kernel launch + sync,
            // so we time the wrapper function for an apples-to-apples comparison.
            let t0 = Instant::now();
            let _ = gpu_matmul(&a_vec, &b_vec, n).unwrap();
            let gpu_ms = t0.elapsed().as_secs_f64() * 1000.0;

            let max_err = max_relative_error(c_cpu.as_slice().unwrap(), c_gpu.as_slice().unwrap());
            println!("⚡ GPU (CUDA)         {:>10.3} ms  ✅ max rel err: {:.2e}", gpu_ms, max_err);
            println!("🚀 Speedup           {:>10.2}×", cpu_ms / gpu_ms);
        }
        Err(e) => {
            println!("⚠️  GPU skipped: {}", e);
        }
    }
}

// ─── Main ─────────────────────────────────────────────────────────────────────
fn main() {
    println!("╔══════════════════════════════════════════════════╗");
    println!("║   Rust Matrix Multiplication: CPU vs GPU         ║");
    println!("╚══════════════════════════════════════════════════╝");
    println!("\n🦀 Rust + ndarray  vs  ⚡ CUDA (cudarc + NVRTC)");

    for &size in &[512, 1024, 2048] {
        benchmark_size(size);
    }

    println!("\n✅ Done.");
}
