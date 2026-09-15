---
# opsx-tuis-compare-flake-o2us
title: Package dossier (Go, filesystem reader)
status: todo
type: epic
priority: high
created_at: 2026-09-15T10:16:14Z
updated_at: 2026-09-15T10:16:14Z
parent: opsx-tuis-compare-flake-35mq
blocked_by:
    - opsx-tuis-compare-flake-ogon
---

OpenSpec change: `package-dossier`

Upstream: `fselich/dossier`, Go 1.25, Bubble Tea style, binary `dossier`, MIT.
Briefing: inventory row 2, section 2.4.

Reads the filesystem directly. Requires `.openspec.yaml` inside each change
directory to see the change at all, which constrains the fixture in milestone 05.
The most mature of the readers at 90 commits.

## Scope
- `pkgs/dossier.nix` using `buildGoModule`, entrypoint `cmd/dossier`.
- Real `vendorHash`.
- `meta` with license MIT, `mainProgram = "dossier"`.
- Record the `.openspec.yaml` requirement in the change's design so the fixture
  epic picks it up.

## Non-goals
No wrapper here. No fixture work here.

## Acceptance
- [ ] `nix build .#dossier` succeeds with a committed real hash
- [ ] `result/bin/dossier --help` exits without an error
- [ ] Smoke check `checks.<system>.smoke-dossier` passes
