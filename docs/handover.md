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

**Time to first paint splits by language, not by design.** The Rust tool paints
in 7 ms, the three Go tools between 10 and 28 ms, and the two Python tools at
239 ms and 355 ms. A tmux popup binding wants under about 200 ms, so both
Python tools miss it, and they will keep missing it on a smaller project because
the cost is interpreter and framework startup.

**The CLI route is cheaper than expected.** itslame shells out to a Node CLI for
everything and still paints at 28 ms. The briefing's section 7 expected process
spawn latency to be the main argument against driving the `openspec` CLI. On
this fixture it is not.

**Only one tool has `--store`, and it is the CLI-backed one.** That is not a
coincidence: the CLI resolves roots, so the tool that delegates to it gets
`--store` for free while the five that parse files do not have it at all.

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

Some feature cells in the matrix are undetermined. Each carries a note naming
what was checked. They are gaps in the evidence, not in the tools, and the
cheapest way to close them is to use the tools rather than to read more source:
open `ost-demo`, try the thing, change the cell.

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
