---
# opsx-tuis-compare-flake-2kzu
title: 07 Evidence and comparison README
status: completed
type: milestone
priority: high
created_at: 2026-09-15T10:17:45Z
updated_at: 2026-09-15T12:01:53Z
---

Turn the working flake into the artifact people came for: a README that says what
each tool is, compares them on evidence, and discloses its own bias.

Briefing: section 3.

Tone is neutral and evidence-backed, with no marketing. Every "yes" cell must
correspond to something observed in the source or from running the tool. Where a
cell was inferred from a README and not verified by running it, mark it partial
and say so in the footnote. Undeterminable means `?` plus a footnote.

## Exit criteria
- [ ] Both matrices are filled with no `TODO` cells
- [ ] The bias disclosure about specgetty is on the page
- [ ] `docs/method.md` explains how every cell was determined

## Summary of Changes

Both matrices filled with no TODO cells, from evidence rather than inference.
19 feature rows, 11 property rows, 6 tools, 53 notes. Every partial and
undetermined cell carries a note saying what was checked, enforced by a test
rather than by discipline.

The README is generated from the same data the terminal renders, and drift
fails the gate. The bias disclosure is above the matrices.

The measurement the briefing called most decision-relevant: 7 to 28 ms to first
paint for the Rust and Go tools, 239 ms and 355 ms for the two Python ones.
