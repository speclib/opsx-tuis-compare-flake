# task-tracking Specification

## Purpose
Tracks the work items that make up a change, so that progress through a change
is visible without reading every file in it.

## Requirements

### Requirement: A task list records completion

The system SHALL record each task as done or not done, and SHALL report the
proportion complete.

#### Scenario: Partially complete list

- **WHEN** a change has four tasks and two are marked done
- **THEN** the system reports the change as 50 percent complete

#### Scenario: Empty list

- **WHEN** a change has no tasks
- **THEN** the system reports the change as having no tasks rather than as
  complete

### Requirement: Tasks belong to exactly one change

The system SHALL associate every task with one change, and SHALL reject a task
that names no change.

#### Scenario: Task without a change

- **WHEN** a task is recorded with no change
- **THEN** the system rejects it and reports which task was rejected
