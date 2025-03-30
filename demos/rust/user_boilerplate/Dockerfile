# Build stage# Build stage
FROM cgr.dev/chainguard/rust:latest-dev AS builder

WORKDIR /workspace

# Copy dependency files first for caching
COPY Cargo.toml Cargo.lock /workspace
RUN mkdir -p src && \
    echo "fn main() {}" > src/main.rs && \
    cargo build --release && \
    rm -rf src

# Copy source code
COPY src ./src

# Final build
RUN cargo build --release

# Runtime stage
FROM cgr.dev/chainguard/rust:latest-dev

WORKDIR /app

# Copy the built binary from builder
COPY --from=builder /workspace/target/release/user_boilerplate .

# Run the binary
CMD ["./user_boilerplate"]

