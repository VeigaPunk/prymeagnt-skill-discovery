# L0 questions (append-only)

No open domain conflicts at mint.

skill-discovery | round-2 | Should freshness treat non-winning shared ~/.agents/skills copies as an owned installed target, or only report them as competing stale candidates? This round reports both, while prime-agent prompt identifies the winning location.

rlm-dispatch | round-2 | Can L0 clarify whether a child session ending idle while rlm.collect still reports running/unsettled is expected transient behavior or a settlement-registry lag? I routed around it by re-polling until done/settled=true.

rlm-dispatch | round-3 | Does collect settlement become authoritative only at terminal registry status, or should session-log stopReason be considered independently? This round uses explicit done/settled collect output as authoritative and treats session content as corroboration.
skill-discovery | round-3 | Is the configured/default primary installation root guaranteed to match runtime winning discovery location? Probe fails closed on mismatch and reports other candidates as informational.
skill-discovery | r14-followup | Substrate asks: headless slash-command channel (send --slash or command events); loud credential failure for isolated stores (auth.json starts {}); sanctioned credential injection (see corpus/lessons/2026-10-12-probe-headless-command-channel.md)
