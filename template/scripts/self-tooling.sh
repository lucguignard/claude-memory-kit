#!/bin/bash
# Self-tooling (run by nightly-audit.sh right after the audit): Claude builds what answers the audit's
# "Tooling needs", then everything is checked; if a check fails, everything is rolled back.
# Files under .claude/ cannot be written by an unattended session: they are staged in staged/<date>/
# and connected by the next interactive session (startup.sh reminds it). Manual run: scripts/self-tooling.sh [YYYY-MM-DD]
. "$(dirname "$0")/kit.sh"
cd "$KIT_ROOT" || exit 1
day="${1:-$(date +%F)}"
report="memory/audit/$day.md"
[ -f "$report" ] || { echo "Self-tooling: no audit report $report."; exit 0; }
grep -A50 "^## Tooling needs" "$report" | sed '1d;/^## /,$d' | grep -q '^- ' || { echo "Self-tooling: no tooling need."; exit 0; }

# Restore point: current commit.
before="$(git rev-parse HEAD 2>/dev/null)"
log="$HOME/.cache/claude-memory-kit-tooling.log"; mkdir -p "$(dirname "$log")"

prompt="$(cat scripts/self-tooling-prompt.md)

Today: $day. Audit report: \`$report\`. Staging folder: \`staged/$day/\`."

claude -p "$prompt" --model "$NIGHT_MODEL" --strict-mcp-config \
  --allowedTools Read Glob Grep WebFetch WebSearch \
  "Edit(/$KIT_ROOT/scripts/**)" "Write(/$KIT_ROOT/scripts/**)" "Edit(/$KIT_ROOT/staged/**)" "Write(/$KIT_ROOT/staged/**)" \
  "Edit(/$KIT_ROOT/memory/audit/**)" "Edit(/$KIT_ROOT/memory/radar/**)" "Write(/$KIT_ROOT/memory/radar/**)" \
  "Bash(git clone:*)" "Bash(mkdir:*)" "Bash(cp:*)" "Bash(chmod +x:*)" "Bash(ls:*)" "Bash(jq:*)" "Bash(bash -n:*)" \
  --disallowedTools "Edit(/$KIT_ROOT/scripts/autosave.sh)" "Edit(/$KIT_ROOT/scripts/filter*)" \
  "Edit(/$KIT_ROOT/scripts/self-tooling*)" "Edit(/$KIT_ROOT/CLAUDE.md)" \
  >> "$log" 2>&1

# Checks: scripts valid, staged JSON readable, startup hook runs, a Claude session still answers.
error=""
for f in scripts/*.sh; do bash -n "$f" 2>/dev/null || error="$error invalid script ($f);"; done
for f in $(find "staged/$day" -name '*.json' 2>/dev/null); do
  jq empty "$f" 2>/dev/null || error="$error unreadable staged settings ($f);"
done
bash scripts/startup.sh > /dev/null 2>&1 || error="$error startup hook fails;"
answer="$(timeout 180 claude -p "Answer only: OK" --model haiku 2>&1)"
grep -q "OK" <<< "$answer" || error="$error a Claude session no longer starts;"

if [ -n "$error" ]; then
  [ -n "$before" ] && git checkout "$before" -- scripts 2>/dev/null
  git clean -fdq -- scripts
  rm -rf "staged/$day"
  printf '\n## Tooling rolled back\n- Check failed:%s everything was restored. Details: `%s`.\n' "$error" "$log" >> "$report"
  echo "=== $(date '+%F %T') ROLLED BACK:$error" >> "$log"
  "$KIT_ROOT/scripts/notify.sh" "Self-tooling rolled back" "Tonight's tooling failed its checks and was undone."
fi

git add -A -- scripts 2>/dev/null
git diff --cached --quiet || git commit -q -m "Self-tooling after the audit of $day"
echo '{}' | scripts/autosave.sh
exit 0
