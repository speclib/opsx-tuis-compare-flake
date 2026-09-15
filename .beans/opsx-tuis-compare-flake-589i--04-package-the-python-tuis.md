---
# opsx-tuis-compare-flake-589i
title: 04 Package the Python TUIs
status: in-progress
type: milestone
priority: high
created_at: 2026-09-15T10:16:50Z
updated_at: 2026-09-15T10:47:42Z
---

Package the two Python TUIs with `buildPythonApplication`. Neither repo ships a
lockfile, so dependencies come from nixpkgs with relaxed version pins.

Briefing: inventory rows 4 and 6, section 2.4.

These two are the most likely to hit the degradation rule in briefing section 5.
If one will not build, keep its attr, set `meta.broken = true`, drop it from
`packages.default`, and record the failure in `docs/method.md` and as a README
footnote. Do not block the flake.

## Exit criteria
- [ ] `nix build .#mstanton .#opsx` succeeds, or a degradation is recorded for
      each one that does not
- [ ] Every degradation has a named failure with the actual error text
