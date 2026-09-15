#!/usr/bin/env bash
# requires: coreutils
#
# The sandbox helper redirects HOME and every XDG base, and its guard actually
# detects an unsandboxed environment. The second half is the falsification: a
# guard that cannot fail proves nothing.
set -euo pipefail

. "$OST_TEST_LIB/sandbox.sh"

echo "-- HOME and XDG bases resolve inside the sandbox"
assert_sandboxed
for var in HOME XDG_DATA_HOME XDG_CONFIG_HOME XDG_CACHE_HOME XDG_STATE_HOME; do
  eval "value=\$$var"
  case "$value" in
    "$OST_SANDBOX_ROOT"/*) echo "   ok  $var=$value" ;;
    *) echo "   FAIL $var=$value is outside $OST_SANDBOX_ROOT" >&2; exit 1 ;;
  esac
done

echo "-- the sandbox is writable"
printf 'written\n' > "$HOME/canary"
test -f "$HOME/canary"

echo "-- XDG_DATA_HOME is where openspec would put a store registry"
mkdir -p "$XDG_DATA_HOME/openspec/stores"
test -d "$XDG_DATA_HOME/openspec/stores"

echo "-- falsification: the guard rejects a HOME outside the root"
(
  HOME=/tmp
  export HOME
  if assert_sandboxed 2>/dev/null; then
    echo "   FAIL assert_sandboxed accepted HOME=/tmp" >&2
    exit 1
  fi
  echo "   ok  assert_sandboxed rejected HOME=/tmp"
)

echo "-- falsification: the guard rejects an unset root"
(
  unset OST_SANDBOX_ROOT
  if assert_sandboxed 2>/dev/null; then
    echo "   FAIL assert_sandboxed accepted an unset OST_SANDBOX_ROOT" >&2
    exit 1
  fi
  echo "   ok  assert_sandboxed rejected an unset root"
)

echo "-- the host home was not touched"
assert_no_host_writes "$OST_HOST_HOME"
