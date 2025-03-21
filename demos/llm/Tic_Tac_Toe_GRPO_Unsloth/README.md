# Tic-Tac-Toe GRPO Fine-Tuning with Unsloth

This project demonstrates how to fine-tune a language model to play Tic-Tac-Toe using Gradient Ratio Policy Optimization (GRPO) with the Unsloth library for faster training.  It leverages a custom GRPO trainer to interact with a Tic-Tac-Toe game environment, rewarding the model for making valid moves and winning the game.

## Key Components

*   **`TicTacToeGame`:** This class implements the core game logic for Tic-Tac-Toe, including board representation, move validation, win/draw condition checking, and a minimax AI opponent.
*   **`SYSTEM_PROMPT`:** This prompt instructs the language model on how to play the game, including the expected format for its responses (reasoning and action).
*   **`CustomGRPOTrainer`:** This custom trainer extends the standard GRPO trainer to handle the interactive Tic-Tac-Toe game. It generates model responses, extracts actions, executes those actions in the game environment, and provides feedback to the model in the form of rewards.
*   **Training Loop:** The training loop initializes the game, creates a dataset with a single initial game state, and then trains the model using the `CustomGRPOTrainer`.

## Dependencies

*   `unsloth`: For fast and memory-efficient fine-tuning.
*   `vllm`: For fast inference.
*   `datasets`: For creating the training dataset.
*   `torch`: For tensor operations and GPU acceleration.
*   `pandas`: For data manipulation.
*   `transformers`: For loading and using the language model.
*   `trl`: For GRPO training.
*   `accelerate`: For distributed training.

## Setup and Usage

1.  **Install Dependencies:**

    ```
    pip install unsloth vllm
    pip install --upgrade pillow
    ```

2.  **Configure Google Drive (Optional):**

    The code includes commented-out lines for mounting Google Drive. If you want to save the fine-tuned model to your Google Drive, uncomment these lines and authorize the Colab notebook to access your drive.

    ```
    #from google.colab import drive
    #drive.mount('/content/drive')
    save_path = "/content/drive/MyDrive/UnslothGRPO/tictactoeExample" #Make sure this directory exists in your Google Drive
    ```

3.  **Run the Notebook:**

    Open the provided Colab notebook and run the cells in order.

## GRPO Details

The `CustomGRPOTrainer` is the heart of this project. It overrides the standard GRPO training loop to implement the following:

1.  **Multi-turn Generation:** The `multi_turn_generation` function generates model responses, extracts the predicted action (a number from 0-8), and then executes that action within the `TicTacToeGame` environment.
2.  **Reward Shaping:** The trainer assigns rewards based on the outcome of the game: winning, drawing, or making an invalid move. A small reward is given for following the correct output format.
3.  **Feedback Loop:** After each move, the trainer provides the model with the new game state as feedback, allowing the model to learn from its actions and improve its strategy.

## Model Details

*   **Model Name:** `Qwen/Qwen2.5-3B-Instruct` (configurable in the notebook).  Other options include `Qwen/Qwen2.5-1.5B-Instruct` and `Qwen/Qwen2.5-7B-Instruct`.  Larger models will likely require more GPU memory.
*   **LoRA Rank:** 16 (can be adjusted; higher values may improve performance but increase memory usage).
*   **Max Sequence Length:** 1563 (can be adjusted for longer reasoning traces).
*   **Quantization:** The model is loaded in 4-bit mode (`load_in_4bit = True`) for reduced memory footprint.

## Important Considerations and Known Issues

*   **Output Format:** The language model must adhere to the specified output format (`<reasoning>`, `<action>`). The code includes a regular expression to extract the action. If the model fails to produce the correct format, the action will not be extracted, which inhibits learning.
*   **"No <action> digit </action> found" Error:** This error indicates that the model is not generating the `<action>` tag with a valid digit inside. This is a common problem with language models and requires careful prompt engineering and hyperparameter tuning.
*   **Hyperparameter Tuning:** The learning rate, batch size, number of training steps, and other hyperparameters may need to be adjusted to achieve optimal performance.
*   **GRPO reward:** This implementation provides the game reward as another reward function, alongside any specified reward functions.
