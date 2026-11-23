#!/bin/bash
# PreCompact hook: stdout becomes extra instructions for the compaction summary. Fixed text, no cost.
cat <<'EOF'
Instructions for the summary:
- Write it in the user's language.
- Keep the current workstream or task (folder name in memory/workstreams/ if any) and where we are.
- List the user's decisions and the corrections they made to tone or method.
- List files created or modified (full paths) and what remains to do.
- Keep verified figures and dates with their source; add nothing invented.
- Include no password, key or personal contact detail.
EOF
exit 0
