# Design: the combined environment

## Wrapping happens here, not in the packages

The briefing is explicit and the reason is concrete: three upstream projects
install a binary called `openspec-tui`. If each package installed its own
`ost-` name, the individual package would stop matching what upstream ships,
which the comparison is supposed to be reporting on. If each package installed
both names, three `openspec-tui` symlinks would race inside one `buildEnv` and
the winner would be an implementation detail of the store path ordering.

So each package keeps exactly the upstream name, and the environment builds one
wrapper per tool. `no-name-collision` asserts both halves: the upstream names
are absent from the environment, and the packages still carry them.

## The tool list is derived, never written down

`ost-env.nix` filters the package set for anything declaring `passthru.smoke`
and not marked `meta.broken`. A hand-written list would have to be edited by
every packaging epic and would silently drop a tool whose line was forgotten.
It also gives the degradation rule for free: marking a tool broken removes it
from the environment and from the checks in one edit.

The environment passes the resulting names out again as
`passthru.toolNames`, so `ost-compare` and the scenarios read what is actually
there rather than a list that can drift from it.

## Runtime PATH for all, not only for those that need it

Only itslame hard-requires the `openspec` CLI. All six wrappers get it anyway,
because the comparison is supposed to judge the tools rather than the user's
installation. A tool that could have used the CLI and did not is then a fact
about the tool.

This is testable rather than assumed: `default-env` runs `ost-itslame` with
`PATH=/nonexistent` and asserts the install hint does not appear.
