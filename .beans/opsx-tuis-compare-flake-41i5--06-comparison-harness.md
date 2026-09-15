---
# opsx-tuis-compare-flake-41i5
title: 06 Comparison harness
status: completed
type: milestone
priority: high
created_at: 2026-09-15T10:17:15Z
updated_at: 2026-09-15T11:56:35Z
---

Assemble the combined environment and the two harness commands. This milestone
delivers the headline promise: `nix shell github:speclib/opsx-tuis-compare-flake`
puts all six tools plus `openspec` on `PATH` under non-colliding names.

Briefing: sections 2.2, 2.3, 2.6.

## Exit criteria
- [ ] `nix shell .` exposes exactly the nine expected commands
- [ ] No bare `openspec-tui` and no bare `opsx-tui` anywhere on `PATH`
- [ ] `ost-demo` lands you in a writable fixture copy
- [ ] `ost-compare --tmux` opens one window per tool on the same project state

## Summary of Changes

The headline promise works. `nix shell .` exposes exactly nine commands:

```
openspec  ost-compare  ost-demo  ost-dossier  ost-itslame
ost-mstanton  ost-neosam  ost-opsx  ost-specgetty
```

No bare `openspec-tui` or `opsx-tui` anywhere, asserted by
`e2e-no-name-collision`. `ost-demo` hands over a writable copy that leaves the
host untouched, proved against a decoy home. `ost-compare --tmux` opens all six
on the same project state.
