# Design: verifying the acceptance criteria

## From a clone, not the working tree

This repo is colocated jj and git, and Nix reads the git index. Throughout the
run, files had to be staged before `nix build` could see them, which means a
green gate in the working tree does not prove the same gate is green for someone
who clones the repository.

So the verification clones to a temporary directory with `--depth 1` and runs
everything there. It found nothing wrong, which is the outcome worth having:
the claim is now checked rather than assumed.

## Result

All six criteria pass. No tool degraded, which the briefing did not expect:
section 5 anticipated that `opsx` or `mstanton` would need the degradation rule,
and both build and run with their dependency pins relaxed and their behaviour
observed rather than assumed.

## The gaps that are recorded rather than fixed

- `x86_64-darwin` is absent from the declared systems, because the pinned
  nixpkgs throws during evaluation for it. Recorded in `docs/method.md` with the
  full error.
- Some feature cells are undetermined. Each carries a note naming what was
  checked. These are gaps in the evidence, not failures of a criterion: the
  criterion is that no cell says `TODO`, and none does.
- The CI workflow has not been observed running, because the remote had no prior
  push when it was written. The file is valid and runs the same gate that passes
  locally, but "green in CI" is not something this run can claim.

Recording these is the point. A verification that reports only successes is a
verification nobody can use.
