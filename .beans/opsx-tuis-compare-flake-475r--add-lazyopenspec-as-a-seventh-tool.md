---
# opsx-tuis-compare-flake-475r
title: Add lazyopenspec as a seventh tool
status: completed
type: epic
priority: normal
created_at: 2026-09-15T13:44:58Z
updated_at: 2026-09-15T13:55:07Z
parent: opsx-tuis-compare-flake-2kzu
---

ItsLame has a second, newer terminal interface: `ItsLame/lazyopenspec`, pushed
2026-09-02 against 2026-07-03 for `ItsLame/openspec-tui`.

It is the same lineage (same internal package layout, still drives the openspec
CLI, keeps `--store`) but a different program to use, so it earns its own row.

## What is different

- lazygit-style stacked numbered panels (Changes, Specs, Archive) plus a detail
  pane and a command log, against the old two-pane layout.
- Actions moved behind an `x` menu with confirm prompts.
- Search gained `n` and `N` match navigation.
- A command log records what it ran, with a guard against concurrent commands.
- `$EDITOR` support is gone: no reference to it anywhere in the new source.
- No LICENSE file. The old repo carries MIT.
- 3422 lines against 2489, and the binary is `lazyopenspec`, which collides with
  nothing.

Neither README mentions the other, so this is recorded as a second tool by the
same author rather than as a replacement.

## Naming

`ost-<author>` cannot disambiguate two tools by one author. The suffix becomes
the project name where the author is ambiguous, so this is `ost-lazyopenspec`.

## Summary of Changes

Added as a seventh tool. `packages.default` now exposes ten commands.

Everything in its matrix row is observed, not read: panels [1] Changes, [2] Specs
and [3] Archive, a thirteen-entry `?` overlay, an `x` actions menu with validate,
apply instructions and archive, and a space toggle that took the change from 3/7
to 4/7 by the CLI's own count.

Two things it dropped against its predecessor: the `$EDITOR` binding and the
positional path argument. And it has no LICENSE file where the older repo is MIT,
so `meta.license` is left unset rather than inheriting the neighbour's. That
surfaced a latent assumption in the wrapper, which copied `license` from every
package and failed to evaluate without one.

The naming rule needed refining: `ost-<author>` cannot separate two tools by one
author, so the suffix is now the shortest thing that identifies the tool. Only
these two use the project name; no existing command name changed.

The finding worth keeping: 5109 ms to a usable screen against its predecessor's
5101 ms, both finishing 2 runs in 5. Two codebases, one author, the same cost, so
the five seconds is not an accident of the older implementation.

`e2e-each-tool-starts` caught the addition immediately by its count assertion,
which is what that assertion was built for.
