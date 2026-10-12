# Skill discovery R14 — isolated lifecycle no-axis stop

Date: 2026-10-12. Work/closure commits: `2a00fab8522ef01a2a85acea395a47fbbd06934a` / `278ade7653e458902ed1bb9743b7948a2991d03f`. Report written after both commits. Author and committer: `skill-discovery-shokunin <skill-discovery@shokunin.local>`.

## Work performed

- Declared one falsifiable **freshness** move first: install a private fixture, execute `/reload` in an existing disposable session, then obtain a *same-session* after-discovery receipt; operability must not regress. See `LOG.md` R14.
- Read-only `corpus/probes/daemon-isolation-preflight.sh` returned `PATH_PREFLIGHT_PASS` with scratch store `/tmp/skill-r14-cq_2t_om/agent-home`, sibling scratch socket, live store `/home/vgpnk/.prime/agent`, and live socket `/tmp/prime-agent-rust-1000/daemon.sock`, under `env -i` removing inherited `PRIME_AGENT_INTERNAL_*`. See `corpus/lessons/r14-raw/preflight.txt` and structured `corpus/lessons/2026-10-12-r14-disposable-lifecycle.json`.
- Started only a disposable `prime-agent --mode daemon --daemon-socket <scratch>/daemon.sock --cwd <scratch>/project` with scratch home/config/data; private PID 185782 and socket existed. Installed `r14-isolated/SKILL.md` to scratch project's `.prime/agent/skills` (exit 0, count 1). Fresh `prime-agent prompt --cwd <scratch-project> --json` lacked the skill before and listed the exact private target after install; outputs `corpus/lessons/r14-raw/prompt-before.json`, `prompt-after.json`, `installer.txt`, `fixture-SKILL.md`.
- Tried an interactive disposable TUI input route, but there is **no trustworthy command event or same-session inventory**. Two private session logs contain five setup events each and no `/reload` event (`corpus/lessons/r14-raw/private-session-events.jsonl`). Escape-sequence TUI output is not accepted as a reload receipt. The direct private daemon PID received SIGTERM; private PID and socket were absent afterward, while operator PID 3336/live socket remained. Shutdown receipt `corpus/lessons/r14-raw/shutdown.txt` and structured lesson; no shutdown command targeted the operator daemon.
- Reconciled R10–R12 reviewed closures already in this branch's `.shokunin/MANIFEST.json`. Appended missing R13 closure only, copying the integration branch's independently reviewed `f7842da` judgment by `skill-r13-independent-review` (integration replay `633fc59/2368bb7`; lane work/report `6834829/1743da1`). No verdict changed.

## Landed changes

- `2a00fab`: raw receipts, structured lesson, LOG/SCORECARD append-only observations and R13 closure reconciliation.
- `278ade7`: R14 no-axis independent-review LOG and MANIFEST closure, after named non-author `skill-r14-independent-review` replayed raw evidence and confirmed no reload proof. The reviewer did not rerun daemon or independently check process disappearance; it checked the supplied shutdown receipt.
- This report is the final R14 report-only commit, after both work and closure commits.

## Before → after measurements and L1 verdict

| Observable | Before | After | Scope |
|---|---|---|---|
| Private install | fixture absent | installer exit 0/count 1, file listed | scratch project only |
| Fresh CLI inventory | fixture absent, prompt exit 0 | fixture present at exact private path, prompt exit 0 | **different fresh CLI processes** |
| Existing private session reload/inventory | no receipt | still no command/reload or same-session discovery receipt | two JSONL files, five setup events each |
| Disposable daemon shutdown | PID/socket present during test | PID/socket absent after direct SIGTERM | live PID/socket still present |

Raw prompt SHA-256: before `e6619d936914bb8a69fc1c904515ea8e5f2131dc513ada2aa2560602f4bea029`, after `e7ed5f19b87dfa95dd7f1e4a6d8da889bcc65c46202d8cfb5f204f615cc136b6`. Named non-author `skill-r14-independent-review` replayed raw before/after and session events; it found no credential-like strings in the committed raw artifacts. **Freshness unchanged; operability unchanged; no admitted axis move.** Precise blocker: no trustworthy executed `/reload` and same-session discovery observation. No daemon lifecycle success assertion; do not check box 2.

## SHONEN

- [x] Cited decision/checklist evidence — existing named non-author `round1-independent-review` / `round2-independent-review`, `SHONEN.md`.
- [ ] End-to-end install → `/reload` → same-session discovery unverified; R14 named non-author `skill-r14-independent-review` explicitly rejected this claim; `corpus/lessons/r14-raw/`.
- [x] Executable instructions — existing named non-authors `round1-independent-review` / `round2-independent-review`, `SHONEN.md`.
- [x] Province boundary — existing named non-authors `round1-independent-review` / `round2-independent-review`, `SHONEN.md`.

No global harness edits, shared install, provider call, push, or operator daemon lifecycle command.
