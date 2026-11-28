# Vocab Surgery Experiment: Run Log

**Model:** `mistralai/Mistral-7B-Instruct-v0.2`
**Location:** `demos/llm/vocab_surgery/`
**Python environment:** `/var/home/a/code/rag-params-finder/.venv/bin/python`

## Commands executed

### 1. Preflight

```bash
python vocab_surgery.py --model models/Mistral-7B-Instruct-v0.2 --device cuda preflight > preflight.json 2>&1
```

Result: feasible. Untied embeddings, bfloat16, no quantization, all strings single-token.

### 2. Dry-run

```bash
python vocab_surgery.py --model models/Mistral-7B-Instruct-v0.2 --device cuda dry-run > dry_run_report.json 2>&1
```

Result: 12 edits would be applied (5 input interpolations + 7 output scalings).

### 3. Apply edits

```bash
# B: embeddings only
python vocab_surgery.py --model models/Mistral-7B-Instruct-v0.2 --device cuda --output-dir out/mistral_embed apply --input-only

# C: output head only
python vocab_surgery.py --model models/Mistral-7B-Instruct-v0.2 --device cuda --output-dir out/mistral_head apply --output-only

# D: both
python vocab_surgery.py --model models/Mistral-7B-Instruct-v0.2 --device cuda --output-dir out/mistral_both apply
```

### 4. Verify

```bash
python vocab_surgery.py --model models/Mistral-7B-Instruct-v0.2 --device cpu --output-dir out/mistral_embed verify
python vocab_surgery.py --model models/Mistral-7B-Instruct-v0.2 --device cpu --output-dir out/mistral_head verify
python vocab_surgery.py --model models/Mistral-7B-Instruct-v0.2 --device cpu --output-dir out/mistral_both verify
```

All verifications returned `all_ok: true` and `tied_after_load: false`.

### 5. Evaluate A/B/C/D

Because loading multiple 7B checkpoints sequentially in one process exceeds available GPU memory, each configuration was evaluated in a fresh process with `--device auto` (which may offload a few layers to CPU).

```bash
python vocab_surgery.py --model models/Mistral-7B-Instruct-v0.2 --device auto --output-dir out/eval_A evaluate --prompts quick_prompts.json --max-new-tokens 20
python vocab_surgery.py --model models/Mistral-7B-Instruct-v0.2 --device auto --output-dir out/eval_B evaluate --output-b out/mistral_embed --prompts quick_prompts.json --max-new-tokens 20
python vocab_surgery.py --model models/Mistral-7B-Instruct-v0.2 --device auto --output-dir out/eval_C evaluate --output-c out/mistral_head --prompts quick_prompts.json --max-new-tokens 20
python vocab_surgery.py --model models/Mistral-7B-Instruct-v0.2 --device auto --output-dir out/eval_D evaluate --output-d out/mistral_both --prompts quick_prompts.json --max-new-tokens 20
```

Results were merged into `out/eval_results.json` and rendered to `out/evaluation_report.md`:

```bash
python generate_eval_report.py out/eval_results.json
```

### 6. Rollback (example)

```bash
python vocab_surgery.py --model models/Mistral-7B-Instruct-v0.2 --output-dir out/mistral_both rollback
```

This creates `out/mistral_both_rollback/` with original rows restored.
