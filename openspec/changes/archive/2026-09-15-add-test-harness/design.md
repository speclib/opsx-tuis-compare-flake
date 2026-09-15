# Design: test harness

## Why a pty and not a fake TTY

Three of the six tools are full-screen terminal programs. Running them with
stdin closed makes them exit immediately, which proves nothing, and setting
`TERM=dumb` makes some of them refuse to start at all. The briefing forbids
faking a TTY and forbids asserting on rendered frames, which leaves exactly one
honest signal: give the program a real pty, let it run for a bounded time, and
judge it on whether it stayed up.

`tests/lib/pty-run.py` uses `pty.openpty` plus `subprocess`, waits for the
deadline, then sends SIGTERM and SIGKILL. The exit rule is the interesting part:

- The program was still running when the deadline hit: pass. It started and
  stayed up.
- The program exited zero before the deadline: pass. Non-interactive tools such
  as `--help` behave this way.
- The program exited non-zero before the deadline: fail, and the captured
  output is printed.

That third case is what makes the check falsifiable. A tool that crashes on
startup fails, a tool that sits at its first frame passes, and no assertion is
made about what the frame contained.

## Sandbox shape

`tests/lib/sandbox.sh` is sourced, not executed, because it must mutate the
caller's environment. It sets `HOME`, `XDG_DATA_HOME`, `XDG_CONFIG_HOME`,
`XDG_CACHE_HOME` and `XDG_STATE_HOME` under a `sandbox/` directory inside the
check's working directory, and exports `OST_SANDBOX_ROOT` so `assert_sandboxed`
has something to compare against.

`assert_sandboxed` is a separate function rather than an inline check so it can
be called twice in the self-test: once in a sandboxed state expecting success,
and once with `HOME=/tmp` expecting failure. A test that cannot fail proves
nothing, so every scenario in this repo ships with its falsification.

The Nix build sandbox already isolates the filesystem, so this helper is not
what stops a rogue write during `nix flake check`. It exists because the same
scripts run outside Nix from `ost-demo` and from the comparison harness, where
nothing else would stop a tool from registering a store in the user's real
registry.

## Scenario discovery

`tests/default.nix` reads `tests/e2e/` with `builtins.readDir` and turns every
`*.sh` into `checks.<system>.e2e-<name>`. Adding a scenario is adding a file.
The alternative, an explicit list, would have to be edited by six later epics
and would silently drop a scenario whose line was forgotten.

Each scenario script gets `PATH` composed from the packages it declares in a
`# requires:` comment on its second line. That keeps the dependency next to the
script that needs it instead of in a table in another file.
