# Cut the alpha release

Beans epic: `opsx-tuis-compare-flake-xkgo` (milestone 08).

## Why

The proof of concept is meant to be an alpha base for later development, so it
has to end in a state someone else can pick up without reconstructing the
reasoning from commit messages.

## What Changes

- Refresh `docs/roadmap.md` from beans.
- Add `docs/handover.md`: what works, what the comparison found, what is
  deliberately not done, and where the gaps are.
- Tag `v0.1.0-alpha` and push.

## Capabilities

### New Capabilities

None. `.openspec.yaml` sets `skip_specs: true`.

### Modified Capabilities

None.

## Impact

- Two documents and a tag.
