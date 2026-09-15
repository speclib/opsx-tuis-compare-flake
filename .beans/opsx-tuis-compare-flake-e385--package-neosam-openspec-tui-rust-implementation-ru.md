---
# opsx-tuis-compare-flake-e385
title: Package neosam openspec-tui (Rust, implementation runner)
status: completed
type: epic
priority: high
created_at: 2026-09-15T10:16:14Z
updated_at: 2026-09-15T10:47:31Z
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

## Summary of Changes

`pkgs/neosam.nix` builds with `rustPlatform.buildRustPackage` and
`cargoLock.lockFile`. No toolchain input was added: nixpkgs rustc 1.98.1
accepts edition 2024 and resolved all 249 locked packages, so the briefing's
escape hatch to `fenix` or `rust-overlay` was not needed.

This tool has no argument parsing. Without a terminal it exits 1 with
`Os { code: 6, ... "No such device or address" }`, which is ENXIO from opening
`/dev/tty`, so a link-and-help check is unavailable rather than merely awkward.

Added `mkStartCheck` to the harness: a real pty, a bounded wait, pass only if
the program is still up, and no assertion about what was drawn. Verified it
works inside the Nix build sandbox with no sandbox relaxation. Falsified
against a binary that exits 4. A package picks its mode with
`passthru.smoke.mode`, because which check is honest is a fact about the tool.
