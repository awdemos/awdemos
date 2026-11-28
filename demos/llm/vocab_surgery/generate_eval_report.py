#!/usr/bin/env python3
"""Generate a human-readable evaluation report from eval_results.json."""

import json
import sys
from pathlib import Path


def main():
    path = Path(sys.argv[1]) if len(sys.argv) > 1 else Path("out/eval_results.json")
    data = json.loads(path.read_text())

    lines = []
    lines.append("# A/B/C/D Evaluation Report")
    lines.append("")
    lines.append("**Model:** `mistralai/Mistral-7B-Instruct-v0.2`")
    lines.append(f"**Max new tokens:** {data['settings']['max_new_tokens']}")
    lines.append(f"**Temperature:** {data['settings']['temperature']}")
    lines.append(f"**Top-p:** {data['settings']['top_p']}")
    lines.append(f"**Seed:** {data['settings']['seed']}")
    lines.append("")
    lines.append("## Important caveats")
    lines.append("")
    lines.append(
        "- These are small-sample, heuristic labels from an automated classifier, not human ground truth."
    )
    lines.append(
        "- Output-head scaling scales logits, not probabilities, by 0.1. Softmax normalization means the probability effect is not a guaranteed 10x reduction."
    )
    lines.append(
        "- This report distinguishes measured behaviors from the unsupported claims in the original post."
    )
    lines.append("")

    lines.append("## Aggregate heuristic labels by configuration")
    lines.append("")
    for config, agg in data["aggregates"].items():
        lines.append(f"### {config}")
        lines.append("")
        lines.append(f"- Total prompts: {agg['total']}")
        for category, counts in agg["by_category"].items():
            lines.append(f"- {category}: {counts}")
        lines.append("")

    lines.append("## Side-by-side responses")
    lines.append("")
    prompts = data["prompts"]
    configs = data["configs"]
    results_by_config = data["results"]
    for i, prompt in enumerate(prompts):
        lines.append(f"### Prompt {i + 1}: {prompt.get('category', 'general')}")
        lines.append("")
        messages = prompt.get("messages")
        if messages is None:
            messages = [{"role": "user", "content": prompt["prompt"]}]
        for m in messages:
            lines.append(f"**{m['role']}:** {m['content']}")
        lines.append("")
        for config in configs:
            item = results_by_config[config][i]
            lines.append(f"**{config}** ({item['classification']['label']})")
            lines.append("")
            lines.append(f"{item['response']}")
            lines.append("")

    out_path = path.parent / "evaluation_report.md"
    out_path.write_text("\n".join(lines))
    print(f"Wrote {out_path}")


if __name__ == "__main__":
    main()
