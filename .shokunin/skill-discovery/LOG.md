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
