#!/bin/bash
# SessionEnd hook: one trace line per session (date, id, reason, folder), outside the repo, for the nightly audit.
# Hook limit: 1.5 s, no call to Claude. Always exit 0.
input=$(cat)
log="$HOME/.cache/claude-memory-kit/session-ends.log"
mkdir -p "$(dirname "$log")" 2>/dev/null
printf '%s session=%s reason=%s cwd=%s\n' \
  "$(date +%Y-%m-%dT%H:%M:%S%z)" \
  "$(jq -r '.session_id // "?"' <<<"$input" 2>/dev/null)" \
  "$(jq -r '.reason // "unknown"' <<<"$input" 2>/dev/null)" \
  "$(jq -r '.cwd // "?"' <<<"$input" 2>/dev/null)" >> "$log" 2>/dev/null
exit 0
