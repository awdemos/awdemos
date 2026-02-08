# Rust Tooling & CLI Applications

High-performance Rust-based command-line tools and utilities demonstrating systems programming excellence.

## 📋 Overview

This directory contains Rust implementations of various tools and utilities, showcasing **performance-critical CLI applications**, **systems programming**, and **modern Rust best practices**. All implementations leverage Tokio for async runtime and follow Rust's ownership model for memory safety.

### What You'll Find Here

| Project | Description | Key Features |
|---------|-------------|--------------|
| **[databases/](databases/)** | Database tooling and utilities | Performance benchmarks, connection pooling |
| **[fizzbuzz/](fizzbuzz/)** | Classic problem optimized in Rust | Multiple implementations, performance comparison |
| **[rust_matrix_multiplication/](rust_matrix_multiplication/)** | GPU-accelerated matrix operations | CUDA integration, parallel processing |
| **[user_boilerplate/](user_boilerplate/)** | CLI application scaffolding | Argument parsing, error handling, testing patterns |

---

## 🚀 Quick Start

### Exploring the Demos

Each demo is self-contained with its own README and documentation:

```bash
# Navigate to any demo directory
cd demos/rust/<demo-name>/README.md

# Run the demo (following individual demo instructions)
cargo run --release
```

### Building All Demos

```bash
# Build all Rust demos
cd demos/rust/
for dir in */; do
  if [ -f "$dir/Cargo.toml" ]; then
    echo "Building $dir..."
    cd "$dir"
    cargo build --release
    cd ..
  fi
done
```

---

## 🏗️ Architecture Patterns

### CLI Application Structure

```
┌─────────────────────────────────────┐
│          CLI Interface              │
│      (clap: argument parsing)       │
└────────────┬───────────────────────┘
             │
┌────────────▼───────────────────────┐
│       Application Logic             │
│   (Business logic, algorithms)      │
└────────────┬───────────────────────┘
             │
┌────────────▼───────────────────────┐
│      I/O & Networking              │
│  (Tokio: async runtime)            │
└────────────┬───────────────────────┘
             │
┌────────────▼───────────────────────┐
│      System Calls                  │
│  (Standard library, nix crate)     │
└─────────────────────────────────────┘
```

### Performance Optimization Stack

| Layer | Technique | Implementation |
|-------|-----------|----------------|
| **Algorithm** | Efficient algorithms | Big-O optimization, smart data structures |
| **Memory** | Zero-copy, stack allocation | `Cow<T>`, `Box<str>`, stack-allocated structs |
| **Parallelism** | Multi-threading | Rayon for data parallelism, Tokio for I/O parallelism |
| **I/O** | Async operations | Tokio runtime, non-blocking syscalls |
| **GPU** | CUDA acceleration | rust-cuda, bindings for NVIDIA GPU |

---

## 💡 Key Rust Concepts Demonstrated

### Ownership & Borrowing

All demos demonstrate Rust's unique memory safety model:

```rust
// Ownership - move semantics
fn take_ownership(s: String) {
    // s is now owned by this function
}

// Borrowing - immutable reference
fn read_string(s: &String) -> usize {
    s.len()
}

// Mutable borrowing
fn append_string(s: &mut String, text: &str) {
    s.push_str(text);
}
```

### Error Handling

Robust error handling with `Result<T, E>`:

```rust
use std::fs::File;
use std::io::Read;

fn read_file(path: &str) -> Result<String, std::io::Error> {
    let mut file = File::open(path)?;
    let mut contents = String::new();
    file.read_to_string(&mut contents)?;
    Ok(contents)
}

// Using with ?
fn main() -> Result<(), Box<dyn std::error::Error>> {
    let contents = read_file("data.txt")?;
    println!("{}", contents);
    Ok(())
}
```

### Async Programming

Tokio-based async runtime:

```rust
use tokio::time::{sleep, Duration};

async fn delayed_operation() -> String {
    sleep(Duration::from_secs(1)).await;
    "Done".to_string()
}

#[tokio::main]
async fn main() {
    let result = delayed_operation().await;
    println!("{}", result);
}
```

---

## 🔧 Technologies & Crates Used

### Core Libraries
- **Tokio** - Async runtime for modern I/O
- **Clap** - Command-line argument parsing
- **Serde** - Serialization/deserialization
- **Anyhow** - Error handling with context

### Database & Networking
- **SQLx** - Compile-time checked SQL
- **Diesel** - ORM for relational databases
- **Hyper** - HTTP client/server

### Performance
- **Rayon** - Data parallelism
- **Crossbeam** - Concurrent programming
- **ndarray** - N-dimensional arrays

### GPU Computing
- **rust-cuda** - CUDA bindings for GPU acceleration
- **ArrayFire** - High-performance GPU arrays

---

## 📊 Performance Benchmarks

### FizzBuzz Implementations

| Approach | Time (1M iterations) | Memory | Notes |
|----------|---------------------|--------|-------|
| Naive string concatenation | ~150ms | High | Slow string allocation |
| Pre-allocated vector | ~45ms | Medium | Better memory management |
| Zero-copy with `Cow` | ~30ms | Low | Optimized for hot paths |

### Matrix Multiplication

| Implementation | Size | CPU Time | GPU Time | Speedup |
|---------------|-------|----------|----------|---------|
| Rust (CPU) | 1024x1024 | 1.2s | - | 1x |
| CUDA (GPU) | 1024x1024 | - | 0.08s | 15x |
| CuBLAS (GPU) | 1024x1024 | - | 0.03s | 40x |

---

## 🎯 Use Cases

### When to Use Rust

✅ **Ideal for:**
- Performance-critical CLI tools
- Systems programming
- Networking and I/O-heavy applications
- Memory-constrained environments
- Cross-platform binaries
- GPU-accelerated computing

❌ **Not ideal for:**
- Rapid prototyping (Python better)
- Enterprise applications (Go/Java ecosystems more mature)
- Data science (Python ecosystem more complete)

### Rust vs Other Languages

| Language | Performance | Memory Safety | Ecosystem | Learning Curve |
|----------|-------------|---------------|-----------|----------------|
| **Rust** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐ |
| **Go** | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Python** | ⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **C++** | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐ |

---

## 🔍 Common Patterns

### Error Handling with Context

```rust
use anyhow::{Context, Result};

fn process_file(path: &str) -> Result<String> {
    std::fs::read_to_string(path)
        .with_context(|| format!("Failed to read file: {}", path))?;
    // ... processing logic ...
    Ok("processed".to_string())
}
```

### CLI Argument Parsing

```rust
use clap::Parser;

#[derive(Parser, Debug)]
struct Args {
    /// Input file path
    #[arg(short, long)]
    input: String,

    /// Number of iterations
    #[arg(short, long, default_value_t = 10)]
    iterations: u32,
}

fn main() {
    let args = Args::parse();
    println!("Processing {}", args.input);
}
```

### Parallel Processing with Rayon

```rust
use rayon::prelude::*;

fn parallel_sum(data: &[u64]) -> u64 {
    data.par_iter().sum()
}
```

---

## 🎓 Learning Path

### Beginner
1. Understand Rust's ownership model
2. Explore [fizzbuzz/](fizzbuzz/) - Classic problem with Rust
3. Learn `clap` for CLI argument parsing
4. Practice basic error handling with `Result`

### Intermediate
5. Study [databases/](databases/) - Database interactions
6. Learn async programming with Tokio
7. Understand [user_boilerplate/](user_boilerplate/) patterns
8. Implement a CLI tool with robust error handling

### Advanced
9. Deep dive into [rust_matrix_multiplication/](rust_matrix_multiplication/)
10. Learn CUDA bindings and GPU programming
11. Optimize for performance with profiling tools
12. Contribute to Rust ecosystem

---

## 🔗 External Resources

### Official Documentation
- [The Rust Book](https://doc.rust-lang.org/book/) - Comprehensive guide
- [Rust by Example](https://doc.rust-lang.org/rust-by-example/) - Code examples
- [Tokio Documentation](https://tokio.rs/) - Async runtime guide

### Crates & Libraries
- [crates.io](https://crates.io/) - Rust package registry
- [docs.rs](https://docs.rs/) - Crate documentation

---

## 🤝 Contributing

Have ideas for new Rust demos or optimizations? Please open an issue or PR following our [contributing guidelines](../../CONTRIBUTING.md).

---

## 📄 License

All demos and code in this directory are licensed under MIT License. See [LICENSE](../../LICENSE) for details.

---

**Built with ❤️ using Rust for performance-critical applications.**
