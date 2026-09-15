# Package dossier

Beans epic: `opsx-tuis-compare-flake-o2us` (milestone 02).
Briefing: inventory row 2, section 2.4.

## Why

dossier is the most mature of the readers and the one whose data-source
assumptions constrain the fixture, so packaging it early tells milestone 05
what the demo project has to contain.

## What Changes

- Add `pkgs/dossier.nix` building `cmd/dossier` with `buildGoModule` from the
  pinned input, with a vendor hash resolved by building.
- Stamp the snapshot into the binary's version, because upstream declares
  `var version string` and leaves it empty outside a release build.
- Register the package and its smoke check.

## Capabilities

### Modified Capabilities

- `tool-packaging`: add the rule for stamping a version an upstream leaves
  unset at build time.

### New Capabilities

None.

## Impact

- New file `pkgs/dossier.nix`.
- `packages.<system>.dossier` and `checks.<system>.smoke-dossier` appear.
- Constrains milestone 05: the fixture needs `.openspec.yaml` in change
  directories and an `archive/` directory.
