# Add ost-compare

Beans epic: `opsx-tuis-compare-flake-vcg7` (milestone 06).
Briefing: section 2.6.

## Why

Six commands on `PATH` with no orientation is not a comparison. `ost-compare`
says what each tool is for, prints the matrices, and opens all of them side by
side on the same project state.

It also settles where the comparison's data lives. The briefing asks for the
same table in the terminal and in the README, and two hand-maintained copies of
a nineteen-row matrix would disagree within a week.

## What Changes

- Add `data/comparison.json`: one source for both matrices, with a provenance
  note behind every soft cell.
- Add `pkgs/ost-compare.nix` and its renderer.
- `--matrix`, `--properties`, `--markdown`, `--json` and `--section` for the
  README generator; `--tmux` for the side-by-side run.
- Add the `comparison-data` scenario enforcing that no cell is undecided
  without an explanation.

## Capabilities

### New Capabilities

- `comparison-data`: what the comparison asserts, what each marker means, and
  what a reader is owed for a cell that is not a plain yes or no.

### Modified Capabilities

None.

## Impact

- `ost-compare` joins `packages.default`, which now exposes nine commands.
- The README in milestone 07 is generated from `data/comparison.json` rather
  than written by hand.
