# Design: flake skeleton

## Input set

Seven inputs: `nixpkgs` plus six upstream sources. Every upstream source is
`flake = false`, including specgetty and neosam which ship their own flake. The
briefing calls this out in section 2.1: uniform packaging in one place gives
uniform wrapper names, uniform `meta` and uniform version strings, and it stops
an upstream output rename from breaking this repo.

### mstanton needs an explicit branch in its URL

`nix flake prefetch github:mstanton/openspec-tui` fails from this network with:

```
error: unable to download
'https://api.github.com/repos/mstanton/openspec-tui/commits/HEAD':
HTTP error 504
```

The repository exists and `https://api.github.com/repos/mstanton/openspec-tui`
returns 200, so this is the proxy failing on the bare `HEAD` resolution, not a
missing repo. Naming the branch in the URL (`github:mstanton/openspec-tui/main`)
takes a different resolution path and succeeds. Once `flake.lock` pins the rev,
the lock is used and the branch name stops mattering.

## Version derivation

`lib/version.nix` takes an input and returns
`0-unstable-<YYYY-MM-DD>+<shortRev>`. The date comes from `lastModifiedDate`,
which flakes expose as a `YYYYMMDDHHMMSS` string, so it is sliced rather than
parsed. `shortRev` is absent when an input is a local path, so the helper falls
back to `dirty` in that case rather than throwing during evaluation.

This keeps the briefing's requirement that a build is honest about being a
snapshot of a date without inventing a semantic version the upstream never
published.

## Package set assembly

`pkgs/default.nix` takes `{ pkgs, inputs }` and returns an attribute set. It
starts as an empty set plus the version helper wired in. Each packaging epic
adds exactly one line. Keeping assembly in one file rather than inlining it in
`flake.nix` means a packaging change never touches `flake.nix`, so the system
list and the input set stay stable across the run.

## What this change deliberately does not do

No wrappers, no `packages.default`, no apps and no fixture. `packages.default`
cannot exist until there is something to put in it, and the briefing's naming
scheme only bites in the combined environment. Milestone 06 owns both.

Checks are wired here as an empty-but-valid attribute set so `nix flake check`
has a shape to grow into. The test harness epic fills it.

## Three systems, not four

The briefing asks for `x86_64-linux`, `aarch64-linux`, `x86_64-darwin` and
`aarch64-darwin`. The pinned nixpkgs refuses the third:

```
error: Nixpkgs 26.11 has dropped support for x86_64-darwin.

The 26.05 stable branch still supports x86_64-darwin, and will
receive security fixes until the end of 2026.
```

This is a hard evaluation failure, not a build failure. Declaring
`x86_64-darwin` makes `nix flake check --all-systems` fail on every output
including the devshell, so the flake would stop being checkable.

The alternatives were to pin nixpkgs to `nixpkgs-26.05-darwin`, which would
hold the whole comparison back on a stable branch that predates several of the
upstream tools' Go and Python requirements, or to add a second nixpkgs input
just for that one platform, which adds an input the briefing did not ask for.
Dropping the platform is the smaller lie: an Intel Mac user gets no output
rather than a broken one, and `docs/method.md` says why.
