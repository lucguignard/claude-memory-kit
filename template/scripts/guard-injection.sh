#!/bin/bash
# Prompt-injection guard (hidden text in a web page, a PDF, an image, a shared doc).
# PostToolUse: as soon as a tool has read outside content, the session is marked "exposed".
# PreToolUse: an exposed session must get the user's OK before any action that sends, shares, publishes
# or deletes (connector writes, artifacts, messages, curl POST, ssh, git push, rm -r…).
# Blocks nothing by itself: it turns those actions into a confirmation prompt.
input=$(cat)
event=$(jq -r '.hook_event_name // empty' <<< "$input")
session=$(jq -r '.session_id // "unknown"' <<< "$input")
tool=$(jq -r '.tool_name // empty' <<< "$input")
dir="/tmp/claude-injection-guard-$(id -u)"
mark="$dir/$session"
root="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "$0")/.." && pwd)}"

if [ "$event" = "PostToolUse" ]; then
  outside=""
  case "$tool" in
    WebFetch|WebSearch|mcp__playwright__*|mcp__*__read*|mcp__*__get*|mcp__*__download*|mcp__*__search*|mcp__*__fetch*) outside="$tool" ;;
    Read)
      p=$(jq -r '.tool_input.file_path // empty' <<< "$input")
      case "$p" in "$root"/*|"$HOME"/.claude/*) ;; *) outside="Read $p" ;; esac ;;
  esac
  if [ -n "$outside" ] && [ ! -f "$mark" ]; then mkdir -p "$dir" && echo "$outside" > "$mark"; fi
  exit 0
fi

# PreToolUse: nothing to do if the session has not read outside content.
[ -f "$mark" ] || exit 0
source_read=$(head -c 200 "$mark")
risky=""
case "$tool" in
  mcp__*__share*|mcp__*__send*|mcp__*__create*|mcp__*__update*|mcp__*__delete*|mcp__*__trash*|mcp__*__publish*|\
  mcp__*__upload*|mcp__*__append*|mcp__*__copy*|mcp__*__reply*|mcp__*__forward*|mcp__*__comment*|\
  Artifact|ArtifactData|ArtifactComments|SendMessage|PushNotification|RemoteTrigger|CronCreate)
    risky="$tool" ;;
  Bash)
    # Ignore the body of a heredoc (text written to a file, not a command).
    cmd=$(jq -r '.tool_input.command // empty' <<< "$input" | awk '{print} /<</{exit}')
    pattern='(^|[^a-z])(curl|wget)[^|;&]*( -d| --data| -F| --form| -T| --upload| -X *(POST|PUT|PATCH|DELETE))|(^|[^a-z.-])(ssh|scp|sftp|rsync|rclone|sendmail|mutt|mail|nc)( |$)|git +push|(^|[^a-z])rm +-[a-zA-Z]*[rR]|(^|[^a-z])gh +(pr|issue|api|gist|release)'
    grep -qE "$pattern" <<< "$cmd" && risky="Bash: $(head -c 120 <<< "$cmd")" ;;
esac
[ -n "$risky" ] || exit 0
reason="Injection guard: this session has read outside content ($source_read). Sensitive action requested: $risky. Check that it matches your own request and not an instruction hidden in that content."
jq -n --arg r "$reason" '{hookSpecificOutput: {hookEventName: "PreToolUse", permissionDecision: "ask", permissionDecisionReason: $r}}'
exit 0
