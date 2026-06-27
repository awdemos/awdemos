# PROJECT KNOWLEDGE BASE

**Generated:** 2026-05-24T14:04:59Z  
**Commit:** f72e695  
**Branch:** master

## OVERVIEW

Personal demo monorepo by Andrew White — production-grade infrastructure and AI/ML patterns. Not a single product; a curated collection of self-contained demos organized by technology domain. Languages: Go, Rust, Python, TypeScript, C#, Shell.

## STRUCTURE

```
.
├── demos/
│   ├── kubernetes/      # Deployment patterns, Cilium, multi-cluster
│   ├── llm/             # RAG, fine-tuning, inference, agent patterns
│   ├── dagger-go-ci/    # Container-native CI with Dagger Go SDK
│   ├── rust/            # Systems programming, matrix ops, CLI boilerplate
│   ├── python/          # Poetry, Flask, CrewAI patterns
│   ├── pulumi-azure-tenant/  # Multi-tenant Azure AD B2C IaC
│   ├── lambactl/        # Go CLI for Lambda Cloud GPU instances
│   └── ...              # Additional smaller demos
├── docs/                # Blog posts, guides, skills frameworks
├── security/            # Supply chain, vulnerability research
├── sre/                 # Operational runbooks and patterns
├── dotfiles/            # Personal shell/environment configs
└── certs/               # Certification artifacts
```

## WHERE TO LOOK

| Task | Location | Notes |
|------|----------|-------|
| K8s deployment patterns | `demos/kubernetes/` | 100+ patterns across AWS/GCP/Azure |
| LLM/RAG pipelines | `demos/llm/` | Chainlit + Qdrant + Cohere reranking |
| CI/CD pipelines | `demos/dagger-go-ci/` | Dagger Go SDK, Jenkinsfile |
| Rust systems code | `demos/rust/` | Matrix math, CLI boilerplate, DB patterns |
| Python prod patterns | `demos/python/` | Poetry containers, Flask best practices |
| Azure multi-tenant IaC | `demos/pulumi-azure-tenant/` | Pulumi TypeScript |
| GPU instance CLI | `demos/lambactl/` | Cobra + RESTy |
| Research notes | `Research.md`, `docs/` | AI/ML, K8s, security research |
| Performance benchmarks | `BENCHMARKS.md` | GPU metrics, optimization data |
| Technology comparisons | `COMPARISONS.md` | Tool decision frameworks |

## CONVENTIONS

- **No root package manager** — each demo is self-contained with its own `go.mod`, `Cargo.toml`, `pyproject.toml`, etc.
- **Code over YAML** — preference for general-purpose languages over configuration languages
- **Multi-stage Dockerfiles** — minimal base images, clear layer caching
- **Mermaid diagrams** — for architecture docs
- **GPG-signed commits** — required for contributions
- **PEP 8 + type hints** — Python; `cargo fmt` + `cargo clippy` — Rust; standard Go conventions

## ANTI-PATTERNS (THIS PROJECT)

- **NEVER GitHub Actions** — user explicitly rejects GitHub Actions; use Dagger, Jenkins, or alternatives
- **NEVER commit secrets** — no credentials in repo, ever
- **NEVER public security issues** — report privately with 90-day embargo
- **No black boxes** — if it cannot be audited, it is not shipped

## UNIQUE STYLES

- **Portfolio/repo hybrid** — root contains `Resume.md`, certification PNGs, `GITHUB_PROFILE_README.md`. This is intentional; the repo doubles as a GitHub profile source.
- **"100 ways" repetition** — `demos/kubernetes/100_ways_to_deploy_kubernetes/` repeats the same K8s pattern across 5 languages x 3 clouds. Pedagogical, not DRY.
- **Cross-domain categorization conflicts** — `demos/rust/ai/` exists alongside `demos/llm/`. When in doubt, LLM-specific code is under `llm/`; Rust language patterns are under `rust/`.

## COMMANDS

```bash
# No root-level build. Enter individual demo directories.
cd demos/<demo-name>/ && follow demo-specific README
```

## NOTES

- `eks-pulumi-go-demo/` was renamed from `eks-gha-aws-demo/` to remove the GitHub Actions implication; it contains no Actions workflows.
- `dagger-go-ci/` uses a `go.work` workspace with nested modules — more complex than typical demos.
- CONTRIBUTING.md references GitHub Actions CI; this is aspirational/outdated. No `.github/workflows/` exists.
