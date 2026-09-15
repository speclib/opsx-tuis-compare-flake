---
# opsx-tuis-compare-flake-35mq
title: 02 Package the Go TUIs
status: in-progress
type: milestone
priority: high
created_at: 2026-09-15T10:16:14Z
updated_at: 2026-09-15T10:38:58Z
---

Package the three Go TUIs with `buildGoModule`. Each gets a real `vendorHash`,
resolved by building with `lib.fakeHash` and reading the hash from the error.

Briefing: sections 1, 2.4.

## Exit criteria
- [ ] `nix build .#specgetty .#dossier .#itslame` succeeds
- [ ] No `lib.fakeHash` anywhere in the tree
- [ ] A link-and-help smoke check passes for each of the three
