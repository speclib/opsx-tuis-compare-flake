---
# opsx-tuis-compare-flake-aubn
title: Correct the matrix and timings from hands-on use
status: completed
type: epic
priority: high
created_at: 2026-09-15T12:43:54Z
updated_at: 2026-09-15T12:49:35Z
parent: opsx-tuis-compare-flake-2kzu
---

Driving all six tools by hand on the fixture contradicted several cells that had
been filled from source reading, and overturned the headline timing claim.

## What was wrong

The published timing was time to first byte, which for a full-screen program is
its terminal setup and arrives long before anything readable. Measured properly
(time to a usable screen, in tmux with an attached client, each tool invoked the
way it actually works) the ranking inverts:

| Tool          | First byte | Usable screen | Completed |
|---------------|------------|---------------|-----------|
| ost-specgetty | 10 ms      | 65 ms         | 5/5       |
| ost-dossier   | 21 ms      | 130 ms        | 5/5       |
| ost-mstanton  | 239 ms     | 374 ms        | 5/5       |
| ost-neosam    | 7 ms       | 756 ms        | 5/5       |
| ost-itslame   | 28 ms      | 5101 ms       | 3/5       |
| ost-opsx      | 355 ms     | never         | 0/5       |

Two conclusions in the README and handover were wrong and must be withdrawn:
that first paint splits by language, and that the CLI route is cheap.

## What running them found

- opsx renders no content in any view under textual 8.2.8. It draws a header,
  switches views, and shows a help overlay; every pane is empty. Many of its
  cells were filled from TabPane and Binding names in the source.
- itslame takes about 5.1 seconds to a usable screen and fails to finish 2 runs
  in 5. Not the CLI: 3 calls, ~0.32 s each, always rc=0.
- dossier live-reloads, which had been undetermined. An external edit moved its
  progress bar with no keypress.
- specgetty has a config tab, and needs --zoom --path or a configured scan root.
- neosam shows a change's delta specs but no project-level specs view, and `?`
  does nothing.

## Summary of Changes

Corrected `data/comparison.json`, `README.md`, `docs/method.md` and
`docs/handover.md`. Committed `tests/lib/drive.py` and
`tests/lib/time-to-usable.sh` so the observations are reproducible, and put pyte
in the devshell. The committed script reproduces the published figures.

Two published conclusions withdrawn: that startup splits by language, and that
the CLI route is cheap.

Getting the measurement right needed three corrections, all now encoded with
their reasons in the script: measure in tmux with a client attached through a
pty; invoke each tool the way it works; wait for content rather than output.

itslame's five seconds is real and is not the CLI. A timing shim recorded three
calls per startup at ~0.32 s each, all rc=0. The rest is inside the tool. That
weakens the case the next briefing expected to make against the CLI approach.

opsx's cells are now `no` with notes saying the source declares the feature.
`meta.broken` is deliberately not set: it builds and starts, and marking it
broken would drop it from the environment and the checks, hiding the finding
rather than reporting it.
