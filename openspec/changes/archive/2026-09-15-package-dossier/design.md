# Design: package dossier

## Vendor hash

Resolved by building with `lib.fakeHash` and reading the error:

```
specified: sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
   got:    sha256-i/egmQk0UHU4RqeKZtHXRQ2mSpWO0I9cLJNmKQ0ED5A=
```

The real hash is committed. The placeholder existed only between those two
builds and is not in any commit.

## Version stamping

`cmd/dossier/main.go` declares `var version string` and prints it for
`--version`. With nothing linked in, the built binary answers `dossier ` with a
trailing space and no version, which would make the properties matrix row a
lie. `ldflags` sets `-X main.version=<snapshot>`, so it now answers
`dossier 0-unstable-2026-07-23+31551e7`.

specgetty is deliberately left alone: it compiles its own `0.2.0` in, and
overwriting an upstream's real version would be worse than leaving a gap.

## Observations for the matrices

Read in `internal/openspec/loader.go`, so these are source observations rather
than README claims:

- A change directory passed directly on the command line must contain
  `.openspec.yaml`, or loading fails with "not a valid change directory
  (missing .openspec.yaml)" (loader.go:249).
- When scanning `openspec/changes/`, `.openspec.yaml` is read as optional
  metadata and its absence is tolerated (loader.go:274).
- `openspec/changes/archive/` is scanned separately and excluded from the
  active list, so archived changes are browsable (loader.go:181).
- `--help` shows `[path]`, a `--theme` flag with dark, none, light and dracula,
  and no `--store` flag.

The first point is the tighter constraint on the fixture: the demo project must
carry `.openspec.yaml` in each change directory for the single-path route to
work at all.
