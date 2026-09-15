# Package neosam openspec-tui

Beans epic: `opsx-tuis-compare-flake-e385` (milestone 03).
Briefing: inventory row 3, section 2.4.

## Why

neosam is the only Rust tool and the only implementation runner of the six, so
it fills several feature matrix rows nothing else can. Packaging it also
exposes a gap in the harness: this tool has no argument parsing at all, so the
link-and-help check the other tools use is not available for it.

## What Changes

- Add `pkgs/neosam.nix` using `rustPlatform.buildRustPackage` with
  `cargoLock.lockFile`.
- Add `mkStartCheck` to the harness: proves a terminal program starts and stays
  up on a real pty, for tools that cannot answer `--help`.
- Let a package choose its check mode through `passthru.smoke.mode`.

## Capabilities

### Modified Capabilities

- `test-harness`: add the guarantee a pty start check gives, for tools with no
  non-interactive entry point.

### New Capabilities

None.

## Impact

- New file `pkgs/neosam.nix`.
- `packages.<system>.neosam` and `checks.<system>.smoke-neosam` appear, the
  latter as a pty start check rather than a link-and-help check.
- No new flake input: the nixpkgs toolchain builds edition 2024 as is.
