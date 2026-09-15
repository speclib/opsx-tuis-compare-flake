# combined-environment Specification

## Purpose
What a person gets when they run `nix shell` on this flake: every tool under
comparison available at once, under names that cannot collide, with whatever
each tool needs at runtime already present.

## Requirements

### Requirement: Every usable tool is exposed under a prefixed name

The combined environment SHALL expose each usable tool as `ost-<author>`, and
SHALL expose the `openspec` CLI under its own name. It MUST expose nothing
else.

#### Scenario: The expected set is present

- **WHEN** the environment's `bin` directory is listed
- **THEN** it contains one `ost-` command per usable tool, plus `openspec`

#### Scenario: Nothing else is present

- **WHEN** the environment's `bin` directory is listed
- **THEN** it contains no entry that is neither `openspec` nor `ost-` prefixed

### Requirement: No upstream binary name reaches PATH

The combined environment MUST NOT expose any tool under the binary name its
upstream installs. This applies in particular to `openspec-tui`, which three
separate upstream projects install.

#### Scenario: Colliding names are absent

- **WHEN** the environment is inspected for `openspec-tui` or `opsx-tui`
- **THEN** neither exists

#### Scenario: Individual packages are unaffected

- **WHEN** an individual package is built directly
- **THEN** it still installs the binary name its upstream ships

### Requirement: A wrapped tool finds what it needs at runtime

Each wrapper SHALL supply the programs its tool requires at runtime, so that a
tool starts from the combined environment without the user installing anything
else.

#### Scenario: A CLI-backed tool works with an otherwise empty PATH

- **WHEN** a tool that requires the `openspec` CLI is run through its wrapper
  with nothing else on `PATH`
- **THEN** it runs and does not report that the CLI is missing

### Requirement: A broken tool leaves the environment

A tool marked broken SHALL be absent from the combined environment while
keeping its package attribute.

#### Scenario: Degraded tool is excluded

- **WHEN** a package is marked `meta.broken`
- **THEN** no wrapper for it appears in the environment, and the environment
  still builds

### Requirement: The demo entry point hands over a writable copy

`ost-demo` SHALL place the user in a copy of the fixture that is outside the
immutable store and writable, so that tools which toggle tasks or write files
can do so.

#### Scenario: A task can be toggled

- **WHEN** a task checkbox is toggled in the demo copy
- **THEN** the write succeeds and the reported task count changes

#### Scenario: Each invocation is independent

- **WHEN** the demo entry point is run twice
- **THEN** the second run starts from the original fixture state

#### Scenario: The immutable copy is not modified

- **WHEN** the demo copy has been edited
- **THEN** the fixture in the store is unchanged

### Requirement: A comparison run never writes to the user's home

A full run through the demo entry point SHALL leave the invoking user's home
directory unchanged, including their OpenSpec store registry and configuration.

#### Scenario: A pre-existing registry survives untouched

- **WHEN** a full harness pass runs with `HOME` pointing at a home that already
  contains a store registry
- **THEN** that home is byte-for-byte unchanged afterwards

#### Scenario: The demo store is not registered in the user's registry

- **WHEN** the demo entry point registers its store
- **THEN** the registration is in the throwaway directory and the user's
  registry does not mention it
