## ADDED Requirements

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
