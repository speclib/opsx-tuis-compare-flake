# Package mstanton openspec-tui

Beans epic: `opsx-tuis-compare-flake-mqfc` (milestone 04).
Briefing: inventory row 4, sections 2.4 and 5.

## Why

The first of the two Python tools, and the first candidate for the briefing's
degradation rule. Neither Python repo ships a lockfile, so both are built
against whatever nixpkgs has, and this one pins `textual>=0.41,<1.0` against a
nixpkgs carrying 8.2.8. Whether that still runs is the question this change
answers.

## What Changes

- Add `pkgs/mstanton.nix` using `buildPythonApplication` with setuptools.
- Relax the dependency pins, which is the only way to build against the single
  nixpkgs this flake has.
- Record the license situation: MIT is claimed in `pyproject.toml` and the
  README, and there is no LICENSE file in the tree.
- Verify by hand that the relaxed build is not merely starting but rendering,
  since a pty start check cannot tell a working program from a framework error
  screen.

## Capabilities

### Modified Capabilities

- `tool-packaging`: add the rule that a relaxed dependency pin is a build
  decision which must be verified by running the tool, not assumed.

### New Capabilities

None.

## Impact

- New file `pkgs/mstanton.nix`.
- `packages.<system>.mstanton` and `checks.<system>.smoke-mstanton` appear.
- The package installs three entry points, of which the combined environment
  will expose one.
