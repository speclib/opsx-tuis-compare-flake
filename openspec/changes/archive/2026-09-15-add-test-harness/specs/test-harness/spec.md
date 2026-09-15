## Purpose

Defines what this repo's tests guarantee. The comparison is only credible if a
green check means something specific, so the harness fixes what a smoke check
proves, what an end-to-end scenario proves, and what isolation every test runs
under.

## ADDED Requirements

### Requirement: Tests never write outside their sandbox

Every check SHALL run with `HOME` and every `XDG_*` base directory pointed at a
build-local path. No check may read or write the invoking user's home
directory, and in particular none may touch `~/.local/share/openspec`.

#### Scenario: Home is redirected

- **WHEN** a check runs the sandbox helper
- **THEN** `HOME` and `XDG_DATA_HOME` both resolve inside the check's own
  working directory

#### Scenario: The guard detects an unsandboxed environment

- **WHEN** `assert_sandboxed` is called with `HOME` pointing outside the
  sandbox root
- **THEN** it exits non-zero

### Requirement: A smoke check proves linking and help, not function

A smoke check SHALL prove that a binary exists, dynamically links, and responds
to `--help` or `--version`. It SHALL NOT claim to prove that the tool works.
The limitation MUST be visible in the check's name.

#### Scenario: Check name states its scope

- **WHEN** a smoke check derivation is inspected
- **THEN** its name identifies it as a link-and-help check

#### Scenario: A broken binary fails the check

- **WHEN** the named binary is absent from the package
- **THEN** the check fails rather than passing vacuously

### Requirement: Terminal programs are started on a real pty

A check that starts a terminal user interface SHALL allocate a real pty and
SHALL NOT fake one. It SHALL bound the run with a timeout and SHALL accept a
non-zero exit caused by that timeout as success.

#### Scenario: A TUI that starts and waits is accepted

- **WHEN** a program opens the terminal and waits for input until the timeout
  expires
- **THEN** the check passes

#### Scenario: A program that dies immediately is rejected

- **WHEN** a program exits non-zero before the timeout for its own reasons
- **THEN** the check fails

#### Scenario: Rendered output is not asserted on

- **WHEN** a pty check is inspected
- **THEN** it makes no assertion about the characters the program drew

### Requirement: Scenarios are discovered, not enumerated

Adding an end-to-end scenario SHALL require adding a script under `tests/e2e/`
and nothing else. `flake.nix` MUST NOT need editing to register a scenario.

#### Scenario: A new script becomes a check

- **WHEN** a script is added to `tests/e2e/`
- **THEN** a corresponding `checks.<system>.e2e-<name>` exists without any other
  file being changed
