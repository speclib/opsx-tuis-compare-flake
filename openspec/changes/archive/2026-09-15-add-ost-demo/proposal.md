# Add ost-demo

Beans epic: `opsx-tuis-compare-flake-pzo1` (milestone 06).
Briefing: section 2.5.

## Why

The comparison asks six tools to write to a project. Nothing in it may write to
the user's real projects or their real OpenSpec store registry, and asking
people to be careful is not a mechanism.

## What Changes

- Add `pkgs/ost-demo.nix`: copies the fixture and the store root to a throwaway
  directory, redirects `HOME` and every `XDG_*` base into it, registers the
  demo store there, and drops you in a shell.
- Let it take a command, so a test can drive it without a terminal.
- Add the `fixture-writable` and `no-host-writes` scenarios.

## Capabilities

### Modified Capabilities

- `combined-environment`: add what the demo entry point guarantees about
  writability and about not touching the host.

### New Capabilities

None.

## Impact

- `ost-demo` joins `packages.default`.
- Two more scenarios, one of which is the strongest guarantee in the repo.
