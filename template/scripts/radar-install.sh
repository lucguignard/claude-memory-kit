#!/bin/bash
# Installs one radar item, unattended: scripts/radar-install.sh <YYYY-MM-DD> <n>
# Running it is the user's consent for that item only. Result on the last line, and on the phone if ntfy is set.
. "$(dirname "$0")/kit.sh"
cd "$KIT_ROOT" || exit 1
date="$1"; n="$2"
[ -f "memory/radar/$date.json" ] && [[ "$n" =~ ^[0-9]+$ ]] || { echo "Usage: $0 <YYYY-MM-DD> <n>  (needs memory/radar/<date>.json)"; exit 1; }
title="$(jq -r --argjson n "$n" '.items[] | select(.n == $n) | .title' "memory/radar/$date.json")"
[ -n "$title" ] || { echo "No item $n in memory/radar/$date.json"; exit 1; }
log="$HOME/.cache/claude-memory-kit-install.log"; mkdir -p "$(dirname "$log")"

prompt="$(cat scripts/radar-install-prompt.md)

Item to install: n°$n of \`memory/radar/$date.json\` (full note: \`memory/radar/$date.md\`). Staging folder: \`staged/radar-$date-$n/\`."

output="$(claude -p "$prompt" --model "$NIGHT_MODEL" --strict-mcp-config \
  --allowedTools Read Glob Grep WebFetch WebSearch \
  "Edit(/$KIT_ROOT/scripts/**)" "Write(/$KIT_ROOT/scripts/**)" "Edit(/$KIT_ROOT/staged/**)" "Write(/$KIT_ROOT/staged/**)" \
  "Edit(/$KIT_ROOT/memory/radar/**)" "Write(/$KIT_ROOT/memory/radar/**)" \
  "Bash(git clone:*)" "Bash(mkdir:*)" "Bash(cp:*)" "Bash(chmod +x:*)" "Bash(ls:*)" "Bash(jq:*)" "Bash(mktemp:*)" \
  "Bash(claude plugin:*)" "Bash(claude mcp list:*)" "Bash(npm install:*)" "Bash(python3 -m venv:*)" "Bash(bash -n:*)" \
  --disallowedTools "Edit(/$KIT_ROOT/scripts/autosave.sh)" "Edit(/$KIT_ROOT/scripts/filter*)" "Edit(/$KIT_ROOT/CLAUDE.md)" \
  2>>"$log")"
{ echo "=== $(date '+%F %T') $date $n"; echo "$output"; } >> "$log"

# Expected last line: STATUS: INSTALLED|STAGED|NEEDS_YOU|FAILED — short explanation.
line="$(grep -E '^STATUS: ' <<< "$output" | tail -1)"
code="$(sed -E 's/^STATUS: ([A-Z_]+).*/\1/' <<< "$line")"
case "$code" in
  INSTALLED) decision=installed ;;
  STAGED) decision="staged, connected at next session" ;;
  NEEDS_YOU) decision="needs the user" ;;
  *) decision=failed; [ -z "$line" ] && line="STATUS: FAILED — see $log" ;;
esac
echo "- $date — $title — $decision" >> memory/radar/decisions.md
git add -A -- scripts 2>/dev/null
git diff --cached --quiet || git commit -q -m "Radar: install « $title » ($date, n°$n)"
echo '{}' | scripts/autosave.sh
"$KIT_ROOT/scripts/notify.sh" "Radar install" "$title: $decision"
echo "$line"
