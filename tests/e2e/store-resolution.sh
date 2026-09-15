#!/usr/bin/env bash
# requires: openspec
#
# Stores are the axis the next briefing turns on, so the comparison has to
# exercise them. This scenario proves the registration lands in the sandbox and
# nowhere else.
#
# `openspec store register` writes to the machine's store registry. That is why
# it runs here, inside a Nix build, where the sandbox makes reaching the real
# registry impossible, rather than on a developer's machine where only care
# would stop it.
set -euo pipefail

. "$OST_TEST_LIB/sandbox.sh"

export DO_NOT_TRACK=1
mkdir -p "$XDG_CONFIG_HOME/openspec"
printf '%s\n' '{"telemetry":{"noticeSeen":true,"enabled":false}}' \
  > "$XDG_CONFIG_HOME/openspec/config.json"

echo "-- no store is registered before we register one"
timeout 60 openspec store list > before.log 2>&1 || true
if grep -aq "ost-demo-store" before.log; then
  echo "   FAIL a store was already registered in a fresh sandbox" >&2
  cat before.log >&2
  exit 1
fi
echo "   ok  registry starts empty"

echo "-- register the second root as a store"
if ! timeout 60 openspec store register "$OST_STORE_ROOT" --id ost-demo-store --yes \
     > register.log 2>&1; then
  echo "   FAIL registration failed" >&2
  head -c 4000 register.log >&2
  exit 1
fi
echo "   ok  registered as ost-demo-store"

echo "-- the registry landed inside the sandbox"
registry=""
for candidate in \
  "$XDG_DATA_HOME/openspec/stores/registry.yaml" \
  "$XDG_DATA_HOME/openspec/stores/registry.json" ; do
  [ -f "$candidate" ] && registry="$candidate"
done
if [ -z "$registry" ]; then
  echo "   FAIL no registry file under $XDG_DATA_HOME/openspec/stores" >&2
  find "$XDG_DATA_HOME" -type f >&2 || true
  exit 1
fi
case "$registry" in
  "$OST_SANDBOX_ROOT"/*) echo "   ok  $registry" ;;
  *) echo "   FAIL registry at $registry is outside $OST_SANDBOX_ROOT" >&2; exit 1 ;;
esac

echo "-- the store resolves by id"
if ! timeout 60 openspec list --store ost-demo-store > resolved.log 2>&1; then
  echo "   FAIL could not list through --store" >&2
  head -c 4000 resolved.log >&2
  exit 1
fi
grep -aq "add-changelog" resolved.log || {
  echo "   FAIL the store's change was not listed" >&2; cat resolved.log >&2; exit 1; }
echo "   ok  --store ost-demo-store resolves to the second root"

echo "-- resolving by id gives the store, not the working directory"
cd "$OST_FIXTURE"
timeout 60 openspec list > cwd.log 2>&1
grep -aq "add-dark-mode" cwd.log || {
  echo "   FAIL the fixture root did not resolve from cwd" >&2; cat cwd.log >&2; exit 1; }
if grep -aq "add-changelog" cwd.log; then
  echo "   FAIL the store leaked into a plain cwd resolution" >&2; cat cwd.log >&2; exit 1
fi
echo "   ok  cwd resolves to the fixture, --store to the store"

echo "-- falsification: an unregistered id is refused"
if timeout 60 openspec list --store no-such-store > bogus.log 2>&1; then
  echo "   FAIL an unregistered store id was accepted" >&2
  cat bogus.log >&2
  exit 1
fi
echo "   ok  an unregistered id is refused"

echo "-- nothing reached the host home"
assert_no_host_writes "$OST_HOST_HOME"
