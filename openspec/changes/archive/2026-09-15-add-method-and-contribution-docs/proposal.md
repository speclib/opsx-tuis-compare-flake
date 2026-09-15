# Add the method and contribution docs

Beans epic: `opsx-tuis-compare-flake-qhwf` (milestone 07).
Briefing: section 3 item 6, section 4, and the section 5 degradation rule.

## Why

A comparison whose method is not written down cannot be checked, and a repo
that cannot take a seventh tool is a one-off rather than a concept.

## What Changes

- `docs/method.md`: what each marker means, the evidence hierarchy, how the
  timings were taken, every falsification performed, the CLI spinner trap, and
  the degradations section.
- `docs/adding-a-tool.md`: the four files a new tool touches and the rules for
  its matrix cells.

## Capabilities

### New Capabilities

None. Documentation of behaviour already specified elsewhere.
`.openspec.yaml` sets `skip_specs: true`.

### Modified Capabilities

None.

## Impact

- Two documents. No flake output changes.
