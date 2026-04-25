# Demos Index

This directory contains working examples, reference architectures, and learning projects organized by technology area.

## AI & Machine Learning

- **`llm/`** — Large language model infrastructure, RAG pipelines, and fine-tuning
  - `chainlit_rust_rag/` — RAG pipeline with Chainlit, LangGraph, Qdrant, and Cohere reranking
  - `finetuning/` — Model fine-tuning experiments
  - `grok/` — Grok-1 architecture research
  - `alpha_maze_finder_grpo/` — GRPO reinforcement learning experiments
  - `attacks/` — LLM security and adversarial testing

## Cloud & Infrastructure

- **`kubernetes/`** — Deployment patterns, debugging guides, and cluster architecture
  - `100_ways_to_deploy_kubernetes/` — Multiple cluster bootstrapping strategies
  - `eks_node_aws_pulumi/` — EKS node management with Pulumi
  - Various guides: debugging, etcd inspection, deterministic builds, multi-cluster networking
- **`pulumi-azure-tenant/`** — Azure AD B2C multi-tenant infrastructure with Pulumi TypeScript
- **`dagger-go-ci/`** — Dagger-based CI/CD pipeline in Go with Trivy scanning
- **`eks-gha-aws-demo/`** — EKS provisioning with Pulumi Go and GitHub Actions
- **`vpc_eks_terraform-demo/`** — Terraform baseline for VPC and EKS

## Systems & Languages

- **`rust/`** — Rust learning projects and patterns
  - `rust_matrix_multiplication/` — Ndarray-based matrix operations
  - `user_boilerplate/` — CLI application boilerplate
  - `fizzbuzz/` — Language fundamentals
  - `databases/` — Database connectivity patterns
- **`python/`** — Production Python patterns
  - `poetry-container-sample/` — Poetry packaging in containers
  - `flask_best_practices/` — Flask application structure
  - `fargate-docker-python/` — AWS Fargate deployment patterns
  - `ai_analysis_crew.py` — CrewAI agent workflow
- **`linux/`** — Linux systems programming notes
  - `Kernel.md` — Kernel concepts
  - `capabilities.h` — Linux capabilities reference
  - `Make-Python-Binary-Basic.md` — Static Python binary compilation
- **`lambactl/`** — Go CLI for Lambda Cloud GPU instance management
- **`QubesOS/`** — Kubernetes on QubesOS research

## Emerging & Research

- **`Xfiles/`** *(parent directory)* — Plan 9 protocol for agents and quantum AI
- **`Routage/`** — Intelligent message routing, mesh networking, and fault-tolerant cluster coordination

---

For a complete list of my original open-source projects, see [PROJECTS.md](../PROJECTS.md) in the repository root.
