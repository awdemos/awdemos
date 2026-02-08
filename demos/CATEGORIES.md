# Demos by Category

This document organizes all demos by technology category for quick navigation. Each category provides production-ready code patterns, architectural insights, and real-world implementations.

---

## 🧠 AI/ML Infrastructure

**Core Focus:** NVIDIA GPU optimization, LLM deployment, MLOps pipelines, multi-agent AI systems

### AI/ML Core Infrastructure

| Demo | Description | Tech Stack | Quick Start |
|-------|-------------|-------------|-------------|
| [LLM Infrastructure](./llm/) | Production LLM deployments with NVIDIA optimization | NVIDIA GPUs, Triton, MLflow, Ray, Kubernetes | [Quick Start](./llm/#quick-start) |
| [Multi-Agent AI](./llm/) | MCP-based agent orchestration and state management | MCP, container-use, Claude Desktop | [Quick Start](./llm/#multi-agent-ai-systems) |
| [NVIDIA Technologies](./llm/) | CUDA, MIG, TensorRT, DCGM optimization | NVIDIA GPU toolkit, Python, Rust | [Quick Start](./llm/#nvidia-gpu-setup) |

### MLOps & Experimentation

| Demo | Description | Tech Stack | Quick Start |
|-------|-------------|-------------|-------------|
| [MLflow Integration](./llm/) | Experiment tracking and model registry | MLflow, Kubernetes, Prometheus | [Quick Start](./llm/#mlops-pipeline-integration) |
| [Ray Distributed Training](./llm/) | Distributed ML on GPU clusters | Ray, Kubernetes, NVIDIA MIG | [Quick Start](./llm/#distributed-ml-with-ray) |
| [RAG Implementation](./llm/) | Retrieval-Augmented Generation patterns | LLMs, Vector DBs, RAG | [Quick Start](./llm/#retrieval-augmented-generation-rag) |

---

## ☸️ Kubernetes Operations

**Core Focus:** Multi-cloud deployments, GitOps, observability, GPU scheduling, service mesh

### Cloud Provider Deployments

| Demo | Description | Cloud | Quick Start |
|-------|-------------|---------|-------------|
| [AWS EKS](./kubernetes/) | Production EKS with GPU nodes and auto-scaling | AWS, EKS, VPC, Cilium | [Quick Start](./kubernetes/#cloud-provider-configurations) |
| [GCP GKE](./kubernetes/) | GKE with confidential computing support | GCP, GKE, Workload Identity | [Quick Start](./kubernetes/#cloud-provider-configurations) |
| [Azure AKS](./kubernetes/) | AKS with hybrid cloud connectivity | Azure, AKS, Azure AD | [Quick Start](./kubernetes/#cloud-provider-configurations) |

### Kubernetes Distributions

| Demo | Description | Distribution | Quick Start |
|-------|-------------|--------------|-------------|
| [Talos Linux](./kubernetes/) | Immutable, API-only Kubernetes OS | Talos, Kubernetes, cluster-api | [Quick Start](./kubernetes/#kubernetes-distributions) |
| [K3s Lightweight](./kubernetes/) | Edge-compatible lightweight K8s | K3s, edge computing | [Quick Start](./kubernetes/#kubernetes-distributions) |
| [vCluster Virtual](./kubernetes/) | Virtual K8s clusters for isolation | vCluster, K8s-in-K8s | [Quick Start](./kubernetes/#virtual-clusters) |

### Advanced Networking

| Demo | Description | Tech Stack | Quick Start |
|-------|-------------|-------------|-------------|
| [Cilium eBPF](./kubernetes/) | Kernel-bypass networking and security | Cilium, eBPF, Hubble, Cilium | [Quick Start](./kubernetes/#networking-security) |
| [Zero-Trust Architecture](./kubernetes/) | Zero-trust networking and policies | Cilium, network policies, mTLS | [Quick Start](./kubernetes/#networking-security) |
| [Ingress Controllers](./kubernetes/) | Multiple ingress strategies | NGINX, Traefik, Cilium Gateway API | [Quick Start](./kubernetes/#ingress-options) |

### Observability

| Demo | Description | Tech Stack | Quick Start |
|-------|-------------|-------------|-------------|
| [Prometheus + Grafana](./kubernetes/) | Metrics collection and dashboards | Prometheus, Grafana, DCGM Exporter | [Quick Start](./kubernetes/#observability-stack) |
| [Loki Logging](./kubernetes/) | Distributed log aggregation | Loki, Promtail, Grafana | [Quick Start](./kubernetes/#observability-stack) |
| [Jaeger Tracing](./kubernetes/) | Distributed request tracing | Jaeger, OpenTelemetry, tracing | [Quick Start](./kubernetes/#observability-stack) |
| [GPU Metrics](./kubernetes/) | DCGM GPU monitoring | NVIDIA DCGM, Prometheus, custom metrics | [Quick Start](./kubernetes/#gpu-metrics) |

---

## 🔧 Development Tools & Automation

**Core Focus:** CI/CD pipelines, testing automation, developer experience, cross-platform tooling

### CI/CD & Automation

| Demo | Description | Tech Stack | Quick Start |
|-------|-------------|-------------|-------------|
| [Dagger Go CI](./dagger-go-ci/) | Container-native programmable pipelines | Dagger, Go, Kubernetes, Tekton | [Quick Start](./dagger-go-ci/) |
| [GitHub Actions](./eks-gha-aws-demo/) | EKS deployment via GitHub Actions | GitHub Actions, Pulumi, AWS | [Quick Start](./eks-gha-aws-demo/) |

### Testing & Debugging

| Demo | Description | Tech Stack | Quick Start |
|-------|-------------|-------------|-------------|
| [cdebug](./cdebug/) | Container debugging and introspection | Docker, debug tools, containers | [Quick Start](./cdebug/) |
| [Python Testing](./python/) | Production testing patterns | pytest, pytest-cov, tox | [Quick Start](./python/#testing) |

---

## 🚀 Programming Language Examples

### Rust Tools & Systems Programming

| Demo | Description | Use Case | Quick Start |
|-------|-------------|-----------|-------------|
| [Database Integration](./rust/databases/) | Rust database patterns | Performance-critical data access | [Quick Start](./rust/) |
| [Fizzbuzz Implementation](./rust/fizzbuzz/) | Idiomatic Rust patterns | Language learning, algorithms | [Quick Start](./rust/) |
| [Matrix Multiplication](./rust/rust_matrix_multiplication/) | Optimized numerical computing | GPU acceleration potential | [Quick Start](./rust/) |
| [User Boilerplate](./rust/user_boilerplate/) | CLI tool scaffolding | Project templates | [Quick Start](./rust/) |

### Python Best Practices

| Demo | Description | Use Case | Quick Start |
|-------|-------------|-----------|-------------|
| [Type Hints](./python/) | Production Python typing | Code quality, IDE support | [Quick Start](./python/) |
| [Poetry Projects](./python/) | Dependency management | Production-ready packaging | [Quick Start](./python/) |
| [Testing Patterns](./python/) | Test organization | Maintainable test suites | [Quick Start](./python/) |

---

## 🛡️ Security & Compliance

**Core Focus:** Supply chain security, SLSA, vulnerability scanning, zero-trust, provenance

### Supply Chain Security

| Demo | Description | Tech Stack | Status |
|-------|-------------|-------------|----------|
| [SBOM Integration](./) | Software Bill of Materials generation | Syft, SPDX, CycloneDX | In Progress |
| [SLSA Attestations](./) | Supply chain Levels for Software Artifacts | Sigstore, Cosign, SLSA | In Progress |
| [Image Scanning](./) | Container vulnerability scanning | Trivy, Grype, GitHub Actions | Implemented |

### Zero-Trust Architecture

| Demo | Description | Tech Stack | Quick Start |
|-------|-------------|-------------|-------------|
| [Cilium Network Policies](./kubernetes/) | Zero-trust networking | Cilium, eBPF, network policies | [Quick Start](./kubernetes/#networking-security) |
| [mTLS Everywhere](./kubernetes/) | Mutual TLS encryption | Cilium, certificates, PKI | [Quick Start](./kubernetes/#networking-security) |

---

## ☁️ Cloud Infrastructure

### Multi-Cloud Patterns

| Demo | Description | Clouds | Quick Start |
|-------|-------------|---------|-------------|
| [Pulumi Azure Tenant](./pulumi-azure-tenant/) | Multi-tenant IaC on Azure | Azure, Pulumi (Go), Azure AD | [Quick Start](./pulumi-azure-tenant/) |
| [AWS EKS Demo](./eks-gha-aws-demo/) | EKS deployment automation | AWS, Pulumi, GitHub Actions | [Quick Start](./eks-gha-aws-demo/) |

### Serverless & Edge

| Demo | Description | Cloud | Quick Start |
|-------|-------------|---------|-------------|
| [Lambactl](./lambactl/) | AWS Lambda CLI tool | AWS Lambda, Go, CLI | [Quick Start](./lambactl/) |

---

## 🐧 Linux & Systems

**Core Focus:** Kernel development, system programming, operating system internals, low-level optimization

### Kernel & OS

| Demo | Description | Area | Quick Start |
|-------|-------------|-------|-------------|
| [Kernel Research](./linux/) | Linux kernel experiments | Systems programming | [Read](./linux/) |
| [Python from Source](./linux/) | Building Python toolchain | Build systems, packaging | [Read](./linux/) |
| [Container from Scratch](./kubernetes/) | Building minimal containers | Linux internals, containers | [Read](./kubernetes/ContainerFromScratch.md) |

---

## 🔬 Research & Experimentation

| Demo | Description | Area | Quick Start |
|-------|-------------|-------|-------------|
| [Research.md](../Research.md) | AI/ML, Kubernetes, security research | Ongoing studies | [Read](../Research.md) |
| [History.md](../History.md) | Technology evolution timeline | Historical context | [Read](../History.md) |

---

## 📊 Demo Statistics

| Category | Number of Demos | Complexity Level | Production Ready |
|----------|------------------|------------------|-----------------|
| AI/ML Infrastructure | 8+ | Advanced | ✅ Yes |
| Kubernetes Operations | 15+ | Advanced | ✅ Yes |
| Development Tools | 4+ | Intermediate | ✅ Yes |
| Rust Tools | 4+ | Intermediate | ✅ Yes |
| Python Best Practices | 3+ | Beginner-Intermediate | ✅ Yes |
| Security & Compliance | 3+ | Advanced | ⚠️ In Progress |
| Cloud Infrastructure | 3+ | Intermediate | ✅ Yes |
| Linux & Systems | 3+ | Advanced | ⚠️ Experimental |
| Research | 2 | N/A | N/A |

---

## 🎯 Quick Start Guide

### For AI/ML Engineers
1. Start with [LLM Infrastructure](./llm/) for GPU optimization
2. Explore [Multi-Agent AI](./llm/) for MCP patterns
3. Review [MLOps Pipeline](./llm/) for production ML
4. Check [BENCHMARKS.md](../BENCHMARKS.md) for GPU performance metrics

### For DevOps Engineers
1. Review [Kubernetes deployments](./kubernetes/) across AWS, GCP, Azure
2. Explore [Dagger CI](./dagger-go-ci/) for container-native pipelines
3. Study [Cilium networking](./kubernetes/) for zero-trust architecture
4. Check [COMPARISONS.md](../COMPARISONS.md) for tool decisions

### For Software Engineers
1. Explore [Rust tools](./rust/) for systems programming
2. Review [Python best practices](./python/) for production code
3. Study [CI/CD patterns](./dagger-go-ci/) for automation
4. Check [cdebug](./cdebug/) for container debugging

### For Security Engineers
1. Review [Supply Chain Security](../COMPARISONS.md/#-container-optimization) approaches
2. Explore [Zero-Trust Architecture](./kubernetes/) implementation
3. Study [Security.md](../SECURITY.md) for vulnerability reporting
4. Check [Research.md](../Research.md) for security research

---

## 🔗 Related Documentation

- [Main README](../README.md) - Portfolio overview
- [COMPARISONS.md](../COMPARISONS.md) - Technology decision frameworks
- [BENCHMARKS.md](../BENCHMARKS.md) - Performance metrics and optimizations
- [Research.md](../Research.md) - Ongoing research topics
- [History.md](../History.md) - Technology evolution

---

## 📄 License

All demos are licensed under MIT License. See [LICENSE](../LICENSE) for details.

---

**Organized by technology domain for easier navigation and exploration.**
