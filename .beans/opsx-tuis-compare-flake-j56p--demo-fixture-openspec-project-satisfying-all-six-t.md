---
# opsx-tuis-compare-flake-j56p
title: Demo fixture OpenSpec project satisfying all six tools
status: completed
type: epic
priority: high
created_at: 2026-09-15T10:16:50Z
updated_at: 2026-09-15T11:41:11Z
parent: opsx-tuis-compare-flake-ecsi
blocked_by:
    - opsx-tuis-compare-flake-ogon
---

OpenSpec change: `add-demo-fixture`

Briefing: section 2.5.

## Scope
`fixture/` as plain files, no nix, plus `pkgs/demo-project.nix` that builds it
into a derivation. Required tree:

```
openspec/
  config.yaml                      # so the openspec CLI recognises the root
  specs/<spec-id>/spec.md          # "### Requirement: ..." + WHEN/THEN scenarios
  changes/
    add-dark-mode/
      .openspec.yaml               # REQUIRED by dossier to see the change at all
      proposal.md  design.md  tasks.md   # tasks.md mixes - [ ] and - [x]
      specs/<spec-id>/spec.md      # delta with ADDED / MODIFIED / REMOVED
    add-user-auth/                 # a second change, no design.md, 0% tasks
    archive/2026-01-10-add-logging/
```

The shape is deliberate: partial task completion exercises progress indicators,
the missing `design.md` exercises artifact status display, and the archive
directory exercises archived-change browsing.

## Non-goals
No store registration in this epic. No harness scripts.

## Acceptance
- [ ] `openspec validate` passes against `fixture/`
- [ ] `openspec list` shows both active changes
- [ ] `openspec list` shows the archived change
- [ ] `nix build .#demo-project` succeeds
- [ ] e2e scenario `fixture-valid` passes

## Summary of Changes

`fixture/` holds two active changes, one archived change and two specs. Every
element earns its place: 3/7 tasks against 0/7 for progress indicators, a
missing `design.md` for artifact-status displays, an archive directory for the
tools that browse archives, and `.openspec.yaml` everywhere because dossier
refuses a change directory without one.

`pkgs/demo-project.nix` validates it at build time, so a broken fixture cannot
reach a comparison run and be recorded as six tool failures.

One finding cost real time and is now in `docs/method.md`: `openspec validate`
with stdout attached straight to a Nix build log redraws its spinner without
bound and never returns. One attempt reached an 821 MB log. Ruled out telemetry,
the missing network, TERM, CI, NO_COLOR, `--strict` and the fixture content;
piping the output is the only thing that changed it, and then it finishes in
1.6 seconds. Every CLI call inside a derivation now redirects to a file.

Scenarios ask for the fixture by mentioning `$OST_FIXTURE` and the harness
notices, so there is no second list to keep in step.
