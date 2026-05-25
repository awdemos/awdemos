# demos/dagger-go-ci — KNOWLEDGE BASE

## OVERVIEW

Container-native CI/CD pipeline using Dagger's Go SDK. Multi-module Go workspace with test, lint, build, and serve stages plus Trivy security scanning.

## STRUCTURE

```
dagger-go-ci/
├── ci/               # Dagger pipeline module (go.mod)
│   ├── main.go       # Pipeline definition
│   ├── frontend/     # Frontend build sub-module
│   └── backend/      # Backend build sub-module
├── website/          # Demo website module (go.mod)
├── main.go           # Root Dagger entry
├── main_test.go      # Pipeline tests
├── go.work           # Go workspace (unusual for demos)
├── Jenkinsfile       # Jenkins orchestration
└── dagger.json       # Dagger module config
```

## WHERE TO LOOK

| Task | Location | Notes |
|------|----------|-------|
| Pipeline definition | `ci/main.go` | Dagger Go SDK pipelines |
| Root entry point | `main.go` | Workspace-level Dagger calls |
| CI orchestration | `Jenkinsfile` | Jenkins, not GitHub Actions |
| Frontend build | `ci/frontend/` | Isolated frontend module |
| Backend build | `ci/backend/` | Isolated backend module |
| Pipeline tests | `main_test.go` | Dagger pipeline unit tests |

## CONVENTIONS

- **Go workspace** — `go.work` ties `ci/`, `ci/frontend/`, `ci/backend/`, `website/` together
- **Dagger Go SDK** — pipelines as code, container-native execution
- **Jenkins for orchestration** — consistent with repo-wide avoidance of GitHub Actions
- **Trivy scanning** — security scan stage in pipeline

## ANTI-PATTERNS

- Do NOT add GitHub Actions workflows here — use Dagger + Jenkins or alternative orchestrators
- Avoid monolithic pipeline files — keep frontend/backend/build stages separated
