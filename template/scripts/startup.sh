#!/bin/bash
# SessionStart hook: prints today's date, memory/INDEX.md, the top of memory/preferences.md and pointers
# (latest journal, last night's audit and radar). Claude reads this before the first reply.
# Hook output above ~10,000 characters is moved to a file and only 2 KB is shown, so we stay under 9,000.
. "$(dirname "$0")/kit.sh"
mem="$KIT_ROOT/memory"
out() {
  echo "Today: $(date +%F)"
  if [ ! -f "$mem/INDEX.md" ]; then echo "memory/INDEX.md is missing: tell the user the kit looks incomplete."; return; fi
  # Filing rules (end of INDEX.md) are read on demand, not at every start.
  sed '/^## Filing rules/,$d' "$mem/INDEX.md"
  echo "(Filing rules: end of memory/INDEX.md, read them before creating or reorganising a note.)"
  if [ -f "$mem/preferences.md" ]; then
    echo; echo "User preferences (apply from the first reply):"
    sed '/^## Details/,$d' "$mem/preferences.md"
    grep -q '^## Details' "$mem/preferences.md" && echo "(More in memory/preferences.md under « Details »: grep it before writing an email, a post or a deliverable.)"
  fi
  last=$(ls "$mem"/journal/*.md 2>/dev/null | sort | tail -1)
  [ -n "$last" ] && echo "Latest journal: memory/journal/$(basename "$last") (read it only if the request resumes recent work)."
  audit=$(ls "$mem"/audit/*.md 2>/dev/null | sort | tail -1)
  [ -n "$audit" ] && { echo "Last audit (memory/audit/$(basename "$audit")):"; sed -n 2p "$audit"; }
  radar="$mem/radar/$(date +%F).md"
  [ -f "$radar" ] && { echo "Today's radar (memory/radar/$(basename "$radar")):"; sed -n 2p "$radar"; }
  # Night jobs cannot write .claude/ (Claude Code protects it): they stage files here for the next interactive session.
  for d in "$KIT_ROOT"/staged/*/; do
    [ -d "$d" ] && echo "TO DO FIRST: tools are staged in staged/$(basename "$d")/ — read its README.md, ask the user to confirm, copy each file to its path, test, then delete the folder."
  done
}
text=$(out)
echo "$text"
if [ "$(printf %s "$text" | wc -m)" -gt 9000 ]; then
  echo "WARNING: startup output is over 9,000 characters (hard limit ~10,000). Condense the top of memory/preferences.md or INDEX.md now, without losing substance, and tell the user in one line."
fi
exit 0
