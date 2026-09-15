# Correct the evidence from hands-on use

Beans epic: `opsx-tuis-compare-flake-aubn` (milestone 07).

## Why

The matrices were filled from source: key tables, binding lists, dependency
manifests. Driving all six tools on the fixture contradicted about a dozen cells
and reversed the headline timing conclusion. Both the wrong cells and the wrong
conclusion were published, so both have to be withdrawn in the same place they
were made.

## What Changes

- Replace the time-to-first-paint property row with time to a usable screen, and
  keep first byte as a separate row labelled as not being responsiveness.
- Correct opsx's feature cells: it renders no content in this build.
- Correct dossier's live reload, specgetty's config tab and markdown handling,
  and neosam's specs and help cells.
- Withdraw two claims from the README and the handover: that startup time splits
  by language, and that the CLI route is cheap.
- Add `tests/lib/drive.py` and `tests/lib/time-to-usable.sh` so the observations
  can be reproduced, and put pyte in the devshell.

## Capabilities

### Modified Capabilities

- `comparison-data`: add the requirement that a cell filled from source is
  superseded by what running the tool shows.

### New Capabilities

None.

## Impact

- `data/comparison.json`, `README.md`, `docs/method.md`, `docs/handover.md`.
- Two new tools under `tests/lib/`, and pyte in the devshell.
