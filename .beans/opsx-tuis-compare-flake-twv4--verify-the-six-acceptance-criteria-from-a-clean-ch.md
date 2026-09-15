---
# opsx-tuis-compare-flake-twv4
title: Verify the six acceptance criteria from a clean checkout
status: todo
type: epic
priority: high
created_at: 2026-09-15T10:18:25Z
updated_at: 2026-09-15T10:18:25Z
parent: opsx-tuis-compare-flake-yx1r
blocked_by:
    - opsx-tuis-compare-flake-aw79
    - opsx-tuis-compare-flake-iciq
---

OpenSpec change: `verify-acceptance-criteria`

Briefing: section 5.

Walk all six acceptance criteria in order from a genuinely clean checkout, not
from the working tree. Clone the repo to a temp directory and run there, so a
missing committed file or an uncommitted hash is caught.

## Scope
- Run each criterion's commands, capture the output verbatim.
- Confirm no `lib.fakeHash` is in the tree.
- Confirm `ls result/bin` on `packages.default` lists the expected set and
  nothing else.
- Confirm the README has no `TODO` cell.
- Produce a degradation report naming every tool that did not build and why.

## Acceptance
- [ ] A verification record committed with commands and their real output
- [ ] Any criterion that fails is either fixed or recorded as a known gap with a
      follow-up bean
- [ ] The degradation report names every degraded tool
