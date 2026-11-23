#!/bin/bash
# Phone alerts through ntfy.sh (optional: set NTFY_TOPIC in kit.conf). Never blocking, always exit 0.
#   notify.sh "Title" "Message"   : used by the night jobs when they fail
#   as a Notification hook (JSON on stdin): "Claude is waiting for you" — generic text, no conversation content
. "$(dirname "$0")/kit.sh"
[ -n "$NTFY_TOPIC" ] || exit 0
if [ $# -eq 0 ]; then
  case "$(jq -r '.notification_type // empty' 2>/dev/null)" in
    permission_prompt) set -- "Claude is waiting" "Claude needs your permission to continue." ;;
    idle_prompt) set -- "Claude is waiting" "Claude has finished and is waiting for your reply." ;;
    *) exit 0 ;;
  esac
fi
curl -fsS -m 10 -H "Title: $1" -d "$2" "https://ntfy.sh/$NTFY_TOPIC" > /dev/null 2>&1
exit 0
