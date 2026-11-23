#!/bin/bash
# UserPromptSubmit hook: spots a secret pasted into a user message. Silent otherwise.
# Never prints the value, only its type, so nothing is repeated in the transcript.
msg=$(jq -r '.prompt // ""' 2>/dev/null)
[ -z "$msg" ] && exit 0
type=""
if grep -qE 'tskey-[A-Za-z0-9_-]{10,}|sk-ant-[A-Za-z0-9_-]{10,}|sk-[A-Za-z0-9]{20,}|gh[pousr]_[A-Za-z0-9]{30,}|github_pat_[A-Za-z0-9_]{30,}|AKIA[0-9A-Z]{16}|AIza[0-9A-Za-z_-]{30,}|xox[abprs]-[A-Za-z0-9-]{10,}' <<< "$msg"; then
  type="an API key"
elif grep -qE '(^|[^A-Za-z])[a-z]{4} [a-z]{4} [a-z]{4} [a-z]{4}([^A-Za-z]|$)' <<< "$msg" && grep -qiE 'password|app pass|mot de passe|mdp' <<< "$msg"; then
  type="an app password"
elif grep -qiE '(password|passwd|mot de passe|mdp)[^[:alnum:]]{0,3}(is|est|:|=|->)[[:space:]]*[^[:space:]]{6,}' <<< "$msg"; then
  type="a password"
fi
[ -z "$type" ] && exit 0
echo "The user's message seems to contain $type in clear text. Say so in one line at the top of your reply: rotate it after use (it stays in the session history). Never repeat the value, never write it to any file or journal."
exit 0
