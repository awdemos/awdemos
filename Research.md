# Research

This document contains a collection of resources related to various topics.

## AI

- "Generative Adversarial Nets" [@arXiv:1406.2661](https://arxiv.org/abs/1406.2661): Presents the foundational framework for generative adversarial networks (GANs), a powerful class of AI models for generating new data similar to the training set.
- "Deep Residual Learning for Image Recognition" [@arXiv:1512.03385](https://arxiv.org/abs/1512.03385): Introduces ResNet, a deep learning model for image recognition that enables training of significantly deeper networks.
- "Attention Is All You Need" [@arXiv:1706.03762](https://arxiv.org/abs/1706.03762)
- "Large Scale GAN Training for High Fidelity Natural Image Synthesis" [@arXiv:1809.11096](https://arxiv.org/abs/1809.11096): Details improvements in GAN training techniques, leading to higher quality and more realistic image generation.
- "Transformer-XL: Attentive Language Models Beyond a Fixed-Length Context" [@arXiv:1901.02860](https://arxiv.org/abs/1901.02860): Advances the Transformer architecture to handle longer context, improving performance on tasks requiring understanding of extended text.
- "BERT: Pre-training of Deep Bidirectional Transformers for Language Understanding" [@arXiv:2402.10200](https://arxiv.org/abs/2402.10200)
- "GPT-3: Language Models are Few-Shot Learners" [@arXiv:2402.18312](https://arxiv.org/abs/2402.18312)
- "Vision Transformer: An Image is Worth 16x16 Words" [@arXiv:2403.08299](https://arxiv.org/abs/2403.08299)
- "EfficientNet: Rethinking Model Scaling for Convolutional Neural Networks" [@arXiv:2403.09629](https://arxiv.org/abs/2403.09629)
- "DALL·E: Creating Images from Text" [@arXiv:2402.09171](https://arxiv.org/pdf/2402.09171.pdf)
- "Exploring the Limits of Transfer Learning with a Unified Text-to-Text Transformer" [@arXiv:2308.08155](https://arxiv.org/abs/2308.08155)
- "Text recognition (optical character recognition) with deep learning methods, ICCV 2019" (https://github.com/clovaai/deep-text-recognition-benchmark)
- "Strategic Reasoning with Language Models" [@arXiv:2305.19165] (https://arxiv.org/abs/2305.19165)
- "Model Merging: A Pathway to Efficient Model Sharing" [@arXiv:2403.13187](https://arxiv.org/abs/2403.13187): Explores techniques for merging different machine learning models to enhance performance and efficiency, offering a novel approach to collaborative model improvement.
- "OLMo: Accelerating the Science of Language Models" [@arXiv:2402.00838] (https://arxiv.org/pdf/2402.00838.pdf)


## Ethereum

Ethereum is an open-source, blockchain-based platform that enables developers to build and deploy decentralized applications. Here are some useful resources:

- [Running Ethereum Nodes on AWS](https://aws.amazon.com/blogs/database/run-ethereum-nodes-on-aws/)
- [Ethereum Execution APIs](https://github.com/ethereum/execution-apis/tree/main/src/engine)
- [Geth Node Architecture](https://geth.ethereum.org/docs/fundamentals/node-architecture)
- [Ethereum Consensus Mechanisms](https://ethereum.org/en/developers/docs/consensus-mechanisms/pos)
- [Ethers.js Documentation](https://docs.ethers.org/v6/)
- [Foundry Book](https://book.getfoundry.sh/)
- [Create Turbo-Eth](https://github.com/turbo-eth/create-turbo-eth)
- [What is Blockchain Node Engine?](https://cloud.google.com/blockchain-node-engine/docs/overview)
- [Ethereum All Core Developers Execution Call #181](https://www.galaxy.com/insights/research/ethereum-all-core-developers-execution-call-181/)

## Circle

- [What is USDC](https://developers.circle.com/stablecoins/docs/what-is-usdc) this is an Ethereum product that runs on EKS clusters in AWS.

## Chainlink nodes

This is a Chainlink presentation I made last year for a client.

- [Chainlink Presentation](https://docs.google.com/presentation/d/1gnTWuusMh8vYbW2R2zybnFGNnfg6ubE7wwlaL7qcdIQ/edit?pli=1#slide=id.p)

## Containers

I have a lot to add here eventually. Let's just start with ,y favorite labs environnment 

- [Explore containerd with iximiuz Labs Courses](https://labs.iximiuz.com/courses)
- [Linux Container Primitives: cgroups, namespaces, and more!](https://www.youtube.com/watch?v=x1npPrzyKfs)

## Docker

Docker is a platform that utilizes OS-level virtualization to deliver software in packages known as containers. As of 2024, my tooling preferences have changed to use nerer tooling and I prefer using Podman and Nerdctl to do container work instead of Docker.

- [Docker Business Products](https://www.docker.com/products/business/)
- [Secure Software Supply Chain Best Practices](https://www.docker.com/blog/secure-software-supply-chain-best-practices/)
- [Building Multimodal GenAI Apps with OctoAI and Docker](https://www.docker.com/blog/build-multimodal-genai-apps-with-octoai-and-docker/)
- [Test your containers with the Docker Desktop one-node cluster](https://www.docker.com/static/test-lab-docker-kubernetes-admin-magazine-article.pdf)

## DevSecOps

DevSecOps is a set of practices that combines software development (Dev) with security (Sec) and operations (Ops). It aims to shorten the development life cycle and provide continuous delivery with high software quality. Here are some key resources:

- [DevSecOps Playbook](https://github.com/6mile/DevSecOps-Playbook)
- [DevSecOps Best Practices](https://www.redhat.com/en/topics/devops/what-is-devsecops)
- [Learning LLMs and GenAI for DevSecOps](https://github.com/jedi4ever/learning-llms-and-genai-for-dev-sec-ops)


## Python

Python is a high-level, interpreted programming language known for its readability.

In the python directory there is a custom project I made that is a data vlidation input checker for a Dockerfile generator I hope to make more robust over time.

- [PyGit Source Code](https://github.com/benhoyt/pygit/blob/master/pygit.py) This is my favorite way to learn python and git.
- [pyenv](https://github.com/pyenv/pyenv) I believe this is an underappreciated component of the python ecosystem more people should be using.

## Datadog

Datadog is a monitoring service for cloud-scale applications.

- [Setting Up SLIs, SLOs, and Monitors with Datadog](https://engineering.sada.com/setting-up-slis-slos-and-monitors-with-datadog-f0428b36436e)
- [Defining and Managing SLOs](https://www.datadoghq.com/blog/define-and-manage-slos/)
- [Datadog Agent Getting Started Guide](https://docs.datadoghq.com/getting_started/agent/)
- [Google SLO Generator](https://github.com/google/slo-generator/blob/master/README.md)

## Nvidia

- [Triton Inference Server](https://github.com/triton-inference-server/server) - An optimized cloud and edge inferencing solution that supports multiple deep learning and machine learning frameworks.
- [NVIDIA Container Toolkit](https://github.com/NVIDIA/nvidia-container-toolkit) - Allows users to build and run GPU accelerated containers, including a container runtime library and utilities to automatically configure containers to leverage NVIDIA GPUs.

(See dedicated page for this elsewhere in the repo)

## Metrics

- [Hardware Metrics Monitoring with Prometheus and Grafana](https://www.sentrysoftware.com/docs/hws-doc/latest/prometheus/grafana.html) - A guide on monitoring hardware metrics using Prometheus and Grafana.

## Just for fun

## Claude generated papers via (https://twitter.com/irl_danB).

None of these following papers are peer reviewed!!! However they provide an imaginative exploration into the realms of physics and consciousness, and scrutinizes the "strange loop" between reality and simulation through a new vantage point.

- [The Fundamental Laws of Physics: A Comprehensive Specification for the Simulation of Reality](https://ia600201.us.archive.org/8/items/the-fundamental-laws-of-physics-a-comprehensive-specification-for-the-simulation-of-reality/The%20Fundamental%20Laws%20of%20Physics-%20A%20Comprehensive%20Specification%20for%20the%20Simulation%20of%20Reality.pdf) - This document delves into the core principles that could govern a simulated reality, offering a detailed specification for the simulation of physical laws as we understand them.

- [A Formal Theory of Self and Consciousness in Simulated Realities](https://ia800207.us.archive.org/0/items/a-formal-theory-of-self-and-consciousness-in-simulated-realities/A%20Formal%20Theory%20of%20Self%20and%20Consciousness%20in%20Simulated%20Realities.pdf) - This paper presents a theoretical framework for understanding the concept of 'self' and 'consciousness' within the context of simulated environments, exploring the implications of such environments on our perception of reality.

- [The Holographic Quantum Automaton: A Unified Framework for Emergent Spacetime and Quantum Gravity](https://ia600209.us.archive.org/32/items/the-holographic-quantum-automaton-a-unified-framework-for-emergent-spacetime-and-quantum-gravity/The%20Holographic%20Quantum%20Automaton-%20A%20Unified%20Framework%20for%20Emergent%20Spacetime%20and%20Quantum%20Gravity.pdf) - This research proposes a novel approach to integrating the concepts of quantum mechanics and general relativity, suggesting a holographic model that could potentially explain the emergence of spacetime and the nature of gravity.

- [Emergence of Consciousness in Artificial Intelligences: A Formal Analysis of the Strange Loop Hypothesis](https://ia600206.us.archive.org/30/items/emergence-of-consciousness-in-artificial-intelligences-a-formal-analysis-of-the-_202403/Emergence%20of%20Consciousness%20in%20Artificial%20Intelligences-%20A%20Formal%20Analysis%20of%20the%20Strange%20Loop%20Hypothesis.pdf) - This paper explores the theoretical underpinnings of consciousness in artificial intelligences, utilizing the Strange Loop hypothesis as a framework for understanding emergent self-awareness in computational systems.