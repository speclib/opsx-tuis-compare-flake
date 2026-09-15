# Design: package itslame openspec-tui

## Vendor hash

Resolved by building and reading the mismatch:

```
specified: sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
   got:    sha256-jt2Q+Pq2dpqROcbyhstDgXCMa7E70/XQPQREUiFDSBE=
```

## The runtime CLI dependency is real, and it is checked early

`main.go:40` does `exec.LookPath("openspec")` before anything else and exits 1
with an installation hint when it fails. Observed directly:

```
$ env -i PATH=/bin HOME=/tmp openspec-tui
openspec-tui: the 'openspec' CLI was not found on your PATH.
Install it with:  npm install -g @fission-ai/openspec
then ensure it is on PATH and retry.
```

This is recorded in the package as `passthru.runtimeDeps`, which milestone 06
reads when it builds the wrapper. Wrapping here instead would put a second
binary name into the individual package output and defeat the point of keeping
`ost-` names to the combined environment.

`--version` and `--help` run before the `LookPath` call, which is why the
link-and-help smoke check passes without `openspec` present. That is worth
knowing: the smoke check genuinely proves less for this tool than for the
others, and `docs/method.md` says so.

## Observations for the matrices

From `--help`, so observed rather than inferred:

- `-store string` exists: "OpenSpec store id to use as the workspace root".
  This is the only one of the six with it.
- A positional `path` argument selects "directory containing an openspec/ root",
  so the unit is a workspace, not a single change.
- `internal/openspec/workspace.go:55` builds `openspec/changes/archive`, so
  archived changes are reachable.
- `internal/openspec/client.go:62` runs the CLI through `exec.CommandContext`,
  confirming the JSON API route rather than file parsing.
