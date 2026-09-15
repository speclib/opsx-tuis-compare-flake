## Purpose

What a person gets when they run `nix shell` on this flake: every tool under
comparison available at once, under names that cannot collide, with whatever
each tool needs at runtime already present.

## ADDED Requirements

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
