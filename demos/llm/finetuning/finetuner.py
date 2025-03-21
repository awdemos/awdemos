import dspy
import torch
from datasets import load_dataset, Dataset
from transformers import AutoTokenizer, AutoModelForCausalLM, AdamW, get_linear_schedule_with_warmup
import re
from difflib import SequenceMatcher
from sklearn.model_selection import train_test_split
import logging
from torch.utils.data import DataLoader
import numpy as np
from rouge_score import rouge_scorer
import argparse
import yaml
import os
from pydantic import BaseModel, Field, ValidationError
from typing import Annotated, Dict, Any

# --- Pydantic Models for Config Validation ---
class DatasetConfig(BaseModel):
    name: str
    test_size: Annotated[float, Field(ge=0.1, le=0.3)]
    random_seed: int
    input_column: str = "input"  # Default based on dataset
    output_column: str = "output"

class ModelConfig(BaseModel):
    checkpoint: str
    learning_rate: Annotated[float, Field(ge=1e-6, le=1e-3)]
    max_length: int
    similarity_threshold: Annotated[float, Field(ge=0.5, le=1.0)]

class TrainingConfig(BaseModel):
    epochs: int
    batch_size: int
    save_dir: str
    save_every: int

class FullConfig(BaseModel):
    dataset: DatasetConfig
    model: ModelConfig
    training: TrainingConfig
    hardware: Dict[str, Any]
    validation: Dict[str, Any]

# --- Initialization ---
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def load_config(config_path: str) -> FullConfig:
    with open(config_path) as f:
        raw_config = yaml.safe_load(f)
    return FullConfig(**raw_config)

# --- Dataset Handling ---
def prepare_dataset(config: FullConfig):
    try:
        dataset = load_dataset(
            config.dataset.name,
            token=True,
            split='train',
            verification_mode="no_checks"
        )
        
        formatted_data = []
        for item in dataset:
            formatted_data.append({
                "Prompt": item[config.dataset.input_column],
                "Response": item[config.dataset.output_column]
            })

        # Debug prints (properly indented)
        logging.info(f"Sample dataset item: {dataset[0]}")
        logging.info(f"Available keys: {dataset[0].keys()}")

        # Split dataset properly
        train_data, test_data = train_test_split(
            formatted_data,
            test_size=config.dataset.test_size,
            random_state=config.dataset.random_seed
        )

        return (
            Dataset.from_dict({
                "Prompt": [d["Prompt"] for d in train_data], 
                "Response": [d["Response"] for d in train_data]
            }),
            Dataset.from_dict({
                "Prompt": [d["Prompt"] for d in test_data],
                "Response": [d["Response"] for d in test_data]
            })
        )
        
    except Exception as e:
        logging.error(f"Dataset preparation failed: {str(e)}")
        raise


# --- Model Setup ---
def setup_model_and_tokenizer(config: FullConfig):
    try:
        tokenizer = AutoTokenizer.from_pretrained(config.model.checkpoint)
        if tokenizer.pad_token is None:
            tokenizer.pad_token = tokenizer.eos_token or "[PAD]"
            
        hf_model = AutoModelForCausalLM.from_pretrained(
            config.model.checkpoint,
            torch_dtype=torch.float16 if config.hardware.get('fp16', False) else torch.float32
        )
        hf_model.resize_token_embeddings(len(tokenizer))
        hf_model.to(torch.device(config.hardware.get('device', 'cuda' if torch.cuda.is_available() else 'cpu')))
        
        lm = dspy.HFModel(model=config.model.checkpoint)
        dspy.settings.configure(lm=lm, tokenizer=tokenizer)
        
        return hf_model, tokenizer, lm
    except Exception as e:
        logging.error(f"Model setup failed: {str(e)}")
        raise

# --- Training Utilities ---
def normalize_text(text: str) -> str:
    return re.sub(r"\s+", " ", re.sub(r"[^\w\s]", "", text)).strip().lower()

def is_similar(response: str, correct_response: str, threshold: float) -> bool:
    return SequenceMatcher(
        None, 
        normalize_text(response), 
        normalize_text(correct_response)
    ).ratio() >= threshold

def check_format(response: str, config: FullConfig) -> bool:
    prefix = config.reasoning.get('forward_prefix', '<think>')
    suffix = config.reasoning.get('answer_suffix', '</answer>')
    return response.startswith(prefix) and response.endswith(suffix)

# --- Main Execution ---
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Train and evaluate the model')
    parser.add_argument('--config', type=str, default='config.yaml')
    args = parser.parse_args()

    try:
        config = load_config(args.config)
        train_dataset, test_dataset = prepare_dataset(config)
        hf_model, tokenizer, lm = setup_model_and_tokenizer(config)
        
        # Initialize DataLoaders
        train_loader = DataLoader(
            train_dataset,
            batch_size=config.training.batch_size,
            shuffle=True,
            pin_memory=config.hardware.get('pin_memory', True)
        )
        
        # Optimizer and Scheduler
        optimizer = AdamW(hf_model.parameters(), lr=config.model.learning_rate)
        scheduler = get_linear_schedule_with_warmup(
            optimizer,
            num_warmup_steps=100,
            num_training_steps=config.training.epochs * len(train_loader)
        )
        
        # Training loop
        for epoch in range(config.training.epochs):
            hf_model.train()
            for batch_idx, batch in enumerate(train_loader):
                # Add your training logic here
                pass
                
    except ValidationError as ve:
        logging.error(f"Configuration error: {str(ve)}")
        exit(1)
    except Exception as e:
        logging.error(f"Fatal error: {str(e)}")
        exit(1)

