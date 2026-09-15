---
# opsx-tuis-compare-flake-rzpk
title: Collect comparison evidence by running every tool on the fixture
status: todo
type: epic
priority: high
created_at: 2026-09-15T10:17:45Z
updated_at: 2026-09-15T10:17:45Z
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
