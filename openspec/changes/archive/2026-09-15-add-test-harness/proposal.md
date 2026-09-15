# Add the test harness

Beans epic: `opsx-tuis-compare-flake-c55b` (milestone 01).
Briefing: section 5.

## Why

Every later epic ends with a test gate, and two of the briefing's hard
constraints are only checkable by a test: that nothing writes outside the repo,
and that a TUI check proves the binary starts without faking a TTY. Building
that machinery per epic would produce six different opinions about what a smoke
check means. It lands once, here, before anything is packaged.

## What Changes

- Add `tests/lib/sandbox.sh`: sets `HOME` and every `XDG_*` path to build-local
  directories, and exposes `assert_sandboxed` which fails when they are not.
- Add `tests/lib/pty-run.py`: runs a command on a real pty with a bounded
  timeout, so a TUI can be started without a fake TTY and without asserting on
  rendered frames.
- Add `tests/default.nix` exposing `mkSmokeCheck` and `mkE2E`, the two check
  constructors every later epic uses.
- Wire `checks.<system>` to the e2e scenarios found in `tests/e2e/`.
- Add the first two scenarios: `sandbox-isolates-home` and its falsification.

## Capabilities

### New Capabilities

- `test-harness`: what a smoke check and an e2e scenario guarantee, and the
  isolation every test runs under.

### Modified Capabilities

None.

## Impact

- New files under `tests/`.
- `checks.<system>` stops being empty.
- Later epics add scenarios by dropping a script into `tests/e2e/`; they do not
  touch `flake.nix`.
