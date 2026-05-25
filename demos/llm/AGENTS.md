# demos/llm — KNOWLEDGE BASE

## OVERVIEW

AI/ML infrastructure patterns: RAG pipelines, fine-tuning setups, LLM inference, multi-agent orchestration, and adversarial security research.

## STRUCTURE

```
llm/
├── chainlit_rust_rag/      # Chainlit + Qdrant + Cohere reranking
├── finetuning/             # Dataset prep and fine-tuning configs
├── grok/                   # Grok-1 architecture research
├── alpha_maze_finder_grpo/ # GRPO maze-solving experiments
├── attacks/                # LLM security research
└── *.md                    # NVIDIA setup, MLOps, deepseek guides
```

## WHERE TO LOOK

| Task | Location | Notes |
|------|----------|-------|
| RAG pipeline | `chainlit_rust_rag/` | Mixed doc types (PDF/HTML/Markdown), HuggingFace embeddings |
| Fine-tuning | `finetuning/` | Config-driven experiments |
| Multi-agent patterns | `MLOPS.md` | MCP-based orchestration notes |
| NVIDIA GPU setup | `Nvidia_software.md`, `Nvidia_cloud_vendors.md` | Cloud vendor GPU options |
| Adversarial testing | `attacks/` | Prompt injection, jailbreak research |
| GRPO experiments | `alpha_maze_finder_grpo/` | Group Relative Policy Optimization |

## CONVENTIONS

- **Poetry for Python** — `pyproject.toml` with locked deps
- **Dockerized services** — Chainlit app containerized with clear layer caching
- **Notebook + script hybrid** — `.ipynb` for exploration, `.py` for production

## ANTI-PATTERNS

- Do NOT commit `.env` files — `chainlit_rust_rag/.env` exists; treat as template only
- Avoid hardcoded API keys in notebooks
