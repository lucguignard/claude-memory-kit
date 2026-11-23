#!/bin/bash
# Installs the kit into a folder that becomes Claude's working directory: ./install.sh <target-folder>
# Never overwrites an existing file. Needs: bash, git, jq, Claude Code (`claude`).
set -e
src="$(cd "$(dirname "$0")/template" && pwd)"
target="${1:?Usage: ./install.sh <target-folder>}"
for cmd in git jq; do command -v "$cmd" >/dev/null || { echo "Missing dependency: $cmd"; exit 1; }; done
command -v claude >/dev/null || echo "Note: Claude Code (claude) not found in PATH; install it before using the kit."
mkdir -p "$target"; target="$(cd "$target" && pwd)"

# Copy without overwriting (cp -n is not portable everywhere: do it file by file).
( cd "$src" && find . -type f ) | while read -r f; do
  if [ -e "$target/$f" ]; then echo "Kept existing: ${f#./}"
  else mkdir -p "$target/$(dirname "$f")"; cp "$src/$f" "$target/$f"; fi
done
chmod +x "$target"/scripts/*.sh

cd "$target"
[ -d .git ] || git init -q
# The autosave hook commits on its own: give this repo an identity if git has none.
git config user.email >/dev/null || { git config user.name "claude-memory-kit"; git config user.email "kit@localhost"; }
[ -f .gitignore ] || printf 'staged/\n.DS_Store\n' > .gitignore
git add -A -- memory CLAUDE.md .claude scripts kit.conf .gitignore 2>/dev/null || true
git diff --cached --quiet || git commit -q -m "Install claude-memory-kit"

cat <<MSG

Installed in $target

Next steps:
  1. cd "$target" && claude      (the startup hook loads memory/INDEX.md and preferences.md)
     Claude Code asks you to trust the folder's hooks the first time: review .claude/settings.json, then accept.
  2. Fill in memory/profile.md and the top of memory/preferences.md (or ask Claude to interview you).
  3. Optional: edit kit.conf (time zone, ntfy topic for phone alerts, night model).
  4. Optional night jobs: run \`claude setup-token\`, save the token as
       export CLAUDE_CODE_OAUTH_TOKEN=...   in ~/.config/claude-memory-kit/token.env  (chmod 600)
     then add to \`crontab -e\`:
       0 5 * * * "$target/scripts/nightly-audit.sh" >> "\$HOME/.cache/claude-memory-kit-audit.log" 2>&1
       0 6 * * * "$target/scripts/radar.sh" >> "\$HOME/.cache/claude-memory-kit-radar.log" 2>&1
MSG
