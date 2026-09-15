# opsx-tuis-compare-flake

One Nix flake that builds every known OpenSpec TUI so you can run them side by
side on the same fixture project and compare them.

```
nix shell github:speclib/opsx-tuis-compare-flake
ost-compare
```

## Status

Scaffold. The flake is not built yet. This README is replaced by the comparison
itself, with both matrices, in milestone 07.

What exists today:

| File               | What it is                                          |
|--------------------|-----------------------------------------------------|
| `docs/briefing.md` | The scope contract. Read this first.                |
| `CLAUDE.md`        | How to work in this repo: the loop, the constraints |
| `docs/roadmap.md`  | Nine milestones and their dependency order          |
| `.beans/`          | Milestones and epics                                |
| `openspec/`        | Change proposals, one per epic                      |

## The six tools

Six distinct upstream repos, three of which install a binary called
`openspec-tui`. They cannot coexist on one `PATH`, so every tool is exposed here
under an `ost-<author>` name:

| Command         | Upstream                | What it is                     |
|-----------------|-------------------------|--------------------------------|
| `ost-specgetty` | `speclib/specgetty`     | Multi-project scanner          |
| `ost-dossier`   | `fselich/dossier`       | Reader, parses the filesystem  |
| `ost-neosam`    | `neosam/openspec-tui`   | Implementation runner          |
| `ost-mstanton`  | `mstanton/openspec-tui` | Authoring and editing          |
| `ost-itslame`   | `ItsLame/openspec-tui`  | Reader, via the `openspec` CLI |
| `ost-opsx`      | `fsmw/opsx-tui`         | Aspiring control center        |

Each enters as a `flake = false` input pinned in `flake.lock`, including the two
that ship their own flake. This is a comparison artifact, not a redistribution
channel.

## Bias disclosure

specgetty is authored by the owner of this repo.

## How the work is tracked

beans holds milestones and epics. OpenSpec holds the proposal, specs, design and
task list for each epic. One epic is one OpenSpec change is one commit.

```bash
beans list                    # the whole tree
beans list --json --ready     # what can be started now
openspec list                 # active changes
```

## License

MIT. See `LICENSE`. Upstream licenses are recorded per tool in the properties
matrix once milestone 07 lands.
