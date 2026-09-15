# Collect the comparison evidence

Beans epic: `opsx-tuis-compare-flake-rzpk` (milestone 07).
Briefing: sections 3 and 7.

## Why

The matrices are the product. Filling them from READMEs would produce a page
that reads well and is wrong, which is worse than no page.

## What Changes

- Determine every feature and property row for all six tools from running them,
  from their key tables and bindings, and from their dependency manifests.
- Measure time to first paint on a real pty in the tmux popup shape, which the
  briefing calls the most decision-relevant number and which no upstream README
  reports.
- Record the provenance rules in `docs/method.md`.

## Capabilities

### New Capabilities

None. The contract for this data landed with `comparison-data`; this change
fills it in. `.openspec.yaml` sets `skip_specs: true`.

### Modified Capabilities

None.

## Impact

- `data/comparison.json` gains a first-paint property row.
- `tests/lib/first-paint.py` is added.
- `docs/method.md` gains the evidence hierarchy and the timings.
