#!/usr/bin/env bash
# Time from exec until the screen carries readable content.
#
# Three things make this different from timing the first byte, and all three
# were learned by getting them wrong first:
#
#   1. Measure inside tmux with a client attached. On a bare pty, tools that
#      query the terminal at startup wait for an answer that never comes;
#      specgetty measured 5048 ms that way and 65 ms here. A detached tmux
#      session is not enough either, because nothing answers there.
#   2. Invoke each tool the way it actually works. Run bare in a project
#      directory, specgetty reports "No OpenSpec projects found" quickly, which
#      scores an error screen as a fast start.
#   3. Wait for content, not for output. The first byte a full-screen program
#      writes is its alternate-screen sequence.
#
# Usage: time-to-usable.sh <label> <runs> -- <command> [args...]
set -uo pipefail

label="${1:?usage: time-to-usable.sh <label> <runs> -- <command> [args...]}"
runs="${2:?}"
shift 2
[ "${1:-}" = "--" ] && shift

: "${OST_PROJECT:?set OST_PROJECT to the directory the tool should start in}"
THRESHOLD="${OST_THRESHOLD:-200}"

measure() {
  local session="ttu-$$-$RANDOM" start found n
  tmux -f /dev/null new-session -d -s "$session" -x 110 -y 34 -c "$OST_PROJECT" "$@" 2>/dev/null || return 1

  # A client attached through a pty, so tmux has a front end that answers
  # terminal queries the way a real one would.
  python3 - "$session" <<'PY' &
import os, pty, subprocess, sys, time
session = sys.argv[1]
controller, worker = pty.openpty()
proc = subprocess.Popen(["tmux", "-f", "/dev/null", "attach", "-t", session],
                        stdin=worker, stdout=worker, stderr=worker,
                        start_new_session=True)
os.close(worker)
deadline = time.time() + 40
while time.time() < deadline and proc.poll() is None:
    try:
        os.read(controller, 65536)
    except OSError:
        break
PY
  local client=$!

  start=$(date +%s.%N)
  found=""
  for _ in $(seq 1 600); do
    n=$(tmux capture-pane -p -t "$session" 2>/dev/null | tr -d ' \n' | wc -c)
    if [ "${n:-0}" -ge "$THRESHOLD" ]; then found=$(date +%s.%N); break; fi
    sleep 0.05
  done

  kill "$client" 2>/dev/null
  tmux kill-session -t "$session" 2>/dev/null
  wait 2>/dev/null

  [ -n "$found" ] || return 1
  awk -v a="$start" -v b="$found" 'BEGIN{printf "%.0f", (b-a)*1000}'
}

samples=()
for _ in $(seq 1 "$runs"); do
  if value=$(measure "$@"); then samples+=("$value"); fi
done

if [ "${#samples[@]}" -eq 0 ]; then
  printf '%-16s never reached a usable screen (0/%s runs)\n' "$label" "$runs"
  exit 0
fi

printf '%s\n' "${samples[@]}" | sort -n | awk -v L="$label" -v R="$runs" '
  {v[NR]=$1}
  END {
    med = (NR % 2) ? v[int(NR/2)+1] : (v[NR/2] + v[NR/2+1]) / 2
    printf "%-16s median %7.0f ms   min %6.0f   max %6.0f   (%d/%s runs finished)\n",
           L, med, v[1], v[NR], NR, R
  }'
