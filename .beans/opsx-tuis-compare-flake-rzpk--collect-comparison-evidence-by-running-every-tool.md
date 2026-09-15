---
# opsx-tuis-compare-flake-rzpk
title: Collect comparison evidence by running every tool on the fixture
status: completed
type: epic
priority: high
created_at: 2026-09-15T10:17:45Z
updated_at: 2026-09-15T12:00:38Z
parent: opsx-tuis-compare-flake-2kzu
blocked_by:
    - opsx-tuis-compare-flake-vcg7
---

OpenSpec change: `collect-comparison-evidence`

Briefing: sections 3 and 7.

Run every tool against the same fixture via `ost-demo` and record what you see.
This epic produces raw observations. The README epic turns them into tables.

## Feature rows to determine per tool
browse active changes, browse archived changes, browse project specs, render
markdown (and how), toggle tasks in place, task progress indicator, validate
change, archive change, open in `$EDITOR`, live reload on disk change,
filter/search, single-change path argument, `--store` support, multi-project or
multi-root view, run an agent to implement a change, batch or dependency
ordering, Kanban or lifecycle view, in-app config editor, help overlay.

## Property rows to determine per tool
language, TUI framework, data source (filesystem versus `openspec` CLI JSON),
requires Node or `openspec` on PATH, config file location, license, distribution
channels (go install, brew, PyPI, nix), repo activity at snapshot date, upstream
flake, binary name, startup time on the fixture.

## The one measurement that matters most
Time each tool on exactly this invocation, per briefing section 7:

```
bind-key C-o display-popup -E -d "#{pane_current_path}" -w 90% -h 90% "<tui>"
```

Sub-200ms to first paint is the target. None of the upstream READMEs will tell
you this number, and it is the most decision-relevant figure in the exercise.

## Evidence discipline
Record for every observation whether it came from running the tool, from reading
the source, or from reading a README. That provenance decides the cell marker.

## Acceptance
- [ ] Every feature row has a determination and a provenance for all six tools
- [ ] Every property row has a determination and a provenance for all six tools
- [ ] Startup timings recorded for every tool that runs
- [ ] Raw observations committed under `docs/`

## Summary of Changes

Every feature and property row determined for all six tools, from running them,
from key tables and binding lists in their sources, and from their dependency
manifests. A README claim alone never justifies a yes.

An early attempt counted grep hits per feature per tool and was abandoned: it
reported zero `--store` hits for itslame, which visibly has the flag in its
`--help`. Counts measure vocabulary, not behaviour.

The rule that cost the most cells is that absence of evidence is not evidence of
absence. A feature a search did not find is undetermined with a note, not "no".
A wrong "no" is the failure a reader cannot detect.

Time to first paint, measured on a real pty in the tmux popup shape, five runs,
median of exec to first byte:

| Tool          | Median | Language |
|---------------|--------|----------|
| ost-neosam    | 7 ms   | Rust     |
| ost-specgetty | 10 ms  | Go       |
| ost-dossier   | 21 ms  | Go       |
| ost-itslame   | 28 ms  | Go       |
| ost-mstanton  | 239 ms | Python   |
| ost-opsx      | 355 ms | Python   |

The split is by language, not by project size, so neither Python tool improves
with a smaller fixture. Both miss the sub-200ms budget a tmux popup wants.

One finding for the next briefing: itslame shells out to a Node CLI and still
paints at 28 ms, which weakens the latency argument against the CLI route that
section 7 expected to be decisive.
