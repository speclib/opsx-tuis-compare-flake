# Design: correcting the evidence

## What was wrong, and why it was wrong

The published timing measured from `exec` to the first byte written to the
terminal. For a full-screen program that byte is the alternate-screen escape
sequence. It is emitted before the tool has read anything, so it ranks tools by
how quickly they call into their terminal library.

Time to a usable screen, defined as the first moment the rendered terminal
carries at least 200 printable characters, gives almost the opposite order:

| Tool          | First byte | Usable screen | Finished |
|---------------|------------|---------------|-----------|
| ost-specgetty | 10 ms      | 65 ms         | 5/5       |
| ost-dossier   | 21 ms      | 130 ms        | 5/5       |
| ost-mstanton  | 239 ms     | 374 ms        | 5/5       |
| ost-neosam    | 7 ms       | 756 ms        | 5/5       |
| ost-itslame   | 23 ms      | 5101 ms       | 3/5       |
| ost-opsx      | 362 ms     | never         | 0/5       |

Two published conclusions die with it. Startup does not split by language: the
fastest is Go, the second slowest is Rust, and a Python tool beats the Rust one.
And the CLI route is not cheap because itslame was fast; itslame is the slowest
tool that works at all.

## Getting the measurement right took three corrections

- **In tmux, with a client attached.** On a bare pty specgetty measured 5048 ms,
  because nothing answered the terminal queries it makes at startup. In tmux it
  is 65 ms. A detached tmux session answers nothing either, so a client has to be
  attached through a pty.
- **Each tool invoked the way it works.** Run bare in a project directory,
  specgetty says "No OpenSpec projects found" quickly. Timing that would have
  scored an error screen as a fast start.
- **Waiting for content, not output.** The whole correction is this distinction.

All three are now encoded in `tests/lib/time-to-usable.sh`, with the reason
written above each, because each was a wrong answer first.

## itslame: measuring what it is not

The obvious explanation for 5.1 seconds was the CLI round trips, which is also
what the briefing expected to find. A shim wrapping `openspec` and timing every
call recorded three calls per startup at about 0.32 s each, all returning 0,
under a second in total.

So the number is real and the explanation is not the CLI. The remaining time is
inside the tool, behind its "Loading OpenSpec workspace..." spinner, and it was
not isolated further. Both halves are recorded: the cost, and the fact that the
obvious cause was ruled out.

This matters for the next briefing, which was expecting spawn latency to be the
argument against the CLI approach. On this evidence the CLI tax is about 0.3 s
per call, and the case against this implementation is not a case against the
approach.

## opsx: recorded, not diagnosed, and not marked broken

opsx starts, switches views and shows a help overlay. Every pane is empty, and
the header carries a raw widget id where a tab label belongs.

The cells become `no` because the matrix describes what the tool does when run.
Each note says the source declares the feature, so a reader can tell "never had
it" from "this build does not show it".

`meta.broken` is deliberately not set. It builds and it starts, and marking it
broken would drop it from `packages.default` and the checks, which would hide
the finding instead of reporting it. The degradation rule is for a tool that
cannot be built, not for one whose behaviour is disappointing.

The likely cause is the relaxed textual pin: upstream declares
`textual>=1.0,<3.0` and this flake builds against 8.2.8. That is a hypothesis.
Confirming it needs a textual in the declared range, which this nixpkgs does not
carry, so it is written as a hypothesis rather than a finding.

## Why the tooling is committed

`docs/method.md` now claims a reproducible measurement, so the measurement has
to be runnable. `tests/lib/drive.py` renders what a tool drew, and
`tests/lib/time-to-usable.sh` produces the published figures. Neither is wired
into `nix flake check`: they assert on rendered output, which the briefing
forbids in a check and which would break on any upstream redesign. They are
instruments, not tests.
