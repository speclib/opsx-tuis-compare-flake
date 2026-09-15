# Package specgetty

Beans epic: `opsx-tuis-compare-flake-juf8` (milestone 02).
Briefing: inventory row 1, section 2.4.

## Why

specgetty is the first tool into the flake, so this change also settles how
every later tool gets packaged and smoke-checked. It is a good first choice
because upstream ships a working `package.nix`, which means a build failure
here is this repo's fault rather than an upstream mystery.

## What Changes

- Add `pkgs/specgetty.nix` building with `buildGoModule` from the pinned
  `src-specgetty` input.
- Register it in `pkgs/default.nix`.
- Let a package declare how it is smoke-checked through `passthru.smoke`, and
  generate `checks.<system>.smoke-<name>` from the package set.

## Capabilities

### New Capabilities

- `tool-packaging`: what packaging a tool into this flake guarantees, and how a
  tool joins the check set.

### Modified Capabilities

None.

## Impact

- New file `pkgs/specgetty.nix`.
- `packages.<system>.specgetty` and `checks.<system>.smoke-specgetty` appear.
- `flake.nix` gains the package set in its check scope. It will not need
  editing again when the next five tools land.

## Bias

specgetty is authored by the owner of this repo. The README carries that
disclosure; it is repeated here so the packaging change is not the only place a
reader could miss it.
