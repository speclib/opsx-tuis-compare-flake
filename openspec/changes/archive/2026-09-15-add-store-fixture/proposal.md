# Add the store fixture

Beans epic: `opsx-tuis-compare-flake-idhw` (milestone 05).
Briefing: sections 2.5 and 7.

## Why

Stores are the axis the next briefing turns on, and only one of the six tools
accepts `--store`. Without a registered store there is nothing to point that
flag at and nothing to observe the other five doing.

## What Changes

- Add `fixture-store/` as a second OpenSpec root, and
  `pkgs/demo-store.nix` building and validating it.
- Add the `store-resolution` scenario, which registers the store inside the
  build sandbox and proves the registry lands there and nowhere else.
- Let a scenario ask for the store by using `$OST_STORE_ROOT`.

## Capabilities

### Modified Capabilities

- `demo-fixture`: add what the store root guarantees and where its registration
  is allowed to land.

### New Capabilities

None.

## Impact

- New `fixture-store/` tree and `pkgs/demo-store.nix`.
- `packages.<system>.demo-store` and `checks.<system>.e2e-store-resolution`.
