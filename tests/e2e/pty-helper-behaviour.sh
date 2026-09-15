#!/usr/bin/env bash
# requires: coreutils
#
# The pty runner gives a real terminal and judges a program on whether it
# stayed up, never on what it drew. All three exit rules are covered here,
# including the failing one.
set -euo pipefail

echo "-- a program that stays up passes"
ost-pty-run --timeout 2 -- sleep 30

echo "-- a program that exits zero passes"
ost-pty-run --timeout 5 -- true

echo "-- stdin really is a tty, not a fake one"
ost-pty-run --timeout 5 -- sh -c 'test -t 0'

echo "-- falsification: a program that dies on its own fails"
if ost-pty-run --timeout 5 -- sh -c 'echo boom >&2; exit 3' 2>/dev/null; then
  echo "   FAIL pty-run accepted a program that exited 3" >&2
  exit 1
fi
echo "   ok  pty-run rejected exit 3"

echo "-- falsification: a missing command fails"
if ost-pty-run --timeout 5 -- this-command-does-not-exist 2>/dev/null; then
  echo "   FAIL pty-run accepted a missing command" >&2
  exit 1
fi
echo "   ok  pty-run rejected a missing command"
