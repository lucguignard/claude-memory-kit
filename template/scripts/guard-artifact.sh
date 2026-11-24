#!/bin/bash
# PreToolUse hook (Artifact tool): blocks publishing an internal file of the kit as a claude.ai artifact
# (scripts, settings, CLAUDE.md, memory notes, journal, audit). Deliverables in workstreams stay publishable.
paths=$(jq -r '.tool_input | [.file_path?, (.file_paths? // [])[], ((.files? // {}) | if type == "object" then .[] | (.from? // .) else empty end)] | map(select(type == "string")) | .[]' 2>/dev/null)
internal='(^|/)(scripts|\.claude)/|(^|/)CLAUDE\.md$|(^|/)memory/[^/]+\.md$|(^|/)memory/(journal|audit|radar)/'
if grep -qE "$internal" <<< "$paths"; then
  echo "Blocked: this file is internal to the kit (scripts, settings, memory notes, journal) and must not be published as an artifact. Deliver a copy outside memory/ if the user wants a page." >&2
  exit 2
fi
exit 0
