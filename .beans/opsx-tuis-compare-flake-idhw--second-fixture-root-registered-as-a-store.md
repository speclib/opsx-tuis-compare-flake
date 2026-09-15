---
# opsx-tuis-compare-flake-idhw
title: Second fixture root registered as a store
status: completed
type: epic
priority: normal
created_at: 2026-09-15T10:16:50Z
updated_at: 2026-09-15T11:43:54Z
parent: opsx-tuis-compare-flake-ecsi
blocked_by:
    - opsx-tuis-compare-flake-j56p
---

OpenSpec change: `add-store-fixture`

Briefing: sections 2.5 and 7.

Stores are the decision axis that matters most for the next briefing, so the
fixture has to cover them. A second fixture root is registered as a store so
`ost-itslame --store <id>` can be exercised and the other five can be observed
failing or ignoring the flag.

## Hard constraint
`openspec store register` writes to
`~/.local/share/openspec/stores/registry.yaml`. Every registration in this repo
happens inside a temp `XDG_DATA_HOME` that the harness sets up. The user's real
registry must never be touched. This is verified by the `no-host-writes` e2e
scenario in milestone 08.

## Scope
- A second fixture root under `fixture/store/`.
- A harness helper that creates a temp `XDG_DATA_HOME`, registers the store there
  and returns the store id.
- e2e scenario `store-resolution` asserting the registration landed in the temp
  path and nowhere else.

## Non-goals
Do not implement store support in any tool. Observe what each one does.

## Acceptance
- [ ] The store registers and resolves inside a temp `XDG_DATA_HOME`
- [ ] `$HOME/.local/share/openspec` is untouched after a full run
- [ ] e2e scenario `store-resolution` passes

## Summary of Changes

`fixture-store/` is a second valid OpenSpec root, built and validated by
`pkgs/demo-store.nix`.

`openspec store register` runs inside the Nix build sandbox rather than on the
host. That is the stronger form of the constraint: the sandbox makes reaching
the real registry impossible instead of merely discouraged, so protection does
not depend on anyone reading a prompt carefully. The scenario asserts where the
registry landed: `/build/work/sandbox/home/.local/share/openspec/stores/registry.yaml`.

Registering and listing alone would pass even if `--store` silently resolved to
the working directory, so the scenario also runs an unscoped `openspec list`
from inside the fixture and asserts the store's change is absent. That is the
"editing plans in the wrong repo" failure the briefing's section 7 names.
Falsified with an unregistered id, which is refused rather than falling back.

Verified afterwards: the host registry at `~/.local/share/openspec/stores/` is
dated 1 September and still contains only Pim's own `nivis` store.
