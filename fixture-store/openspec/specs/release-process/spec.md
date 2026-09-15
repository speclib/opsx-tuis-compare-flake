# release-process Specification

## Purpose
Describes how a release is cut, so that the same steps happen in the same order
whoever runs them.

## Requirements

### Requirement: A release is tagged

The system SHALL tag every release with a version, and SHALL refuse to publish
an untagged build.

#### Scenario: Untagged build

- **WHEN** a publish is attempted from an untagged build
- **THEN** the system refuses and says which tag was expected
