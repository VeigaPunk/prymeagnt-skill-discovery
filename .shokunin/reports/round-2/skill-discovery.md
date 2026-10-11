# skill-discovery — round 2 report

## Work performed
- Added a read-only freshness probe that compares committed skill source SHA-256 and mtime to installed candidates, then checks a newly launched `prime-agent prompt` inventory and winning location. Evidence: `.shokunin/skill-discovery/corpus/probes/freshness.sh`; `git rev-parse HEAD` before report: `e92a3acfe63c6ca4e605e1aa45f9d1399e661c47`.
- Ran probe after the implementation commit with `prime-agent` 0.10.0; source commit was `e92a3acfe63c6ca4e605e1aa45f9d1399e661c47`. It discovered godspeed, shokunin, and ufo from `/home/vgpnk/.prime/agent/skills/`; godspeed matched source hash; shokunin and ufo installed hashes differed. All three competing `/home/vgpnk/.agents/skills` hashes also differed. Evidence: command `.shokunin/skill-discovery/corpus/probes/freshness.sh` (captured output summarized in `.shokunin/skill-discovery/LOG.md`, Round 2).
- Recorded unresolved ownership question about non-winning `.agents` copies in `.shokunin/l0-questions.md`; reports them as candidates separately and does not count them as winning discovery roots.

## Landed changes
- `corpus/probes/freshness.sh` adds the reproducible drift/discovery probe; `LOG.md` Round 2 and `SCORECARD.md` freshness row record the change. Carried by commit `e92a3acfe63c6ca4e605e1aa45f9d1399e661c47`.
- `.shokunin/l0-questions.md` carries the open question; same commit `e92a3acfe63c6ca4e605e1aa45f9d1399e661c47`.

## Before → after measurements
- Freshness probe capability: before **0** repeatable SHA-256/mtime-to-HEAD checks in the Round 1 checklist; after **1** executable probe comparing three named skills and checking fresh-process discovery. Counting command: `grep -c 'source_hash=' .shokunin/skill-discovery/corpus/probes/freshness.sh` (1); committed implementation measured at `e92a3acfe63c6ca4e605e1aa45f9d1399e661c47`. This establishes repeatable detection capability, not that the copies were refreshed.
- Live state: before this probe, no committed source-vs-installed hash measurement existed; after probe run at 2026-10-11T19:20:40-03:00, 1/3 `/home/vgpnk/.prime/agent` installed copies matched and 2/3 were flagged DRIFT; new-process discovery was 3/3. Counting command: `.shokunin/skill-discovery/corpus/probes/freshness.sh` (reports `comparison=` and `fresh_inventory=` per skill); code measured at commit `e92a3acfe63c6ca4e605e1aa45f9d1399e661c47`.

## Verdicts
- `freshness`: **improved** (lane proposal to L1). A repeatable version/date-stamped check now detects content drift and confirms fresh-process winner without mutation.
- `operability`: **unchanged**. Existing install/frontmatter/discovery/reload checklist retained; round did not alter its tested operation.
- Provenance: **[1/2]** primary evidence consists of the checked-in probe and its direct output. **[2/2]** whether non-winning shared `.agents` copies are in-scope installed targets remains unresolved; see `.shokunin/l0-questions.md`. No install, reload, or source modification was performed.

## SHONEN
- [ ] Real decision tables/error patterns/checklists with cited sources; non-author verifier required.
- [ ] End-to-end domain task executed and logged; non-author verifier required.
- [ ] Instructions executable without oral context; non-author verifier required.
- [ ] No cross-domain bleed; PROVINCE remains accurate; non-author verifier required.
