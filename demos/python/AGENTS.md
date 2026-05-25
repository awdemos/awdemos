# demos/python — KNOWLEDGE BASE

## OVERVIEW

Production Python patterns: Poetry packaging, Flask best practices, CrewAI agent workflows, and containerized deployments.

## STRUCTURE

```
python/
├── poetry-container-sample/  # Poetry + Dockerfile pattern
├── flask_best_practices/     # Production Flask app
├── fargate-docker-python/    # AWS Fargate + Pulumi Go deployment
├── ai_analysis_crew.py       # CrewAI agent workflow
├── my_socket_server.py       # Network programming
└── sieve_of_eratosthenes.py  # Algorithm reference
```

## WHERE TO LOOK

| Task | Location | Notes |
|------|----------|-------|
| Poetry + containers | `poetry-container-sample/` | Modern Python packaging |
| Flask production | `flask_best_practices/` | Dockerfile, Pipfile |
| Fargate deployment | `fargate-docker-python/` | Pulumi Go + task definition |
| CrewAI agents | `ai_analysis_crew.py` | Multi-agent workflow |

## CONVENTIONS

- **PEP 8 + type hints** — all production code typed
- **Poetry over pip** — `pyproject.toml` with lock files
- **Docker multi-stage** — slim final images
- **Docstrings required** — Google or NumPy style

## ANTI-PATTERNS

- `fargate-docker-python/` uses Pulumi **Go** (not Python) for infrastructure — infrastructure code may not match runtime language
- Avoid `requirements.txt` without pinning in new demos
