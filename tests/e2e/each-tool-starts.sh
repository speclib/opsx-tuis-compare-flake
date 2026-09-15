#!/usr/bin/env bash
# requires: coreutils
#
# Every tool in the environment starts against the fixture and stays up.
#
# This is the scenario most at risk of passing vacuously, so two things are
# deliberate. The tools are driven on a real pty, because most of them exit
# immediately without one and would then be judged on an error path. And
# ost-opsx is given an explicit --project, because with no project it exits 0
# without drawing, which a start check would otherwise count as success.
#
# Nothing here asserts on what was drawn. Frame content is exactly what upstream
# is free to change.
set -euo pipefail

. "$OST_TEST_LIB/sandbox.sh"

cd "$OST_FIXTURE"

started=0
failed=0

start() {
  label="$1"; shift
  if ost-pty-run --timeout 6 -- "$@" > "$label.log" 2>&1; then
    echo "   ok  $label"
    started=$((started + 1))
  else
    echo "   FAIL $label did not stay up" >&2
    head -c 3000 "$label.log" >&2
    failed=$((failed + 1))
  fi
}

echo "-- every tool starts against the fixture"
start ost-specgetty "$OST_ENV/bin/ost-specgetty"
start ost-dossier   "$OST_ENV/bin/ost-dossier"
start ost-neosam    "$OST_ENV/bin/ost-neosam"
start ost-mstanton  "$OST_ENV/bin/ost-mstanton"
start ost-itslame   "$OST_ENV/bin/ost-itslame"
start ost-opsx      "$OST_ENV/bin/ost-opsx" --project "$OST_FIXTURE"

[ "$failed" = "0" ] || exit 1

echo "-- the count matches what the environment exposes"
exposed=$(find "$OST_ENV/bin" -name 'ost-*' -not -name 'ost-demo' -not -name 'ost-compare' | wc -l)
if [ "$started" != "$exposed" ]; then
  echo "   FAIL started $started tools but the environment exposes $exposed" >&2
  ls "$OST_ENV/bin" >&2
  exit 1
fi
echo "   ok  $started of $exposed"

echo "-- falsification: a tool that exits immediately is not counted as started"
# ost-opsx without a project is the real example: it exits 0 drawing nothing.
# A pty start check counts a clean early exit as a pass, so this proves the
# suite would not catch that on its own, which is why the invocation above
# passes --project. Run from a directory with no OpenSpec root.
mkdir -p "$PWD/../empty" && cd "$PWD/../empty"
if ost-pty-run --timeout 6 -- "$OST_ENV/bin/ost-opsx" > opsx-bare.log 2>&1; then
  drew=$(wc -c < opsx-bare.log)
  echo "   ok  ost-opsx with no project exits 0 after $drew bytes, which is why"
  echo "       the run above passes --project rather than trusting the exit code"
else
  echo "   note ost-opsx with no project now fails outright; the --project"
  echo "        invocation above is still correct"
fi
