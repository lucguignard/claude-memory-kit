#!/bin/bash
# Public link in one command: serves a folder (or an already open port) through a temporary Cloudflare tunnel
# (trycloudflare.com, no account) and sends the address to the phone via ntfy if NTFY_TOPIC is set in kit.conf.
# Usage: scripts/public-link.sh <folder|port>   (Ctrl+C to stop everything; the address changes on every run)
# Needs cloudflared in PATH (or CLOUDFLARED=/path/to/cloudflared). Anyone with the link can read what is served.
. "$(dirname "$0")/kit.sh"
target="$1"
[ -n "$target" ] || { echo "Usage: $0 <folder|port>"; exit 1; }
cf="${CLOUDFLARED:-$(command -v cloudflared)}"
[ -x "$cf" ] || { echo "cloudflared not found (install it or set CLOUDFLARED)"; exit 1; }
tmp=$(mktemp -d); pids=()
trap 'kill "${pids[@]}" 2>/dev/null; rm -rf "$tmp"' EXIT
if [[ "$target" =~ ^[0-9]+$ ]]; then port="$target"
else
  [ -d "$target" ] || { echo "Folder not found: $target"; exit 1; }
  port=$((20000 + RANDOM % 10000))
  python3 -m http.server "$port" --bind 127.0.0.1 --directory "$target" > "$tmp/server.log" 2>&1 & pids+=($!)
  sleep 1
fi
"$cf" tunnel --no-autoupdate --url "http://127.0.0.1:$port" > "$tmp/tunnel.log" 2>&1 & pids+=($!)
url=""
for _ in $(seq 1 24); do
  url=$(grep -o 'https://[a-z0-9-]*\.trycloudflare\.com' "$tmp/tunnel.log" | tail -1)
  [ -n "$url" ] && break; sleep 2
done
[ -n "$url" ] || { echo "No address obtained"; exit 1; }
[ -n "$NTFY_TOPIC" ] && curl -fsS -m 20 -H "Title: Public link ready" -H "Click: $url" -d "$url" "https://ntfy.sh/$NTFY_TOPIC" > /dev/null 2>&1
echo "$url"
wait "${pids[${#pids[@]}-1]}"
