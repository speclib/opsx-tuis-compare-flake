# Method

How each claim in this repo was determined, and what every marker means.

## Provenance markers

| Marker | Meaning                                                        |
|--------|----------------------------------------------------------------|
| yes    | Observed by running the tool, or read directly in its source    |
| no     | Observed absent by running the tool, or absent from its source  |
| part   | Present but incomplete, or inferred from a README not from a run |
| ?      | Could not be determined. The footnote says what was tried        |

A cell is never filled from a README claim alone without being marked `part`.

## Platform support

`x86_64-darwin` is not a declared system. The pinned nixpkgs refuses to
evaluate for it:

```
error: Nixpkgs 26.11 has dropped support for x86_64-darwin.

The 26.05 stable branch still supports x86_64-darwin, and will
receive security fixes until the end of 2026.
```

This is an evaluation failure rather than a build failure, so declaring the
platform would make `nix flake check --all-systems` fail for every output,
including the devshell. Pinning nixpkgs to `nixpkgs-26.05-darwin` instead would
hold the whole comparison on a branch older than several upstreams' Go and
Python requirements. Declared systems are therefore `x86_64-linux`,
`aarch64-linux` and `aarch64-darwin`.

## Upstream snapshots

Every tool is built from a revision pinned in `flake.lock`. The package version
records it as `0-unstable-<date>+<shortRev>`, and `nix eval .#lib.versions`
prints the whole set.

## How the tests were falsified

A test that cannot fail proves nothing, so each piece of the harness was broken
on purpose and the failure observed.

| What was broken                              | What failed, and how                                                 |
|----------------------------------------------|----------------------------------------------------------------------|
| `assert_sandboxed` made to always return 0    | `e2e-sandbox-isolates-home` failed: "assert_sandboxed accepted HOME=/tmp" |
| A smoke check pointed at a non-existent binary | The check failed and listed what the package's `bin` did contain     |
| Pty runner given a program that exits 3       | Covered inside `e2e-pty-helper-behaviour`, which asserts the failure  |
| A pty start check pointed at a binary exiting 4 | The check failed: "pty-run: exited 4 before the 3.0s deadline: FAIL" |

The first two cannot live inside `nix flake check`, because a check that must
fail would fail the gate. They are run by hand and recorded here. The third is
a falsification a scenario can carry itself, so it does.

## What a green check means

| Check          | Proves                                                          |
|----------------|-----------------------------------------------------------------|
| `smoke-<tool>` | The binary exists, dynamically links, and answers `--help`       |
| `smoke-<tool>` in pty mode | The binary exists, links, and stays up on a real terminal for a bounded time |
| `e2e-<name>`   | The named scenario's assertions held under a sandboxed `HOME`    |

A smoke check is a link-and-help check. It does not prove the tool works, and
its derivation name says so.

## What a smoke check proves per tool

The link-and-help check runs `--help` before the tool reaches its real work, so
for some tools it proves less than for others.

| Tool    | Caveat                                                                     |
|---------|-----------------------------------------------------------------------------|
| itslame | `--help` and `--version` run before its `exec.LookPath("openspec")` check, so a green smoke check does not prove the CLI was found |
| neosam  | Has no argument parsing at all. `--help` exits 1 with ENXIO from opening `/dev/tty`, so it gets a pty start check instead |

## Relaxed dependency pins

Neither Python tool ships a lockfile, and there is one nixpkgs for the whole
flake, so both are built with their version constraints relaxed. That crosses
boundaries upstream excluded, which makes a green build worthless as evidence
on its own. Each relaxed tool was therefore started by hand on a real pty and
the drawn output read back.

| Tool     | Upstream pin              | Built against  | Observed                          |
|----------|---------------------------|----------------|-----------------------------------|
| mstanton | `textual>=0.41.0,<1.0.0`  | textual 8.2.8  | Renders its real menu, not an error screen |
| opsx     | `textual>=1.0,<3.0`       | textual 8.2.8  | Renders its header and board tab when given a project |

A pty start check cannot tell a working Textual program from one that crashed
into Textual's own error screen, since both stay up. That is why the check is
not permitted to assert on rendered output and why this table exists instead.
Recheck it when either version moves.

## Per-user state written by the tools

Observed after one run of `opsx-tui` under a redirected `HOME`:

| Path                                         | Written by                                  |
|----------------------------------------------|---------------------------------------------|
| `$XDG_DATA_HOME/opsx-tui/recent-projects.json` | opsx-tui, remembering projects via platformdirs |
| `$XDG_CONFIG_HOME/openspec/config.json`        | the `openspec` CLI, a telemetry anonymousId |

Both land in the user's real directories if nothing redirects them. This is the
concrete reason the harness sets `XDG_DATA_HOME` and `XDG_CONFIG_HOME` and not
only `HOME`.

The first one also explains a confusing observation during packaging: a second
run appeared to find a project from a directory that had none, because it had
remembered the previous one.

## Tools that can exit successfully without starting

`opsx-tui` with a clean `HOME` and no OpenSpec root in the working directory
exits 0 after 239 bytes of terminal setup and teardown, drawing nothing and
printing no error. It does not walk up from the working directory the way the
`openspec` CLI does.

Its check is therefore a link-and-help check rather than a pty start check: a
pty start check counts a clean early exit as a pass, so it would claim the tool
started when it had not. Any scenario that means to start this tool must pass
it `--project`.

## Degradations

None. All six tools build and run. The briefing anticipated that `opsx` or
`mstanton` might not; both do, with relaxed dependency pins recorded above.
