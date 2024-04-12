# Nvidia

Nvidia has released some important software projects to go along with their hardware including production ready inference engines and container orchestrations toolkits. I believe it will be a good choice for many companies to evulate if if one of these tools can be used in their projects.

- [Nvidia Launchpad AI](https://www.nvidia.com/en-us/launchpad/ai/) - An excellent labs resource.

- [Nvidia GPU Operator](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/latest/index.html) - Automation for all the management of all NVIDIA software components needed to provision GPU in Kubernetes.

- [System Management Interface SMI](https://developer.nvidia.com/nvidia-system-management-interface) - The NVIDIA System Management Interface (nvidia-smi) is a command line utility, based on top of the NVIDIA Management Library (NVML), intended to aid in the management and monitoring of NVIDIA GPU devices.

- [Triton Inference Server](https://github.com/triton-inference-server/server) - An optimized cloud and edge inferencing solution that supports multiple deep learning and machine learning frameworks.

Quickstart: (https://github.com/triton-inference-server/server/blob/main/docs/getting_started/quickstart.md)

- [NVIDIA Container Toolkit](https://github.com/NVIDIA/nvidia-container-toolkit) - Allows users to build and run GPU accelerated containers, including a container runtime library and utilities to automatically configure containers to leverage NVIDIA GPUs.

Quickstart: (https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)

- [Deploying a 1.3B GPT-3 Model with NVIDIA NeMo Megatron](https://developer.nvidia.com/blog/deploying-a-1-3b-gpt-3-model-with-nvidia-nemo-megatron/) - A comprehensive guide on deploying large-scale GPT-3 models using NVIDIA's NeMo Megatron framework.

- [NIM](https://www.youtube.com/watch?v=Od-AdE4If8o) - an inference microservice with RAG capabilities.

- [Enabling Peer-to-Peer P2P Connections in NVIDIA GPUs with Linux Open GPU Kernel Module] - (https://github.com/tinygrad/open-gpu-kernel-modules)
Released 04-12-2024 (https://twitter.com/__tinygrad__/status/1778677126092509611)

### Prerequisites:
- NVIDIA GPUs with support for P2P.
- A Linux system with the latest NVIDIA drivers installed.
- The Open GPU Kernel Modules from the [tinygrad/open-gpu-kernel-modules](https://github.com/tinygrad/open-gpu-kernel-modules) GitHub repository.

### Steps to Enable P2P Support:

1. **Install NVIDIA Drivers**: Ensure that the latest NVIDIA drivers are installed on your system. These drivers are necessary for the GPUs to function correctly and for the P2P feature to be available.

2. **Clone the Open GPU Kernel Modules Repository**:



## Examples

```sh
nvidia-smi
docker run --gpus all --rm -ti nvcr.io/nvidia/pytorch:24.01-py3

docker run --gpus=1 --rm -p8000:8000 -p8001:8001 -p8002:8002 -v/full/path/to/docs/examples/model_repository:/models nvcr.io/nvidia/tritonserver:24.01-py3 tritonserver --model-repository=/models
```

## Talos

Talos Linux is a distribution of Kubernetes that installs a bare metal minimal operating on a host. Features include an immutable operating system, a total of 12 installed binaries, no shell, no package manager, a single PID that is only allowed to run the Kubernetes API server. Talos can be setup to run air-gapped, encrypted disks, and OIDC authentication, web managed, and other features. For Nvidia supported features see:

(https://www.talos.dev/v1.6/talos-guides/configuration/nvidia-fabricmanager/)

(https://www.talos.dev/v1.6/talos-guides/configuration/nvidia-gpu-proprietary/)

(https://www.talos.dev/v1.6/talos-guides/configuration/nvidia-gpu/)

(https://www.talos.dev/v1.4/talos-guides/configuration/nvidia-gpu-proprietary/) (legacy reference example)


## Ubuntu

Ubuntu offers robust support for Nvidia hardware and a range of professional services to make integration easier (https://ubuntu.com/nvidia)

An excellent driver installer script is avai;able from Lambda Labs here: 

```sh
wget -nv -O- https://lambdalabs.com/install-lambda-stack.sh | sh -
sudo reboot
```

## Other

"The DGX-1, is a 3-foot-long, 5-inch-thin rectangular container that Nvidia calls "the world's first AI supercomputer in a box." The $130,000 machine delivers 170 teraflops of performance--on par with 250 conventional servers. In August Huang personally delivered the first unit to Elon Musk and his San Francisco AI nonprofit, OpenAI."

(https://www.forbes.com/sites/aarontilley/2016/11/30/nvidia-deep-learning-ai-intel/)

(https://www.nextplatform.com/2024/03/19/how-nvidia-blackwell-systems-attack-1-trillion-parameter-ai-models/)

(https://twitter.com/__tinygrad__/status/1770311229879230628)