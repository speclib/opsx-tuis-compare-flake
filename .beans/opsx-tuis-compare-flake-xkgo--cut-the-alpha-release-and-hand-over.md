---
# opsx-tuis-compare-flake-xkgo
title: Cut the alpha release and hand over
status: todo
type: epic
priority: normal
created_at: 2026-09-15T10:18:25Z
updated_at: 2026-09-15T10:19:18Z
parent: opsx-tuis-compare-flake-yx1r
blocked_by:
    - opsx-tuis-compare-flake-twv4
---

OpenSpec change: `cut-alpha-release`

This PoC is meant to serve as an alpha base for later development, so it ends in
a state someone else can pick up.

## Scope
- Refresh `docs/roadmap.md`. Note that `beans roadmap` returns an empty
  document in beans 0.4.2, reproduced in a minimal scratch project, so update the
  file from `beans list` until that is fixed.
- Confirm every completed bean has a `## Summary of Changes` section and every
  scrapped bean has a `## Reasons for Scrapping` section.
- Archive completed beans with `beans archive`.
- Tag `v0.1.0-alpha` and push the `main` bookmark.
- Write a handover note: what works, what degraded, what the next briefing needs
  (see the deferred carry-over milestone).

## Acceptance
- [ ] `docs/roadmap.md` regenerated and committed
- [ ] `jj git push --bookmark main` succeeds
- [ ] Tag pushed
- [ ] Handover note committed
