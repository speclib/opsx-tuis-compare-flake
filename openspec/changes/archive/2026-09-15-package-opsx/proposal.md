# Package opsx-tui

Beans epic: `opsx-tuis-compare-flake-7x5c` (milestone 04).
Briefing: inventory row 6, sections 2.4, 2.5 and 5.

## Why

The last of the six and the one the briefing said to assume may not run. It
does run, but only when it can resolve a project, and it fails silently when it
cannot. Establishing that now decides how the harness has to invoke it in
milestones 06 and 08.

## What Changes

- Add `pkgs/opsx.nix` using `buildPythonApplication` with the setuptools
  backend and the src layout.
- Relax the dependency pins, a wider jump than any other tool here.
- Record the license contradiction in the package rather than resolving it.
- Record two observed behaviours that bind later milestones: the silent exit
  when no project resolves, and the per-user state both this tool and the
  `openspec` CLI write outside the repo.

## Capabilities

### Modified Capabilities

- `tool-packaging`: add the rule that a tool writing per-user state has that
  recorded, because the comparison harness must sandbox it.

### New Capabilities

None.

## Impact

- New file `pkgs/opsx.nix`. All six tools are now packaged, none degraded.
- Binds milestone 06: `ost-demo` must set `XDG_DATA_HOME` and `XDG_CONFIG_HOME`,
  not only `HOME`.
- Binds milestone 08: `each-tool-starts` must pass this tool an explicit
  project, or it will exit 0 without starting and the scenario would pass
  vacuously.
