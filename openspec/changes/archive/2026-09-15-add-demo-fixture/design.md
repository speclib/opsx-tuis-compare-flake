# Design: the demo fixture

## Shape

Two active changes, one archived, two specs. Every element earns its place by
making some tool behave visibly differently:

| Element                                | What it exercises                        |
|----------------------------------------|------------------------------------------|
| `add-dark-mode` at 3 of 7 tasks         | Progress indicators, partial state        |
| `add-user-auth` at 0 of 7 tasks         | The empty-progress case                   |
| `add-user-auth` has no `design.md`      | Artifact-status displays                  |
| `archive/2026-01-10-add-logging`        | Tools that browse archives separately     |
| `.openspec.yaml` in every change        | dossier, which refuses a change without it |
| ADDED and MODIFIED delta headers        | Delta rendering                           |
| A new capability with a `## Purpose`    | The new-capability path                   |

The content is a plausible small product rather than lorem ipsum, because
several tools render markdown and a reader has to be able to tell a rendering
bug from nonsense input.

## Validated at build time, not only in a test

A broken fixture makes all six tools look broken at once, and the matrices
would record that as six tool failures. Validating inside
`pkgs/demo-project.nix` means the fixture cannot reach a comparison run in a
state that invalidates it.

## The openspec CLI cannot write to a Nix build log

`openspec validate` with its stdout attached directly to the builder's stdout
redraws its progress spinner without bound and never returns. One attempt
reached an 821 MB log before it was killed, with the tail consisting entirely
of cursor-up and erase-line sequences.

Piping or redirecting its output stops it. The cause was isolated by
elimination: it is not the telemetry write, not the absence of a network, not
`TERM`, not `CI`, and not the `--strict` flag, since a run whose output goes
through a pipe completes in under two seconds with the same environment,
version and input.

Every invocation of the CLI inside a derivation therefore redirects to a file.
That also bounds what a failure prints, which is worth having on its own.

## Fixture delivery to scenarios

A scenario asks for the fixture by mentioning `$OST_FIXTURE`, and the harness
notices. The alternative, a list of fixture-needing scenarios in
`tests/default.nix`, is another list to keep in step, and the failure mode of
forgetting an entry is a scenario that silently tests nothing.

The copy is made writable because several tools toggle task checkboxes, and
the point of the comparison is to let them.
