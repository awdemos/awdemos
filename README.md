# README

## Project Overview

Hi and welcome to my demos repo!

This repository showcases a collection of demo projects and research that interest me. 

The demos directory include examples of deploying resources into public clouds, using Terraform, Pulumi, and Kubernetes for deploying resources, application containers, as well as some nice-to-haves like git tips and a lot more. 

If you are a non-engineering reviewer of this information, first of all welcome and thanks for coming by! I hope that you find this informational, feel free to just examine the sections most relevant to your interests.

For technical readers, be sure to check out the analysis of Grok, CVE-2024-3094, my Ultimate Kubernetes Wishlist, low level Kubernetes details, SRE definitions, and LLM attacks.

# Why You Should Consider Hiring Me

If you're encountering these challenges:

- Struggling to manage cloud inrastructure in a reliable manner.
- Seeking ways to make your Kubernetes, workloads, cloud, or SRE more cost-effective or faster.
- Overwhelmed by the plethora of tools and frameworks available. If you want to switch over from legacy to modern tech stacks.
- If you are uncertain about the next steps for your inrastructure products.
- In need of a subject matter expert to assess your requirements and evaluate potential needs.
- Experience matters! I steer my projects away from risky engineering practices and towards emerging solutions that use patterns that are designed to work better, faster, cheaper.

## What I Offer

- **Domain-Specific Evaluation Systems**: Tailor-made systems to assess the performance and reliability of your inrastructure, ensuring they meet the specific needs of your domain.
- **Cost management**: Enhancing the efficiency of cloud deployments is more important now then ever. I can frequently get 50% cost savings for an organization.
- **Development Tools and Infrastructure**: Custom solutions to streamline your development process, facilitating rapid iterations on sotfware releases.
- **Product Strategy Guidance**: Strategic advice on product development, prioritization, and talent evaluation to bolster your team.
- **Content and Writing**: I also provide documentation on any systems or environments I work on.

## Consulting Services Offered

### Tier 1: Strategy

Guidance on:
- On-prem or cloud performance (cost, quality, speed)
- LLMs
- Agents, agentic frameworks, bots
- Prompting
- Industry trends
- AI workshops
- Product strategy
- Custom systems
- Techniques like "Shift Left," immutable operating systems, zero authentication. (As it is 2024, we can even do better then "Shift left," we can "Start left")

You'll receive a comprehensive plan and regular team consultations to navigate common pitfalls and optimize tool and technique selection.

### Tier 2: Comprehensive

Includes all Tier 1 services, plus:
- **Implementation**: Production-ready code and prototypes to fast-track release and development.
- **Hands-On MLOps Optimization**: Direct involvement in fine-tuning and prompt engineering to boost model performance.
- **Content Production**: Creation of technical documents and blog posts to share best practices and insights with your stakeholders.
- **Team Growth**: Personalized training for 2-4 team members to quickly enhance their AI skills.
- **Extended Consultation**: I am available on consulting retainer on an hourly basis. That can include Linux, DevOps, SRE, AI, and other cutting-edge techniques and trends.

Tier 2 services are exclusive to one client at a time to guarantee the highest quality of service.

## What Perplexity thinks my resume says about my character and personality

Based on my extensive experience and accomplishments, several aspects of my character and personality can be inferred:

## Growth Mindset and Adaptability
I demonstrate a strong growth mindset, as evidenced by my career progression from IT roles to advanced AI engineering positions. I've consistently adapted to new technologies and challenges, showing a willingness to learn and evolve.

## Intellectual Curiosity
My diverse research interests and continuous pursuit of certifications and bootcamps indicate a deep intellectual curiosity. I'm passionate about staying at the forefront of technology, particularly in AI, machine learning, and programming languages.

## Leadership and Collaboration
Throughout my career, I've taken on leadership roles, managing teams and collaboration across teams and departments. This suggests strong interpersonal skills and the ability to work effectively in diverse environments.

## Innovation-Driven
I appear to be innovation-driven, often implementing new technologies and improving existing systems. My work in AI and blockchain indicates a forward-thinking approach to technology.

## Detail-Oriented and Security-Conscious
My experience in creating disaster recovery plans, implementing security measures, and obtaining security-related certifications suggests a detail-oriented nature and a strong focus on cybersecurity.

## Ethical Considerations
My involvement in establishing AI governance models and an awareness of ethical and legal implications in AI technology is up to date on this topic. I view AI as a social good and a marvelous opportunity to improve quality of life.
I can commit to you that I will not work on AI weapon systems or unethical use cases and I have not done so in the past.

## Problem-Solver
My track record of tackling complex technical challenges across various roles suggests strong problem-solving skills and a proactive approach to addressing issues.

## Communicator
My experience as a Sales Engineer and ability to work with diverse stakeholders indicate strong communication skills, both technical and non-technical.

## Lifelong Learner
My ongoing pursuit of certifications and participation in bootcamps, even at a senior level in my career, demonstrates a commitment to lifelong learning and self-improvement.

These traits paint a picture of me as a well-rounded, technically proficient professional who is proactive, adaptable, and committed to driving innovation while maintaining ethical standards in technology.


## How to Engage My Services

If anything strikes you as particularly interesting and you want to speak with me about an opportunity? 

You can schedule a meeting with me anytime during Eastern Standard Time ([https://cal.com/aiconsulting](https://cal.com/aiconsulting)).

### Git Repo Highlights:

- **SRE Methodologies**: A detailed explanation of the changes the SRE discipline brings to the world of software delivery. 

- **Pulumi Projects**: Utilizes Pulumi for infrastructure as code to deploy resources into AWS, with configurations written in Go. For more information, please see [Pulumi's Go documentation](https://www.pulumi.com/docs/languages-sdks/go/).

- **Ethereum Node Deployment**: Features an infrastructure setup including a VPC, public subnet, internet gateway, route table, security group, and an EC2 instance. The EC2 instance is configured to install and run an Ethereum node using the `geth` command.

- **Fargate Integration**: Demonstrates building a local Docker container and pushing it to an AWS ECR repository, presumably for later ingestion into Kubernetes.

- **Golang CLI for Lambda Labs**: Lambda Labs is an cloud on-demand GPU cloud service. My project includes an example and untested Golang CLI using the OpenAPI spec of the service.

- **Grok Large Language Model Analysis**: Includes analysis of how the [https://github.com/xai-org/grok-1](https://github.com/xai-org/grok-1) codebase works.

- **Kubernetes LLM Installs**: This includes examples of installing Mistral LLM and the OpenAI embedding service in Kubernetes via helm charts, showcasing how to run LLMs in Kubernetes.

- **Python Scripts and Packaging**: Some example scripts and best practices I like.

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
- [vCluster](https://www.vcluster.com/) - Virtual Kubernetes clusters.
- [Cilium](https://cilium.io/) - eBPF-based Networking, Observability, and Security.
- [Cloudflare](https://developers.cloudflare.com/products/) - The entire suite of Cloudflare alternatives to AWS services is growing and quite compelling cost performance advantages.

## AI and Scripting
- [GPTScript](https://github.com/gptscript-ai/gptscript) - Natural language gpt scripting engine.
- [aider](https://github.com/paul-gauthier/aider) - A smart codegen in the terminal.
- [ComfyUI](https://github.com/comfyanonymous/ComfyUI) - This stable difffusion framework or another like is likely going to change the Internet forever imho.
- [vLLM](https://github.com/vllm-project/vllm) - vLLM is a fast and easy-to-use library for LLM inference and serving.


## Containers and Worklows
- [bincapz](https://github.com/chainguard-dev/bincapz) - A tool for securing container images by applying binary capabilities with fine-grained control.
- [Colima](https://github.com/abiosoft/colima) - A container runtime for macOS (and Linux) that emphasizes simplicity and performance. It supports Docker and Kubernetes out of the box.
- [Dive](https://github.com/wagoodman/dive) - A tool for exploring each layer in an image, analyzing the contents, and discovering ways to shrink the size of your Docker/OCI image.
- [Podman](https://podman.io/) - A daemonless container engine for developing, managing, and running OCI Containers.
- [nerdctl](https://github.com/containerd/nerdctl) - Docker-compatible CLI for containerd.
- [slim](https://github.com/slimtoolkit/slim) - Minify container images by up to 30x.
- [Fedora Silverblue](https://silverblue.fedoraproject.org/) - Fedora Silverblue is a variant of the Fedora Workstation with an immutable desktop operating system aimed at good support for container-focused workflows. I use the Blufin spinoff now.
- [Xenia Linux](https://xenialinux.com/) - An immutable distribution based on Gentoo
- [Asterinas](https://github.com/asterinas/asterinas) - Asterinas is a secure, fast, and general-purpose OS kernel, written in Rust and providing Linux-compatible ABI.


## CI/CD and Automation
- [Tekton](https://tekton.dev/) - A powerful and flexible open-source framework for creating CI/CD systems.
- [Dagger.io](https://dagger.io/) - A programmable deployment system for your applications.

## Development Tools and IDEs
- [WezTerm](https://wezfurlong.org/wezterm/index.html) - WezTerm is a powerful cross-platform terminal emulator and multiplexer written by @wez and implemented in Rust
- [Zed IDE](https://zed.dev/) - Rust written AI enabled IDE.
- [Devcontainer](https://code.visualstudio.com/docs/remote/containers) - Develop inside a Docker container with Visual Studio Code.
- [Devpod](https://www.gitpod.io/docs/dev-environments) - Automated, ready-to-code development environments for Gitpod.

## Programming Languages and Frameworks
- [Go](https://golang.org/) - An open source programming language that makes it easy to build simple, reliable, and efficient software.
- [Bash](https://www.gnu.org/software/bash/) - GNU Project's shell and command language.
- [TypeScript](https://www.typescriptlang.org/) - A superset of JavaScript that compiles to clean JavaScript output.
- [Rust CLI's](https://www.rust-lang.org/what/cli) - Building command line tools with Rust. Rust is my favorite language by a mile right now.
- [Python](https://www.python.org/) - A programming language that lets you work quickly and integrate systems more effectively.

## Security and Privacy
- [Chainguard](https://chainguard.dev/) - Solutions for securing Docker images.
- [GrapheneOS](https://grapheneos.org/) - A privacy and security-focused Android distribution.
- [NitroPC](https://www.nitrokey.com/news/2021/introducing-nitro-pc) - A secure and open-source mini PC with open source BIOS.
- [Learn LLMs and DevSecOps](https://github.com/jedi4ever/learning-llms-and-genai-for-dev-sec-ops) - DevSecOps issues or LLMS.


## Contributing

While this is my demo repo, pull requests made in the spirit of this repository are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License

Any software written by me is released under the [MIT](https://choosealicense.com/licenses/mit/) license. Software released by others may have other licenses, please see their licensing page for more information.
