## MODIFIED Requirements

### Requirement: Tasks belong to exactly one change

The system SHALL associate every task with one change, and SHALL reject a task
that names no change. A rejection SHALL record the reason in the structured log
so that rejections can be counted.

#### Scenario: Task without a change

- **WHEN** a task is recorded with no change
- **THEN** the system rejects it and reports which task was rejected

#### Scenario: Rejection is countable

- **WHEN** a task is rejected
- **THEN** the structured log records the reason as a field
