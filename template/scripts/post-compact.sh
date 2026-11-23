#!/bin/bash
# SessionStart hook (source: compact): points to the workstream touched in the last 2 days, if any.
root="$(cd "$(dirname "$0")/.." && pwd)"
last=""
for d in "$root"/memory/workstreams/*/; do
  d="${d%/}"; [ -d "$d" ] && [ "${d##*/}" != "_done" ] || continue
  [ -z "$last" ] || [ "$d" -nt "$last" ] && last="$d"
done
[ -n "$last" ] && [ -n "$(find "$last" -maxdepth 0 -mtime -2)" ] || exit 0
echo "After compaction: recent workstream ${last#$root/}/ (read plan.md / findings.md if needed)."
[ -f "$last/plan.md" ] && { echo "Still to do:"; grep -m 8 -- '- \[ \]' "$last/plan.md"; }
[ -f "$last/progress.md" ] && { echo "Latest progress:"; tail -n 3 "$last/progress.md" | cut -c1-300; }
exit 0
