# Add lazyopenspec as a seventh tool

Beans epic: `opsx-tuis-compare-flake-475r` (milestone 07).

## Why

ItsLame has a second, newer terminal interface. It shares a lineage with
`ItsLame/openspec-tui` but is a different program to use, and it is the first
case of one author shipping two tools, which the naming scheme did not survive
unchanged.

## What Changes

- Add `src-lazyopenspec` as a pinned `flake = false` input.
- Add `pkgs/lazyopenspec.nix`, with no `meta.license`, because the repository
  declares none.
- Let the wrapper carry a license through only when the package declares one.
- Refine the naming rule: the suffix is the author, except where one author
  ships two tools.
- Add it to the comparison data from observation, and to `each-tool-starts`.

## Capabilities

### Modified Capabilities

- `combined-environment`: state the naming rule for an author with more than one
  tool, and that a package without a license does not acquire one.

### New Capabilities

None.

## Impact

- `packages.default` exposes ten commands.
- The matrix gains a seventh column.
