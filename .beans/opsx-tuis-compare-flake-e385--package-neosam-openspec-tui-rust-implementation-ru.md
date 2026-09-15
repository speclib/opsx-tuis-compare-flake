---
# opsx-tuis-compare-flake-e385
title: Package neosam openspec-tui (Rust, implementation runner)
status: todo
type: epic
priority: high
created_at: 2026-09-15T10:16:14Z
updated_at: 2026-09-15T10:16:14Z
parent: opsx-tuis-compare-flake-3b8w
blocked_by:
    - opsx-tuis-compare-flake-ogon
---

OpenSpec change: `package-neosam`

Upstream: `neosam/openspec-tui`, Rust with ratatui and crossterm, edition 2024,
binary `openspec-tui`, MIT. Ships `Cargo.lock` and a devshell `flake.nix`.
Briefing: inventory row 3, section 2.4.

Not a reader but an implementation runner: batch runs, a dependency graph between
changes, it launches `claude`, and it has a config editor. That shapes several
feature matrix rows.

## Scope
- `pkgs/neosam.nix` using `rustPlatform.buildRustPackage` with
  `cargoLock.lockFile = "${src}/Cargo.lock"`.
- Edition 2024 needs a recent toolchain. Try the plain nixpkgs rustc first. Only
  if that fails, add `rust-overlay` or `fenix` as an input, and record why in the
  change's design.
- `meta` with license MIT, `mainProgram = "openspec-tui"`.

## Non-goals
No wrapper here. Do not add a Rust toolchain input speculatively.

## Acceptance
- [ ] `nix build .#neosam` succeeds
- [ ] `result/bin/openspec-tui --help` exits without an error
- [ ] Smoke check `checks.<system>.smoke-neosam` passes
- [ ] If a toolchain input was added, the design says which build error forced it
