---
# opsx-tuis-compare-flake-59th
title: CI workflow running nix flake check
status: todo
type: epic
priority: normal
created_at: 2026-09-15T10:15:45Z
updated_at: 2026-09-15T10:15:45Z
parent: opsx-tuis-compare-flake-5xdz
blocked_by:
    - opsx-tuis-compare-flake-ogon
---

OpenSpec change: `add-ci-workflow`

Briefing: section 4. CI only needs to prove one system.

## Scope
- `.github/workflows/build.yml` running `nix flake check` on `ubuntu-latest`,
  x86_64-linux only, with the Nix installer and flakes enabled.
- A build step for `packages.default` once it exists, tolerant of it being absent
  early.

## Non-goals
No macOS runners. No binary cache publishing. No release automation.

## Acceptance
- [ ] Workflow file is valid and runs `nix flake check`
- [ ] A push to main produces a green run
