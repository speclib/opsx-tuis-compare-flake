# Add the combined environment

Beans epic: `opsx-tuis-compare-flake-ix26` (milestone 06).
Briefing: sections 2.2 and 2.3.

## Why

This is the headline promise of the repo: one command and every tool is on
`PATH` at once. It is also where the design's single hardest constraint bites,
since three of the six upstream projects install a binary called
`openspec-tui`.

## What Changes

- Add `pkgs/ost-env.nix` building `packages.<system>.default` as a `buildEnv`
  of one wrapper per usable tool, plus the `openspec` CLI.
- Expose each tool as `ost-<author>`, generated from the package set.
- Give every wrapper the runtime `PATH` its tool needs.
- Add `apps.<system>.<name>` so `nix run .#itslame` works.
- Add the `default-env` and `no-name-collision` scenarios.

## Capabilities

### New Capabilities

- `combined-environment`: what a consumer gets on `PATH`, and what is
  guaranteed never to be there.

### Modified Capabilities

None.

## Impact

- `packages.<system>.default` exists for the first time, so the CI step that
  skipped it starts running.
- `apps.<system>.*` appear.
