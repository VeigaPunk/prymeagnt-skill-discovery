# Skill discovery checklist — 2026-10-11

Use this checklist to separate a skill copied to disk from one discovered by a new process, and from changes reloaded in an existing process. Sources are read-only; commands below do not install or modify skills.

## 1. Installed-file check (filesystem only)

Set `TARGET` to the destination used by `scripts/install-skills.sh` (default: `${PRIME_AGENT_CODING_AGENT_DIR:-$HOME/.prime/agent}/skills`). For each skill name, check the expected file exists and is non-empty:

```sh
test -s "$TARGET/<name>/SKILL.md" && echo installed-file-present
```

This proves only file presence, not that Prime Agent accepts or discovers it. The installer copies each visible source skill directory into `$TARGET/<name>/` (`scripts/install-skills.sh:12-49`).

## 2. Frontmatter checks (file contents)

Read `SKILL.md` and confirm YAML frontmatter has a non-empty `name` matching the skill directory and a non-empty `description`. The installed skill-creator contract sets name to lowercase letters/digits/hyphens (≤64 chars), description ≤1024 chars, and warns that a missing/empty description is silently not loaded (`/home/vgpnk/.local/share/prime-agent/skills/skill-creator/SKILL.md`, Frontmatter). This is a content check, not runtime proof.

## 3. Fresh-process discovery (safe reproducible probe)

After files are in place, run this read-only probe from the intended project directory:

```sh
prime-agent prompt 2>/dev/null | grep -n -A3 -B1 '<name>NAME</name>'
```

Replace `NAME` with the exact frontmatter name. A matching inventory entry establishes discovery by this newly launched process; inspect its `<location>` to check which source won. No match means this probe did not verify discovery; check settings, discovery roots, and `--no-skills`/name collisions. Startup exposes name and description, not full skill body (`docs/capability-survey.md:1.2`).

Live snapshot verified 2026-10-11 in this worktree: `prime-agent prompt 2>/dev/null | grep -nE 'godspeed|shokunin|ufo' | head -9` returned all 3 names and locations under `/home/vgpnk/.prime/agent/skills/` (captured output in lane report). This is an environment-specific result, not a guarantee for another installation.

## 4. Existing-process reload (separate check)

For an already-running interactive session, issue `/reload`, then inspect the skill inventory or try `/skill:NAME`. The installed skill-creator verification instructions say `/reload` picks up new/changed skills and `/skill:<name>` invokes a loaded skill (`/home/vgpnk/.local/share/prime-agent/skills/skill-creator/SKILL.md`, Verification). A fresh `prime-agent prompt` does not verify reload in an existing session. No live `/reload` was run in this round.

## Evidence and limits

The project smoke log records install Check 0d and fresh-process discovery Check 0e, both PASS in the original M7 environment (`verification/smoke-test.log`, Checks 0d–0e). It does not establish that reload was exercised. Do not claim successful runtime discovery from file existence alone, or successful reload from a new process.
