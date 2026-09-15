---
# opsx-tuis-compare-flake-ecsi
title: 05 Fixture project
status: in-progress
type: milestone
priority: high
created_at: 2026-09-15T10:16:50Z
updated_at: 2026-09-15T10:52:57Z
---

Build the shared fixture OpenSpec project that every tool is judged on, plus a
second root registered as a store so the `--store` axis can be exercised.

Briefing: section 2.5.

The fixture must satisfy all six tools' expectations at once, because their
assumptions differ. dossier needs `.openspec.yaml` in each change directory; the
CLI-backed tools need a root the `openspec` CLI recognises.

## Exit criteria
- [ ] `openspec validate` passes on the fixture
- [ ] `openspec list` sees both active changes and the archived one
- [ ] Store registration happens only inside a temp `XDG_DATA_HOME`
