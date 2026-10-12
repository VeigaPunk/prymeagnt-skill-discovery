# Skill discovery R13 — default installer source through script symlink

Date: 2026-10-12. Base `b929d86`; implementation/probe/log/scorecard commit `68348294023e6e144bca2edd50b465e088a54926`. Author and committer: `skill-discovery-shokunin <skill-discovery@shokunin.local>`.

## Work performed

- `scripts/install-skills.sh:15`: resolve the script path via `realpath -e -- "${BASH_SOURCE[0]}"` before `dirname`; then derive the default `../skills` from the actual installer's parent. Explicit `SKILLS_SOURCE` remains authoritative (`scripts/install-skills.sh:16`). Assumption: invoking an installer via symlink is useful, but this is not explicitly documented.
- `.shokunin/skill-discovery/corpus/probes/r13-script-link.sh`: private, disposable symlink at `<scratch>/bin/install-skills.sh`, actual installer target, explicit-source override, per-case separate private project targets and fresh CLI inventory tied to the private target `<location>`. All scratch is removed. Actual baseline was `git show b929d86:scripts/install-skills.sh` extracted as executable into a private directory with a sibling copy of the repo's `skills/`; current invocation uses the actual `scripts/install-skills.sh`. This ensures baseline's direct invocation has a valid default source, so only symlink routing differs.
- `bash -n scripts/install-skills.sh .shokunin/skill-discovery/corpus/probes/r13-script-link.sh` and `git diff --check` passed. Current R9–R12 probes passed: R9 mixed 0/1, only-fake 1/0; R10 mixed 0/2, only-external 1/0, internal/peer present and ghost/absolute absent; R11 mixed 0/1, only-link 1/0, outside absent; R12 mixed 1/1, linked-only 1/0, ordinary-only 0/1, outside write no and sentinel unchanged.

## Landed changes

- Commit `68348294023e6e144bca2edd50b465e088a54926`: one-line default-source anchor fix; R13 reproducible probe; append-only `LOG.md` R13 and `SCORECARD.md` R13 observation. This report lands in a later report-only commit.

## Before → after measurements

Command: `.shokunin/skill-discovery/corpus/probes/r13-script-link.sh <absolute-installer-path>`. Baseline path was the private executable extracted from `b929d86` with sibling `skills/`; current path was `scripts/install-skills.sh` at `6834829`. Each case used fresh `prime-agent prompt --cwd <private-project> --json`, exit 0 in both versions. "Private inventory" means the skill's `<location>` equals that case's private target, not an unrelated global skill of the same name.

| Case / measure | Baseline `b929d86` | Current `6834829` |
|---|---|---|
| Direct default install exit/count | 0 / 3 | 0 / 3 |
| Direct private inventory godspeed, shokunin, ufo | all present | all present |
| Symlink default install exit/count | 1 / 0 (error: no skills in private `bin/../skills`) | 0 / 3 |
| Symlink private inventory godspeed, shokunin, ufo | all absent | all present |
| Symlink with explicit private `SKILLS_SOURCE` exit/count | 0 / 1 | 0 / 1 |
| Override private inventory override-r13 / ordinary three | present / all absent | present / all absent |

**Proposed operability improved narrowly:** default SOURCE now resolves relative to the actual script when invoked via symlink; direct invocation and override remain usable. **Freshness unchanged:** fresh CLI processes say nothing about an existing daemon/session or `/reload`. GNU `realpath -e` was already used by this installer; this makes no portability promise beyond that environment. No daemon, reload, shared target, provider, global harness, manifest, merge, push, or atomicity change; no claim against concurrent path replacement.

## SHONEN

- [x] Cited decision/checklist evidence, verified by named non-author `round1-independent-review` / `round2-independent-review` at `65a1d7b` / `68b4257` (existing `SHONEN.md` receipt; not a new R13 review).
- [ ] End-to-end domain task including daemon reload: not verified.
- [x] Executable instructions, verified by those same non-authors at those commits (not a new R13 review).
- [x] Province scope, verified by those same non-authors at those commits (not a new R13 review).
