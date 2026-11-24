#!/bin/bash
# SessionStart hook: reminds Claude of the ssh aliases in ~/.ssh/config (stdout is added to the context),
# so it tries `ssh <alias>` before saying it has no access. Reads host names only, never keys or addresses.
f="$HOME/.ssh/config"
[ -r "$f" ] || exit 0
names=$(awk 'tolower($1)=="host"{for(i=2;i<=NF;i++) if($i !~ /[*?!]/) printf "%s ", $i}' "$f")
[ -n "$names" ] || exit 0
echo "Machines reachable over ssh (aliases in ~/.ssh/config): ${names}— try « ssh <alias> » before saying you have no access."
exit 0
