---
# opsx-tuis-compare-flake-yx1r
title: 08 Acceptance and alpha release
status: completed
type: milestone
priority: high
created_at: 2026-09-15T10:18:25Z
updated_at: 2026-09-15T12:07:35Z
---

Prove the PoC against the briefing's own acceptance criteria from a clean
checkout, complete the e2e suite, and cut the alpha.

Briefing: section 5.

## The six acceptance criteria
1. `nix flake check` passes.
2. `nix build .#specgetty .#dossier .#neosam .#mstanton .#itslame .#opsx` all
   succeed, with real hashes committed.
3. `nix shell .` exposes exactly `ost-specgetty ost-dossier ost-neosam
   ost-mstanton ost-itslame ost-opsx ost-compare ost-demo openspec` and no bare
   `openspec-tui`.
4. Each `checks.<name>` runs the binary non-interactively and proves it starts.
   TUIs need a TTY. Do not fake one; a link-and-help check is enough and must be
   labelled as such.
5. `ost-demo` lands you in a writable fixture where all six start against the
   same data.
6. `README.md` contains both filled matrices with no `TODO` cells.

Criterion 2 is read together with the degradation rule: a tool marked
`meta.broken = true` with its failure recorded satisfies it.

## Exit criteria
- [ ] All six criteria verified from a clean checkout, with the commands and
      their output recorded
- [ ] Every degraded tool named in the final report

## Summary of Changes

All six acceptance criteria verified from a clean clone, no degradations, the
e2e suite complete at ten scenarios, and the alpha cut.

The briefing expected `opsx` or `mstanton` to need the degradation rule. Neither
did. The rule is still wired in and still tested: marking a tool `meta.broken`
drops it from `packages.default`, the apps and the checks in one edit.
