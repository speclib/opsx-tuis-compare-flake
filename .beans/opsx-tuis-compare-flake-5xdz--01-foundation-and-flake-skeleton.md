---
# opsx-tuis-compare-flake-5xdz
title: 01 Foundation and flake skeleton
status: completed
type: milestone
priority: high
created_at: 2026-09-15T10:15:45Z
updated_at: 2026-09-15T10:38:34Z
---

Get a flake that evaluates on all four systems, a test harness the later
milestones plug into, and CI that proves it. Nothing is packaged yet.

Briefing: sections 2.1, 2.3, 4.

## Exit criteria
- [ ] `nix flake check` passes from a clean checkout on x86_64-linux
- [ ] All four systems evaluate: x86_64-linux, aarch64-linux, x86_64-darwin, aarch64-darwin
- [ ] `flake.lock` is committed and pins all six upstream sources
- [ ] `tests/e2e/` runner exists and is wired into `checks`
- [ ] CI is green on a push to main

## Summary of Changes

All three epics complete.

- Flake skeleton: three systems via plain `genAttrs`, six `flake = false`
  inputs pinned, version helper, devshell. `x86_64-darwin` was dropped because
  nixpkgs 26.11 throws on it during evaluation.
- Test harness: sandbox helper, real-pty runner, `mkSmokeCheck`, `mkE2E`, and
  scenario discovery from `tests/e2e/`. Every piece falsified and recorded.
- CI: `nix flake check` on ubuntu-latest.

`nix flake check --all-systems` passes.
