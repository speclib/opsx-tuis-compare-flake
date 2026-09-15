## ADDED Requirements

### Requirement: A second root is available as a store

The comparison SHALL provide a second OpenSpec root, distinct from the fixture,
registrable as a store, so that tools can be observed against the `--store`
resolution path.

#### Scenario: The store resolves by id

- **WHEN** a tool or the CLI is given the registered store id
- **THEN** it resolves to the second root and sees that root's changes

#### Scenario: The store does not leak into working-directory resolution

- **WHEN** resolution happens from a working directory inside the fixture with
  no store id given
- **THEN** the fixture resolves and the store's changes are absent

### Requirement: Store registration never reaches the machine's registry

Registering a store for the comparison SHALL write only inside the sandbox. The
registry under the user's real data directory MUST NOT be created or modified.

#### Scenario: The registry lands in the sandbox

- **WHEN** a store is registered during a test
- **THEN** the registry file is inside the sandbox root

#### Scenario: An unregistered id is refused

- **WHEN** an id that was never registered is given
- **THEN** resolution fails rather than falling back to another root
