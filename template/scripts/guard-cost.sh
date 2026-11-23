#!/bin/bash
# UserPromptSubmit hook: resuming a long conversation after more than an hour means the prompt cache has
# expired and the whole context is billed again. Silent otherwise.
path=$(jq -r '.transcript_path // ""' 2>/dev/null)
[ -f "$path" ] || exit 0
last=$(tail -n 200 "$path" | jq -c 'select(.message.usage? and .message.model != "<synthetic>") | [.timestamp, .message.usage.input_tokens + (.message.usage.cache_creation_input_tokens // 0) + (.message.usage.cache_read_input_tokens // 0)]' 2>/dev/null | tail -1)
[ -z "$last" ] && exit 0
when=$(jq -r '.[0]' <<< "$last"); size=$(jq -r '.[1]' <<< "$last")
pause=$(( ($(date +%s) - $(date -d "$when" +%s 2>/dev/null || echo 0)) / 60 ))
if [ "$pause" -ge 60 ] && [ "$size" -ge 100000 ]; then
  echo "Resuming after $pause min a conversation of $size tokens: this message is expensive (cache expired). Say so in one line at the top of your reply and suggest starting a new conversation from the workstream notes, unless the current task is nearly done."
fi
exit 0
