---
# opsx-tuis-compare-flake-c55b
title: 'Test harness: smoke checks, e2e runner and host sandbox'
status: completed
type: epic
priority: high
created_at: 2026-09-15T10:15:45Z
updated_at: 2026-09-15T10:37:42Z
parent: opsx-tuis-compare-flake-5xdz
blocked_by:
    - opsx-tuis-compare-flake-ogon
---

OpenSpec change: `add-test-harness`

Briefing: section 5. See the Testing section of CLAUDE.md for the three layers
and the seven required e2e scenarios.

## Scope
- `tests/e2e/` layout plus a runner invoked from `checks.<system>.e2e-*`.
- A sandbox helper that sets `HOME` and `XDG_DATA_HOME` to derivation-local temp
  paths, so no test can reach `~/.local/share/openspec`.
- A pty helper for driving TUIs with a bounded timeout, accepting a non-zero exit
  from the timeout.
- A smoke-check helper that asserts a binary exists, links, and answers `--help`
  or `--version`. Its check name must say it is a link-and-help check, not a
  functional one.
- One self-test proving the sandbox helper isolates `HOME`.

## Non-goals
The seven e2e scenarios themselves land in milestone 08. This epic delivers the
machinery plus the sandbox self-test.

## Acceptance
- [ ] `nix flake check` runs the sandbox self-test and it passes
- [ ] The self-test fails if the sandbox helper is removed
- [ ] Helpers are documented in `docs/method.md` or a `tests/README.md`

## Summary of Changes

Added `tests/lib/sandbox.sh`, `tests/lib/pty-run.py`, `tests/default.nix` and
the first two scenarios. `checks.<system>` now discovers `tests/e2e/*.sh`, so a
later epic adds a scenario by adding a file.

The pty runner gives a real terminal and judges a program on whether it stayed
up: still running at the deadline passes, a clean exit passes, a non-zero exit
before the deadline fails. It asserts nothing about rendered output.

Each piece was falsified and the result recorded in `docs/method.md`:

- `assert_sandboxed` stubbed to return 0 makes `e2e-sandbox-isolates-home`
  fail with "assert_sandboxed accepted HOME=/tmp"
- a smoke check pointed at a missing binary fails and lists what the package
  does contain
- `e2e-pty-helper-behaviour` carries its own falsifications for exit 3 and a
  missing command
