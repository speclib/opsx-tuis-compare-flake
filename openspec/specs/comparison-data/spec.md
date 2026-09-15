# comparison-data Specification

## Purpose
The comparison's findings and their provenance. This is the substance of the
repo: the flake exists to make these claims checkable, so what a claim means
and what backs it are part of the contract.

## Requirements

### Requirement: Every cell is decided

Every tool SHALL have a value in every row of both matrices. No cell may be
empty or hold a placeholder.

#### Scenario: No missing or placeholder cells

- **WHEN** the comparison data is checked
- **THEN** every row has a value for every tool, and none contains `TODO`

### Requirement: A cell that is not yes or no explains itself

A cell marked partial or undetermined SHALL carry a note saying what was
observed or what was checked and left unresolved. A note MUST NOT be orphaned.

#### Scenario: Soft cells carry notes

- **WHEN** a cell is partial or undetermined
- **THEN** a note is attached to it

#### Scenario: An unexplained cell fails the check

- **WHEN** a partial cell has its note removed
- **THEN** the completeness check fails

#### Scenario: Notes are all used

- **WHEN** the notes are checked against the matrices
- **THEN** every note is referenced by at least one cell

### Requirement: The terminal and the page cannot disagree

The matrices printed in the terminal and those published in the README SHALL be
produced from the same data. Neither may be edited independently.

#### Scenario: One source

- **WHEN** a cell changes
- **THEN** both the terminal output and the README change with it

### Requirement: The documented commands exist

Every command named in the comparison data SHALL be present in the combined
environment.

#### Scenario: Documentation matches the environment

- **WHEN** the comparison data is checked against the environment
- **THEN** every command it names is executable there

### Requirement: The tools can be run side by side

The comparison SHALL be able to open every tool at once against one shared
project state, so they are judged on identical data.

#### Scenario: One window per tool

- **WHEN** the side-by-side mode is started
- **THEN** a window exists for each tool, all rooted at the same fixture copy

### Requirement: The published page is generated, not transcribed

The README's matrices SHALL be produced from the comparison data rather than
written by hand, and a check SHALL fail when the committed file differs from
what the data produces.

#### Scenario: Drift fails the gate

- **WHEN** the committed README differs from the generated one
- **THEN** the check fails and names the command that regenerates it

#### Scenario: No placeholder survives generation

- **WHEN** the README is generated
- **THEN** no unreplaced placeholder remains in the output

### Requirement: The page discloses its own bias

The README SHALL state, on the page, that one of the compared tools is written
by the owner of this repository.

#### Scenario: Disclosure is present

- **WHEN** the README is read
- **THEN** the authorship of specgetty is stated before the matrices

### Requirement: Observation supersedes source reading

Where a cell filled from a tool's source disagrees with what the tool does when
run, the matrix SHALL record what running it showed, and the note SHALL say that
the source declares the feature.

#### Scenario: A declared feature that does not reach the screen

- **WHEN** a tool's source declares a view but running it renders nothing
- **THEN** the cell records the observed absence, and its note distinguishes
  that from a tool that never had the feature

#### Scenario: An undetermined cell settled by running the tool

- **WHEN** a cell was undetermined from source and running the tool settles it
- **THEN** the cell is updated and its note says it was observed

### Requirement: A timing figure states what it measures

A published timing SHALL state what it measures and under what conditions. A
measurement that does not correspond to when a person can read something MUST
NOT be presented as responsiveness.

#### Scenario: Time to content is the headline figure

- **WHEN** the properties matrix reports startup cost
- **THEN** the headline row is time until the screen carries readable content

#### Scenario: A misleading figure is labelled

- **WHEN** time to first byte is published alongside it
- **THEN** its label and note say it is not responsiveness
