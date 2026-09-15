---
# opsx-tuis-compare-flake-mqfc
title: Package mstanton openspec-tui (Python, Textual authoring tool)
status: todo
type: epic
priority: normal
created_at: 2026-09-15T10:16:50Z
updated_at: 2026-09-15T10:16:50Z
parent: opsx-tuis-compare-flake-589i
blocked_by:
    - opsx-tuis-compare-flake-ogon
---

OpenSpec change: `package-mstanton`

Upstream: `mstanton/openspec-tui`, Python 3.8+, Textual, binaries
`openspec-tui` and `openspec-tui-editor`. `pyproject.toml`, no lockfile.
Briefing: inventory row 4, section 2.4.

Authoring and editor angle: it creates changes from templates. Three commits.
The README contains copy-paste errors and points at `Fission-AI/openspec-tui`.
Treat it as low-fidelity evidence. The README claims MIT but there is no LICENSE
file in the tree, which the properties matrix must state.

## Scope
- `pkgs/mstanton.nix` using `python3Packages.buildPythonApplication` with
  `pyproject = true`. Check the real build backend in `pyproject.toml`.
- Dependency `textual` from nixpkgs.
- `pythonRelaxDepsHook` with `pythonRelaxDeps = [ "*" ]`, and `doCheck = false`.
- `meta.license` MIT with an adjacent comment recording that the claim comes from
  the README and no LICENSE file exists in the tree.

## Non-goals
No wrapper here. Do not fix upstream's README errors.

## Acceptance
- [ ] `nix build .#mstanton` succeeds, or `meta.broken = true` with the failure
      recorded in `docs/method.md`
- [ ] If it builds, `result/bin/openspec-tui --help` exits without an error
- [ ] Smoke check passes or is skipped with a stated reason
