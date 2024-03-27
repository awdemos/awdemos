# README

## Project Overview

Hi and welcome to my demos repo!

This repository showcases a collection of demo projects and research that interest me. Among other things there are example deployments in Docker, AWS, and GCP, bare metal Kubernetes, and other projects leveraging modern and cutting-edge technologies.

While the initial focus of this demo is for technical projects, I have expanded it to include various topics including containers, Large Language Models, and tooling.

The demos include examples using Terraform and Pulumi for deploying resources, containerization with docker, Kubernetes for orchestration, as well as some nice-to-haves like git tips, zsh, and neovim configs, and a lot more.

Be sure to check out the analysis of Grok, the Ultimate Kubernetes Wishlist, low level Kubernetes details, and even Talos cluster setups in docker.

If anything strikes you as particularly interesting and you want to speak with me about an opportunity? You can schedule a meeting with me anytime during Eastern Standard Time ([https://cal.com/aiconsulting](https://cal.com/aiconsulting)).

### Highlights:

- **Pulumi Projects**: Utilizes Pulumi for infrastructure as code to deploy resources into AWS, with configurations written in Go. For more information, please see [Pulumi's Go documentation](https://www.pulumi.com/docs/languages-sdks/go/).

- **Ethereum Node Deployment**: Features an infrastructure setup including a VPC, public subnet, internet gateway, route table, security group, and an EC2 instance. The EC2 instance is configured to install and run an Ethereum node using the `geth` command.

- **Fargate Integration**: Demonstrates building a local Docker container and pushing it to an AWS ECR repository, presumably for later ingestion into Kubernetes.

- **Golang CLI for Lambda Labs**: Lambda Labs is an cloud on-demand GPU cloud service. My project includes an example and untested Golang CLI using the OpenAPI spec of the service.

- **Grok Large Language Model Analysis**: Includes analysis of how the [https://github.com/xai-org/grok-1](https://github.com/xai-org/grok-1) codebase works.

- **Kubernetes LLM Installs**: Includes examples of installing Mistral LLM and the OpenAI embedding service in Kubernetes via helm charts, showcasing how to run LLMs in Kubernetes.

- **Python Scripts and Packaging**: Recent work I did setting up poetry.

## Prerequisites

- AWS/GCP CLI configured with your credentials
- Nerdctl
- Git
- Docker
- Kubernetes CLI (kubectl)
- Pulumi
- Python
- Terraform

## Setup Instructions

### Cloning the Repository

```sh
git clone https://github.com/awdemos/demos.git
cd demos
```

# Some of my favorite tools

A curated list of my favorite projects across various domains and technologies.

## Infrastructure and Orchestration
- [Talos](https://www.talos.dev/) - A modern OS for Kubernetes.
- [Pulumi](https://www.pulumi.com/) - Infrastructure as Code for any cloud using your favorite languages.
- [Kargo](https://github.com/ContainerCraft/Kargo) - Kubernetes cluster lifecycle management tool.
- [vCluster](https://www.vcluster.com/) - Virtual Kubernetes clusters.
- [Cilium](https://cilium.io/) - eBPF-based Networking, Observability, and Security.
- [Cloudflare](https://developers.cloudflare.com/products/) - The entire suite of Cloudflare alternatives to AWS services is growing and quite compelling cost performance advantages.

## AI and Scripting
- [GPTScript](https://github.com/gptscript-ai/gptscript) - Natural language gpt scripting engine.
- [LangChain](https://langchain.com/) - LLM framework.
- [aider](https://github.com/paul-gauthier/aider) - A smart codegen in the terminal.

## Containers and Worklows
- [Dive](https://github.com/wagoodman/dive) - A tool for exploring each layer in an image, analyzing the contents, and discovering ways to shrink the size of your Docker/OCI image.
- [Podman](https://podman.io/) - A daemonless container engine for developing, managing, and running OCI Containers.
- [nerdctl](https://github.com/containerd/nerdctl) - Docker-compatible CLI for containerd.
- [slim](https://github.com/slimtoolkit/slim) - Minify container images by up to 30x.
- [Fedora Silverblue](https://silverblue.fedoraproject.org/) - Fedora Silverblue is a variant of the Fedora Workstation with an immutable desktop operating system aimed at good support for container-focused workflows.

## CI/CD and Automation
- [Tekton](https://tekton.dev/) - A powerful and flexible open-source framework for creating CI/CD systems.
- [Dagger.io](https://dagger.io/) - A programmable deployment system for your applications.

## Development Tools and IDEs
- [Kitty Terminal](https://sw.kovidgoyal.net/kitty/) - A fast, feature-rich, GPU based terminal emulator.
- [Cursor IDE](https://cursor.sh/) - AI enabled IDE.
- [Devcontainer](https://code.visualstudio.com/docs/remote/containers) - Develop inside a Docker container with Visual Studio Code.
- [Devpod](https://www.gitpod.io/docs/dev-environments) - Automated, ready-to-code development environments for Gitpod.

## Programming Languages and Frameworks
- [Go](https://golang.org/) - An open source programming language that makes it easy to build simple, reliable, and efficient software.
- [Bash](https://www.gnu.org/software/bash/) - GNU Project's shell and command language.
- [TypeScript](https://www.typescriptlang.org/) - A superset of JavaScript that compiles to clean JavaScript output.
- [Rust CLI's](https://www.rust-lang.org/what/cli) - Building command line tools with Rust.
- [Python](https://www.python.org/) - A programming language that lets you work quickly and integrate systems more effectively.

## Security and Privacy
- [Chainguard](https://chainguard.dev/) - Solutions for securing your software supply chain.
- [GrapheneOS](https://grapheneos.org/) - A privacy and security-focused Android distribution.
- [NitroPC](https://www.nitrokey.com/news/2021/introducing-nitro-pc) - A secure and open-source mini PC with open source BIOS.
- [Learn LLMs and DevSecOps](https://github.com/jedi4ever/learning-llms-and-genai-for-dev-sec-ops) - DevSecOps issues or LLMS.


## Contributing

While this is my demo repo, pull requests made in the spirit of this repository are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License

[MIT](https://choosealicense.com/licenses/mit/)
