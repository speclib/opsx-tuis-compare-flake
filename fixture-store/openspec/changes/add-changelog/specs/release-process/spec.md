## ADDED Requirements

### Requirement: A release updates the changelog

The system SHALL require a changelog entry for the version being released, and
SHALL refuse to publish without one.

#### Scenario: Missing entry

- **WHEN** a release is attempted with no changelog entry for its version
- **THEN** the system refuses and names the version it expected an entry for
