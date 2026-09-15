#!/usr/bin/env bash
# requires: coreutils
#
# The headline promise of this repo is that one command puts every tool on PATH
# under a name that does not collide. This scenario is that promise, written
# down so it cannot quietly stop being true.
set -euo pipefail

. "$OST_TEST_LIB/sandbox.sh"

echo "-- every expected command is present"
expected="openspec ost-dossier ost-itslame ost-mstanton ost-neosam ost-opsx ost-specgetty"
missing=0
for cmd in $expected; do
  if [ -x "$OST_ENV/bin/$cmd" ]; then
    echo "   ok  $cmd"
  else
    echo "   FAIL $cmd is missing" >&2
    missing=1
  fi
done
[ "$missing" = "0" ] || { ls "$OST_ENV/bin" >&2; exit 1; }

echo "-- and nothing else"
actual=$(ls "$OST_ENV/bin" | sort | tr '\n' ' ')
wanted=$(printf '%s\n' $expected | sort | tr '\n' ' ')
if [ "$actual" != "$wanted" ]; then
  echo "   FAIL the environment exposes a different set" >&2
  echo "   expected: $wanted" >&2
  echo "   actual:   $actual" >&2
  exit 1
fi
echo "   ok  exactly $(printf '%s\n' $expected | wc -l) commands"

echo "-- each ost- command actually runs the tool it wraps"
for cmd in ost-specgetty ost-dossier ost-itslame ost-opsx; do
  if ! "$OST_ENV/bin/$cmd" --help > "$cmd.out" 2>&1; then
    echo "   FAIL $cmd --help failed" >&2
    head -c 2000 "$cmd.out" >&2
    exit 1
  fi
  echo "   ok  $cmd --help"
done

echo "-- the wrappers put the openspec CLI on PATH for the tools that need it"
# itslame exits 1 with an install hint when it cannot find the CLI. Running it
# with a PATH that has nothing else on it proves the wrapper supplies one.
if ! env -i PATH=/nonexistent "$OST_ENV/bin/ost-itslame" --help > itslame.out 2>&1; then
  echo "   FAIL ost-itslame could not run with an empty PATH" >&2
  cat itslame.out >&2
  exit 1
fi
if grep -aq "was not found on your PATH" itslame.out; then
  echo "   FAIL the wrapper did not supply the openspec CLI" >&2
  cat itslame.out >&2
  exit 1
fi
echo "   ok  ost-itslame finds openspec through its wrapper"

echo "-- nothing reached the host home"
assert_no_host_writes "$OST_HOST_HOME"
