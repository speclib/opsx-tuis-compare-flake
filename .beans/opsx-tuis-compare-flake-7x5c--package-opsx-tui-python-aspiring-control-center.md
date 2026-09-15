---
# opsx-tuis-compare-flake-7x5c
title: Package opsx-tui (Python, aspiring control center)
status: todo
type: epic
priority: normal
created_at: 2026-09-15T10:16:50Z
updated_at: 2026-09-15T10:16:50Z
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
