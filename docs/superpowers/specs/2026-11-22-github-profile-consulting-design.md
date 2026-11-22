# GitHub Profile Consulting Design

## Purpose

Rework the public GitHub profile in `README.md` so AI platform leaders can quickly understand Andrew White's consulting value, trust the warmth of his introduction, and inspect recent technical work that supports the offer.

## Audience and positioning

The primary audience is CTOs, VPs of Engineering, and AI platform leads responsible for production AI infrastructure, model routing, GPU systems, private deployment, and reliable operations.

The chosen direction is a warm expert presentation with the buyer first. The profile should sound welcoming, experienced, and useful without aggressive sales language or a defensive engineering philosophy.

## Opening

Begin with a personal greeting and thanks for visiting. State that Andrew helps AI platform teams turn complex ideas into reliable, auditable systems.

Describe consulting across AI infrastructure, model routing, private inference, GPU computing, Linux, and production operations. Name Vibe Coding Agency as the consulting vehicle and invite visitors to discuss ambitious engineering work.

Place these actions immediately after the introduction:

- Book an introductory call through the existing Calendly link.
- Explore consulting services at `https://vibecodingagency.com/`.
- Email `andrew@awdemos.com`.

## Page structure

### How I can help

Present four concise service areas:

1. AI platform architecture.
2. Inference and model routing.
3. GPU and Linux systems.
4. Production reliability and operability.

Describe outcomes and engagement types rather than listing technologies without context.

### Selected products and engineering work

Use a compact project section with accurate, buyer-relevant descriptions and public repository links. Feature:

- Merlin: production-oriented LLM routing, governance, and observability.
- score-centering: a commercial Rust library for differentiable per-token score centering in reinforcement learning trainers.
- RegicideOS: AI-focused Linux distribution and systems engineering.
- gpt2.s: GPT-2 small implemented in handwritten AArch64 assembly, with a portable C version.
- needle-rs: a pure Rust on-device tool-calling runtime with quantized model support and grammar-constrained decoding.
- MAS-Steer: adversarial search for targeted activation-steering interventions in frozen language models.
- tiny-lm-rs: a Rust and WebAssembly GPT that trains in the browser with handwritten backpropagation.
- oxidatedBSD: a `no_std` amd64 kernel with preemptive user processes and separate address spaces. Link to the public repository only if one exists; otherwise omit the link rather than inventing one.

Do not present qwenputer as Andrew's product because its origin points to another author's repository.

### Experience you can draw on

Briefly establish credibility through Andrew's Fortune 500 AI Factory role, NVIDIA collaboration, Helix Center, Cycorp, Top 500 HPC, OpenDNS, and Wikimedia experience. Keep this subordinate to the buyer's needs and selected work.

### How I work

Frame engineering values positively: transparency, careful implementation, reproducibility, auditability, and shared understanding. Remove defensive or hostile phrasing while preserving Andrew's commitment to understandable systems and AI sovereignty.

### Open source and contact

Retain a short invitation to inspect and discuss open-source work. Move detailed contribution mechanics out of the main buyer path. Repeat the introductory-call action and retain relevant professional contact links.

## Style constraints

- Remove every Unicode em dash from `README.md`.
- Use warm, plain, confident English.
- Avoid inflated claims and describe experimental projects accurately.
- Keep the opening focused on the visitor rather than Andrew's biography.
- Preserve valid Markdown and working links.
- Do not add emoji or decorative badges to the new opening.

## Scope

Edit only the live profile source, `README.md`, during implementation. Leave the older `GITHUB_PROFILE_README.md` template unchanged. Do not modify project repositories or the consulting website as part of this task.

## Verification

- Confirm the rendered profile has the approved section order and calls to action.
- Check that `README.md` contains no em dash characters.
- Validate every local Markdown link target and confirm external project URLs against repository metadata.
- Review the final diff for accuracy, tone, and unintended changes.
