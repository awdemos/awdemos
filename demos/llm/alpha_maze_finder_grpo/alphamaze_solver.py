# AlphaMaze Solver using GRPO and Unsloth

# Install UV for module management
#!pip install uv
#!uv pip install unsloth vllm pillow datasets torch pandas numpy

# Import necessary libraries
from unsloth import FastLanguageModel
from unsloth import PatchFastRL
PatchFastRL("GRPO", FastLanguageModel)
from unsloth import is_bfloat16_supported
from trl import GRPOTrainer, GRPOConfig
from peft import LoraConfig, get_peft_model
from datasets import Dataset
import torch
import pandas as pd
import numpy as np
import random

# Define the MazeGame class
class MazeGame:
    def __init__(self, size=5):
        self.size = size
        self.maze = self.generate_maze()
        self.current_position = (0, 0)
        self.target_position = (size-1, size-1)
        self.done = False

    def generate_maze(self):
        # Simple maze generation using random walls
        maze = np.zeros((self.size, self.size), dtype=int)
        for i in range(self.size):
            for j in range(self.size):
                if random.random() < 0.3 and (i, j) != (0, 0) and (i, j) != (self.size-1, self.size-1):
                    maze[i, j] = 1  # Wall
        return maze

    def move(self, direction):
        x, y = self.current_position
        if direction == 'up' and x > 0 and self.maze[x-1, y] == 0:
            self.current_position = (x-1, y)
        elif direction == 'down' and x < self.size-1 and self.maze[x+1, y] == 0:
            self.current_position = (x+1, y)
        elif direction == 'left' and y > 0 and self.maze[x, y-1] == 0:
            self.current_position = (x, y-1)
        elif direction == 'right' and y < self.size-1 and self.maze[x, y+1] == 0:
            self.current_position = (x, y+1)
        
        self.done = self.is_solved()
        return self.get_state(), self.done

    def get_state(self):
        state = self.maze.copy()
        state[self.current_position] = 2  # Mark current position
        state[self.target_position] = 3  # Mark target position
        return state.tolist()

    def is_solved(self):
        return self.current_position == self.target_position

# Generate maze dataset
def generate_maze_dataset(num_mazes=1000):
    dataset = []
    for _ in range(num_mazes):
        game = MazeGame()
        maze_state = game.get_state()
        solution = solve_maze(game)
        prompt = f"Solve the maze. Current state:\n{maze_state}\nProvide a sequence of moves (up, down, left, right) to reach the target."
        dataset.append({
            "maze": maze_state,
            "solution": solution,
            "prompt": prompt
        })
    return dataset

# Simple maze-solving algorithm (BFS)
def solve_maze(game):
    from collections import deque

    start = game.current_position
    target = game.target_position
    queue = deque([(start, [])])
    visited = set([start])

    while queue:
        (x, y), path = queue.popleft()
        if (x, y) == target:
            return path

        for dx, dy, move in [(0, -1, 'left'), (0, 1, 'right'), (-1, 0, 'up'), (1, 0, 'down')]:
            next_x, next_y = x + dy, y + dy
            if 0 <= next_x < game.size and 0 <= next_y < game.size and game.maze[next_x, next_y] == 0:
                if (next_x, next_y) not in visited:
                    visited.add((next_x, next_y))
                    queue.append(((next_x, next_y), path + [move]))

    return []  # No solution found

# Reward function
def maze_reward(completions, prompts, **kwargs):
    rewards = []
    for completion in completions:
        game = MazeGame()
        moves = completion.split()
        for move in moves:
            _, done = game.move(move)
            if done:
                rewards.append(1.0)
                break
        else:
            rewards.append(-1.0)
    rewards_tensor = torch.tensor(rewards, dtype=torch.float32, requires_grad=False)
    
    # Check if 'model' is in kwargs, otherwise use 'cpu'
    device = kwargs.get('model', torch.device('cpu')).device if isinstance(kwargs.get('model'), torch.nn.Module) else torch.device('cpu')
    return rewards_tensor.to(device)

# Custom GRPO Trainer
class CustomGRPOTrainer(GRPOTrainer):
    def __init__(self, *args, **kwargs):
        self.maze_object = kwargs.pop("maze_object", None)
        super().__init__(*args, **kwargs)

    def multi_turn_generation(self, prompt, model, tokenizer, generation_config, max_new_tokens=50, max_total_tokens=200, maze_object=None):
        game = self.maze_object()
        state = game.get_state()
        moves = []

        while not game.done and len(moves) < max_new_tokens:
            prompt += f"\nCurrent maze state:\n{state}\nNext move:"
            inputs = tokenizer(prompt, return_tensors="pt").to(model.device)
            outputs = model.generate(**inputs, max_new_tokens=1, **generation_config)
            move = tokenizer.decode(outputs[0][-1:], skip_special_tokens=True).strip().lower()

            if move in ['up', 'down', 'left', 'right']:
                state, _ = game.move(move)
                moves.append(move)
            else:
                break

        return " ".join(moves)

    def prepare_inputs(self, data):
        return data["prompt"] if isinstance(data, dict) else data

    def compute_loss(self, model, inputs, return_outputs=False, num_items_in_batch=None):
        prompts = inputs["prompt"]
        completions = inputs["solution"]
        rewards = self.reward_funcs[0](completions, prompts=prompts, model=model)

    # Use num_items_in_batch if needed in your loss calculation
        if num_items_in_batch is not None:
        # Add any necessary logic using num_items_in_batch
            pass

    # The rest of your GRPO loss calculation based on rewards
        return rewards

# Set up the model and tokenizer
model_name = "homebrewltd/AlphaMaze-v0.2-1.5B"
model, tokenizer = FastLanguageModel.from_pretrained(
    model_name=model_name,
    max_seq_length=2048,
    dtype=None,
    load_in_4bit=True,
    trust_remote_code=True
)

# Apply LoRA adapter
lora_config = LoraConfig(
    r=8,
    lora_alpha=32,
    target_modules=[
        "q_proj",
        "k_proj",
        "v_proj",
        "o_proj",
        "gate_proj",
        "up_proj",
        "down_proj",
        "lm_head",
    ],
    lora_dropout=0.05,
    bias="none",
    task_type="CAUSAL_LM"
)
model = get_peft_model(model, lora_config)

# Training configuration
training_args = GRPOConfig(
    output_dir="./maze_solver_model",
    num_train_epochs=3,
    per_device_train_batch_size=8,
    gradient_accumulation_steps=4,
    learning_rate=2e-5,
    logging_steps=10,
    save_steps=100,
    save_total_limit=2,
    fp16=False,  # Disable float16
    bf16=is_bfloat16_supported(), # Enable bfloat16 if supported
    max_grad_norm=0.3,
    warmup_ratio=0.03,
    group_by_length=True,
    lr_scheduler_type="cosine",
    eval_strategy="no"  # see lib docs for more options
)

# Prepare the dataset
maze_dataset = generate_maze_dataset(num_mazes=1000)
train_dataset = Dataset.from_pandas(pd.DataFrame(maze_dataset))

print("GRPOTrainer:", GRPOTrainer)
print("CustomGRPOTrainer:", CustomGRPOTrainer)

# Initialize and train the model
trainer = CustomGRPOTrainer(
    model=model,
    tokenizer=tokenizer,
    reward_funcs=[maze_reward],
    args=training_args,
    train_dataset=train_dataset,
    maze_object=MazeGame
)

trainer.train()

# Save the trained model
model.save_pretrained("./maze_solver_model")
tokenizer.save_pretrained("./maze_solver_model")

# Test the trained model
def test_model(model, tokenizer, num_tests=5):
    for _ in range(num_tests):
        game = MazeGame()
        state = game.get_state()
        print("Initial maze state:")
        print(np.array(state))
        
        prompt = f"Solve the maze. Current state:\n{state}\nProvide a sequence of moves (up, down, left, right) to reach the target (3)."
        inputs = tokenizer(prompt, return_tensors="pt").to(model.device)
        outputs = model.generate(**inputs, max_new_tokens=50)
        moves = tokenizer.decode(outputs[0], skip_special_tokens=True).split()
        
        print("Model's solution:", moves)
        
        for move in moves:
            state, done = game.move(move)
            if done:
                print("Maze solved!")
                break
        else:
            print("Maze not solved.")
        
        print("Final maze state:")
        print(np.array(state))
        print("\n")

test_model(model, tokenizer)


