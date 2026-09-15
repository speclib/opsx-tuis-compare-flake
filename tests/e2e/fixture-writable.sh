#!/usr/bin/env bash
# requires: coreutils
#
# Several tools toggle task checkboxes and write files, and the comparison is
# supposed to let them. This proves ost-demo hands over something writable, and
# that the copy in the store is not what gets written to.
set -euo pipefail

. "$OST_TEST_LIB/sandbox.sh"

echo "-- ost-demo reports a project path outside the nix store"
project=$("$OST_ENV/bin/ost-demo" 'printf "%s" "$OST_FIXTURE"')
case "$project" in
  /nix/store/*)
    echo "   FAIL ost-demo handed over a store path: $project" >&2; exit 1 ;;
  "")
    echo "   FAIL ost-demo reported no project path" >&2; exit 1 ;;
esac
echo "   ok  $project"

echo "-- a task checkbox can be toggled, and the tools see the change"
before=$("$OST_ENV/bin/ost-demo" 'openspec list 2>/dev/null | grep -a add-dark-mode')
after=$("$OST_ENV/bin/ost-demo" '
  sed -i "s/- \[ \] 2.2/- [x] 2.2/" openspec/changes/add-dark-mode/tasks.md
  openspec list 2>/dev/null | grep -a add-dark-mode')

echo "   before: $(echo "$before" | tr -s " ")"
echo "   after:  $(echo "$after" | tr -s " ")"

echo "$before" | grep -aq "3/7" || {
  echo "   FAIL expected the fixture to start at 3/7 tasks" >&2; exit 1; }
echo "$after" | grep -aq "4/7" || {
  echo "   FAIL toggling a checkbox did not change the count" >&2; exit 1; }
echo "   ok  3/7 became 4/7"

echo "-- each invocation gets its own copy, so one run cannot poison the next"
again=$("$OST_ENV/bin/ost-demo" 'openspec list 2>/dev/null | grep -a add-dark-mode')
echo "$again" | grep -aq "3/7" || {
  echo "   FAIL a later run inherited the previous run's edit" >&2
  echo "   got: $again" >&2
  exit 1; }
echo "   ok  back to 3/7 in a fresh copy"

echo "-- the fixture in the nix store is unchanged"
grep -aq -- "- \[ \] 2.2" "$OST_FIXTURE/openspec/changes/add-dark-mode/tasks.md" || {
  echo "   FAIL the store copy was modified" >&2; exit 1; }
echo "   ok  store copy intact"
