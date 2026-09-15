## ADDED Requirements

### Requirement: The exposed name identifies the tool uniquely

Each tool SHALL be exposed under a name that identifies it unambiguously. The
suffix SHALL be the author where that is unique among the packaged tools, and
the project name where it is not.

#### Scenario: Two tools by one author

- **WHEN** one author has more than one packaged tool
- **THEN** each is exposed under its project name rather than the shared author

#### Scenario: Names stay unique

- **WHEN** the combined environment is inspected
- **THEN** no two tools resolve to the same command

### Requirement: A package without a license does not acquire one

Where an upstream declares no license, the package SHALL leave its license
unset, and the combined environment MUST NOT substitute one from another
package.

#### Scenario: An unlicensed tool is wrapped

- **WHEN** a package declaring no license is wrapped into the environment
- **THEN** the wrapper declares no license either, and the environment still
  builds
