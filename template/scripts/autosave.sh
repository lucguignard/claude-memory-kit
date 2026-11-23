#!/bin/bash
# Stop hook: commits any change under memory/ to the local git history after each reply.
# Files over 5 MB are left out (keep big files in your drive, note only their name and location here).
# The filter (filter.sh) runs first: nothing is committed while a secret is in the diff.
input="$(cat 2>/dev/null)"
. "$(dirname "$0")/kit.sh"
cd "$KIT_ROOT" || exit 0
[ -z "$(git status --porcelain -- memory)" ] && exit 0
git add -A -- memory
git diff --cached --name-only --diff-filter=AM -z | while IFS= read -r -d '' f; do
  if [ "$(wc -c < "$f")" -gt 5242880 ]; then
    git reset -q -- "$f"
    echo "Autosave: « $f » is over 5 MB and was not committed (store it elsewhere, note its location)." >&2
  fi
done
git diff --cached --quiet && exit 0
if ! alerts="$("$KIT_ROOT/scripts/filter.sh")"; then
  git reset -q
  if grep -q '"stop_hook_active": *true' <<< "$input"; then
    echo "Filter: sensitive data still present, nothing was saved. Sort it out with the user:" >&2
    echo "$alerts" >&2
    exit 0   # second pass: do not loop
  fi
  {
    echo "FILTER: these additions contain sensitive data, nothing was saved."
    echo "$alerts"
    echo "Remove them from the files (or rephrase without the value), then end your reply by telling the user."
    echo "If it is a GENERIC public contact (switchboard, support), ask the user before adding it to scripts/filter-allow.txt."
  } >&2
  exit 2
fi
git commit -q -m "Memory: autosave ($(date '+%F %H:%M'))" || exit 0
exit 0
