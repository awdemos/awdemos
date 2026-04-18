# Project Index — Original Work Only

This document lists only repositories and projects I created myself. Forks and contributions to third-party projects are listed separately at the bottom.

---

## 🚩 Flagship Repositories

### [RegicideOS](https://github.com/awdemos/RegicideOS) ⭐ 10
**Language:** Rust, Shell  
**License:** —  
AI-native, Rust-first Linux distribution based on Gentoo, Btrfs, and Cosmic Desktop. This is my most ambitious systems project — a from-the-ground-up OS designed for AI workloads, with Rust tooling throughout the stack.

**Why it matters:** Building a Linux distribution demonstrates deep understanding of bootloaders, init systems, package management, filesystems, and desktop environments. The AI-native focus means pre-optimized GPU drivers, container runtimes, and ML tooling out of the box.

---

### [zerochain](https://github.com/awdemos/zerochain) ⭐ 3
**Language:** Rust  
**License:** MIT  
Multi-agent orchestration using plain text files as agents. Instead of complex RPC or message queues, agents coordinate through a simple file-based protocol.

**Why it matters:** It explores whether multi-agent systems can be built with minimal infrastructure — no databases, no brokers, no network stacks. Just files, inodes, and watchers.

---

### [merlin](https://github.com/awdemos/merlin) ⭐ 3
**Language:** Rust  
**License:** —  
LLM prompt router written in Rust using reinforcement learning. Routes prompts to the optimal model based on latency, cost, and quality constraints.

**Why it matters:** Inference routing is becoming critical infrastructure as organizations deploy multiple models. Doing this in Rust with Tokio async means sub-millisecond routing decisions without GC pauses.

---

## 🛠️ Developer Tools

### [opencode-pushguard](https://github.com/awdemos/opencode-pushguard) ⭐ 9
**Language:** TypeScript  
**License:** —  
Pre-push git hook that reviews code for quality issues before it leaves your machine. Designed for AI-assisted development workflows where agents might generate sloppy code.

---

### [opencode-watchtower](https://github.com/awdemos/opencode-watchtower) ⭐ 5
**Language:** Shell  
**License:** —  
Safer agent tool calling designed for [opencode](https://opencode.ai). Uses utcp (untrusted code path) isolation to prevent AI agents from executing dangerous commands.

---

### [opencode-memento](https://github.com/awdemos/opencode-memento) ⭐ 4
**Language:** TypeScript  
**License:** —  
OpenCode plugin that preserves project context across sessions. Automatically injects relevant prior work into compaction windows so agents don't lose track of architectural decisions.

---

### [Kommand](https://github.com/awdemos/Kommand) ⭐ 1
**Language:** Python  
**License:** MIT  
MCP (Model Context Protocol) server for spawning isolated sub-agents with secure project isolation and dynamic tool management.

---

## 🏗️ Infrastructure & Protocols

### [DCAP](https://github.com/awdemos/DCAP)
**Language:** Rust  
**License:** —  
Dynamic Configuration and Application Platform. A protocol and runtime for decentralized commerce agents.

---

### [demo-rust-server](https://github.com/awdemos/demo-rust-server) ⭐ 2
**Language:** Rust  
**License:** MIT  
A simple Rust HTTP server inspired by Rust for Network Programming and the Go Podinfo project. Learning project for async Rust and containerized deployment.

---

### [ZFG](https://github.com/awdemos/ZFG) ⭐ 1
**Language:** Shell  
**License:** —  
Zero Fugazis Linux — a minimal, opinionated Linux distribution experiment.

---

### [LLMNotes](https://github.com/awdemos/LLMNotes) ⭐ 6
**Language:** Python  
**License:** —  
Research notes and experiments on large language models.

---

### [AEI5](https://github.com/awdemos/AEI5) ⭐ 1
**Language:** Jupyter Notebook  
**License:** MIT  
AI/ML experiments and educational notebooks.

---

### [burn-demos](https://github.com/awdemos/burn-demos)
**Language:** Rust  
**License:** —  
Experiments with the [Burn](https://burn.dev) deep learning framework in Rust.

---

### [pushguard](https://github.com/awdemos/pushguard)
**Language:** TypeScript  
**License:** —  
Earlier iteration of pushguard tooling.

---

## 📁 Demos in This Repository

These live in the `demos/` directory of this repo and represent working examples, reference architectures, and learning projects.

### AI / LLM
- **`demos/llm/chainlit_rust_rag/`** — RAG pipeline using Chainlit frontend with LangGraph, Qdrant vector store, and Cohere reranking. Processes mixed document types (PDF, HTML, Markdown) with fine-tuned HuggingFace embeddings.
- **`demos/llm/finetuning/`** — Fine-tuning experiments and dataset preparation.
- **`demos/llm/grok/`** — Research into the Grok-1 model architecture.
- **`demos/llm/alpha_maze_finder_grpo/`** — GRPO (Group Relative Policy Optimization) maze-solving experiments.
- **`demos/llm/attacks/`** — LLM security research and adversarial testing.

### Infrastructure
- **`demos/kubernetes/`** — 100+ deployment patterns, debugging guides, deterministic build strategies, and multi-cluster architecture notes. Includes Cilium eBPF networking setup.
- **`demos/pulumi-azure-tenant/`** — Multi-tenant Azure AD B2C infrastructure provisioned with Pulumi TypeScript.
- **`demos/dagger-go-ci/`** — Container-native CI/CD pipeline using Dagger's Go SDK. Includes test, lint, build, and serve stages with Trivy security scanning.
- **`demos/eks-gha-aws-demo/`** — AWS EKS cluster provisioning with Pulumi Go and GitHub Actions integration.
- **`demos/vpc_eks_terraform-demo/`** — Terraform modules for VPC and EKS baseline infrastructure.

### Systems & Languages
- **`demos/rust/rust_matrix_multiplication/`** — Basic matrix multiplication with `ndarray`, foundational learning for GPU-accelerated linear algebra.
- **`demos/rust/user_boilerplate/`** — CLI boilerplate and patterns for Rust application development.
- **`demos/rust/fizzbuzz/`** — Rust language fundamentals.
- **`demos/rust/databases/`** — Database interaction patterns in Rust.
- **`demos/python/`** — Production Python patterns including Poetry packaging, Flask best practices, and CrewAI agent workflows.
- **`demos/linux/`** — Linux kernel notes, capabilities headers, and Python binary compilation for static linking.
- **`demos/lambactl/`** — Go CLI for Lambda Cloud GPU instance management (Cobra + RESTy).
- **`demos/QubesOS/`** — Notes on running Kubernetes clusters on QubesOS.

---

## 🔀 Forks & Third-Party Contributions

These are repositories I forked to study, contribute to, or extend. They are **not my original work**.

| Fork | Original Author | Purpose |
|------|-----------------|---------|
| [efrit](https://github.com/awdemos/efrit) | steveyegge | Native elisp coding agent for Emacs |
| [shimmy](https://github.com/awdemos/shimmy) | Michael-A-Kuykendall | Python-free Rust inference server |
| [container-use](https://github.com/awdemos/container-use) | dagger | Isolated dev environments for AI agents |
| [desloppify](https://github.com/awdemos/desloppify) | peteromallet | Agent harness for code quality |
| [cowabungaai](https://github.com/awdemos/cowabungaai) | ansilh | Local/cloud-native generative AI deployment |
| [SWE-AF](https://github.com/awdemos/SWE-AF) | Agent-Field | Autonomous software engineering fleet |
| [microjpt](https://github.com/awdemos/microjpt) | ssrhaso | Minimal GPT implementation in Julia |
| [opencode-anthropic-auth](https://github.com/awdemos/opencode-anthropic-auth) | jinzhongjia | Anthropic auth for OpenCode |
| [orange-lab](https://github.com/awdemos/orange-lab) | QC-Labs | Private infrastructure for cloud natives |
| [awesome-opencode](https://github.com/awdemos/awesome-opencode) | awesome-opencode | Curated resources for opencode.ai |
| [opencode-agents](https://github.com/awdemos/opencode-agents) | darrenhinde | OpenCode configurations and prompts |

---

*Last updated: April 2026*
