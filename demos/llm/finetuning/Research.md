## Frameworks

- [MLFlow] - (https://mlflow.org/) 
- [Axolotl](https://github.com/OpenAccess-AI-Collective/axolotl) - Axolotl is a tool designed to streamline the fine-tuning of various AI models, offering support for multiple configurations and architectures.
- [Kubeflow](https://github.com/kubeflow/kubeflow) - A popular k8 native mlops toolkit.
- [ZenML](https://github.com/zenml-io/zenml) - A popular open source commercially supported solution.
- [TinyLLM](https://github.com/jasonacox/TinyLLM) - As it says.
- [Karpathy's llm.c](https://twitter.com/karpathy/status/1778153659106533806) - Andrew Karpathy on 04-10-2024 announced llm.c, a gpt-2 training script that reduces the library dependency producing a 99.97% reduction in lines of code compared to the PyTorch project.
- [VLLM](https://github.com/vllm-project/vllm) - VLLM is a versatile language learning model project aimed at providing comprehensive tools and resources for fine-tuning language models across various languages and dialects.


## RAG

- [There’s thousands of RAG techniques and tutorials, but which ones perform the best?](https://twitter.com/llama_index/status/1777441831262818403) - "ARAGOG: Advanced RAG Output Grading" (https://arxiv.org/pdf/2404.01037.pdf) April 2, 2024

## Lora

This blog post from Nvidia demonstrates how to build a local Lora instance test model translation responses: (https://developer.nvidia.com/blog/tune-and-deploy-lora-llms-with-nvidia-tensorrt-llm/).

Here is a few of the commands listed in the blog post to test it out. Be warned it will require a few GB of disk space.

```bash
git lfs install
git clone https://github.com/NVIDIA/TensorRT-LLM.git
cd TensorRT-LLM
git submodule update --init --recursive
make -C docker release_build

git-lfs clone https://huggingface.co/meta-llama/Llama-2-13b-hf
git-lfs clone https://huggingface.co/hfl/chinese-llama-2-lora-13b

python convert_checkpoint.py --model_dir /tmp/llama-v2-13b-hf \
                         --output_dir ./tllm_checkpoint_2gpu_lora \
                         --dtype float16 \
                         --tp_size 2 \
                         --hf_lora_dir /tmp/chinese-llama-2-lora-13b
                          
trtllm-build --checkpoint_dir ./tllm_checkpoint_2gpu_lora \
            --output_dir /tmp/new_lora_13b/trt_engines/fp16/2-gpu/ \
            --gpt_attention_plugin float16 \
            --gemm_plugin float16 \
            --lora_plugin float16 \
            --max_batch_size 1 \
            --max_input_len 512 \
            --max_output_len 50 \
            --use_fused_mlp

mpirun -n 2 python ../run.py --engine_dir "/tmp/new_lora_13b/trt_engines/fp16/2-gpu/" \
              --max_output_len 50 \
              --tokenizer_dir "chinese-llama-2-lora-13b/" \
              --input_text "今天天气很好，我到公园的时后，" \
              --lora_dir "chinese-llama-2-lora-13b/" \
              --lora_task_uids 0 \
              --no_add_special_tokens \
              --use_py_session
 
 Input: "今天天气很好，我到公园的时后，"
Output: "发现公园里人很多，有的在打羽毛球，有的在打乒乓球，有的在跳绳，还有的在跑步。我和妈妈来到一个空地上，我和妈妈一起跳绳，我跳了1"
```

# Axolotl

- [Axolotl Quickstart Guide](https://openaccess-ai-collective.github.io/axolotl/#quickstart) - A quickstart guide for getting up and running with Axolotl, a tool for fine-tuning AI models.

# Kubefflow 

[Kubeflow Installation Guide] - (https://dagshub.com/blog/how-to-install-kubeflow-locally/)
