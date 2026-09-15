---
# opsx-tuis-compare-flake-j56p
title: Demo fixture OpenSpec project satisfying all six tools
status: todo
type: epic
priority: high
created_at: 2026-09-15T10:16:50Z
updated_at: 2026-09-15T10:16:50Z
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
