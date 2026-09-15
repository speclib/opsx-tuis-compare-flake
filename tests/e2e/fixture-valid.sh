#!/usr/bin/env bash
# requires: openspec
#
# The fixture is the control in this comparison: every tool is judged on it. If
# it stops being a valid OpenSpec project, every tool looks broken at once and
# the matrices become meaningless.
#
# Note the redirection on every openspec call. With its stdout attached
# directly to a Nix build log the CLI redraws its progress spinner without
# bound and never returns. See docs/method.md.
set -euo pipefail

. "$OST_TEST_LIB/sandbox.sh"

export DO_NOT_TRACK=1
mkdir -p "$XDG_CONFIG_HOME/openspec"
printf '%s\n' '{"telemetry":{"noticeSeen":true,"enabled":false}}' \
  > "$XDG_CONFIG_HOME/openspec/config.json"

cd "$OST_FIXTURE"

echo "-- openspec validates every change and spec"
if ! timeout 120 openspec validate --all --strict > validate.log 2>&1; then
  echo "   FAIL validation did not pass" >&2
  head -c 4000 validate.log >&2
  exit 1
fi
grep -a "Totals: 4 passed, 0 failed" validate.log >/dev/null || {
  echo "   FAIL expected 4 items to pass" >&2
  head -c 2000 validate.log >&2
  exit 1
}
echo "   ok  4 items validated"

echo "-- openspec sees both active changes"
timeout 60 openspec list > list.log 2>&1
for change in add-dark-mode add-user-auth; do
  grep -a -q "$change" list.log || {
    echo "   FAIL $change missing from openspec list" >&2
    cat list.log >&2
    exit 1
  }
  echo "   ok  $change listed"
done

echo "-- the two changes differ in task progress, so indicators have something to show"
grep -a -q "add-dark-mode *3/7" list.log || {
  echo "   FAIL add-dark-mode is not at 3/7 tasks" >&2; cat list.log >&2; exit 1; }
grep -a -q "add-user-auth *0/7" list.log || {
  echo "   FAIL add-user-auth is not at 0/7 tasks" >&2; cat list.log >&2; exit 1; }
echo "   ok  3/7 and 0/7"

echo "-- openspec sees both specs"
timeout 60 openspec list --specs > specs.log 2>&1
for spec in task-tracking theming; do
  grep -a -q "$spec" specs.log || {
    echo "   FAIL $spec missing from openspec list --specs" >&2; cat specs.log >&2; exit 1; }
  echo "   ok  $spec listed"
done

echo "-- the archived change is present on disk for the tools that browse archives"
test -d "$OST_FIXTURE/openspec/changes/archive/2026-01-10-add-logging" || {
  echo "   FAIL archived change missing" >&2; exit 1; }
echo "   ok  2026-01-10-add-logging"

echo "-- every change directory carries .openspec.yaml, which dossier requires"
missing=0
for dir in "$OST_FIXTURE"/openspec/changes/*/ "$OST_FIXTURE"/openspec/changes/archive/*/; do
  case "$dir" in */archive/) continue ;; esac
  if [ ! -f "$dir/.openspec.yaml" ]; then
    echo "   FAIL $dir has no .openspec.yaml" >&2
    missing=1
  fi
done
[ "$missing" = "0" ] || exit 1
echo "   ok  every change directory has one"

echo "-- one change has no design.md, so artifact-status displays differ"
test ! -f "$OST_FIXTURE/openspec/changes/add-user-auth/design.md" || {
  echo "   FAIL add-user-auth gained a design.md; the fixture lost that contrast" >&2
  exit 1; }
echo "   ok  add-user-auth still has no design.md"

echo "-- nothing reached the host home"
assert_no_host_writes "$OST_HOST_HOME"
