# Design: adding lazyopenspec

## Why it is a separate row and not a version bump

It shares the internal package layout, the CLI-backed design and the `--store`
flag with `ItsLame/openspec-tui`. It differs in layout (stacked numbered panels
and a command log against two panes), in how workflow actions are reached (an
`x` menu with confirm prompts), in search (`n` and `N` step between matches), and
in what it dropped: no `$EDITOR` binding, no positional path argument, no
LICENSE file. 3422 lines against 2489.

Neither repository's README mentions the other. The older one was last pushed
two months before the newer, which is not enough to call it dead, so both are
packaged and the page says so rather than picking a winner.

## The naming rule needed refining, not replacing

`ost-<author>` worked while every author had one tool. The suffix is now the
shortest thing that identifies the tool: the author where that is unique, the
project where it is not. Only these two move to project names; the other five
are unchanged, so no existing command name breaks.

## No license, and no borrowed one

The repository carries no LICENSE file and the GitHub API reports none. The
same author's other repo is MIT, and inheriting that would be exactly the
invented evidence the briefing forbids.

`meta.license` is therefore left unset. That is "unknown" to nixpkgs rather than
"unfree", so the package still builds, and the properties matrix says "none
declared" instead of guessing. Building from source for a comparison is not the
same as redistributing it, which is the line this repo already draws for
fsmw/opsx-tui.

This surfaced a latent assumption: the wrapper copied `description`, `homepage`
and `license` from each package, so a package without a license failed to
evaluate the whole environment. The wrapper now carries a license through only
when there is one.

## What running it showed

Everything in its row is observed rather than read. Panels [1] Changes, [2]
Specs and [3] Archive; `?` opens a thirteen-entry keybindings overlay; `x` opens
an actions menu with validate, apply instructions and archive; space in the
tasks tab wrote through to disk, taking the change from 3/7 to 4/7 by the CLI's
own count.

The measurement worth having: 5109 ms to a usable screen, 2 of 5 runs finishing.
Its predecessor is 5101 ms at the same rate. Two codebases, one author, the same
cost, so the five seconds is not an accident of the older implementation.
