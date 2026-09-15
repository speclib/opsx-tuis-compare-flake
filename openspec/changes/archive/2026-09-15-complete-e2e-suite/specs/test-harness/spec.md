## ADDED Requirements

### Requirement: The suite covers every tool the environment exposes

A check that starts the tools SHALL assert that the number it started equals the
number the combined environment exposes, so that a tool added later cannot be
silently skipped.

#### Scenario: A tool added later is not skipped

- **WHEN** a tool is added to the environment but not to the starting check
- **THEN** the check fails on the count rather than passing over it

#### Scenario: Each tool is started against the shared fixture

- **WHEN** the check runs
- **THEN** every exposed tool is started with the fixture as its working
  directory, on a real pty
