# GitHub Profile Consulting Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Rewrite the public GitHub profile as a warm, buyer-focused introduction to Andrew White's AI platform consulting services, supported by recent deep technical work.

**Architecture:** Modify only `README.md`, which is the live profile source. Lead with consulting outcomes and contact actions, use selected products as evidence, then present experience, working values, open-source context, and a final invitation to talk.

**Tech Stack:** GitHub-flavored Markdown, Python 3 standard library for content checks, Git and GitHub CLI for verification.

**Execution note:** Independent link review replaced the broken scheduler with the working strategy-call page, removed an unavailable social link and an unpublished C-port claim, and canonicalized the repository link. A later profile revision added a recruiter/hiring-manager path, a Compactation link, and reworded two project descriptions; the Task 3 verification below is updated for that current state.

---

### Task 1: Establish the content checks

**Files:**
- Modify: `README.md`
- Reference: `docs/superpowers/specs/2026-11-22-github-profile-consulting-design.md`

- [x] **Step 1: Run the pre-change content check**

Run from the repository root:

```bash
python3 - <<'PY'
from pathlib import Path
text = Path('README.md').read_text()
required = [
    "# Hi, I'm Andrew White",
    '## How I can help',
    '## Selected products and engineering work',
    '## Experience you can draw on',
    '## How I work',
]
missing = [item for item in required if item not in text]
assert not missing, f'Missing approved sections: {missing}'
assert '\u2014' not in text, 'README.md still contains an em dash'
PY
```

Expected: FAIL with missing approved sections. The current profile also contains em dash characters.

- [x] **Step 2: Confirm repository visibility before writing links**

Run:

```bash
for repo in merlin RegicideOS gpt2.s needle-rs mas-steer tiny-lm-rs score-centering oxidatedBSD; do
  printf '%s: ' "$repo"
  gh repo view "awdemos/$repo" --json visibility --jq .visibility 2>/dev/null || printf 'not publicly listed\n'
done
```

Expected: the first six repositories are `PUBLIC`; `score-centering` is `PRIVATE`; `oxidatedBSD` is not publicly listed. Do not create repository links for the last two projects.

### Task 2: Rewrite the live profile

**Files:**
- Modify: `README.md`

- [x] **Step 1: Replace the complete profile with the approved structure and copy**

Set `README.md` to exactly this content (the original approved draft). The profile was extended after execution: a "For recruiters and hiring managers" section and a Compactation link were added, and the score-centering and oxidatedBSD descriptions were reworded. Task 3 verifies the current file, not this historical draft:

````markdown
<div align="center">

# Hi, I'm Andrew White

### I'm a professional AI consulting engineer for startups and big companies

</div>

Thanks for stopping by. I help AI platform teams turn complex ideas into reliable, auditable systems.

Through [Vibe Coding Agency](https://vibecodingagency.com/), I partner with technical leaders on architecture, hands-on implementation, and careful debugging across model routing, private inference, GPU computing, Linux, and production operations.

I work with some of the largest namebrand companies you have heard of and stealth mode startups nobody has heard of.

If you're building something ambitious and would value another experienced engineer, I'd be glad to hear about it.

**[Discuss a project](https://vibecodingagency.com/strategy-call/)** · **[Explore consulting services](https://vibecodingagency.com/)** · **[Email me](mailto:contact@vibecodingagency.com)**

## How I can help

- **AI platform architecture:** Design practical, observable platforms for deploying and operating AI systems, from early technical decisions through production.
- **Inference and model routing:** Build private inference stacks, model gateways, routing policies, and evaluation loops that balance quality, latency, cost, and control.
- **GPU and Linux systems:** Work through the full stack, including GPU configuration, CUDA environments, Linux performance, storage, networking, and difficult system behavior.
- **Production reliability:** Improve observability, reproducibility, security boundaries, and operational readiness so your team can run the system with confidence.

## Products, standards, and research

- [**Vibe Coding Agency**](https://vibecodingagency.com/): AI infrastructure consulting and hands-on product engineering.
- [**score-centering**](https://scorecentering.com/): Managed training observability for GRPO, PPO, and REINFORCE.
- [**Adversarial Review**](https://adversarial-review.com/): An open standard for evidence-backed, severity-rated code review.
- [**Loops and Graphs**](https://loopsandgraphs.dev/): A control framework for AI coding agents built around deterministic checks and planned graphs.
- [**Neuron Engineering**](https://neuronengineering.dev/): Research and engineering for inference-time model steering and neuron interventions.

## Selected products and engineering work

These projects show the kind of problems I enjoy: AI infrastructure, systems software, model internals, and tools that make complex behavior easier to understand.

| Project | What it demonstrates |
|---|---|
| [**Merlin**](https://github.com/awdemos/merlin) | Multi-provider LLM routing in Rust with semantic routing, policy controls, cost and latency awareness, and observability. |
| [**score-centering**](https://scorecentering.com/) | A commercial Rust library for differentiable per-token score centering in GRPO, PPO, and REINFORCE trainers, with a managed observability service. |
| [**RegicideOS**](https://github.com/awdemos/RegicideOS) | An AI-native Linux distribution built on Gentoo, Btrfs, and COSMIC, with GPU and ML tooling integrated into the system. |
| [**gpt2.s**](https://github.com/awdemos/gpt2.s) | GPT-2 small in handwritten AArch64 assembly with raw syscalls and output verified against PyTorch. |
| [**needle-rs**](https://github.com/awdemos/needle-rs) | A pure Rust runtime for on-device tool calling, including quantized model loading, incremental inference, and grammar-constrained decoding. |
| [**MAS-Steer**](https://github.com/awdemos/mas-steer) | A Rust multi-agent search system for discovering activation-steering interventions while measuring damage to model behavior. |
| [**tiny-lm-rs**](https://github.com/awdemos/tiny-lm-rs) | A Rust and WebAssembly GPT that trains live in the browser using handwritten, finite-difference-checked backpropagation. |
| [**oxidatedBSD**](docs/projects/oxidatedbsd.md) | An unpublished `no_std` amd64 OS with an interactive shell, disk-loaded programs, per-process address spaces, and preemptible syscalls. |

You can find more open-source experiments and reference architectures in my [project index](PROJECTS.md) and [awdemos repository](https://github.com/awdemos/awdemos).

## Experience you can draw on

By day, I'm an AI Factory Lead at a Fortune 500 company, collaborating with NVIDIA on infrastructure designed to ship reliably and quickly. Previously, I was lead AI infrastructure engineer at the Helix Center for Applied AI, worked on symbolic AI at Cycorp under Dr. Doug Lenat, built Top 500 HPC systems, and spent time at OpenDNS and the Wikimedia Foundation.

That background helps me move comfortably between business constraints, platform architecture, and low-level technical details. I care about finding the useful path forward and leaving your team with a system it can understand and own.

## How I work

I care about systems you can inspect, reproduce, and maintain. I prefer small, composable tools, clear interfaces, useful tests, and documentation that explains important decisions. For AI systems, that means models you can evaluate, data you can control, and infrastructure your team can understand.

I aim to make collaboration straightforward: listen carefully, share context, be candid about tradeoffs, and focus on work that creates lasting value for your team.

## Open source

Many of my experiments are public, including rough drafts, research implementations, and production-oriented tools. You're welcome to explore them, open an issue, or share an idea. If you'd like to contribute, please start with [CONTRIBUTING.md](CONTRIBUTING.md).

## Get in touch

If you're responsible for an AI platform, planning a private inference deployment, or untangling a difficult systems problem, I'd be happy to discuss it.

- **Discuss a project:** [Strategy call](https://vibecodingagency.com/strategy-call/)
- **Consulting:** [Vibe Coding Agency](https://vibecodingagency.com/)
- **Email:** [contact@vibecodingagency.com](mailto:contact@vibecodingagency.com)
- **LinkedIn:** not available

---

<div align="center">

*Quotidie est ratio plenae laetitiae in miraculo vitae*<br>
*Every day is the reason for complete joy in the miracle of life*

*My favorite song is "Rainbow Connection" by Kermit the Frog from The Muppet Movie.*

**© 2026 Andrew White**

</div>
````

- [x] **Step 2: Check the Markdown diff for accidental changes**

Run:

```bash
git diff --check -- README.md
git diff --stat -- README.md
```

Expected: no whitespace errors; only `README.md` is reported by the diff stat.

### Task 3: Verify the finished profile

**Files:**
- Verify: `README.md`
- Verify local targets: `PROJECTS.md`, `CONTRIBUTING.md`

- [x] **Step 1: Run the approved structure and em dash checks**

Run:

```bash
python3 - <<'PY'
from pathlib import Path
text = Path('README.md').read_text()
required = [
    "# Hi, I'm Andrew White",
    '## How I can help',
    '## Selected products and engineering work',
    '## Experience you can draw on',
    '## How I work',
    '## For recruiters and hiring managers',
    '## Open source',
    '## Get in touch',
    '**[Discuss a project](https://vibecodingagency.com/strategy-call/)**',
    '- **Discuss a project:** [Strategy call](https://vibecodingagency.com/strategy-call/)',
    'https://vibecodingagency.com/',
    'mailto:contact@vibecodingagency.com',
    '[awdemos repository](https://github.com/awdemos/awdemos)',
    '[Résumé](Resume.md)',
    '[**Compactation**](https://compactation.dev/)',
    'A commercial Rust library',
    'An unpublished `no_std` amd64 OS',
]
missing = [item for item in required if item not in text]
assert not missing, f'Missing required content: {missing}'
forbidden = [
    'https://calendly.com/aicareerpathllc/30min',
    'https://twitter.com/awdemos',
    'https://x.com/awdemos',
    'https://github.com/awdemos/demos',
    'portable C implementation',
]
present = [item for item in forbidden if item in text]
assert not present, f'Stale or broken content remains: {present}'
assert '\u2014' not in text, 'README.md contains an em dash'
sections = [
    "# Hi, I'm Andrew White",
    '## How I can help',
    '## Selected products and engineering work',
    '## Experience you can draw on',
    '## For recruiters and hiring managers',
    '## How I work',
    '## Open source',
    '## Get in touch',
]
positions = [text.index(section) for section in sections]
assert positions == sorted(positions), f'Incorrect section order: {sections}'
print('PASS: current content, heading order, rejected stale URLs and claims, and no em dashes')
PY
```

Expected: `PASS: current content, heading order, rejected stale URLs and claims, and no em dashes`.

- [x] **Step 2: Validate local Markdown links and public project links**

Run:

```bash
python3 - <<'PY'
import json
import subprocess
from pathlib import Path

for target in ('PROJECTS.md', 'CONTRIBUTING.md'):
    assert Path(target).is_file(), f'Missing local link target: {target}'
print('PASS: local Markdown link targets exist')

expected = {
    'merlin': 'https://github.com/awdemos/merlin',
    'RegicideOS': 'https://github.com/awdemos/RegicideOS',
    'gpt2.s': 'https://github.com/awdemos/gpt2.s',
    'needle-rs': 'https://github.com/awdemos/needle-rs',
    'mas-steer': 'https://github.com/awdemos/mas-steer',
    'tiny-lm-rs': 'https://github.com/awdemos/tiny-lm-rs',
}
actual_urls = []
for repo, expected_url in expected.items():
    result = subprocess.run(
        ['gh', 'repo', 'view', f'awdemos/{repo}', '--json', 'url,visibility'],
        capture_output=True,
        text=True,
        check=False,
    )
    assert result.returncode == 0, f'gh repo view failed for {repo}: {result.stderr.strip()}'
    record = json.loads(result.stdout)
    assert record.get('visibility') == 'PUBLIC', f'{repo} is not PUBLIC: {record}'
    assert record.get('url') == expected_url, f'Unexpected URL for {repo}: {record}'
    actual_urls.append(record['url'])

assert len(actual_urls) == 6, f'Expected exactly six repository URLs, got {len(actual_urls)}'
assert actual_urls == list(expected.values()), f'Unexpected repository URL set: {actual_urls}'
print('\n'.join(actual_urls))
print('PASS: all six expected repositories are PUBLIC with exact URLs')
PY
```

Expected: the local check prints `PASS`, followed by exactly six expected public repository URLs and a final `PASS` for repository visibility and URLs. Any `gh` error, non-public visibility, missing repository, or unexpected URL fails the check.

- [x] **Step 3: Review the final content as a buyer**

Read `README.md` from top to bottom and confirm:

- The first screen contains a warm introduction, consulting value, and three contact actions.
- Service descriptions address buyer outcomes before project details.
- Private or unpublished projects have no broken GitHub links.
- Experimental work is described without inflated production claims.
- No defensive wording remains.
- The older `GITHUB_PROFILE_README.md` is clearly marked as a superseded historical draft if it is present.

Run:

```bash
git diff --name-only
git status --short
```

Expected (at the time this task ran): the only modified files were `README.md` and `docs/superpowers/plans/2026-11-22-github-profile-consulting.md`. On current HEAD, later profile fixes also touch `GITHUB_PROFILE_README.md`, `Resume.md`, and this plan; the check is retained as a record of the original task, not as a current clean-tree assertion.

### Task 4: Commit the profile update

**Files:**
- Modify: `README.md`
- Modify: `docs/superpowers/plans/2026-11-22-github-profile-consulting.md`

- [x] **Step 1: Commit the plan and verified profile**

Run:

```bash
git add README.md docs/superpowers/plans/2026-11-22-github-profile-consulting.md
git diff --cached --check
git commit -S -m "docs: make GitHub profile warmer and buyer focused"
```

Expected: a signed commit containing the profile rewrite and this implementation plan.

- [x] **Step 2: Confirm the final repository state**

Run:

```bash
git status --short
git log -1 --pretty=format:'%h %s'
```

Expected: no uncommitted changes and the latest commit is `docs: make GitHub profile warmer and buyer focused`.
