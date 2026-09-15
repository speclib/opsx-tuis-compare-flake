# Add the flake skeleton

Beans epic: `opsx-tuis-compare-flake-ogon` (milestone 01).
Briefing: sections 2.1, 2.3 and 4.

## Why

Nothing in this repo builds yet. Every later epic packages a tool into a flake
that does not exist. The skeleton has to land first, and it has to declare the
shape that the other eight epics plug into, because retrofitting the system list
or the input set later would touch every package file.

## What Changes

- Add `flake.nix` with `nixpkgs` plus the six upstream TUI sources as
  `flake = false` inputs.
- Declare the four supported systems as a literal list mapped with
  `nixpkgs.lib.genAttrs`. No flake-utils, no flake-parts.
- Add `pkgs/default.nix` that assembles the package set. It starts empty and
  each packaging epic adds one entry.
- Add a `lib/version.nix` helper that derives a package version from an input's
  `shortRev` and `lastModifiedDate`, so the snapshot date is visible in the
  README and in `--version` output.
- Add `devShells.<system>.default` with the toolchains needed to hack on the
  flake.
- Commit `flake.lock` pinning all seven inputs.

## Capabilities

### New Capabilities

- `flake-packaging`: the outputs this flake exposes, the systems it supports,
  and how upstream sources enter it.

### Modified Capabilities

None. This is the first change.

## Impact

- New files: `flake.nix`, `flake.lock`, `pkgs/default.nix`, `lib/version.nix`.
- No upstream tool is packaged yet, so `packages.<system>` is empty and
  `packages.default` does not exist until milestone 06.
- `nix flake check` becomes the gate every later change must keep green.
