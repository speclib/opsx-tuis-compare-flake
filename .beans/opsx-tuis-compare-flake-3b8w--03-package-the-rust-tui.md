---
# opsx-tuis-compare-flake-3b8w
title: 03 Package the Rust TUI
status: completed
type: milestone
priority: high
created_at: 2026-09-15T10:16:14Z
updated_at: 2026-09-15T10:47:31Z
---

Package the one Rust TUI with `rustPlatform.buildRustPackage`.

Briefing: inventory row 3, section 2.4.

## Exit criteria
- [ ] `nix build .#neosam` succeeds
- [ ] A link-and-help smoke check passes

## Summary of Changes

The one Rust tool builds from the plain nixpkgs toolchain, no extra input. Its
check is a pty start check rather than link-and-help, because the tool has no
non-interactive entry point at all.
