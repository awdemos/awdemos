# Quick verification script
import dspy
import torch
from datasets import load_dataset
from transformers import AutoTokenizer

print("dspy version:", dspy.__version__)
print("torch version:", torch.__version__)
print("CUDA available:", torch.cuda.is_available())

# Test dataset loading
dataset = load_dataset("TuringsSolutions/PFAF750") 
print("Dataset sample:", dataset['train'][0])

