## ADDED Requirements

### Requirement: An unset upstream version is stamped at build time

When an upstream declares a version variable and leaves it empty outside its
own release process, the package SHALL stamp the snapshot into it, so that the
tool's own `--version` output agrees with the package version.

#### Scenario: Version output names the snapshot

- **WHEN** a tool whose upstream leaves its version variable unset is built and
  run with `--version`
- **THEN** the output contains the same snapshot string as the package version

#### Scenario: An upstream that sets its own version is left alone

- **WHEN** an upstream compiles its version in as a constant
- **THEN** the package does not overwrite it
