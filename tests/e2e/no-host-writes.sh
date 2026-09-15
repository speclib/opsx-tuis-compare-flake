#!/usr/bin/env bash
# requires: coreutils
#
# The constraint this protects is the one with real-world consequences: running
# the comparison must not touch the user's OpenSpec store registry or their
# projects.
#
# A naive version of this test passes for the wrong reason. Inside a Nix build
# there is no user home to write to, so asserting "the host home is clean" is
# true before anything runs. This scenario therefore builds a decoy home that
# looks exactly like a real one, points HOME at it, runs a full harness pass,
# and then diffs it.
set -euo pipefail

. "$OST_TEST_LIB/sandbox.sh"

decoy="$PWD/decoy-home"
mkdir -p "$decoy/.local/share/openspec/stores" "$decoy/.config/openspec" "$decoy/projects"

# A registry with a store in it, exactly like the one a user would have.
cat > "$decoy/.local/share/openspec/stores/registry.yaml" <<'YAML'
version: 1
stores:
  someones-real-store:
    backend:
      type: git
      local_path: /home/someone/planning/openspec
YAML
printf '%s\n' '{"telemetry":{"noticeSeen":true}}' > "$decoy/.config/openspec/config.json"
printf 'do not touch\n' > "$decoy/projects/canary"

fingerprint() {
  find "$decoy" -type f -exec sh -c 'printf "%s " "$1"; cat "$1"' _ {} \; | sort
}

before=$(fingerprint)
echo "-- decoy home prepared with $(printf '%s\n' "$before" | wc -l) files"

echo "-- run a full harness pass with HOME pointing at the decoy"
(
  export HOME="$decoy"
  export XDG_DATA_HOME="$decoy/.local/share"
  export XDG_CONFIG_HOME="$decoy/.config"
  export XDG_CACHE_HOME="$decoy/.cache"
  export XDG_STATE_HOME="$decoy/.local/state"

  # ost-demo is the entry point a person uses, and it is what registers a store.
  "$OST_ENV/bin/ost-demo" '
    openspec list > /dev/null 2>&1
    openspec store list > /dev/null 2>&1
    ost-specgetty --help > /dev/null 2>&1
    ost-dossier --help > /dev/null 2>&1
    ost-itslame --help > /dev/null 2>&1
    ost-opsx --help > /dev/null 2>&1
    sed -i "s/- \[ \] 2.2/- [x] 2.2/" openspec/changes/add-dark-mode/tasks.md
  ' > /dev/null 2>&1
) || {
  echo "   FAIL the harness pass itself failed" >&2
  exit 1
}
echo "   ok  harness pass completed"

echo "-- the decoy home is byte-for-byte unchanged"
after=$(fingerprint)
if [ "$before" != "$after" ]; then
  echo "   FAIL the run modified the decoy home" >&2
  printf '%s\n' "$before" > /tmp/before.txt
  printf '%s\n' "$after" > /tmp/after.txt
  diff /tmp/before.txt /tmp/after.txt >&2 || true
  exit 1
fi
echo "   ok  nothing added, removed or changed"

echo "-- the decoy registry still holds only the store that was there before"
grep -aq "someones-real-store" "$decoy/.local/share/openspec/stores/registry.yaml" || {
  echo "   FAIL the pre-existing store vanished from the registry" >&2; exit 1; }
if grep -aq "ost-demo-store" "$decoy/.local/share/openspec/stores/registry.yaml"; then
  echo "   FAIL ost-demo registered its store in the host registry" >&2
  cat "$decoy/.local/share/openspec/stores/registry.yaml" >&2
  exit 1
fi
echo "   ok  registry untouched"

echo "-- falsification: the fingerprint does notice a write"
printf 'tampered\n' >> "$decoy/projects/canary"
if [ "$before" = "$(fingerprint)" ]; then
  echo "   FAIL the fingerprint cannot detect a change, so this test proves nothing" >&2
  exit 1
fi
echo "   ok  the fingerprint detects a deliberate write"
