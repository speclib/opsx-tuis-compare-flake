## ADDED Requirements

### Requirement: The demo entry point hands over a writable copy

`ost-demo` SHALL place the user in a copy of the fixture that is outside the
immutable store and writable, so that tools which toggle tasks or write files
can do so.

#### Scenario: A task can be toggled

- **WHEN** a task checkbox is toggled in the demo copy
- **THEN** the write succeeds and the reported task count changes

#### Scenario: Each invocation is independent

- **WHEN** the demo entry point is run twice
- **THEN** the second run starts from the original fixture state

#### Scenario: The immutable copy is not modified

- **WHEN** the demo copy has been edited
- **THEN** the fixture in the store is unchanged

### Requirement: A comparison run never writes to the user's home

A full run through the demo entry point SHALL leave the invoking user's home
directory unchanged, including their OpenSpec store registry and configuration.

#### Scenario: A pre-existing registry survives untouched

- **WHEN** a full harness pass runs with `HOME` pointing at a home that already
  contains a store registry
- **THEN** that home is byte-for-byte unchanged afterwards

#### Scenario: The demo store is not registered in the user's registry

- **WHEN** the demo entry point registers its store
- **THEN** the registration is in the throwaway directory and the user's
  registry does not mention it
