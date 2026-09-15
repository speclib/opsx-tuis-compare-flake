---
# opsx-tuis-compare-flake-o2us
title: Package dossier (Go, filesystem reader)
status: completed
type: epic
priority: high
created_at: 2026-09-15T10:16:14Z
updated_at: 2026-09-15T10:42:40Z
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

## Summary of Changes

`pkgs/dossier.nix` builds `cmd/dossier` with `buildGoModule`. Vendor hash
resolved by building with a placeholder and reading the mismatch:
`sha256-i/egmQk0UHU4RqeKZtHXRQ2mSpWO0I9cLJNmKQ0ED5A=`. No placeholder reached a
commit.

`main.go` declares `var version string` and printed a bare `dossier ` with no
version, so `ldflags` now stamps the snapshot. specgetty is left alone because
it compiles its own version in.

Source observations that constrain milestone 05, read in
`internal/openspec/loader.go`: a change directory passed directly on the
command line must contain `.openspec.yaml` (loader.go:249); when scanning
`openspec/changes/` its absence is tolerated (loader.go:274); and
`changes/archive/` is scanned separately so archived changes are browsable
(loader.go:181).
