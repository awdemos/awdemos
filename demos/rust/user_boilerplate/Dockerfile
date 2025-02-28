# Build stage
FROM cgr.dev/chainguard/rust:latest-dev AS builder

WORKDIR /app

# Copy dependency files first for caching
COPY Cargo.toml Cargo.lock .
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
COPY --from=builder /app/target/release/user_boilerplate .

# Copy any additional runtime files if needed
# COPY config/* ./config/

# Run the binary
CMD ["./user_boilerplate"]
