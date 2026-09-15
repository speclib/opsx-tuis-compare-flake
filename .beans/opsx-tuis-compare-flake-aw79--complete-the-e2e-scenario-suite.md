---
# opsx-tuis-compare-flake-aw79
title: Complete the e2e scenario suite
status: todo
type: epic
priority: high
created_at: 2026-09-15T10:18:25Z
updated_at: 2026-09-15T10:18:25Z
parent: opsx-tuis-compare-flake-yx1r
blocked_by:
    - opsx-tuis-compare-flake-c55b
    - opsx-tuis-compare-flake-vcg7
---

OpenSpec change: `complete-e2e-suite`

Briefing: section 5 criterion 4. See the Testing section of CLAUDE.md.

The harness machinery landed in milestone 01. This epic implements every
scenario against the finished flake.

| Scenario            | Asserts                                                           |
|---------------------|-------------------------------------------------------------------|
| `default-env`       | `packages.default` exposes the nine expected commands and no more  |
| `no-name-collision` | no `openspec-tui` or `opsx-tui` binary is on `PATH`                |
| `fixture-valid`     | `openspec validate` passes on the fixture, and `list` sees it      |
| `fixture-writable`  | `ost-demo` yields a writable copy outside the store                |
| `store-resolution`  | a registered store resolves under the temp `XDG_DATA_HOME` only    |
| `each-tool-starts`  | every non-broken tool starts against the fixture and exits cleanly |
| `no-host-writes`    | a full harness run leaves `$HOME` fixture-free                     |

## TTY discipline
`each-tool-starts` drives TUIs under the pty helper with a bounded timeout and
accepts a non-zero exit caused by that timeout. Never assert on rendered frames;
frame content is not a stable contract.

## Negative testing
Each scenario must be shown to fail when the thing it protects is removed. A test
that cannot fail proves nothing. Record how each one was falsified.

## Acceptance
- [ ] All seven scenarios implemented and wired into `checks.<system>.e2e-*`
- [ ] `nix flake check` runs all of them and passes
- [ ] Each scenario has a recorded falsification
