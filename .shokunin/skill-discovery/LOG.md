# skill-discovery append-only log

## Mint 2026-10-11
- Explicit operator directive; no craft round, no verdict or promotion yet.
- Evidence: `.shokunin/mints/skill-discovery.md`; sources: `.shokunin/skill-discovery/corpus/knowledge/seed.md`.
- Next falsifiable move: execute one bounded read-only task, cite before/after, and have L1 judge every owned axis.

## Round 1 — 2026-10-11
- Added a sourced, actionable checklist separating installed-file presence, frontmatter validation, fresh-process discovery, and existing-process reload; includes a read-only `prime-agent prompt` probe and explicitly marks reload unrun. Evidence: `corpus/lessons/2026-10-11-skill-discovery-checklist.md` §§1–4; source contracts: `scripts/install-skills.sh:12-49`, `docs/capability-survey.md:1.2`, `verification/smoke-test.log` Checks 0d–0e, installed `skill-creator/SKILL.md` Frontmatter/Verification.
- Safe fresh-process probe run in the assigned worktree: `prime-agent prompt 2>/dev/null | grep -nE 'godspeed|shokunin|ufo' | head -9`; returned all three names and installed-file locations at `/home/vgpnk/.prime/agent/skills/`. This validates the probe only for this environment; no install or interactive reload was run.
- Operability checkpoint count: before 0 actionable lane checklist checkpoints (seed only cited sources, no procedure); after 4 distinct checks in the lesson. Freshness is not improved by this documentation move; the cited survey and runtime snapshot are dated 2026-10-11 and should be rechecked before reuse.
- Verdict proposal for L1: operability improved; freshness unchanged. Evidence is a sourced checklist plus a successful safe fresh-process probe; no assertion of reload success.


## Round 2 — 2026-10-11
- Added read-only repeatable freshness probe at `corpus/probes/freshness.sh`: records date, CLI version, source commit, source SHA-256/mtime, candidate installed-copy SHA-256/mtime, and fresh-process winning discovery location; returns nonzero on drift or missing inventory. Command: `.shokunin/skill-discovery/corpus/probes/freshness.sh`.
- Evidence: run at 2026-10-11T19:20:17-03:00, prime-agent 0.10.0, source commit `65a1d7b8215bf1bb764c0c9957f217a930f27b78`; all 3 source skills discovered from `~/.prime/agent/skills`; godspeed installed copy hash matched, while shokunin and ufo hashes differed. All three `~/.agents/skills` candidates differed. Probe output is recorded in round report. No source/install/reload mutation.
- Operability preserved; freshness probe makes drift falsifiable/reproducible and flags observed drift. L1 verdict proposal: freshness improved, operability unchanged.
- Provenance: [1/2] primary evidence is live probe output and source script; [2/2] interpretation of whether non-winning `~/.agents` candidates count as owned installations remains open at `.shokunin/l0-questions.md`; candidate copies are reported separately, not treated as actual discovery winner.
