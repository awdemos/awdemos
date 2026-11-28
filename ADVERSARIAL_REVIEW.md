# ADVERSARIAL_REVIEW.md — Agent Adversarial Review Standard

Version 1.1.0 · Canonical source: https://github.com/awdemos/adversarial-review
· Site: https://adversarial-review.com
· License: MIT (https://github.com/awdemos/adversarial-review/blob/main/LICENSE) —
  copy this file into your repo, modify it, and ship it under your own terms;
  the MIT license applies to the template text.

## What this file is

This file is an agent-readable contract between a repository and any coding
agent (AI or human) that works on it. Just as `AGENTS.md` tells an agent how
to behave in this repo, `ADVERSARIAL_REVIEW.md` tells the agent that its
output is expected to survive **adversarial review** — and defines how that
review is performed, what it hunts for, and how findings are reported.

From v1.1.0 the default review is a three-role loop: an authoring agent M
produces the work, an independent reviewer R proposes findings, and a
challenger C audits R's review rather than re-reviewing the change from
scratch. An arbitrator — normally the human NCO — resolves what remains
unsettled. Self-review is not review, and agreement between agents is not
evidence.

Drop this file in a repository root (alongside `AGENTS.md` / `CLAUDE.md`).
Agents that support the convention pick it up automatically. Modify only the
`## Repo-specific rules` section for your project; the protocol, lenses, and
review loop below are the portable standard and must not be weakened (you may
add lenses or rounds, not remove the core lenses or the reviewer–challenger
loop).

## The protocol

When asked for an adversarial review (or when finishing a non-trivial change
in a repo that declares this file), the agent MUST:

1. **Review as an adversary, not a linter.** Assume the code is guilty until
   proven innocent. The goal is to find ways the change fails, breaks
   invariants, or can be abused — not to confirm it works. Every finding
   must name a concrete trigger: a code path, a command, or a reproduction.
   Hypothetical failure scenarios with no trigger are UNVERIFIED items, not
   findings.
2. **Run independent passes, one lens at a time.** A complete review covers
   every lens in `## Lenses` below. Each lens is a separate pass; do not
   blend them. The verdict must list each core lens as COVERED or SKIPPED
   with a one-line justification. Skipping a lens requires a reason;
   skipping silently is a failed review.
3. **Verify against the artifact, not a description of it.** Read the actual
   diff, commits, and surrounding code; a summary written by the authoring
   agent is not evidence. Every finding must be backed by evidence the agent
   actually produced: a command that was run, a code path that was read, an
   experiment result. If a suspicion could not be confirmed or refuted,
   report it under UNVERIFIED with what was attempted and why it could not
   be settled — never promote it to a finding, and never drop it.
4. **Rate severity honestly.**
   - **CRITICAL** — exploitable security hole, data loss, or broken core
     guarantee; must fix before merge.
   - **HIGH** — real defect or guarantee weakened under plausible conditions.
   - **MEDIUM** — correctness/robustness gap with a concrete failure mode.
   - **LOW** — hardening, clarity, or hygiene.
   Inflate nothing. A reviewer who cries wolf trains maintainers to ignore
   the report; a reviewer who under-rates trains them to skip the report.
5. **Run the default reviewer–challenger loop.** R proposes findings as
   structured data; C audits those findings, disputes weak ones, and hunts
   for misses. M does not edit while R and C are exchanging review text.
   See `## Review loop` below. A lone agent reviewing its own output does
   not satisfy this rule.
6. **Reconcile every objection explicitly.** For each C verdict, either
   accept it and fix the finding, or reject it with a reason and the evidence
   that settles it. No objection may be silently dropped. An unresolved
   `DISAGREE_CONCERN` attached to a CRITICAL/HIGH finding is escalated to the
   human NCO rather than settled by a model vote.
7. **Fix-forward only after review, and only in scope.** Address
   CRITICAL/HIGH findings first; re-review the diff after fixes. A review of
   unreviewed new code is not done. Fixes must stay within the scope of the
   reviewed change; an out-of-scope improvement is reported as a separate
   item, not silently implemented.

## Review loop

The loop has three roles. It is the default for every review under this
standard; a repo may add roles or rounds, not remove these.

| Role | Job | Constraint |
|------|-----|------------|
| Authoring agent M | Produce and edit the artifact; update the change log | Edits only outside the inner loop |
| Reviewer R | Propose findings per lens, with severity and confidence | Reads the artifact directly; cites code |
| Challenger C | Dispute R's findings, check severities, hunt misses | Audits the review, not a fresh review from scratch |

- **Artifact frozen in the inner loop.** R writes a review, C evaluates and
  may revise it, R responds. This exchange repeats until the review
  stabilizes or a cap of five rounds is reached. Only then may M edit. A
  finding-free review is valid only if each lens records what was exercised;
  agreement alone is not acceptance.
- **Different model families.** R and C MUST run on different model
  families where the environment provides more than one. If only one family
  is available, continue with R and C on distinct instances, and record the
  limitation in the report so readers know the independence is weaker.
- **Structured contract.** Each finding carries a stable id, severity,
  confidence in [0, 1], `path:line`, what breaks, evidence, a suggested fix,
  and what evidence would change R's mind. C returns one verdict per finding
  id: ACCEPT, REJECT, MODIFY, or NEEDS_EVIDENCE, plus any missed issue with
  a code citation.
- **Typed disagreement.** C labels each objection as
  `DISAGREE_EVIDENCE: <code citation>` when specific code contradicts a
  finding, or `DISAGREE_CONCERN: <epistemic objection>` when it cannot point
  to contradicting code. On `DISAGREE_EVIDENCE`, R revises the finding in
  light of the cited code. On `DISAGREE_CONCERN`, R must cite code that
  confirms the bug (and keep the finding) or refutes it (and drop the
  finding). A confident rebuttal without a code citation does not settle the
  objection; that is how false consensus happens.
- **Reconciliation and escalation.** The report records the disposition of
  every C verdict. Unresolved concerns on CRITICAL/HIGH findings go to the
  human NCO. C is a brake on false positives, not an extra source of
  speculative findings: a new issue from C needs the same evidence as one
  from R.

## Lenses

| Lens | Hunts for |
|------|-----------|
| `security` | Injection, authn/authz gaps, secret handling, unsafe deserialization, dependency confusion, path traversal, tamper-evasion of integrity guarantees |
| `correctness` | Edge cases, error paths, race conditions, off-by-one, broken invariants, unhandled states |
| `spec-compliance` | Behavior that diverges from documented contract/README; tests that don't test what they claim |
| `performance` | Complexity regressions, unbounded growth, allocation hot paths, startup/latency cost, binary/dependency bloat |
| `abuse` | Ways the feature can be used against its intent: spam, forgery, downgrade, replay, truncation, griefing |
| `operational` | Deploy/persistence failure modes, migration hazards, observability gaps, rollback story |
| `governance` | Contributor-process integrity: signoff requirements actually enforced, verified/signed commits, issues-before-PRs, license and version hygiene, who may change the rules |

## Output format

```markdown
## Adversarial review — <scope: commit range / files> (<date>)

M: <authoring agent id> · R: <reviewer id, model family> · C: <challenger id, model family>
Reviewing commit: <hash>

1. [CRITICAL] security — f1 — src/auth.rs:88 — session token accepted after
   logout. Evidence: `curl -X POST ...` reproduced in 2 requests; transcript
   below. Confidence: 0.93. Would change mind if: revocation checked in
   middleware. Fix: check revocation list in middleware, not only at issue time.
2. [MEDIUM] performance — f2 — src/parse.rs:40 — O(n^2) fold on startup; measured
   42 ms per call at n=15k. Evidence: benchmark command and output below.
   Confidence: 0.81. Would change mind if: benchmark run on a cold cache shows
   <5 ms. Fix: precompute once, store by reference.

UNVERIFIED: suspected race in src/queue.rs:120 — attempted reproduction with
`stress -c 8` for 10 min, inconclusive. Needs a machine with >8 cores.

Reconciliation:
- f1: ACCEPT — fixed in <fix commit>; diff re-reviewed.
- f2: MODIFY — downgraded from HIGH; C cited the benchmark methodology.
- f3: REJECT — C cited src/auth.rs:31 refuting the claim; evidence recorded.
- f4: NEEDS_EVIDENCE — DISAGREE_CONCERN on a HIGH finding; escalated to NCO <name>.

Verdict per lens: security COVERED (1 finding), correctness COVERED (clean:
212 paths read, error branches exercised via test X), performance COVERED
(1 finding), abuse SKIPPED (no externally reachable surface in this diff) —
reason recorded, spec-compliance COVERED (1 doc drift), operational COVERED
(clean: deploy path re-run in staging), governance COVERED (clean).
Not checked: Windows builds (out of scope for this diff).
Model families: distinct / same-family limitation recorded.
```

## Repo-specific rules

<!-- Adapted from the v1.1.0 template for the awdemos monorepo. Protocol, lenses,
     and reviewer–challenger loop above are unchanged. -->

Every change in this repository is a candidate for review under this standard,
especially changes that touch agent instructions, automation, host bootstrap
scripts, or published documentation.

- Priority invariants that must never regress: commits must be GPG-signed;
  no credentials or secrets in the tree; no GitHub Actions workflows (use
  Dagger, Jenkins, or systemd user units instead); no unauditable black boxes;
  each demo stays self-contained with its own dependency manifest (there is no
  root package manager). Do not weaken the seven protocol rules, the core
  lenses, the reviewer–challenger loop, or these rules without an explicit NCO
  decision.
- Known weak spots that always get a second pass: README product/standard links
  (verify each URL resolves and points at the intended property);
  `demos/llm/vocab_surgery/` artifact hygiene (`.gitignore` must keep model
  weights and run outputs out of git — the 84 GB cleanup must not regress);
  `demos/llm/inference-platform/serving-base/scripts/00-bootstrap-host.sh`
  (host-level k3s/NVIDIA changes need rollback and permission review);
  systemd user units that drive external actions, especially `job-agent.service`
  with `AUTO_SUBMIT=1` (verify the apply gate, budget, and timezone); and any
  documentation describing the current profile or consulting positioning.
- Extra lenses: `automation` — confirm scheduled/one-shot jobs cannot loop,
  double-submit, or act outside their declared scope; `artifact-hygiene` —
  confirm generated weights, logs, databases, and build outputs stay ignored
  and no large binaries enter the tree. The `governance` lens additionally
  checks the anti-patterns listed above, not only license/version hygiene.
- Out of scope unless the change touches them: translated README variants,
  certification images, and historical notes under `docs/`.
- Review roles: R = independent reviewer subagent, C = challenger subagent.
  Use different model families where the environment provides more than one;
  otherwise record the same-family limitation in the report. Escalation
  authority: the repository owner (Andrew White) is the NCO of record.
- Commands the reviewer must run before reporting: `git status --short`,
  `git log --show-signature -1`, `git ls-files | grep -iE '\.(env|pem|key)$|secret'`
  (confirm any match is a placeholder), and the demo-specific test/lint command
  for every touched demo. For doc-only changes, verify all changed URLs resolve.
