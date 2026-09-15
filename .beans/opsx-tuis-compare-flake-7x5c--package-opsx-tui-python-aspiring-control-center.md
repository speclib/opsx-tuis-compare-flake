---
# opsx-tuis-compare-flake-7x5c
title: Package opsx-tui (Python, aspiring control center)
status: completed
type: epic
priority: normal
created_at: 2026-09-15T10:16:50Z
updated_at: 2026-09-15T10:52:45Z
parent: opsx-tuis-compare-flake-589i
blocked_by:
    - opsx-tuis-compare-flake-ogon
---

OpenSpec change: `package-opsx`

Upstream: `fsmw/opsx-tui`, Python 3.11 to 3.14, Textual plus Pydantic 2,
watchfiles, platformdirs, SQLite and keyring. Binary `opsx-tui`, source under
`src/opsx_tui/`. `pyproject.toml`, no lockfile.
Briefing: inventory row 6, sections 2.4 and 1.

The largest ambition of the six: Kanban board, agent runner and backends, a
security model. The README describes a roadmap rather than shipped behaviour, at
8 commits. Assume it may not run.

## Licensing
GitHub reports GPL-3.0; the README says the license has yet to be defined. Do not
silently assert a license. Set `meta.license = lib.licenses.gpl3Only;` with an
adjacent comment recording the contradiction, and put a line about it in the
README properties matrix.

## Scope
- `pkgs/opsx.nix` using `buildPythonApplication`, `pyproject = true`. The backend
  may be hatchling; check `pyproject.toml`.
- Dependencies from nixpkgs: `textual pydantic watchfiles platformdirs keyring`.
- `pythonRelaxDepsHook` with `pythonRelaxDeps = [ "*" ]`, and `doCheck = false`.

## Non-goals
No wrapper here. Do not implement missing upstream features to make it start.

## Acceptance
- [ ] `nix build .#opsx` succeeds, or `meta.broken = true` with the failure
      recorded in `docs/method.md`
- [ ] The license contradiction is recorded in the nix file and queued for the
      README properties matrix
- [ ] Smoke check passes or is skipped with a stated reason

## Summary of Changes

Builds and runs. The briefing said to assume it may not; it does.

`--help` answers, and given `--project <root>` it renders a header and a board
tab and stays up. Pins relaxed from `textual>=1.0,<3.0` against nixpkgs 8.2.8,
the widest jump of the six.

Three findings that bind later milestones:

- With a clean HOME and no OpenSpec root in cwd it exits 0 after 239 bytes,
  drawing nothing and printing no error. It does not walk up the way the CLI
  does. Its check therefore stays a link-and-help check: a pty start check
  counts a clean early exit as a pass and would claim it started when it had
  not. `each-tool-starts` must pass it `--project`.
- It writes `$XDG_DATA_HOME/opsx-tui/recent-projects.json`, and the `openspec`
  CLI writes `$XDG_CONFIG_HOME/openspec/config.json` with a telemetry id. Both
  reach the real user directories unless redirected, so `ost-demo` must set
  both XDG vars, not only HOME.
- The briefing's SQLite and keyring dependencies are not in `pyproject.toml` nor
  anywhere under `src/opsx_tui/`. They are README roadmap, not shipped code.

License contradiction recorded, not resolved: a GPL-3.0 LICENSE file in the
tree and GitHub reporting GPL-3.0, against a README saying the license has yet
to be defined.
