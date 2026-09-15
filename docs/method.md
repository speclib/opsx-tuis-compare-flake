# Method

How each claim in this repo was determined, and what every marker means.

## Provenance markers

| Marker | Meaning                                                        |
|--------|----------------------------------------------------------------|
| yes    | Observed by running the tool, or read directly in its source    |
| no     | Observed absent by running the tool, or absent from its source  |
| part   | Present but incomplete, or inferred from a README not from a run |
| ?      | Could not be determined. The footnote says what was tried        |

A cell is never filled from a README claim alone without being marked `part`.

## Platform support

`x86_64-darwin` is not a declared system. The pinned nixpkgs refuses to
evaluate for it:

```
error: Nixpkgs 26.11 has dropped support for x86_64-darwin.

The 26.05 stable branch still supports x86_64-darwin, and will
receive security fixes until the end of 2026.
```

This is an evaluation failure rather than a build failure, so declaring the
platform would make `nix flake check --all-systems` fail for every output,
including the devshell. Pinning nixpkgs to `nixpkgs-26.05-darwin` instead would
hold the whole comparison on a branch older than several upstreams' Go and
Python requirements. Declared systems are therefore `x86_64-linux`,
`aarch64-linux` and `aarch64-darwin`.

## Upstream snapshots

Every tool is built from a revision pinned in `flake.lock`. The package version
records it as `0-unstable-<date>+<shortRev>`, and `nix eval .#lib.versions`
prints the whole set.

## Degradations

None yet.
