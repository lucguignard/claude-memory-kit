#!/bin/bash
# Context for the /resume skill: end of the latest journal, progress of the matching workstream, git status.
# Usage: scripts/resume.sh [topic words]
. "$(dirname "$0")/kit.sh"
mem="$KIT_ROOT/memory"
last=$(ls "$mem"/journal/*.md 2>/dev/null | sort | tail -1)
if [ -n "$last" ]; then
  echo "### Latest journal ($(basename "$last"))"; tail -n 20 "$last"
fi
if [ $# -gt 0 ]; then
  for word in "$@"; do
    for d in "$mem"/workstreams/*/; do
      [ -d "$d" ] || continue
      case "$(basename "$d")" in *"$word"*)
        echo; echo "### Workstream $(basename "$d"): progress"; tail -n 25 "$d/progress.md" 2>/dev/null ;;
      esac
    done
  done | awk '!seen[$0]++ || /^$/'
fi
echo; echo "### Git status"; git -C "$KIT_ROOT" status --short | head -10; git -C "$KIT_ROOT" log --oneline -3
exit 0
