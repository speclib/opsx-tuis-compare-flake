---
# opsx-tuis-compare-flake-juf8
title: Package specgetty (Go, spg)
status: todo
type: epic
priority: high
created_at: 2026-09-15T10:16:14Z
updated_at: 2026-09-15T10:16:14Z
parent: opsx-tuis-compare-flake-35mq
blocked_by:
    - opsx-tuis-compare-flake-ogon
---

OpenSpec change: `package-specgetty`

Upstream: `speclib/specgetty`, Go, binary `spg`, MIT.
Briefing: inventory row 1, section 2.4.

A multi-project scanner: it finds all OpenSpec projects on disk and reports
status. It is a different category from the readers, and the README must say so.

## Scope
- `pkgs/specgetty.nix` using `buildGoModule`.
- Read upstream's own `flake.nix` and `package.nix` first. They record build
  quirks. Rewrite rather than import them, per briefing section 2.1.
- Real `vendorHash`.
- `meta` with license MIT, description, `mainProgram = "spg"`.

## Non-goals
The `ost-specgetty` wrapper is created in the combined env, milestone 06. This
package keeps the upstream binary name `spg`.

## Bias note
specgetty is authored by the owner of this compare repo. That disclosure belongs
in the README (briefing section 3 item 7), not only here.

## Acceptance
- [ ] `nix build .#specgetty` succeeds with a committed real hash
- [ ] `result/bin/spg --help` exits without an error
- [ ] Smoke check `checks.<system>.smoke-specgetty` passes
