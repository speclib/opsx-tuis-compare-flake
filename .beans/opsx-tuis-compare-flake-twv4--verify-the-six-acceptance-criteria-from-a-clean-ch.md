---
# opsx-tuis-compare-flake-twv4
title: Verify the six acceptance criteria from a clean checkout
status: completed
type: epic
priority: high
created_at: 2026-09-15T10:18:25Z
updated_at: 2026-09-15T12:06:06Z
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

## Summary of Changes

All six criteria verified from a clean `--depth 1` clone at commit `178d1be`,
not from the working tree. That distinction matters here: Nix reads the git
index, so a green gate in the working tree does not prove the same for someone
who clones. It found nothing wrong, which is the outcome worth having.

| Criterion                              | Result |
|----------------------------------------|--------|
| 1. `nix flake check` passes            | pass   |
| 2. All six build, real hashes           | pass   |
| 3. Exactly nine commands, no collision  | pass   |
| 4. Each check proves the binary starts  | pass   |
| 5. `ost-demo` gives a writable fixture  | pass   |
| 6. Both matrices, no TODO cells         | pass   |

**Degradations: none.** The briefing expected `opsx` or `mstanton` to need the
degradation rule. Both build and run.

Host registry after the full run: dated 1 September, still containing only Pim's
own `nivis` store.

Three gaps recorded rather than fixed, in `docs/acceptance.md`: `x86_64-darwin`
is not a declared system because nixpkgs throws on it; some feature cells are
undetermined, each naming what was checked; and CI has not been observed running
because the remote had no prior push when the workflow was written.
