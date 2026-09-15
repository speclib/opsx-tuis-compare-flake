# Handover

What this repository is at the end of the proof-of-concept run, and what the
next person needs to know.

## What works

`nix shell github:speclib/opsx-tuis-compare-flake` puts nine commands on `PATH`:
the six tools as `ost-<author>`, plus `ost-compare`, `ost-demo` and the
`openspec` CLI. All six tools build from pinned sources with real hashes, and
all six start against the shared fixture. Nothing degraded.

`nix flake check --all-systems` runs eighteen checks and passes: six per-tool
checks, ten end-to-end scenarios, and two self-checks.

## What the comparison found

The full matrices are in `README.md`. Three findings are worth stating on their
own, because they are what the next briefing was asking for.

**Startup cost is about what a tool does before drawing, not what it is written
in.** Time to a usable screen: specgetty 65 ms, dossier 130 ms, mstanton 374 ms,
neosam 756 ms, itslame 5101 ms, opsx never. The fastest is Go and the second
slowest is Rust, and a Python tool beats the Rust one.

An earlier version of this note claimed the split was by language, based on time
to first byte. That measurement was wrong for the question: for a full-screen
program the first byte is the alternate-screen escape sequence. The corrected
numbers are in `docs/method.md` along with how to reproduce them.

**The CLI route costs about 0.3 s per call, and that is not what makes itslame
slow.** Section 7 expected process spawn latency to be the main argument against
driving the `openspec` CLI. itslame makes three calls at startup, about 0.32 s
each, all succeeding, and still takes 5.1 seconds to a usable screen, failing to
finish 2 runs in 5. The remaining time is inside the tool. So the CLI tax is
real but modest, and the case against this particular implementation is not the
case against the approach.

**Only the CLI-backed tools have `--store`.** That is not a
coincidence: the CLI resolves roots, so a tool that delegates to it gets
`--store` for free, while the five that parse files do not have it at all.

**The five seconds survived a rewrite.** ItsLame's newer `lazyopenspec` is a
different program to use, with a lazygit-style layout and a command log, but it
takes 5109 ms to a usable screen against itslame's 5101 ms and fails at the same
rate. Two independent codebases by the same author, same cost. Worth a look
before adopting the CLI-backed shape, and it is the most concrete open question
this comparison leaves behind.

**opsx renders nothing in this build.** It starts, switches views and shows a
help overlay; every pane is empty. Its declared `textual>=1.0,<3.0` is built
against nixpkgs' 8.2.8. That is the likely cause and it is not confirmed, because
this nixpkgs carries no textual in the declared range. The matrix records what
was observed and its notes say the source declares the features, so nobody
mistakes this for a tool that never had them.

## What is deliberately not done

- The new TUI. It is a different repository and a different risk profile. The
  section 7 notes are in `docs/briefing.md` and tracked as beans milestone 09,
  which is in draft and should stay there.
- `x86_64-darwin`. The pinned nixpkgs throws during evaluation for it, so it is
  not a declared system. `docs/method.md` has the full error and the
  alternatives that were considered.
- CI has not been observed running. The workflow is valid and runs the same gate
  that passes locally, but nobody has watched it go green.

## Where the gaps are

Some feature cells in the matrix are still undetermined. Each carries a note
naming what was checked. The cheapest way to close them is to use the tools
rather than to read more source: open `ost-demo`, try the thing, change the cell.

That is not theoretical. The first pass filled the matrix from key tables,
binding lists and dependency manifests, and a later pass driving all six tools
on the fixture changed about a dozen cells and reversed the timing conclusion.
A comparison assembled only from reading source gets the features roughly right
and the experience completely wrong.

Specific things still open: whether neosam can archive a change or filter, and
whether specgetty's config tab edits or only displays. The one question that
would settle opsx is whether it renders against a textual in its declared range.

The briefing also asks for something no amount of source reading produces:

> what made you quit each tool within 30 seconds; which one you reached for a
> second time; which keymap fought your muscle memory

None of that is filled in. It cannot be, by the process that built this.

## How to work on it

`CLAUDE.md` has the loop. In short: pick the next epic with
`beans list --json --ready`, run the OpenSpec propose workflow, do the work, run
the gate, archive, commit, close the bean. One epic is one change is one commit.

The three rules most likely to be broken by accident:

1. Each package keeps its upstream binary name. The `ost-` name is added by the
   combined environment. Three upstreams install `openspec-tui`.
2. A cell you could not determine is `unknown` with a note, never `no`.
3. Any `openspec` call inside a derivation redirects its output to a file, or
   the build will not terminate. See `docs/method.md`.

## Snapshot

Every tool is pinned in `flake.lock`. For the exact revisions:

```bash
nix eval --json .#lib.versions | jq
```
