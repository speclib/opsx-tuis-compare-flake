# Verify the acceptance criteria

Beans epic: `opsx-tuis-compare-flake-twv4` (milestone 08).
Briefing: section 5.

## Why

The gate has been green throughout, but always in the working tree. A criterion
list is worth checking from a clean clone, because that is the only thing that
catches a file the gate saw only because it was untracked on disk.

## What Changes

- Clone the repository to a temporary directory and walk all six criteria
  there.
- Record the commands and their real output in `docs/acceptance.md`.
- Record the degradation report and the known gaps.

## Capabilities

### New Capabilities

None. This change verifies existing behaviour and records the result.
`.openspec.yaml` sets `skip_specs: true`.

### Modified Capabilities

None.

## Impact

- New `docs/acceptance.md`. No flake output changes.
