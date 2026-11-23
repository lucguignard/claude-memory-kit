#!/bin/bash
# shellcheck disable=SC2034  # variables here are read by the scripts that source this file
# Shared settings, sourced by every script. Edit kit.conf (repo root), not this file.
KIT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export PATH="$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:$PATH"
NTFY_TOPIC=""        # phone alerts via https://ntfy.sh (optional, pick a long random topic)
NIGHT_MODEL="sonnet" # model for the night jobs (audit, radar, installs)
[ -f "$KIT_ROOT/kit.conf" ] && . "$KIT_ROOT/kit.conf"
[ -n "$KIT_TZ" ] && export TZ="$KIT_TZ"
# Long-lived token for unattended runs (`claude setup-token`), kept outside the repo.
[ -f "$HOME/.config/claude-memory-kit/token.env" ] && . "$HOME/.config/claude-memory-kit/token.env"
# Portable helpers (Linux and macOS).
day_ago() { date -d "-$1 day" +%F 2>/dev/null || date -v-"$1"d +%F; }
with_timeout() { local s="$1"; shift
  if command -v timeout >/dev/null; then timeout "$s" "$@"; elif command -v gtimeout >/dev/null; then gtimeout "$s" "$@"; else "$@"; fi; }
