# Add the demo fixture

Beans epic: `opsx-tuis-compare-flake-j56p` (milestone 05).
Briefing: section 2.5.

## Why

Six tools cannot be compared on six different projects. The fixture is the
control: identical data for all of them, shaped so the differences between the
tools have somewhere to show.

## What Changes

- Add `fixture/` as plain files: two active changes, one archived change, two
  specs.
- Add `pkgs/demo-project.nix` building it into a derivation and validating it
  at build time.
- Add the `fixture-valid` e2e scenario.
- Let a scenario ask for the fixture by using `$OST_FIXTURE`.

## Capabilities

### New Capabilities

- `demo-fixture`: what the shared fixture guarantees to every tool judged on it.

### Modified Capabilities

None.

## Impact

- New `fixture/` tree and `pkgs/demo-project.nix`.
- `packages.<system>.demo-project` and `checks.<system>.e2e-fixture-valid`.
- Any scenario mentioning `$OST_FIXTURE` gets a writable copy.
