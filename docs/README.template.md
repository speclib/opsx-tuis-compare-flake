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

The time-to-first-paint row is the one measurement none of the upstream
READMEs report, and it is the one that decides whether a tool can live behind a
tmux popup binding:

```
bind-key C-o display-popup -E -d "#{pane_current_path}" -w 90% -h 90% "<tui>"
```

That shape wants first paint under about 200 ms. The three Go tools and the
Rust one land between 7 and 28 ms. The two Python ones land at 239 ms and
355 ms, and the cost is interpreter and framework startup rather than anything
about the project being opened, so it will not improve with a smaller fixture.

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

**Both Python tools are built with their dependency pins relaxed.** Neither
ships a lockfile, and there is one nixpkgs for the whole flake. Both were
started and observed rather than assumed to work; see
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
each, and runs eight end-to-end scenarios, each of which has been deliberately
broken to prove it can fail.

## Adding a tool

Open a pull request. See [docs/adding-a-tool.md](docs/adding-a-tool.md); it is
four files and one of them is this table's data.

## License

This repository is MIT. Each packaged tool keeps its own license, recorded in
the properties matrix above.
