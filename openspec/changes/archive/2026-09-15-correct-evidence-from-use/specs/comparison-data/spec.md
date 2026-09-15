## ADDED Requirements

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
