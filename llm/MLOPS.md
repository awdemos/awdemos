## MLOPS

This is a large subject and I only have time to add a couple of entries to this for now.


- [MLOps Continuous Delivery and Automation Pipelines in Machine Learning](https://cloud.google.com/architecture/mlops-continuous-delivery-and-automation-pipelines-in-machine-learning) - GCP MLOPS resources. I believe GCP is a sound choice for hosting MLOps ffor some organizations.

## Demo

Run Llama locally, 3gb download warning:

```sh
brew install ggerganov/ggerganov/llama.cpp
llama-cli --hf-repo ggml-org/models --model mistral-7b-v0.2-iq3_s-imat.gguf -p "I like big" -r "."
```