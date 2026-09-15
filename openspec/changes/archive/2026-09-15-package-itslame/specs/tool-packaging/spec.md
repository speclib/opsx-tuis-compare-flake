## ADDED Requirements

### Requirement: Runtime program dependencies are declared by the package

A package whose tool requires another program at runtime SHALL record that
dependency, and the combined environment SHALL put that program on `PATH`. A
user MUST NOT have to install it separately for the tool to start.

#### Scenario: A CLI-backed tool finds its CLI

- **WHEN** a tool that shells out to the `openspec` CLI is started from the
  combined environment
- **THEN** it finds the CLI and does not exit with an installation hint

#### Scenario: The dependency is visible in the package

- **WHEN** a package for a tool with a runtime program dependency is inspected
- **THEN** the dependency is recorded there rather than only in documentation
