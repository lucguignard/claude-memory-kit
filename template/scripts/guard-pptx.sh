#!/bin/bash
# PostToolUse hook (Edit|Write|Bash): after a .pptx is created or changed, runs scripts/pptx-check.py
# and sends the warnings back to Claude (exit 2 + stderr). Silent in every other case.
. "$(dirname "$0")/kit.sh"
in=$(cat)
tool=$(jq -r '.tool_name // empty' <<<"$in" 2>/dev/null)
files=()
case "$tool" in
  Edit|Write)
    f=$(jq -r '.tool_input.file_path // empty' <<<"$in")
    [[ "$f" == *.pptx ]] && files+=("$f") ;;
  Bash)
    cmd=$(jq -r '.tool_input.command // empty' <<<"$in")
    [[ "$cmd" == *pptx* ]] || exit 0
    [[ "$cmd" == *pptx-check* ]] && exit 0
    cwd=$(jq -r '.cwd // empty' <<<"$in")
    while IFS= read -r f; do files+=("$f"); done < <(find "${cwd:-$KIT_ROOT}" "$KIT_ROOT" /tmp -maxdepth 6 -name '*.pptx' -mmin -2 -not -path '*/node_modules/*' -not -name '~$*' 2>/dev/null | sort -u | head -3) ;;
esac
[ ${#files[@]} -gt 0 ] || exit 0
command -v python3 >/dev/null || exit 0
out=""
for f in "${files[@]}"; do
  [ -f "$f" ] || continue
  r=$(python3 "$KIT_ROOT/scripts/pptx-check.py" "$f" 2>&1) || true
  case "$r" in OK:*|"") ;; *) out+="$(basename "$f"):"$'\n'"$r"$'\n' ;; esac
done
[ -n "$out" ] || exit 0
echo "Automatic pptx check — warnings to fix before answering the user:"$'\n'"$out" >&2
exit 2
