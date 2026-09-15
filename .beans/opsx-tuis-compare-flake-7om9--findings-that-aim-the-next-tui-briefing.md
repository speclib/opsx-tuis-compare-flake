---
# opsx-tuis-compare-flake-7om9
title: Findings that aim the next TUI briefing
status: draft
type: epic
priority: deferred
created_at: 2026-09-15T10:18:25Z
updated_at: 2026-09-15T10:18:25Z
parent: opsx-tuis-compare-flake-w1bm
---

Not to be implemented here. This epic collects what the comparison settles, so
the next briefing starts from evidence instead of from opinion.

Briefing: section 7.

## Questions the comparison should settle
- Filesystem parsing versus `openspec` CLI JSON. itslame shells out to the CLI;
  dossier and specgetty parse files. The CLI route gets `--store`,
  `openspec context`, `doctor` and workset resolution for free, and it survives
  OpenSpec's file-format churn, at the cost of a Node dependency and process
  spawn latency. Judge that latency on the fixture; it is the main argument
  against.
- Stores are a resolution problem, not a directory problem. OpenSpec resolves a
  root in precedence order: `--store <id>`, then the nearest `openspec/` walking
  up from cwd, then a `store:` pointer in `openspec/config.yaml`, then the global
  `defaultStore`, then an error or a selection hint. A TUI launched from a tmux
  popup in an arbitrary directory must reproduce that exactly, and must show
  which case it landed in. Getting this wrong means silently editing plans in the
  wrong repo.
- Stores make the single-project TUI shape wrong. A store is a standalone
  planning repo shared by several code repos, and a code repo can reference
  stores read-only. The new TUI needs a root banner showing id, path and
  resolution source, a way to switch between root and referenced stores, and an
  indication that referenced material is read-only.
- Per-machine state is per-machine. The store registry and worksets live under
  `~/.local/share/openspec`, never in the shared repo.
- Beta means moving. Stores landed in OpenSpec v1.5.0 and the docs warn that
  command names, flags, file formats and JSON keys may change. There is a known
  casing split in the agent JSON: store-family snake_case, workflow-family
  camelCase. Isolate every CLI call behind one adapter module and pin a minimum
  `openspec` version at startup.
- tmux popup is a design constraint, not a keybinding. Sub-200ms to first paint,
  honours `$PWD` for root resolution, renders correctly in a small non-fullscreen
  pane, and exits cleanly rather than leaving the terminal dirty.

## Personal lessons to collect while comparing
- What made you quit each tool within 30 seconds.
- Which one you reached for a second time.
- Which keymap fought your muscle memory.
