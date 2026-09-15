---
# opsx-tuis-compare-flake-41i5
title: 06 Comparison harness
status: todo
type: milestone
priority: high
created_at: 2026-09-15T10:17:15Z
updated_at: 2026-09-15T10:17:15Z
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
