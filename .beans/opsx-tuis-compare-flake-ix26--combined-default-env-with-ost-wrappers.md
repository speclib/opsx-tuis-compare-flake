---
# opsx-tuis-compare-flake-ix26
title: Combined default env with ost-* wrappers
status: todo
type: epic
priority: high
created_at: 2026-09-15T10:17:15Z
updated_at: 2026-09-15T10:17:15Z
parent: opsx-tuis-compare-flake-41i5
blocked_by:
    - opsx-tuis-compare-flake-juf8
    - opsx-tuis-compare-flake-o2us
    - opsx-tuis-compare-flake-pg6i
    - opsx-tuis-compare-flake-e385
    - opsx-tuis-compare-flake-mqfc
    - opsx-tuis-compare-flake-7x5c
---

OpenSpec change: `add-default-env`

Briefing: sections 2.2 and 2.3.

The naming scheme is non-negotiable. Three upstream projects install a binary
called `openspec-tui`; they cannot coexist on one `PATH`.

| Package attr | Exposed command | Wraps          |
|--------------|-----------------|----------------|
| `specgetty`  | `ost-specgetty` | `spg`          |
| `dossier`    | `ost-dossier`   | `dossier`      |
| `neosam`     | `ost-neosam`    | `openspec-tui` |
| `mstanton`   | `ost-mstanton`  | `openspec-tui` |
| `itslame`    | `ost-itslame`   | `openspec-tui` |
| `opsx`       | `ost-opsx`      | `opsx-tui`     |

## Scope
- Per-tool wrappers via `makeWrapper` or `writeShellApplication` producing
  `$out/bin/ost-<author>`, each with
  `--prefix PATH : ${lib.makeBinPath [ pkgs.openspec pkgs.git ]}`.
- `packages.<system>.default` as a `buildEnv` or `symlinkJoin` of the six
  wrappers plus `ost-compare`, `ost-demo` and the `openspec` CLI.
- `apps.<system>.<name>` so `nix run .#itslame` works.
- Any tool marked `meta.broken = true` is excluded from `packages.default` and
  its absence is recorded.

## Why wrappers and not the raw packages
Only the combined env exposes the `ost-*` names. Each individual package keeps
its upstream binary name, so three `openspec-tui` symlinks never race inside one
`buildEnv`.

## Acceptance
- [ ] `nix build .#default && ls result/bin` lists only the expected commands
- [ ] e2e scenario `default-env` passes
- [ ] e2e scenario `no-name-collision` passes
- [ ] `nix run .#itslame -- --help` works
