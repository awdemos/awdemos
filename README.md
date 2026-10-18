<div align="center">

> *Quotidie est ratio plenae laetitiae in miraculo vitae*
> *Every day is the reason for complete joy in the miracle of life*

# awdemos — open-source systems and AI infrastructure, built from scratch

[![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)](https://kernel.org/)
[![Rust](https://img.shields.io/badge/Rust-000000?style=for-the-badge&logo=rust&logoColor=white)](https://www.rust-lang.org/)
[![NVIDIA](https://img.shields.io/badge/NVIDIA-76B900?style=for-the-badge&logo=nvidia&logoColor=white)](https://www.nvidia.com/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)](https://kubernetes.io/)
[![Go](https://img.shields.io/badge/Go-00ADD8?style=for-the-badge&logo=go&logoColor=white)](https://go.dev/)
[![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://python.org/)

</div>

---

## What this is

awdemos is my open-source workshop: a growing collection of systems and AI
infrastructure tools that I build almost entirely in Rust, almost entirely from
scratch — an operating system, a text editor, agent harnesses, GPU utilities,
and the odd flight simulator. The premise is simple: **if you use a tool every
day, you should understand it well enough to have written it yourself.** Most of
these projects started as "I wonder how that works" and ended up as things other
people run in production.

## Who it's for

- Systems and infrastructure engineers who like reading real code more than docs
- Rust developers looking for non-toy projects to contribute to
- People running local or on-prem LLMs who want tooling that doesn't phone home
- Anyone who shares the suspicion that a tool you can't audit is a tool you don't own

No prior connection needed — if a project here solves a problem you have, or
creates one you want to solve, you're in the right place.

## Flagship projects

Everything below is real, public, and under active development in this org:

| Project | What it is |
|---|---|
| [**RegicideOS**](https://github.com/awdemos/RegicideOS) | Immutable Linux distribution built on Gentoo, BtrFS, and the COSMIC desktop — an OS that actually understands GPUs |
| [**RegicideOSArch**](https://github.com/awdemos/RegicideOSArch) | The Arch-based sibling of RegicideOS: bootable images, BTRFS, AI tooling out of the box |
| [**neoxide**](https://github.com/awdemos/neoxide) | A Vim-inspired terminal editor in Rust — LSP, tree-sitter, Lua plugins, splits, registers, and a voice mode |
| [**Xfiles**](https://github.com/awdemos/Xfiles) | A Plan 9-inspired communication hub for AI agents, built around virtual filesystem namespaces and MCP |
| [**kache**](https://github.com/awdemos/kache) | Zero-copy, content-addressed build cache for Rust and C/C++ — hardlinks locally, S3 when you want to share |
| [**llm-visuals**](https://github.com/awdemos/llm-visuals) | Live terminal dashboard for a local llama.cpp model: tok/s, TTFT, GPU load, context, expert routing |
| [**spark-doctor**](https://github.com/awdemos/spark-doctor) | Diagnostic CLI for the NVIDIA DGX Spark — catches power caps, thermal issues, and CUDA wheel mismatches early |
| [**veloGB10**](https://github.com/awdemos/veloGB10) | An inference engine purpose-built and tuned for the GB10 |
| [**wetware-rs**](https://github.com/awdemos/wetware-rs) | Compute on a real brain — the complete fruit-fly connectome run as a reservoir, with a trained readout |
| [**octox**](https://github.com/awdemos/octox) | A Unix-like operating system in Rust, inspired by xv6-riscv — small enough to read in a weekend |
| [**phosphor**](https://github.com/awdemos/phosphor) | A truecolor, self-learning terminal screensaver, because the machine idling should still be interesting |
| [**oomwrap**](https://github.com/awdemos/oomwrap) | Wraps commands that might exhaust memory and stops them before they freeze your machine |

The org has 400+ repositories — experiments in languages, simulations, security,
and games. Dig around; the rough drafts are public on purpose.

## How to get involved

1. **Pick a project and run it.** Every repo has its own README and build instructions. If something doesn't work, that's a bug — file it.
2. **Open an issue before a PR.** Good first contributions: bug reports with reproduction steps, documentation fixes, failing tests, performance observations.
3. **Read [CONTRIBUTING.md](CONTRIBUTING.md) before submitting.** The short version: small focused changes, clear commit messages, GPG-signed commits, `cargo fmt`/`cargo clippy` for Rust, and no GitHub Actions (Dagger or Jenkins instead).
4. **Security issues:** do not open a public issue. Report privately with reproduction steps; I hold a 90-day embargo before any disclosure.

Everything here is MIT-licensed unless a repo says otherwise.

## A note on how I build

I design from first principles and distrust black boxes: if it can't be audited,
it doesn't ship. I prefer code over YAML where a choice exists, I care about
memory safety because 3 a.m. segfaults are a waste of a life, and I believe in
AI sovereignty — models you own, data you control, infrastructure you can read.
I grew up on Slashdot and open source culture, and building in public is still
how I work.

By day I'm an AI Factory Lead at a Fortune 500, collaborating with NVIDIA on
infrastructure that ships reliably and fast. Before that: lead AI infrastructure
engineer at the Helix Center for Applied AI, symbolic AI at Cycorp under
Dr. Doug Lenat, Top 500 HPC systems, and time at OpenDNS and the Wikimedia
Foundation. I also run [Vibe Coding Agency](https://vibecodingagency.com/),
which funds the open-source work you see here.

## Get in touch

- **Email:** andrew@awdemos.com
- **X/Twitter:** [@awdemos](https://twitter.com/awdemos)
- **LinkedIn:** [andrewwhite](https://linkedin.com/in/andrewwhite)
- **Book a call:** [Calendly](https://calendly.com/aicareerpathllc/30min)
- **Community:** [Enterprise AI Atlas](https://github.com/enterprise-ai-atlas)

If you're working at the intersection of systems, AI, and security — or you
want to argue about any of the decisions in these repos — open an issue or
send me a message. Collaboration is the point.

---

<div align="center">

**© 2026 Andrew White** — Built with curiosity, caffeine, and a deep distrust of complexity for its own sake.

</div>
