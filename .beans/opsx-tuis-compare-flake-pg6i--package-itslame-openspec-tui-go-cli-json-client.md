---
# opsx-tuis-compare-flake-pg6i
title: Package itslame openspec-tui (Go, CLI JSON client)
status: todo
type: epic
priority: high
created_at: 2026-09-15T10:16:14Z
updated_at: 2026-09-15T10:16:14Z
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
