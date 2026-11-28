use cudarc::driver::{CudaDevice, CudaFunction, LaunchAsync, LaunchConfig};
use cudarc::nvrtc::compile_ptx;
use ndarray::Array2;
use rand::Rng;
use std::sync::Arc;
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

fn launch_config(n: usize) -> LaunchConfig {
    let block_size = 16u32;
    let grid_size = (n as u32).div_ceil(block_size);
    LaunchConfig {
        grid_dim: (grid_size, grid_size, 1),
        block_dim: (block_size, block_size, 1),
        shared_mem_bytes: 0,
    }
}

// ─── CPU Implementation ───────────────────────────────────────────────────────
fn cpu_matmul(a: &Array2<f32>, b: &Array2<f32>) -> Array2<f32> {
    a.dot(b)
}

// ─── GPU Context ──────────────────────────────────────────────────────────────
// Device setup and NVRTC compilation are one-time costs. Keeping them in a
// reusable context is what makes the benchmark timings meaningful: none of
// this setup work is inside a timed region.
struct GpuMatmul {
    dev: Arc<CudaDevice>,
    kernel: CudaFunction,
}

impl GpuMatmul {
    fn new() -> Result<Self, Box<dyn std::error::Error>> {
        let dev = CudaDevice::new(0)?;
        let ptx = compile_ptx(KERNEL_SRC)?;
        dev.load_ptx(ptx, "matmul", &["matmul_f32"])?;
        let kernel = dev
            .get_func("matmul", "matmul_f32")
            .ok_or("compiled matmul_f32 symbol was not found")?;
        Ok(Self { dev, kernel })
    }

    // Full end-to-end path: allocate, H2D copy, launch, sync, D2H copy.
    fn run(&self, a: &[f32], b: &[f32], n: usize) -> Result<Vec<f32>, Box<dyn std::error::Error>> {
        let a_dev = self.dev.htod_copy(a.to_vec())?;
        let b_dev = self.dev.htod_copy(b.to_vec())?;
        let mut c_dev = self.dev.alloc_zeros::<f32>(n * n)?;

        let cfg = launch_config(n);
        let n_i32 = n as i32;
        unsafe {
            self.kernel
                .clone()
                .launch(cfg, (&a_dev, &b_dev, &mut c_dev, n_i32))?;
        }
        self.dev.synchronize()?;
        let c_host = self.dev.dtoh_sync_copy(&c_dev)?;
        Ok(c_host)
    }

    // Kernel-only timing. Input transfers and buffer allocation happen BEFORE
    // the timer starts, and the result transfer happens AFTER it stops. Only
    // the kernel launch and device synchronization are measured.
    fn time_kernel(
        &self,
        a: &[f32],
        b: &[f32],
        n: usize,
    ) -> Result<(Vec<f32>, f64), Box<dyn std::error::Error>> {
        let a_dev = self.dev.htod_copy(a.to_vec())?;
        let b_dev = self.dev.htod_copy(b.to_vec())?;
        let mut c_dev = self.dev.alloc_zeros::<f32>(n * n)?;

        let cfg = launch_config(n);
        let n_i32 = n as i32;

        let t0 = Instant::now();
        unsafe {
            self.kernel
                .clone()
                .launch(cfg, (&a_dev, &b_dev, &mut c_dev, n_i32))?;
        }
        self.dev.synchronize()?;
        let kernel_ms = t0.elapsed().as_secs_f64() * 1000.0;

        let c_host = self.dev.dtoh_sync_copy(&c_dev)?;
        Ok((c_host, kernel_ms))
    }

    // End-to-end timing: the full run including host/device transfers.
    fn time_end_to_end(
        &self,
        a: &[f32],
        b: &[f32],
        n: usize,
    ) -> Result<(Vec<f32>, f64), Box<dyn std::error::Error>> {
        let t0 = Instant::now();
        let c_host = self.run(a, b, n)?;
        let total_ms = t0.elapsed().as_secs_f64() * 1000.0;
        Ok((c_host, total_ms))
    }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────
fn random_matrix(n: usize) -> Vec<f32> {
    let mut rng = rand::thread_rng();
    (0..n * n).map(|_| rng.gen::<f32>()).collect()
}

fn vec_to_array2(vec: Vec<f32>, n: usize) -> Array2<f32> {
    Array2::from_shape_vec((n, n), vec).expect("matrix shape matches vector length")
}

fn max_relative_error(a: &[f32], b: &[f32]) -> f32 {
    a.iter()
        .zip(b.iter())
        .map(|(x, y)| (x - y).abs() / y.abs().max(1e-6))
        .fold(0.0f32, |max, err| max.max(err))
}

// ─── Benchmark ────────────────────────────────────────────────────────────────
fn benchmark_size(n: usize, gpu: Option<&GpuMatmul>) {
    println!("\n📐 Matrix size: {}×{}", n, n);
    println!("{:-<50}", "");

    let a_vec = random_matrix(n);
    let b_vec = random_matrix(n);

    let a_arr = vec_to_array2(a_vec.clone(), n);
    let b_arr = vec_to_array2(b_vec.clone(), n);

    let t0 = Instant::now();
    let c_cpu = cpu_matmul(&a_arr, &b_arr);
    let cpu_ms = t0.elapsed().as_secs_f64() * 1000.0;
    println!("🖥️  CPU (ndarray)      {:>10.3} ms", cpu_ms);

    let Some(gpu) = gpu else {
        return;
    };

    // Untimed warm-up so first-use driver effects do not pollute the timings.
    if let Err(e) = gpu.run(&a_vec, &b_vec, n) {
        println!("⚠️  GPU run failed: {}", e);
        return;
    }

    let cpu_slice = c_cpu.as_slice().expect("CPU result is contiguous");

    match gpu.time_kernel(&a_vec, &b_vec, n) {
        Ok((c_gpu_vec, kernel_ms)) => {
            let c_gpu = vec_to_array2(c_gpu_vec, n);
            let gpu_slice = c_gpu.as_slice().expect("GPU result is contiguous");
            let max_err = max_relative_error(cpu_slice, gpu_slice);
            println!(
                "⚡ GPU kernel only    {:>10.3} ms  ✅ max rel err: {:.2e}",
                kernel_ms, max_err
            );

            match gpu.time_end_to_end(&a_vec, &b_vec, n) {
                Ok((_, total_ms)) => {
                    println!(
                        "🔁 GPU + transfers   {:>10.3} ms  (H2D + kernel + D2H)",
                        total_ms
                    );
                    println!("🚀 Speedup (kernel)  {:>10.2}×", cpu_ms / kernel_ms);
                }
                Err(e) => println!("⚠️  GPU end-to-end timing failed: {}", e),
            }
        }
        Err(e) => println!("⚠️  GPU kernel timing failed: {}", e),
    }
}

// ─── Main ─────────────────────────────────────────────────────────────────────
fn main() {
    println!("╔══════════════════════════════════════════════════╗");
    println!("║   Rust Matrix Multiplication: CPU vs GPU         ║");
    println!("╚══════════════════════════════════════════════════╝");
    println!("\n🦀 Rust + ndarray  vs  ⚡ CUDA (cudarc + NVRTC)");

    let gpu = match GpuMatmul::new() {
        Ok(gpu) => Some(gpu),
        Err(e) => {
            println!("⚠️  GPU skipped: {}", e);
            None
        }
    };

    for &size in &[512, 1024, 2048] {
        benchmark_size(size, gpu.as_ref());
    }

    println!("\n✅ Done.");
}
