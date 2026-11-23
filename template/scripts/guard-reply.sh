#!/bin/bash
# Stop hook: re-reads the end of the reply before it is sent and nudges, once per reply, on two habits:
# 1. "do instead of offering": a reply ending with "do you want me to…?" for a safe, reversible action;
# 2. unverified deliverable: "please check on your side", "I could not verify the result".
# Silent otherwise. Never blocks twice in a row (stop_hook_active). English and French patterns.
input=$(cat)
[ "$(jq -r '.stop_hook_active // false' <<< "$input" 2>/dev/null)" = "true" ] && exit 0
end=$(jq -r '.last_assistant_message // ""' <<< "$input" 2>/dev/null | tail -c 400)
[ -z "$end" ] && exit 0
# Silent when the user's last message was a mere acknowledgement ("ok", "thanks"): no task in progress.
path=$(jq -r '.transcript_path // ""' <<< "$input" 2>/dev/null)
if [ -n "$path" ] && [ -r "$path" ]; then
  last=$(tail -n 200 "$path" | jq -rs '[.[] | select(.type=="user" and (.isSidechain|not)) | .message.content | if type=="string" then . else ([.[]? | select(.type=="text") | .text] | join(" ")) end | select(length>0)] | last // ""' 2>/dev/null)
  if [ -n "$last" ] && [ "${#last}" -le 40 ] && grep -qiE "^[[:space:]]*(ok|okay|thanks|thank you|great|perfect|cool|nice|yes|merci|parfait|super|oui|top|d'accord)[[:space:]!.,a-z]*$" <<< "$last"; then
    exit 0
  fi
fi
reason=""
if grep -qiE "(do you want me to|would you like me to|shall I|should I|want me to|tu veux|veux-tu|souhaites-tu)[^?]{0,150}\?[^?]*$" <<< "$end"; then
  reason="Your reply ends with an offer (« do you want me to…? »). If the action is safe and reversible (copy, tidy your own output, update a note), do it now and say so. Otherwise keep the question."
elif grep -qiE "check (it )?on your side|please verify|I (could not|couldn't|did not|didn't) (verify|check|test)|à vérifier de ton côté" <<< "$end"; then
  reason="You are handing verification back to the user. Check the result yourself (run it, screenshot it, re-read it) before saying it is ready. If that is impossible, say so plainly."
fi
[ -z "$reason" ] && exit 0
jq -n --arg r "$reason" '{decision: "block", reason: $r}'
exit 0
