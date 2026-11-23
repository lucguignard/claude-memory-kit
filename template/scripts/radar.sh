#!/bin/bash
# Daily radar (cron, e.g. 06:00): finds skills, plugins, MCP servers, settings and techniques that would have
# helped with what the user actually did on their last working day (journal + requests typed in Claude sessions),
# with the nightly audit's "Tooling needs" first. Writes memory/radar/YYYY-MM-DD.md and .json. Proposes only.
. "$(dirname "$0")/kit.sh"
cd "$KIT_ROOT" || exit 1
mkdir -p memory/radar
work="$(mktemp -d)"; trap 'rm -rf "$work"' EXIT
material="$work/last-working-day.md"

for n in 1 2 3 4 5 6 7; do
  day="$(date -d "-$n day" +%F)"
  : > "$material"
  for f in memory/journal/"$day"*.md; do
    [ -f "$f" ] && { echo "## Journal $f"; cat "$f"; echo; } >> "$material"
  done
  # Requests typed by the user that day (not tool output, not the kit's own runs).
  find "$HOME/.claude/projects" -name '*.jsonl' -newermt "$day" 2>/dev/null | while read -r t; do
    asks="$(jq -r --arg d "$day" '
      select(.type == "user" and (.message.content | type) == "string")
      | select((.timestamp // "" | sub("\\.[0-9]+Z$"; "Z") | fromdateiso8601? | strflocaltime("%F")) == $d)
      | .message.content
      | select(startswith("<") | not)
      | select(test("^KIT-(AUDIT|RADAR|INSTALL|TOOLING)") | not)
      | select(startswith("This session is being continued") | not)
      | "- " + (.[0:600] | gsub("\n"; " "))' "$t" 2>/dev/null)"
    [ -n "$asks" ] && { echo "## Session $(basename "$t" .jsonl)"; echo "$asks"; echo; } >> "$material"
  done
  [ -s "$material" ] && break
done
[ -s "$material" ] || echo "(No activity found in the last 7 days.)" > "$material"
for a in memory/audit/"$(date +%F)"*.md; do
  [ -f "$a" ] && { echo "## Last night's audit ($a)"; cat "$a"; echo; } >> "$material"
done

prompt="$(cat "$KIT_ROOT/scripts/radar-prompt.md")

Today: $(date +%F). Working day analysed: $day.
Material (read-only, outside the repo): $material"

claude -p "$prompt" --model "$NIGHT_MODEL" --strict-mcp-config --add-dir "$work" \
  --allowedTools Read Glob Grep WebSearch WebFetch \
  "Edit(/$KIT_ROOT/memory/radar/**)" "Write(/$KIT_ROOT/memory/radar/**)"
code=$?
if [ "$code" -ne 0 ] || [ ! -f "memory/radar/$(date +%F).md" ]; then
  "$KIT_ROOT/scripts/notify.sh" "Radar failed" "The morning radar did not write today's note (exit $code)."
fi
echo '{}' | "$KIT_ROOT/scripts/autosave.sh"
exit 0
