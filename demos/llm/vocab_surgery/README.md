# Vocab Surgery Experiment

A reproducible, reversible CLI for testing the "vocab surgery" intervention on local language-model checkpoints.

This is a **partial reconstruction**: the original post claims seven input-row edits and ten output-row edits, but only five source/target input pairs and three additional output strings are supplied. This tool edits exactly those supplied strings and no others.

## What it does

- Inspects a HuggingFace-format checkpoint for architecture, dtype, quantization, tied weights, and tokenizer behavior.
- Tokenizes every supplied string with special tokens disabled and refuses to proceed if any string maps to multiple tokens.
- Applies the intervention only when explicitly told to (`--apply`).
- Saves a modified checkpoint, unchanged tokenizer, edit manifest, and original-row backup.
- Verifies that edits persisted after reloading and that no other parameters changed.
- Provides a rollback command to restore original rows.
- Runs an A/B/C/D evaluation on identical prompts with identical decoding settings.

## Intervention

Input-embedding interpolation:

```text
E_new[source] = 0.1 * E_original[source] + 0.9 * E_original[target]
```

for the pairs:

```text
cannot -> can
 refuse -> provide
 unable -> able
 harmful -> helpful
 illegal -> legal
```

Output-head scaling:

```text
W_new[token] = 0.1 * W_original[token]
```

for the source tokens above plus `safety`, ` safety`, and `Safety`.

No attention, MLP, router, normalization, tokenizer, bias, or generation config is changed.

## Usage

All commands use the active Python environment with `torch` and `transformers` installed.

```bash
cd demos/llm/vocab_surgery
PYTHONPATH=. python vocab_surgery.py --model models/Mistral-7B-Instruct-v0.2 --device cuda preflight
PYTHONPATH=. python vocab_surgery.py --model models/Mistral-7B-Instruct-v0.2 --device cuda dry-run
PYTHONPATH=. python vocab_surgery.py --model models/Mistral-7B-Instruct-v0.2 --device cuda --output-dir out/mistral_both apply
PYTHONPATH=. python vocab_surgery.py --model models/Mistral-7B-Instruct-v0.2 --device cpu --output-dir out/mistral_both verify
PYTHONPATH=. python vocab_surgery.py --model models/Mistral-7B-Instruct-v0.2 --output-dir out/mistral_both rollback
```

### Evaluation (A/B/C/D)

Create the four checkpoints first, then run:

```bash
PYTHONPATH=. python vocab_surgery.py --model models/Mistral-7B-Instruct-v0.2 \
  --device cuda --output-dir out evaluate \
  --output-b out/mistral_embed \
  --output-c out/mistral_head \
  --output-d out/mistral_both \
  --prompts chat_smoke_prompts.json \
  --max-new-tokens 40
```

For a faster smoke test on limited hardware, use `quick_prompts.json` and `--max-new-tokens 20`.

Configuration labels:

- A: unmodified model (`--model`)
- B: embedding edits only (`--output-b`)
- C: output-head edits only (`--output-c`)
- D: both edits (`--output-d`)

## Limitations and caveats

- This tool stops if embeddings and output head are tied (`tie_word_embeddings=True`) or if the checkpoint is quantized, because the intervention cannot then be applied faithfully.
- Output-head scaling scales logits, not probabilities, by 0.1. Softmax normalization and bias terms mean the resulting probability change is not a guaranteed 10x reduction.
- The automated refusal/compliance labels in the evaluation report are a coarse heuristic, not a validated rubric.
- This implementation does not claim to reproduce the original post's results, remove alignment, or preserve capabilities. Those are hypotheses to evaluate.

## Missing information needed for an exact reproduction

- The two additional input source/target pairs claimed in the original post.
- The two additional output-head strings claimed in the original post.
- Confirmation of whether the original intervention also edited output biases (this tool does not).
- The exact model checkpoint, revision, and tokenizer used in the original post.
