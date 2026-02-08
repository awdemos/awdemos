# Research

This document contains a collection of resources related to various topics, with focus on AI infrastructure, multi-agent systems, NVIDIA technologies, supply chain security, and modern development practices.

## AI & Multi-Agent Systems

### Large Language Models & Transformers
- "Attention Is All You Need" [@arXiv:1706.03762](https://arxiv.org/abs/1706.03762): Foundational transformer architecture paper
- "BERT: Pre-training of Deep Bidirectional Transformers for Language Understanding" [@arXiv:2402.10200](https://arxiv.org/abs/2402.10200)
- "GPT-3: Language Models are Few-Shot Learners" [@arXiv:2402.18312](https://arxiv.org/abs/2402.18312)
- "Transformer-XL: Attentive Language Models Beyond a Fixed-Length Context" [@arXiv:1901.02860](https://arxiv.org/abs/1901.02860): Extends transformers for longer context windows
- "OLMo: Accelerating the Science of Language Models" [@arXiv:2402.00838](https://arxiv.org/pdf/2402.00838.pdf): Complete open source foundational model release

### Multi-Agent AI Systems
- "More Agents Is All You Need" [@arXiv:2402.05120](https://arxiv.org/abs/2402.05120): Demonstrates LLM performance scaling through sampling-and-voting with multiple agents
- "AgentBench" [@arXiv:2308.03688](https://arxiv.org/abs/2308.03688): Comprehensive benchmark for evaluating LLM agents
- "AutoGen: Enabling Next-Gen LLM Applications" (Microsoft Research): Multi-agent conversation framework
- "Model Context Protocol (MCP) Specification" (Anthropic/OpenAI): Protocol for connecting LLMs to external tools and data sources

### AI Agents & Tool Use
- "Strategic Reasoning with Language Models" [@arXiv:2305.19165](https://arxiv.org/abs/2305.19165): Studies strategic capabilities of LLMs
- "ReAct: Synergizing Reasoning and Acting in Language Models" [@arXiv:2210.03629](https://arxiv.org/abs/2210.03629): Framework for combining reasoning with tool use
- "Toolformer" [@arXiv:2302.04761](https://arxiv.org/abs/2302.04761): Self-supervised learning to decide which API calls to make

### Computer Vision & GANs
- "Generative Adversarial Nets" [@arXiv:1406.2661](https://arxiv.org/abs/1406.2661): Foundational GAN framework
- "Deep Residual Learning for Image Recognition" [@arXiv:1512.03385](https://arxiv.org/abs/1512.03385): ResNet architecture enabling deeper networks
- "Large Scale GAN Training for High Fidelity Natural Image Synthesis" [@arXiv:1809.11096](https://arxiv.org/abs/1809.11096): High-quality image generation techniques
- "Vision Transformer: An Image is Worth 16x16 Words" [@arXiv:2403.08299](https://arxiv.org/abs/2403.08299)
- "DALL·E: Creating Images from Text" [@arXiv:2402.09171](https://arxiv.org/pdf/2402.09171.pdf)

### Model Optimization & Efficiency
- "EfficientNet: Rethinking Model Scaling for Convolutional Neural Networks" [@arXiv:2403.09629](https://arxiv.org/abs/2403.09629)
- "Model Merging: A Pathway to Efficient Model Sharing" [@arXiv:2403.13187](https://arxiv.org/abs/2403.13187): Techniques for merging ML models to enhance performance
- "LoRA: Low-Rank Adaptation of Large Language Models" [@arXiv:2106.09685](https://arxiv.org/abs/2106.09685): Efficient fine-tuning approach

### Retrieval-Augmented Generation (RAG)
- "Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks" [@arXiv:2005.11401](https://arxiv.org/abs/2005.11401): Foundational RAG paper
- "Dense Passage Retrieval for Open-Domain Question Answering" [@arXiv:2004.04906](https://arxiv.org/abs/2004.04906): Dense retrieval for question answering
- "Exploring the Limits of Transfer Learning with a Unified Text-to-Text Transformer" [@arXiv:2308.08155](https://arxiv.org/abs/2308.08155)

### AI Safety & Alignment
- "Constitutional AI: Harmlessness from AI Feedback" [@arXiv:2212.08073](https://arxiv.org/abs/2212.08073): Self-improvement through AI feedback
- "Red Teaming Language Models to Reduce Harms" [@arXiv:2209.07858](https://arxiv.org/abs/2209.07858): Methods for identifying and mitigating harmful outputs
- "AAS (Artificial Age Score) Monad Framework": Systematic evaluation methodology for AI systems (see dotfiles)



## Blockchain & Web3

### Ethereum
- [Running Ethereum Nodes on AWS](https://aws.amazon.com/blogs/database/run-ethereum-nodes-on-aws/)
- [Ethereum Execution APIs](https://github.com/ethereum/execution-apis/tree/main/src/engine)
- [Geth Node Architecture](https://geth.ethereum.org/docs/fundamentals/node-architecture)
- [Ethereum Consensus Mechanisms](https://ethereum.org/en/developers/docs/consensus-mechanisms/pos)
- [Ethers.js Documentation](https://docs.ethers.org/v6/)
- [Foundry Book](https://book.getfoundry.sh/)
- [Create Turbo-Eth](https://github.com/turbo-eth/create-turbo-eth)

### Stablecoins
- [What is USDC](https://developers.circle.com/stablecoins/docs/what-is-usdc): Ethereum product running on EKS clusters in AWS

### Oracle Networks
- [Chainlink Documentation](https://docs.chain.link/): Decentralized oracle network

---

## Containers & Orchestration

### Container Runtimes & Tools
- [Explore containerd with iximiuz Labs Courses](https://labs.iximiuz.com/courses): Hands-on containerd learning
- [Linux Container Primitives](https://www.youtube.com/watch?v=x1npPrzyKfs): cgroups, namespaces, and more
- [Podman Documentation](https://docs.podman.io/): Daemonless container engine
- [nerdctl Documentation](https://github.com/containerd/nerdctl): Docker-compatible containerd CLI

### Container Security
- [Dive](https://github.com/wagoodman/dive): Docker image layer analysis
- [Trivy](https://aquasecurity.github.io/trivy/): Container security scanner
- [bincapz](https://github.com/chainguard-dev/bincapz): Container image security analysis
- [Slim Toolkit](https://github.com/slimtoolkit/slim): Container image optimization

### Docker Resources
- [Docker Business Products](https://www.docker.com/products/business/)
- [Secure Software Supply Chain Best Practices](https://www.docker.com/blog/secure-software-supply-chain-best-practices/)
- [Building Multimodal GenAI Apps with OctoAI and Docker](https://www.docker.com/blog/build-multimodal-genai-apps-with-octoai-and-docker/)

---

## DevSecOps

- [DevSecOps Playbook](https://github.com/6mile/DevSecOps-Playbook): Comprehensive security integration guide
- [DevSecOps Best Practices](https://www.redhat.com/en/topics/devops/what-is-devsecops): Red Hat's approach to DevSecOps
- [Learning LLMs and GenAI for DevSecOps](https://github.com/jedi4ever/learning-llms-and-genai-for-dev-sec-ops): AI applications in security

---

## Python

- [Understanding Python Builtins](https://tushar.lol/post/builtins/#so-whats-a-builtin): Deep dive into Python's built-in functions
- [PyGit Source Code](https://github.com/benhoyt/pygit/blob/master/pygit.py): Pure Python git implementation for learning
- [pyenv](https://github.com/pyenv/pyenv): Python version management

*Note: See `python/` directory for custom data validation project for Dockerfile generation*

---

## Monitoring & Observability

### Datadog
- [Setting Up SLIs, SLOs, and Monitors with Datadog](https://engineering.sada.com/setting-up-slis-slos-and-monitors-with-datadog-f0428b36436e)
- [Defining and Managing SLOs](https://www.datadoghq.com/blog/define-and-manage-slos/)
- [Datadog Agent Getting Started Guide](https://docs.datadoghq.com/getting_started/agent/)
- [Google SLO Generator](https://github.com/google/slo-generator/blob/master/README.md)

### Metrics Collection
- [Prometheus Documentation](https://prometheus.io/docs/): Monitoring and alerting toolkit
- [Grafana Documentation](https://grafana.com/docs/): Visualization and analytics platform
- [Hardware Metrics Monitoring with Prometheus and Grafana](https://www.sentrysoftware.com/docs/hws-doc/latest/prometheus/grafana.html)

---

## Software Development & Philosophy

### Agile & Development Methodologies
- [Sprints - The Biggest Mistake Of Software Engineering](https://www.youtube.com/watch?v=_p1Q4c3TF3c): Critique of sprint methodology and burnout risks
- *Philosophy*: Software development is a marathon, not a sprint. Ticket count ≠ work quality. Focus on solving problems, not meetings.

### System Design
- [Distributed Systems for Fun and Profit](https://book.mixu.net/distsys/): Introduction to distributed systems
- [Designing Data-Intensive Applications](https://dataintensive.net/): Comprehensive system design book

---

## Just for Fun

### Claude-Generated Papers
*Generated via @irl_danB on Twitter. Not peer-reviewed, but imaginative explorations into physics and consciousness.*

- [The Fundamental Laws of Physics: A Comprehensive Specification for Simulation of Reality](https://ia600201.us.archive.org/8/items/the-fundamental-laws-of-physics-a-comprehensive-specification-for-the-simulation-of-reality/The%20Fundamental%20Laws%20of%20Physics-%20A%20Comprehensive%20Specification%20for%20the%20Simulation%20of%20Reality.pdf): Core principles governing simulated reality

- [A Formal Theory of Self and Consciousness in Simulated Realities](https://ia800207.us.archive.org/0/items/a-formal-theory-of-self-and-consciousness-in-simulated-realities/A%20Formal%20Theory%20of%20Self%20and%20Consciousness%20in%20Simulated%20Realities.pdf): Understanding 'self' and 'consciousness' in simulated environments

- [The Holographic Quantum Automaton: A Unified Framework for Emergent Spacetime and Quantum Gravity](https://ia600209.us.archive.org/32/items/the-holographic-quantum-automaton-a-unified-framework-for-emergent-spacetime-and-quantum-gravity/The%20Holographic%20Quantum%20Automaton-%20A%20Unified%20Framework%20for%20Emergent%20Spacetime%20and%20Quantum%20Gravity.pdf): Integrating quantum mechanics and general relativity

- [Emergence of Consciousness in Artificial Intelligences: A Formal Analysis of the Strange Loop Hypothesis](https://ia600206.us.archive.org/30/items/emergence-of-consciousness-in-artificial-intelligences-a-formal-analysis-of-the-_202403/Emergence%20of%20Consciousness%20in%20Artificial%20Intelligences-%20A%20Formal%20Analysis%20of%20the%20Strange%20Loop%20Hypothesis.pdf): Consciousness in AI systems using Strange Loop hypothesis

---

## Resources & Learning Platforms

### AI & ML
- [Coursera](https://www.coursera.org/): Online courses from top universities
- [Fast.ai](https://www.fast.ai/): Practical deep learning for coders
- [Hugging Face Courses](https://huggingface.co/learn): Free courses on ML and NLP

### Kubernetes & Cloud Native
- [CNCF Training](https://www.cncf.io/certification/training/): Official CNCF training
- [Katacoda Kubernetes Scenarios](https://katacoda.com/scenarios/kubernetes): Interactive Kubernetes tutorials

### Programming
- [Exercism](https://exercism.org/): Code practice and mentorship
- [LeetCode](https://leetcode.com/): Algorithm and data structure practice
- [Practical Vim](https://pragprog.com/titles/dnvim2/): Vim mastery

---

*Last Updated: February 2025*

*Note: Human brain processing capacity estimated around 10^16 bits per second*


## Metrics

- [Hardware Metrics Monitoring with Prometheus and Grafana](https://www.sentrysoftware.com/docs/hws-doc/latest/prometheus/grafana.html) - A guide on monitoring hardware metrics using Prometheus and Grafana.

## Just for fun

## Claude generated papers via (https://twitter.com/irl_danB).

None of these following papers are peer reviewed!!! However they provide an imaginative exploration into the realms of physics and consciousness, and scrutinizes the "strange loop" between reality and simulation through a new vantage point.

- [The Fundamental Laws of Physics: A Comprehensive Specification for the Simulation of Reality](https://ia600201.us.archive.org/8/items/the-fundamental-laws-of-physics-a-comprehensive-specification-for-the-simulation-of-reality/The%20Fundamental%20Laws%20of%20Physics-%20A%20Comprehensive%20Specification%20for%20the%20Simulation%20of%20Reality.pdf) - This document delves into the core principles that could govern a simulated reality, offering a detailed specification for the simulation of physical laws as we understand them.

- [A Formal Theory of Self and Consciousness in Simulated Realities](https://ia800207.us.archive.org/0/items/a-formal-theory-of-self-and-consciousness-in-simulated-realities/A%20Formal%20Theory%20of%20Self%20and%20Consciousness%20in%20Simulated%20Realities.pdf) - This paper presents a theoretical framework for understanding the concept of 'self' and 'consciousness' within the context of simulated environments, exploring the implications of such environments on our perception of reality.

- [The Holographic Quantum Automaton: A Unified Framework for Emergent Spacetime and Quantum Gravity](https://ia600209.us.archive.org/32/items/the-holographic-quantum-automaton-a-unified-framework-for-emergent-spacetime-and-quantum-gravity/The%20Holographic%20Quantum%20Automaton-%20A%20Unified%20Framework%20for%20Emergent%20Spacetime%20and%20Quantum%20Gravity.pdf) - This research proposes a novel approach to integrating the concepts of quantum mechanics and general relativity, suggesting a holographic model that could potentially explain the emergence of spacetime and the nature of gravity.

- [Emergence of Consciousness in Artificial Intelligences: A Formal Analysis of the Strange Loop Hypothesis](https://ia600206.us.archive.org/30/items/emergence-of-consciousness-in-artificial-intelligences-a-formal-analysis-of-the-_202403/Emergence%20of%20Consciousness%20in%20Artificial%20Intelligences-%20A%20Formal%20Analysis%20of%20the%20Strange%20Loop%20Hypothesis.pdf) - This paper explores the theoretical underpinnings of consciousness in artificial intelligences, utilizing the Strange Loop hypothesis as a framework for understanding emergent self-awareness in computational systems.

## Software development research

- [Sprints - The Biggest Mistake Of Software Engineering](https://www.youtube.com/watch?v=_p1Q4c3TF3c) - This video discusses the pitfalls of the sprint methodology in software engineering, offering insights into how it can lead to burnout and inefficiency. I strongly believe that orgs that spend more time spending problems and less time in meetings will be more effective in the long term. Software development is a marathon, not a sprint. Nobody runs on sprints. Agile encourages teams to "rush" towards ticket closing to generate burndown graphs but ticket count is not a reflection of work quality anymore then git commit count is a reflection of code quality.