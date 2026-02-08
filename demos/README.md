# Demos & Examples

This directory contains production-ready demonstrations, architectural patterns, and learning resources across multiple domains.

---

## 📂 Directory Overview

| Directory | Description | Technologies |
|-----------|-------------|--------------|
| **[kubernetes/](kubernetes/)** | 100+ deployment patterns | K8s, EKS, GKE, Talos, Cilium |
| **[llm/](llm/)** | AI/ML infrastructure demos | Mistral, OpenAI, NVIDIA GPUs |
| **[dagger-go-ci/](dagger-go-ci/)** | CI/CD pipelines | Dagger, Tekton, Go |
| **[pulumi-azure-tenant/](pulumi-azure-tenant/)** | Multi-tenant IaC | Pulumi (Go), Azure |
| **[cdebug/](cdebug/)** | Container debugging tool | Docker, Podman, Kubernetes |
| **[rust/](rust/)** | Rust CLI tools | Rust, Tokio |
| **[python/](python/)** | Python best practices | Poetry, Type hints |
| **[linux/](linux/)** | Linux infrastructure | Systemd, Containers |
| **[lambactl/](lambactl/)** | Lambda automation | AWS Lambda, Go |
| **[QubesOS/](QubesOS/)** | Security-focused OS | Xen, Qubes |

---

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/awdemos/demos.git
cd demos

# Explore available demos
ls -la
```

---

## 🎯 Featured Demos

### AI/ML Infrastructure

- **[llm/finetuning](llm/finetuning)** - LLM fine-tuning workflows with MLflow
- **[llm/grok](llm/grok)** - Grok model integration examples
- **[llm/chainlit_rust_rag](llm/chainlit_rust_rag)** - RAG pipeline with Rust backend
- **[llm/attacks](llm/attacks)** - Adversarial attack demonstrations

### Kubernetes & Cloud Native

- **[kubernetes/](kubernetes/)** - Comprehensive K8s patterns (100+ examples)
- **[eks-gha-aws-demo](eks-gha-aws-demo)** - EKS with GitHub Actions
- **[vpc_eks_terraform-demo](vpc_eks_terraform-demo)** - VPC + EKS with Terraform

### CI/CD & Automation

- **[dagger-go-ci/](dagger-go-ci/)** - Container-native CI/CD pipelines
- **[cdebug/](cdebug/)** - Container debugging across runtimes

### Development Tools

- **[rust/user_boilerplate](rust/user_boilerplate)** - Rust CLI boilerplate
- **[python/flask_best_practices](python/flask_best_practices)** - Production Flask patterns
- **[python/poetry-container-sample](python/poetry-container-sample)** - Poetry in containers

---

## 📚 Usage Guidelines

Each demo directory includes:
- `README.md` - Detailed documentation and usage instructions
- Configuration files - Production-ready examples
- Scripts - Automation helpers where applicable

**Best Practices:**
- Review README.md before running any demo
- Check requirements for each demo (tools, versions, dependencies)
- Many demos require AWS/GCP/Azure credentials for cloud resources
- Kubernetes demos typically assume a running cluster

---

## 🔧 Prerequisites

### Core Tools
- [Docker](https://docs.docker.com/get-docker/) or [Podman](https://podman.io/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Git](https://git-scm.com/)

### Cloud Tools (as needed)
- [AWS CLI](https://aws.amazon.com/cli/)
- [GCP CLI (gcloud)](https://cloud.google.com/sdk/gcloud)
- [Azure CLI](https://docs.microsoft.com/cli/azure/)

### Development Tools
- [Go](https://golang.org/) - For Go-based demos
- [Python 3.10+](https://www.python.org/) - For Python demos
- [Rust](https://www.rust-lang.org/) - For Rust demos
- [Node.js](https://nodejs.org/) - For TypeScript/JavaScript demos

---

## 🤝 Contributing

While this is a demonstration repository, feedback is welcome! Create an [issue](https://github.com/awdemos/demos/issues) for questions or suggestions.

---

## 📄 License

All original code in this repository is released under the **MIT License**. Third-party components may have different licenses.

---

*Explore the demos to see production-ready infrastructure patterns in action!*
