# Design: the method and contribution docs

## What method.md has to carry

Not a description of the matrices, which the README already shows, but the
things a reader cannot recover from the page:

- What each marker obliges, and that absence of evidence was never read as
  evidence of absence.
- The evidence hierarchy, including that a README claim alone is never a `yes`.
- What each kind of check actually proves, and where a green check proves less
  than it appears to. itslame answers `--help` before it looks for the CLI it
  requires, so its smoke check is weaker than the others'.
- Every falsification performed, with the failure text, including the three that
  cannot live in `nix flake check` because a check that must fail would fail the
  gate.
- The two traps that cost real time: the `openspec` CLI spinner that runs away
  when its stdout is a build log, and `x86_64-darwin` being dropped by nixpkgs.
- The degradations section, currently empty, with the shape a future entry takes.

## Why adding-a-tool.md leads with the constraint

The first thing it says about the package is to keep the upstream binary name.
That is the rule a contributor is most likely to break, because adding
`ost-` to the package looks tidier, and breaking it reintroduces exactly the
collision the repo exists to solve.

It also states the `unknown` rule plainly, because the second most likely
mistake is a contributor filling their own tool's row with confident yeses.
