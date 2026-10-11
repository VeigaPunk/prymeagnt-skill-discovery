# Skill discovery R6 — daemon isolation safety preflight

Date: 2026-10-11
Branch: `craft/skill-discovery-r6`
Agent identity: `skill-discovery-shonen <skill-discovery@shokunin.local>` (author and committer)

## Axis and decision

**Freshness** was the sole requested move. I did not start a daemon, session, or reload. The inspected environment has inherited `PRIME_AGENT_INTERNAL_*` state, including worker/supervisor socket and session lease variables (variable names only; values omitted). The CLI accepts `--daemon-socket` and `--session-dir`, and the wrapper documents `PRIME_AGENT_CODING_AGENT_DIR` / `PRIME_AGENT_DAEMON_SOCKET` overrides, but these do not prove a private daemon lifecycle or prevent internal worker state from attaching to the shared daemon. Therefore a disposable path choice is insufficient evidence of isolation. No launch was safe to attempt from this session.

Added `.shokunin/skill-discovery/corpus/probes/daemon-isolation-preflight.sh`, a read-only path/env guard. It refuses any inherited `PRIME_AGENT_INTERNAL_*` variable, overlapping private/live store roots, or an equal / store-contained private socket. It only reports path preflight; it does **not** launch or establish daemon isolation. This round's validation used `env -i` and fake private paths: distinct paths passed; same socket, synthetic inherited internal variable, and nested store each refused. No daemon/session was started by these tests. The current inherited process environment was independently observed to contain internal variables, so any attempted invocation without a sanitized environment should refuse.

Reproduce path-guard fixture checks (no service launch):

```sh
P=.shokunin/skill-discovery/corpus/probes/daemon-isolation-preflight.sh
env -i PATH="$PATH" bash "$P" /tmp/sd-private-agent /tmp/sd-private-runtime/daemon.sock /home/vgpnk/.prime/agent /tmp/prime-agent-rust-1000/daemon.sock
```

Probe SHA-256: `e8150b53042b75d6cb8b292f17f6b1c322f618d9af49ec005816889b25c22136` (work commit `b0d0f78`). Negative fixtures are documented by shell arguments in the round's commit receipt; the probe is intentionally not a daemon runner. Existing R4/R5 probes were preserved. No MANIFEST/global/source files, shared skill paths, settings, TUI, or daemon were touched.

## Axis verdict

- **Freshness: unchanged / no advance.** No daemon reload or live process freshness claim. Private CLI path flags and environment overrides alone do not verify isolation.
- **Operability: unchanged.** A tested guard is useful safety evidence but does not advance the previously measured install/discovery workflow.
- **SHONEN box 2: unchecked.** No end-to-end daemon-backed task was executed; this is not a SHONEN end-to-end result.

## Limits

The guard is a conservative preflight, not an authorization to launch. It cannot prove how the CLI interprets overrides, isolate daemon-global behavior, or establish that every internal state channel has been removed. Future isolated lifecycle testing requires an independently verified launch method, a sanitized environment, and private store and socket proven disjoint from live paths; otherwise continue not to launch.
