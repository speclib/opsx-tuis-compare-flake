# Roadmap

Nine milestones. Milestones and epics live in beans; the tasks inside each epic
live in that epic's OpenSpec change. One epic is one change is one commit.

> `beans roadmap` produces an empty document in beans 0.4.2, reproduced in a
> minimal scratch project, so this file is maintained from `beans list` until
> that is fixed.

| Milestone | Epics | Delivers |
|-----------|-------|----------|
| 01 Foundation and flake skeleton | 3 | A flake that evaluates on four systems, the test harness, CI |
| 02 Package the Go TUIs | 3 | specgetty, dossier, itslame |
| 03 Package the Rust TUI | 1 | neosam |
| 04 Package the Python TUIs | 2 | mstanton, opsx |
| 05 Fixture project | 2 | The shared demo project and a second root as a store |
| 06 Comparison harness | 3 | `packages.default`, `ost-demo`, `ost-compare` |
| 07 Evidence and comparison README | 3 | The observations, both matrices, method docs |
| 08 Acceptance and alpha release | 3 | The e2e suite, verified acceptance, the alpha |
| 09 Deferred carry-over | 1 | Findings that aim the next briefing. Not built here. |

## Dependency order

Milestone numbers give the intended reading order, but the real ordering comes
from the blocked-by edges in beans. Run `beans list --json --ready` and take the
lowest numbered milestone with open work.

```
flake-skeleton
├── test-harness ──────────────────────────────┐
├── ci-workflow                                │
├── package-specgetty ─┐                       │
├── package-dossier ───┤                       │
├── package-itslame ───┤                       │
├── package-neosam ────┼── default-env         │
├── package-mstanton ──┤        │              │
├── package-opsx ──────┘        │              │
└── demo-fixture ───────────────┤              │
    └── store-fixture           │              │
                                ▼              │
                             ost-demo          │
                                │              │
                                ▼              │
                            ost-compare ───────┤
                                │              │
                                ▼              ▼
                        evidence-collection  e2e-suite
                          │        │           │
                          ▼        ▼           │
                     readme    method-docs     │
                          │                    │
                          └────────┬───────────┘
                                   ▼
                        acceptance-verification
                                   │
                                   ▼
                             alpha-release
```

## Degradation

Briefing section 5 allows a tool that will not build to keep its package attr,
carry `meta.broken = true`, leave `packages.default`, and have its failure
recorded. mstanton and opsx are the likely candidates. A five-of-six flake that
works beats a six-of-six flake that does not evaluate.
