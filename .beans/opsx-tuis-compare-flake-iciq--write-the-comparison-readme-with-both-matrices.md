---
# opsx-tuis-compare-flake-iciq
title: Write the comparison README with both matrices
status: todo
type: epic
priority: high
created_at: 2026-09-15T10:17:45Z
updated_at: 2026-09-15T10:17:45Z
parent: opsx-tuis-compare-flake-2kzu
blocked_by:
    - opsx-tuis-compare-flake-rzpk
---

OpenSpec change: `write-comparison-readme`

Briefing: section 3. Section order matters: someone landing on the repo wants the
verdict, then the evidence.

## Required sections, in order
1. What this is: one paragraph, plus the
   `nix shell github:speclib/opsx-tuis-compare-flake` line and `ost-compare`.
2. The contenders: one short paragraph per tool covering what it is for. Be
   explicit that they are not all the same kind of program. specgetty is a
   fleet-level scanner; dossier and itslame are readers; neosam is a runner;
   mstanton is an author; opsx is an aspiring control center.
3. Feature matrix: rows are features, columns are the six tools.
4. Properties matrix.
5. Notes and caveats: the `openspec-tui` name collision, the fsmw license
   contradiction, that this is a snapshot of pinned revs with the date, and what
   a partial cell means.
6. Method: how to reproduce.
7. Bias disclosure: specgetty is authored by the owner of this compare repo. One
   line, on the page. The artifact is worthless as a comparison without it.
8. Adding a tool: open a PR, add input, add package, add table rows.

## Also state
That this repo takes all six upstreams as `flake = false` inputs even where they
ship their own flake, because it is a comparison artifact and not a
redistribution channel. Include the snapshot date derived from the pinned revs.

## Acceptance
- [ ] All eight sections present in order
- [ ] No `TODO` cell in either matrix
- [ ] Every partial and `?` cell has a footnote
- [ ] Bias disclosure present
- [ ] Prose passes the repo prose rules: no em dash, no en dash, straight quotes
