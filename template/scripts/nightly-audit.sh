#!/bin/bash
# Nightly audit (cron, e.g. 05:00): re-reads the conversations of the last working day (user requests,
# Claude's replies, tool errors), writes the missing rules and facts into memory/, and lists tooling needs
# that self-tooling.sh (right after) and the radar (06:00) will address. Manual run: scripts/nightly-audit.sh [YYYY-MM-DD]
. "$(dirname "$0")/kit.sh"
cd "$KIT_ROOT" || exit 1
mkdir -p memory/audit
work="$(mktemp -d)"; trap 'rm -rf "$work"' EXIT
material="$work/conversations.md"

# One session, condensed: user messages in full, Claude's replies and tool calls shortened, tool errors.
condense() {
  jq -r --arg d "$2" '
    select(.timestamp != null)
    | select((.timestamp | sub("\\.[0-9]+Z$"; "Z") | fromdateiso8601? | strflocaltime("%F")) == $d)
    | if .type == "user" and (.message.content | type) == "string" then
        (.message.content | select(startswith("<") | not) | "\n**User**: " + (.[0:1500] | gsub("\n"; " ")))
      elif .type == "user" then
        (.message.content[]? | select(.type == "tool_result" and .is_error == true)
         | "  [TOOL ERROR] " + ((.content | tostring)[0:300] | gsub("\n"; " ")))
      elif .type == "assistant" then
        (.message.content[]?
         | if .type == "text" then "**Claude**: " + (.text[0:900] | gsub("\n"; " "))
           elif .type == "tool_use" then "  [" + .name + "] " + ((.input.description // .input.file_path // .input.command // .input.query // "") | tostring | .[0:150] | gsub("\n"; " "))
           else empty end)
      else empty end' "$1" 2>/dev/null
}

# Last working day within 7 days (or the date given as argument).
if [ -n "$1" ]; then days="$1"; else days="$(for n in 1 2 3 4 5 6 7; do date -d "-$n day" +%F; done)"; fi
for day in $days; do
  : > "$material"
  for f in memory/journal/"$day"*.md; do
    [ -f "$f" ] && { echo "## Journal $f"; cat "$f"; echo; } >> "$material"
  done
  find "$HOME/.claude/projects" -name '*.jsonl' -newermt "$day" 2>/dev/null | while read -r t; do
    # Skip the kit's own unattended runs.
    jq -r 'select(.type == "user" and (.message.content | type) == "string") | .message.content' "$t" 2>/dev/null \
      | head -1 | grep -qE "^(KIT-AUDIT|KIT-RADAR|KIT-INSTALL|KIT-TOOLING)" && continue
    text="$(condense "$t" "$day")"
    [ -n "$text" ] && { echo "## Session $(basename "$t" .jsonl)"; echo "$text"; echo; } >> "$material"
  done
  grep -q "^## Session" "$material" && break
done
grep -q "^## Session" "$material" || { echo "Audit: no conversation in the last 7 days."; exit 0; }
# AUDIT_DRY_RUN=1: show the material without calling Claude.
[ -n "$AUDIT_DRY_RUN" ] && { echo "Day: $day"; wc -c "$material"; cat "$material"; exit 0; }

prompt="$(cat "$KIT_ROOT/scripts/audit-prompt.md")

Today: $(date +%F). Day audited: $day.
Conversations to audit (read-only, outside the repo): $material"

claude -p "$prompt" --model "$NIGHT_MODEL" --strict-mcp-config --add-dir "$work" \
  --allowedTools Read Glob Grep "Edit(/$KIT_ROOT/memory/**)" "Write(/$KIT_ROOT/memory/**)"
code=$?
[ "$code" -ne 0 ] && "$KIT_ROOT/scripts/notify.sh" "Audit failed" "The nightly audit failed (exit $code)."

# Safety net if the Stop hook did not commit (the filter applies).
echo '{}' | "$KIT_ROOT/scripts/autosave.sh"

# Then Claude installs the tools the audit asked for (only for today's audit).
{ [ -z "$1" ] || [ "$1" = "$(date +%F)" ]; } && "$KIT_ROOT/scripts/self-tooling.sh"
exit 0
