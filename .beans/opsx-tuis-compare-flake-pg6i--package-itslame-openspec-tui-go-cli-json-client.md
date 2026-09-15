---
# opsx-tuis-compare-flake-pg6i
title: Package itslame openspec-tui (Go, CLI JSON client)
status: completed
type: epic
priority: high
created_at: 2026-09-15T10:16:14Z
updated_at: 2026-09-15T10:44:42Z
parent: opsx-tuis-compare-flake-35mq
blocked_by:
    - opsx-tuis-compare-flake-ogon
---

OpenSpec change: `package-itslame`

Upstream: `ItsLame/openspec-tui`, Go, Bubble Tea plus Glamour, binary
`openspec-tui`, MIT.
Briefing: inventory row 5, section 2.4.

Shells out to the `openspec` CLI JSON API rather than parsing files. It already
supports `--store <id>`, and it can validate, archive and toggle tasks from the
TUI. It hard-requires `openspec` on `PATH` at runtime.

## Scope
- `pkgs/itslame.nix` using `buildGoModule`, entrypoint is the repo root
  `main.go`.
- Real `vendorHash`.
- `meta` with license MIT, `mainProgram = "openspec-tui"`.
- Record the runtime `openspec` dependency in the change's design. The wrapper in
  milestone 06 puts `pkgs.openspec` and `pkgs.git` on `PATH`.

## Non-goals
No wrapper here. The upstream binary name `openspec-tui` stays inside this
package output and must never reach `packages.default` unwrapped.

## Acceptance
- [ ] `nix build .#itslame` succeeds with a committed real hash
- [ ] `result/bin/openspec-tui --help` exits without an error
- [ ] Smoke check `checks.<system>.smoke-itslame` passes

## Summary of Changes

`pkgs/itslame.nix` builds the repo root `main.go` with `buildGoModule`. Vendor
hash `sha256-jt2Q+Pq2dpqROcbyhstDgXCMa7E70/XQPQREUiFDSBE=`, resolved by
building. Snapshot stamped over upstream's `var version = "dev"`.

The runtime dependency is confirmed in source and by running it:
`main.go:40` calls `exec.LookPath("openspec")` and exits 1 with an install
hint. Recorded as `passthru.runtimeDeps` for the milestone 06 wrapper.

Noted in `docs/method.md`: `--help` and `--version` run before that check, so
this tool's smoke check proves less than the others'.

Observed from `--help`: `-store string` exists, the only one of the six with
it. A positional `path` selects a workspace, not a change.
