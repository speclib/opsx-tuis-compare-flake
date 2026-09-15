# Package itslame openspec-tui

Beans epic: `opsx-tuis-compare-flake-pg6i` (milestone 02).
Briefing: inventory row 5, sections 2.4 and 7.

## Why

This is the only tool of the six that drives the `openspec` CLI JSON API rather
than parsing files, which is the exact question the comparison exists to
settle. It is also the only one that already has `--store`, so the fixture's
store axis has something to exercise.

## What Changes

- Add `pkgs/itslame.nix` building the repo root `main.go` with `buildGoModule`,
  vendor hash resolved by building.
- Stamp the snapshot into `main.version`, which upstream defaults to `"dev"`.
- Record that the tool refuses to start without `openspec` on `PATH`, so the
  combined environment in milestone 06 must supply it.

## Capabilities

### Modified Capabilities

- `tool-packaging`: add the rule that a package whose tool needs another
  program at runtime declares that dependency rather than relying on the user's
  environment.

### New Capabilities

None.

## Impact

- New file `pkgs/itslame.nix`.
- `packages.<system>.itslame` and `checks.<system>.smoke-itslame` appear.
- Binds milestone 06: the `ost-itslame` wrapper must put `openspec` on `PATH`.
