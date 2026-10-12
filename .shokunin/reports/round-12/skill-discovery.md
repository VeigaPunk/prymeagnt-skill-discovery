# Skill discovery R12 — destination skill entry symlink

Date: 2026-10-12. Base `c3984d3`; implementation/probe/log/scorecard commit `9eb73d5f561820b6dbb443d463bc77d73c1ddbfe`. Author and committer: `skill-discovery-shokunin <skill-discovery@shokunin.local>`.

## One move

`scripts/install-skills.sh` now refuses a symlink at the specific `$TARGET/$name` destination before `mkdir -p` and `cp -a`. The check uses the exact entry path without a trailing slash, so `[ -L ]` sees it. A normal directory entry follows the original path. This is not a broad containment or atomic installer change: in a mixed source the ordinary sibling can already have been copied before a later linked entry fails.

## Actual baseline/current private native observations

Run `.shokunin/skill-discovery/corpus/probes/r12-target-directory-link.sh <installer-path>` against actual `git show c3984d3:scripts/install-skills.sh` (extracted executable) and current `scripts/install-skills.sh`. For each run it creates disposable private source/project/target/outside directories. `$TARGET/z-linked` points to the outside directory; the external sentinel exists before the install and is never overwritten by the probe. No existing external `SKILL.md` is used or overwritten. Each case runs a fresh `prime-agent prompt --cwd <private-project> --json`; scratch is removed on exit.

| Case / measurement | Baseline `c3984d3` | Current `9eb73d5` |
|---|---|---|
| Mixed install exit / installed count | 0 / 2 | 1 / 1 |
| Mixed outside `SKILL.md` written / ordinary installed | yes / yes | no / yes |
| Mixed inventory linked / ordinary | present / present | absent / present |
| Linked-only install exit / installed count | 0 / 1 | 1 / 0 |
| Linked-only outside `SKILL.md` written / linked inventory | yes / present | no / absent |
| Ordinary-only install exit / installed count | 0 / 1 | 0 / 1 |
| Ordinary-only outside write / ordinary inventory | no / present | no / present |

The external sentinel remains unchanged in every case; destination link remains a link. All six fresh prompt processes exited 0. R9 control: mixed 0/count 1, only-fake 1/count 0. R10: mixed 0/count 2, external-only 1/count 0; ghost/absolute absent, internal/peer present in fresh inventory. R11: mixed 0/count 1, only-link 1/count 0; outside absent and ordinary present in mixed fresh inventory. `bash -n` on installer/probe and `git diff --check` passed.

## Proposed one-axis verdict and limits

**Operability improved narrowly:** the linked destination no longer causes a false-success outside write/count, while the ordinary non-link path and R9/R10/R11 controls persist. **Freshness unchanged:** fresh CLI inventory is not daemon reload or an existing session update. No daemon/session reload, provider inference, shared install, manifest/global harness change, merge, or push. The implementation is fail-closed at the encountered destination entry, not transactional for earlier siblings and not a general defense against concurrent path replacement.
