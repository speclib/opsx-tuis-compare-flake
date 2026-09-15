---
# opsx-tuis-compare-flake-ogon
title: Flake skeleton with plain genAttrs multi-system support
status: todo
type: epic
priority: high
created_at: 2026-09-15T10:15:45Z
updated_at: 2026-09-15T10:15:45Z
parent: opsx-tuis-compare-flake-5xdz
---

OpenSpec change: `add-flake-skeleton`

Briefing: sections 2.1, 2.3, 4, and the "Required flake skeleton shape" block in
CLAUDE.md.

## Scope
- `flake.nix` with `nixpkgs` plus the six `flake = false` upstream sources.
- Systems declared as a literal list, mapped with `nixpkgs.lib.genAttrs`.
  flake-utils and flake-parts are forbidden.
- `pkgs/default.nix` assembling an initially empty package set.
- `devShells.<system>.default` with go, cargo, python3, nix tooling, jj and tmux.
- `flake.lock` committed.
- Version strings derived from each input's `shortRev` and `lastModifiedDate`, so
  the snapshot date is visible in `--version` output and the README.

## Non-goals
No packages are built in this epic. The package set may be empty.

## Acceptance
- [ ] `nix flake check` passes
- [ ] `nix flake show` lists the four systems
- [ ] `nix develop` drops into a shell with go, cargo and python3 present
- [ ] grep finds no `flake-utils` and no `flake-parts` in the tree
