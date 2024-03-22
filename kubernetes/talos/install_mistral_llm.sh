#!/bin/bash
helm repo add substratusai https://substratusai.github.io/helm
helm repo update
helm install lingo substratusai/lingo

helm upgrade --install stapi-minilm-l6-v2 substratusai/stapi -f - << EOF
model: all-MiniLM-L6-v2
replicaCount: 0
deploymentAnnotations:
  lingo.substratus.ai/models: text-embedding-ada-002
EOF

helm upgrade --install mistral-7b-instruct substratusai/vllm -f - << EOF
model: mistralai/Mistral-7B-Instruct-v0.1
replicaCount: 0
env:
- name: SERVED_MODEL_NAME
  value: mistral-7b-instruct-v0.1 # needs to be same as lingo model name
deploymentAnnotations:
  lingo.substratus.ai/models: mistral-7b-instruct-v0.1
  lingo.substratus.ai/min-replicas: "0" # needs to be string
  lingo.substratus.ai/max-replicas: "3" # needs to be string
EOF

echo "see more instructions on https://github.com/substratusai/lingo"