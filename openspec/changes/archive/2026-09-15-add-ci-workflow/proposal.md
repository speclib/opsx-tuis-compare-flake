# Add the CI workflow

Beans epic: `opsx-tuis-compare-flake-59th` (milestone 01).
Briefing: section 4.

## Why

The gate only means something if it runs somewhere other than the machine that
wrote the code. The briefing asks CI to prove one system, which is enough to
catch the failure that matters here: a file that builds locally because it is
untracked, or a hash that was never committed.

## What Changes

- Add `.github/workflows/build.yml` running `nix flake check` on
  `ubuntu-latest`, x86_64-linux only.
- Build `packages.default` when it exists, tolerating its absence until
  milestone 06 creates it.
- Run on push to `main` and on pull requests.

## Capabilities

### New Capabilities

None. This change adds no observable behaviour to the artifact people install;
it only runs the existing gate somewhere else. `.openspec.yaml` sets
`skip_specs: true` accordingly.

### Modified Capabilities

None.

## Impact

- New file `.github/workflows/build.yml`.
- No change to any flake output.
