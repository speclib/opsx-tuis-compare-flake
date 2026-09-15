---
# opsx-tuis-compare-flake-vcg7
title: 'ost-compare: side-by-side launcher and matrix printer'
status: completed
type: epic
priority: high
created_at: 2026-09-15T10:17:15Z
updated_at: 2026-09-15T11:56:34Z
parent: opsx-tuis-compare-flake-41i5
blocked_by:
    - opsx-tuis-compare-flake-pzo1
---

OpenSpec change: `add-ost-compare`

Briefing: section 2.6.

## Scope
- `ost-compare` prints the six commands with a one-line description each and
  what each one is good at.
- `ost-compare --tmux` opens a tmux session against the fixture with one window
  per tool, so you can flip between them on the same project state.
- `ost-compare --matrix` re-prints the README feature table in the terminal.

The matrix text has one source. Generate the terminal output from the same data
the README is built from, or generate the README table from this data. Do not
maintain two copies by hand.

## Acceptance
- [ ] `ost-compare` lists exactly the tools present in `packages.default`
- [ ] `ost-compare --tmux` creates one window per non-broken tool
- [ ] `ost-compare --matrix` output matches the README feature matrix
- [ ] e2e scenario `each-tool-starts` passes

## Summary of Changes

`data/comparison.json` is the single source: 6 tools, 19 feature rows, 10
property rows, 52 notes. `ost-compare` renders it, and milestone 07 generates
the README from the same file, so the terminal and the page cannot drift.

Markers: yes and no mean observed, part means present but incomplete or a
README claim not verified, unknown means undetermined with a note saying what
was checked. The last two are machine-enforced: `comparison-data` fails if any
soft cell lacks a note, and falsifies itself by removing one.

`--tmux` opens one window per tool plus a matrix window, all sharing a single
`ost-demo` copy. Verified under a pty: 7 windows, correct names.

One bug found by running it rather than reasoning about it: selecting the
orientation window by index gives `can't find window: 0` for anyone whose
tmux.conf sets `base-index 1`. It selects by name now.
