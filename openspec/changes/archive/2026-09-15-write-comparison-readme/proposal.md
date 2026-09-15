# Write the comparison README

Beans epic: `opsx-tuis-compare-flake-iciq` (milestone 07).
Briefing: section 3.

## Why

The README is what someone lands on. The briefing fixes its order because a
reader wants the verdict and then the evidence, and it requires the bias
disclosure on the page because without it the artifact is worthless as a
comparison.

## What Changes

- Add `docs/README.template.md` with the prose and three placeholders.
- Add `pkgs/readme.nix` generating `README.md` from the template and the
  comparison data.
- Replace the scaffold README with the generated one.
- Add `checks.<system>.readme-is-current`, which fails when the committed file
  has drifted from what the data produces.

## Capabilities

### Modified Capabilities

- `comparison-data`: add the requirement that the published page is generated
  rather than transcribed, and that drift fails the gate.

### New Capabilities

None.

## Impact

- `README.md` becomes a generated file. Editing its tables by hand is caught.
- `packages.<system>.readme` appears.
