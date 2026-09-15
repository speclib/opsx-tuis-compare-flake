# Design: package specgetty

## Reading upstream's package.nix rather than importing it

Upstream ships `package.nix`, and it is where three facts came from: the module
main package lives in `src/`, so Go names the binary `src` and it has to be
renamed to `spg`; `doCheck` is off; and the vendor hash. The file is read and
then rewritten here rather than imported, because the briefing keeps packaging
uniform in one place, and because importing it would couple this flake to a
file upstream is free to restructure.

The vendor hash was not copied on trust. `nix build .#specgetty` from a clean
store succeeded with it, which is the same proof a freshly resolved hash gives:
a wrong hash is a build failure, not a silent mismatch.

## Smoke checks derive from the package set

The alternative was a hand-written list of checks. That list would need editing
by five more epics and would silently lose a tool whose line was forgotten.
Instead a package declares `passthru.smoke = { bin; args; acceptExit; }`, and
`mkToolChecks` maps the package set into `checks.<system>.smoke-<name>`.

The filter also drops anything marked `meta.broken`, which is what the
briefing's degradation rule needs: a tool that will not build keeps its attr
and stops being checked, without a second list to keep in step.

## Observations for the matrices

Recorded while running the built binary, so they are observations rather than
README claims:

- `spg --version` prints `specgetty version 0.2.0`.
- Config lives at `$XDG_CONFIG_HOME/specgetty/config.yml`, shown in `--help`.
- `--path` takes a single project path and `--zoom` starts inside it, so the
  single-change path argument row is a yes with a caveat: the unit is a
  project, not a change.
- There is no `--store` flag in `--help`.
