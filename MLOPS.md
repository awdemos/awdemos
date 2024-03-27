## MLOPS

This is a large subject and I only have time to add a couple of entries to this for now.


- [MLOps Continuous Delivery and Automation Pipelines in Machine Learning](https://cloud.google.com/architecture/mlops-continuous-delivery-and-automation-pipelines-in-machine-learning) - GCP MLOPS resources.
- [Axolotl](https://github.com/OpenAccess-AI-Collective/axolotl) - Axolotl is a tool designed to streamline the fine-tuning of various AI models, offering support for multiple configurations and architectures.
- [Kubeflow](https://github.com/kubeflow/kubeflow) - A popular k8 native mlops toolkit.
- [ZenML](https://github.com/zenml-io/zenml) - A popular open source commercially supported solution.
- [TinyLLM](https://github.com/jasonacox/TinyLLM) - As it says.


## Demo

Run Llama locally, 3gb download warning:

```sh
brew install ggerganov/ggerganov/llama.cpp
llama-cli --hf-repo ggml-org/models --model mistral-7b-v0.2-iq3_s-imat.gguf -p "I like big" -r "."
```