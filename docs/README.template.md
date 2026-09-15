# opsx-tuis-compare-flake

Six people have written a terminal interface for [OpenSpec](https://github.com/Fission-AI/OpenSpec).
Three of them called the binary `openspec-tui`, so you cannot install more than
one and decide for yourself. This flake builds all six from source under names
that do not collide, on one shared fixture project, and reports what they
actually do.

```
nix shell github:speclib/opsx-tuis-compare-flake
ost-compare          # what each one is for
ost-demo             # a throwaway copy of the fixture to try them on
```

Nine commands land on your `PATH`: `ost-specgetty`, `ost-dossier`,
`ost-neosam`, `ost-mstanton`, `ost-itslame`, `ost-opsx`, plus `ost-compare`,
`ost-demo` and the `openspec` CLI. Nothing here writes to your projects or to
your OpenSpec store registry.

## Bias disclosure

specgetty is written by the owner of this repository. It is packaged, measured
and marked by the same rules as the other five, and the rules are in
[docs/method.md](docs/method.md) so you can check that claim rather than take it.

## The contenders

They are not six versions of one program. Two are readers, one scans your whole
machine, one runs changes, one writes them, and one wants to be a control
centre. Read the categories before reading the matrix, or the matrix will
mislead you.

{{CONTENDERS}}

## Feature matrix

`yes` and `no` mean observed, by running the tool or by reading its source.
`part` means present but incomplete, or claimed by a README and not verified.
`?` means undetermined, and the footnote says what was checked. There is no
cell here that means "probably".

{{FEATURES}}

## Properties

{{PROPERTIES}}

## What the numbers say

The measurement that matters is how long until you can read something, and none
of the upstream READMEs report it. It decides whether a tool can live behind a
tmux popup binding:

```
bind-key C-o display-popup -E -d "#{pane_current_path}" -w 90% -h 90% "<tui>"
```

That shape wants something on screen in a few hundred milliseconds. Two tools
clear it comfortably, two are usable, and two are not:

- **specgetty at 65 ms and dossier at 130 ms** are the only two that feel
  instant.
- **mstanton at 374 ms and neosam at 756 ms** are usable but noticeable.
- **itslame takes 5.1 seconds**, and two runs in five never finished at all. It
  sits behind a "Loading OpenSpec workspace..." spinner. This is not the cost of
  shelling out to the CLI: a counting shim recorded three calls per startup at
  about 0.32 s each, all succeeding. The wait is inside the tool.
- **opsx never reaches a usable screen.** It draws a header and nothing else.

Note what this does not correlate with. The fastest is Go and the second slowest
is Rust; a Python tool beats the Rust one. Startup cost here is about what each
tool decides to do before drawing, not what it was written in.

If you are looking for the popup-binding tool, it is dossier, with specgetty if
your unit of work is the machine rather than one project.

## Notes and caveats

**The name collision is the whole reason this repo has a naming scheme.**
`neosam/openspec-tui`, `mstanton/openspec-tui` and `ItsLame/openspec-tui` all
install a binary called `openspec-tui`. Each package here keeps that upstream
name, and only the combined environment renames them, so what you see in the
properties matrix is what upstream really installs.

**fsmw/opsx-tui has contradictory licensing.** The tree carries a GPL-3.0
`LICENSE` file and GitHub reports GPL-3.0, while its README says the license
has yet to be defined and that redistribution permission must not be assumed.
This repo records both and asserts neither.

**mstanton/openspec-tui claims MIT with no LICENSE file.** The claim is in
`pyproject.toml` and the README; there is no file in the tree and the GitHub
API reports no license.

**This is a snapshot.** Every tool is built from a revision pinned in
`flake.lock`, and the package versions carry the date. Run
`nix eval --json .#lib.versions` for the exact set. A tool that gained a feature
last week will still be reported as it was at its pinned revision.

**opsx does not render anything in this build.** It starts, switches between
views and shows its help overlay, but every pane is empty. Most of its `no`
cells are that, not a tool that never had the feature: its source declares the
views. The likeliest cause is the point below, and it is the reason this page
does not credit opsx with the board and runner its README describes.

**Both Python tools are built with their dependency pins relaxed.** Neither
ships a lockfile, and there is one nixpkgs for the whole flake, so opsx's
declared `textual>=1.0,<3.0` is built against textual 8.2.8. mstanton survives
the same treatment and renders fine. Testing whether a textual in the declared
range fixes opsx would need a version this nixpkgs does not carry, so the claim
here is what was observed, not a diagnosis. See
[docs/method.md](docs/method.md).

**This is a comparison artifact, not a redistribution channel.** All six enter
as `flake = false` inputs, including the two that ship their own flake, so
packaging stays uniform and an upstream output rename cannot break this repo.

## Method

Every cell traces to something observed. The rules, the falsifications, and the
things that were checked and left undetermined are in
[docs/method.md](docs/method.md).

The short version: the fixture is one OpenSpec project with two active changes
at different task completion, one archived change, and two specs, plus a second
root registered as a store. Every tool is judged on that same data.
`nix flake check` builds all six, runs a link-and-help or pty start check for
each, and runs the end-to-end scenarios, each of which has been deliberately
broken to prove it can fail.

Cells were first filled from source, then corrected by driving every tool on the
fixture and reading back what it drew. That pass changed a dozen cells and
reversed the timing conclusion, which is worth knowing before trusting any
comparison assembled only from reading code.

## Adding a tool

Open a pull request. See [docs/adding-a-tool.md](docs/adding-a-tool.md); it is
four files and one of them is this table's data.

## License

This repository is MIT. Each packaged tool keeps its own license, recorded in
the properties matrix above.
