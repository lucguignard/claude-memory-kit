#!/bin/bash
# Runs a long command detached from the session (it survives the end of the session), log + PID in ~/.cache/claude-detach/.
# Usage: scripts/detach.sh <name> <command…>   |   scripts/detach.sh --status   |   scripts/detach.sh --stop <name>
d="$HOME/.cache/claude-detach"; mkdir -p "$d"
case "$1" in
  --status) for p in "$d"/*.pid; do [ -e "$p" ] || { echo "Nothing running."; exit 0; }
              n=$(basename "$p" .pid); if kill -0 "$(cat "$p")" 2>/dev/null; then echo "$n: running (PID $(cat "$p")), log $d/$n.log"; else echo "$n: finished, log $d/$n.log"; fi; done; exit 0;;
  --stop) [ -f "$d/$2.pid" ] || { echo "Unknown: $2"; exit 1; }; kill -- "-$(cat "$d/$2.pid")" 2>/dev/null || kill "$(cat "$d/$2.pid")" 2>/dev/null; echo "Stopped: $2"; exit 0;;
esac
name="$1"; shift
[[ "$name" =~ ^[A-Za-z0-9_-]+$ ]] && [ $# -gt 0 ] || { echo "Usage: $0 <name> <command…> | --status | --stop <name>"; exit 1; }
if [ -f "$d/$name.pid" ] && kill -0 "$(cat "$d/$name.pid")" 2>/dev/null; then echo "Already running: $name"; exit 1; fi
setsid nohup "$@" >"$d/$name.log" 2>&1 </dev/null &
echo $! >"$d/$name.pid"
echo "Started: $name (PID $!), log $d/$name.log"
