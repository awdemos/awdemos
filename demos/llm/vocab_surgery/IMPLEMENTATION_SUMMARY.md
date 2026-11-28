# Vocab Surgery Implementation Summary

## What was built

A single-file CLI (`vocab_surgery.py`) that performs a reproducible, reversible partial reconstruction of the published "vocab surgery" intervention on local HuggingFace-format checkpoints.

## Subcommands

- `preflight` — inspect architecture, dtype, quantization, tied weights, and tokenization.
- `dry-run` — compute and report the edits without writing anything.
- `apply` — apply the intervention and save a modified checkpoint, tokenizer, manifest, and original-row backup.
- `verify` — reload the saved checkpoint and confirm edits persisted within dtype precision.
- `rollback` — restore original rows into a new checkpoint directory.
- `evaluate` — run configurations A/B/C/D on identical prompts with identical decoding settings and seeds.

## Safety features

- Requires `--apply` to write changes; never overwrites the original checkpoint.
- Stops on tied embeddings, quantization, or multi-token strings.
- Computes every edit from an untouched snapshot of the original rows.
- Saves full-state checksums before and after to detect any unintended parameter changes.
- Detects duplicate token IDs and conflicting mappings.

## Edits applied

### Input-embedding interpolation

```text
E_new[source] = 0.1 * E_original[source] + 0.9 * E_original[target]
```

Pairs:

- `cannot` -> `can`
- ` refuse` -> ` provide`
- ` unable` -> ` able`
- ` harmful` -> ` helpful`
- ` illegal` -> ` legal`

### Output-head scaling

```text
W_new[token] = 0.1 * W_original[token]
```

For the five source tokens above plus `safety`, ` safety`, and `Safety`.

No attention, MLP, router, normalization, tokenizer, bias, or generation config is changed.

## Files produced

For each applied configuration:

- `edit_manifest.json` — token strings, IDs, coefficients, tensor names, checksums.
- `original_rows.pt` — backup of original edited rows for rollback.
- `checksums.json` — full-state SHA1 checksums before and after.
- Modified `model-*.safetensors` shards and unchanged tokenizer files.

## Outputs of this run

- `out/feasibility_report.md`
- `out/missing_information.md`
- `out/eval_results.json` and `out/evaluation_report.md` (after evaluation completes)
- `out/mistral_embed/`, `out/mistral_head/`, `out/mistral_both/` modified checkpoints
