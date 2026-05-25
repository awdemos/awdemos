# demos/rust — KNOWLEDGE BASE

## OVERVIEW

Systems programming patterns in Rust: matrix operations, CLI boilerplate, database integration, and LLM inference server experiments.

## STRUCTURE

```
rust/
├── user_boilerplate/           # CLI scaffolding (clap, tracing, anyhow)
├── rust_matrix_multiplication/ # ndarray-based linear algebra
├── databases/                  # PL/Rust and DB interaction patterns
├── fizzbuzz/                   # Language fundamentals
└── ai/
    └── llm_inference_server/   # Rust LLM serving experiment
```

## WHERE TO LOOK

| Task | Location | Notes |
|------|----------|-------|
| CLI boilerplate | `user_boilerplate/` | Production-ready clap + tracing setup |
| Matrix math | `rust_matrix_multiplication/` | ndarray, GPU-acceleration prep |
| DB patterns | `databases/` | PL/Rust notes |
| LLM inference | `ai/llm_inference_server/` | Cross-categorized; see also `demos/llm/` |

## CONVENTIONS

- **cargo fmt + cargo clippy** — enforced formatting and lints
- **clap for CLI** — `user_boilerplate` uses derive-based argument parsing
- **tracing for observability** — structured logging standard
- **Docker multi-stage builds** — minimal final images

## ANTI-PATTERNS

- `ai/llm_inference_server/` is categorized under `rust/` rather than `llm/` — when adding new LLM demos, prefer `demos/llm/`
- Avoid `unwrap()` in production code — use `anyhow` or `thiserror`
