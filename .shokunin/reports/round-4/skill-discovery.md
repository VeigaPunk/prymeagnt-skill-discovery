# skill-discovery — round 4 report

## Work performed
- Inspected `scripts/install-skills.sh`; it accepts `SKILLS_SOURCE` and a positional target directory, so the lifecycle could run entirely in a disposable project scratch tree without touching shared skill roots. Source: `scripts/install-skills.sh:4-9,22-23`.
- Added and ran `.shokunin/skill-discovery/corpus/probes/isolated-lifecycle.sh` twice; both runs exited 0, installed the disposable fixture into a private temporary `.prime/agent/skills`, checked file/frontmatter, and `prime-agent prompt --cwd <scratch>` listed its name and exact target `SKILL.md` location. Second run output is in the verification transcript; command is reproducible.
- Tried `prime-agent prompt --cwd <scratch> --skill <path>`; it rejected the option as unknown for the prompt subcommand. Tried top-level explicit `--skill` with a fresh print session; startup reached inference but returned `402 Insufficient balance`, not an inventory result. These routes are excluded as evidence.
- Did not start a separate daemon-backed disposable session and did not exercise `/reload`; this was unnecessary to demonstrate isolated install plus fresh-process discovery and avoids claiming reload coverage. No shared skill directory, settings, prompt, or live TUI was changed. Scratch dirs are cleaned by the probe.

## Landed changes
- Added isolated install/discovery lifecycle probe, updated round log and scorecard. Change commit: `5404e052bfa7e48515f493a41662270e4182895f` (lane identity `skill-discovery-shonen <skill-discovery@shokunin.local>`).

## Before → after measurements
- **Operability — improved (proposal to L1):** Before, round 3 only verified a discovery-matching fixture and negative cases; it did not install a skill. After, the reproducible probe executes private install, validates file/frontmatter, and verifies a fresh process lists the installed path. Counting/check: `.shokunin/skill-discovery/corpus/probes/isolated-lifecycle.sh` → exit 0; measured at `5404e052bfa7e48515f493a41662270e4182895f`. The custom source/target contract is from `scripts/install-skills.sh` and was exercised.
- **Freshness — unchanged:** no live installation tree or daemon reload state was inspected; previous live drift measurement remains round 2.

## SHONEN
- [x] Real decision tables/error patterns/checklists with cited sources — prior non-author reviewers cited in `LOG.md`; this round adds a reproducible procedure.
- [ ] End-to-end domain task executed and logged — private install + fresh-process discovery is verified here, but `/reload` and a separately created daemon-backed session were not exercised; no non-author round-4 verifier receipt.
- [x] Instructions executable without oral context — command is `\.shokunin/skill-discovery/corpus/probes/isolated-lifecycle.sh`; prior non-author reviews cited in `LOG.md`.
- [x] No cross-domain bleed; `PROVINCE.md` remains accurate — prior non-author review receipts cited in `LOG.md`; round 4 only changed owned paths.

Report prepared after change commit `5404e052bfa7e48515f493a41662270e4182895f`; round 4 remains partial and does not promote the lane.
