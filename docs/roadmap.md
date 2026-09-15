# Roadmap

Milestones and epics live in beans; the tasks inside each epic live in that
epic's OpenSpec change. One epic is one change is one commit.

> `beans roadmap` produces an empty document in beans 0.4.2, reproduced in a
> minimal scratch project, so this file is generated from `beans query` until
> that is fixed.

Generated 2026-09-15.

| Milestone | Status | Epics |
|-----------|--------|-------|
| 01 Foundation and flake skeleton | done | 3/3 |
| 02 Package the Go TUIs | done | 3/3 |
| 03 Package the Rust TUI | done | 1/1 |
| 04 Package the Python TUIs | done | 2/2 |
| 05 Fixture project | done | 2/2 |
| 06 Comparison harness | done | 3/3 |
| 07 Evidence and comparison README | done | 3/3 |
| 08 Acceptance and alpha release | doing | 2/3 |
| 09 Deferred carry-over for the new TUI briefing | draft | 0/1 |

## Epics

### 01 Foundation and flake skeleton

- [x] CI workflow running nix flake check
- [x] Flake skeleton with plain genAttrs multi-system support
- [x] Test harness: smoke checks, e2e runner and host sandbox

### 02 Package the Go TUIs

- [x] Package dossier (Go, filesystem reader)
- [x] Package itslame openspec-tui (Go, CLI JSON client)
- [x] Package specgetty (Go, spg)

### 03 Package the Rust TUI

- [x] Package neosam openspec-tui (Rust, implementation runner)

### 04 Package the Python TUIs

- [x] Package mstanton openspec-tui (Python, Textual authoring tool)
- [x] Package opsx-tui (Python, aspiring control center)

### 05 Fixture project

- [x] Demo fixture OpenSpec project satisfying all six tools
- [x] Second fixture root registered as a store

### 06 Comparison harness

- [x] Combined default env with ost-* wrappers
- [x] ost-compare: side-by-side launcher and matrix printer
- [x] ost-demo: writable fixture sandbox

### 07 Evidence and comparison README

- [x] Collect comparison evidence by running every tool on the fixture
- [x] Write the comparison README with both matrices
- [x] docs/method.md and docs/adding-a-tool.md

### 08 Acceptance and alpha release

- [x] Complete the e2e scenario suite
- [ ] Cut the alpha release and hand over
- [x] Verify the six acceptance criteria from a clean checkout

### 09 Deferred carry-over for the new TUI briefing

- [ ] Findings that aim the next TUI briefing

## Outcome

All eight build milestones are complete. All six tools build and run, none
degraded, and the six acceptance criteria in `docs/briefing.md` section 5 were
verified from a clean clone. See `docs/acceptance.md`.

Milestone 09 is deliberately not started. It holds the section 7 carry-over
notes for the next briefing.
