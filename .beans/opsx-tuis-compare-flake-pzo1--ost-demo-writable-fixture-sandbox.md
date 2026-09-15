---
# opsx-tuis-compare-flake-pzo1
title: 'ost-demo: writable fixture sandbox'
status: todo
type: epic
priority: high
created_at: 2026-09-15T10:17:15Z
updated_at: 2026-09-15T10:17:15Z
parent: opsx-tuis-compare-flake-41i5
blocked_by:
    - opsx-tuis-compare-flake-ix26
    - opsx-tuis-compare-flake-j56p
---

OpenSpec change: `add-ost-demo`

Briefing: section 2.5, last paragraph.

Nothing in the comparison may mutate the user's real projects. Several tools
toggle checkboxes and write files, so the fixture has to be handed over as a
writable copy.

## Scope
`ost-demo` copies the fixture to `$(mktemp -d)`, makes it writable, changes into
it, prints the path, and drops you in a shell. It sets a temp `XDG_DATA_HOME` for
the session so store registration stays sandboxed.

## Acceptance
- [ ] `ost-demo` prints a path under a temp directory and the shell starts there
- [ ] The copy is writable: toggling a task checkbox succeeds
- [ ] `fixture/` in the nix store is unchanged afterwards
- [ ] e2e scenario `fixture-writable` passes
- [ ] e2e scenario `no-host-writes` passes
