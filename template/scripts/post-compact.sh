#!/bin/bash
# SessionStart hook (source: compact): points to the workstream touched in the last 2 days, if any.
root="$(cd "$(dirname "$0")/.." && pwd)"
last=$(find "$root/memory/workstreams" -mindepth 1 -maxdepth 1 -type d ! -name '_done' -mtime -2 -printf '%T@ %p\n' 2>/dev/null | sort -rn | head -1 | cut -d' ' -f2-)
[ -z "$last" ] && exit 0
echo "After compaction: recent workstream ${last#$root/}/ (read plan.md / findings.md if needed)."
[ -f "$last/plan.md" ] && { echo "Still to do:"; grep -m 8 -- '- \[ \]' "$last/plan.md"; }
[ -f "$last/progress.md" ] && { echo "Latest progress:"; tail -n 3 "$last/progress.md" | cut -c1-300; }
exit 0
