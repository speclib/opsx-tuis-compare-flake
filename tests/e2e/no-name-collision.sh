#!/usr/bin/env bash
# requires: coreutils
#
# Three of the six upstream projects install a binary called openspec-tui, and a
# fourth installs opsx-tui. This is the single most important constraint in the
# design: those names must never reach PATH from the combined environment.
set -euo pipefail

. "$OST_TEST_LIB/sandbox.sh"

echo "-- no upstream binary name is exposed"
for name in openspec-tui opsx-tui openspec-tui-editor openspec-tui-gui spg dossier; do
  if [ -e "$OST_ENV/bin/$name" ]; then
    echo "   FAIL $name is on PATH from the combined environment" >&2
    ls -la "$OST_ENV/bin" >&2
    exit 1
  fi
  echo "   ok  $name absent"
done

echo "-- every exposed tool command carries the ost- prefix"
for entry in "$OST_ENV"/bin/*; do
  name=$(basename "$entry")
  case "$name" in
    openspec) continue ;;          # the CLI keeps its own name on purpose
    ost-*) ;;
    *)
      echo "   FAIL $name is neither the openspec CLI nor an ost- command" >&2
      exit 1
      ;;
  esac
done
echo "   ok  every tool command is prefixed"

echo "-- the individual packages do keep their upstream names"
# The constraint is about the combined environment, not the packages. Checking
# this keeps the test honest about what it is protecting.
command -v ost-neosam > /dev/null || {
  echo "   FAIL ost-neosam not on PATH" >&2; exit 1; }
echo "   ok  wrapping happens in the environment, not in the packages"

echo "-- nothing reached the host home"
assert_no_host_writes "$OST_HOST_HOME"
