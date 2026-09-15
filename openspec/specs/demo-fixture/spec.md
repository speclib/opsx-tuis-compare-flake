# demo-fixture Specification

## Purpose
The shared OpenSpec project every tool under comparison is judged on. It is the
control in the experiment: identical data for all six, shaped so that the
differences between them have somewhere to show.

## Requirements

### Requirement: The fixture is a valid OpenSpec project

The fixture SHALL pass `openspec validate --all --strict`, and this SHALL be
checked when it is built rather than only when it is used.

#### Scenario: Validation at build time

- **WHEN** the fixture derivation is built
- **THEN** validation runs and the build fails if any change or spec is invalid

#### Scenario: The CLI can list it

- **WHEN** `openspec list` runs in the fixture
- **THEN** both active changes appear

### Requirement: The fixture makes tools differ visibly

The fixture SHALL contain changes that differ in task progress and in which
artifacts exist, so that progress indicators and artifact-status displays have
something to distinguish.

#### Scenario: Task progress differs

- **WHEN** the two active changes are listed
- **THEN** one reports partial task completion and the other reports none
  completed

#### Scenario: Artifact presence differs

- **WHEN** the two active changes are compared
- **THEN** one has a design document and the other does not

#### Scenario: An archived change exists

- **WHEN** the fixture is inspected
- **THEN** an archived change is present, so tools that browse archives have
  something to show

### Requirement: The fixture satisfies every tool's assumptions at once

The fixture SHALL meet the loading requirements of all tools under comparison
simultaneously, so that no tool fails for a reason belonging to the fixture
rather than to the tool.

#### Scenario: Change directories carry their metadata file

- **WHEN** any change directory in the fixture is inspected
- **THEN** it contains `.openspec.yaml`, which at least one tool requires
  before it will load a change directory at all

### Requirement: A scenario gets its own writable copy

A test scenario using the fixture SHALL receive a writable copy. The fixture in
the store MUST NOT be modified, and asking for it MUST NOT require editing the
check machinery.

#### Scenario: Copy is writable

- **WHEN** a scenario writes to a file in its fixture copy
- **THEN** the write succeeds and the store copy is unchanged

#### Scenario: Asking for the fixture is local to the scenario

- **WHEN** a scenario refers to the fixture
- **THEN** it receives one without any other file being edited
