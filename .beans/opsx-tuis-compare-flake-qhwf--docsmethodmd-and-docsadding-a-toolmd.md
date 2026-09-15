---
# opsx-tuis-compare-flake-qhwf
title: docs/method.md and docs/adding-a-tool.md
status: todo
type: epic
priority: normal
created_at: 2026-09-15T10:17:45Z
updated_at: 2026-09-15T10:17:45Z
parent: opsx-tuis-compare-flake-2kzu
blocked_by:
    - opsx-tuis-compare-flake-rzpk
---

OpenSpec change: `add-method-and-contribution-docs`

Briefing: sections 3 item 6, 4, and 5 degradation rule.

## Scope
- `docs/method.md`: how each matrix cell was determined, what "supported" meant
  per cell, the fixture and harness used, the provenance convention, and a record
  of every tool that degraded with the actual failure text.
- `docs/adding-a-tool.md`: add an input, add a package file, add a wrapper entry,
  add table rows, run the gate. This is what makes the repo a concept rather than
  a one-off.

## Acceptance
- [ ] Someone who has never seen the repo can reproduce a matrix cell from
      `docs/method.md`
- [ ] Every degraded tool has its failure recorded verbatim
- [ ] `docs/adding-a-tool.md` lists every file a new tool touches
