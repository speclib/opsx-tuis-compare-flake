## ADDED Requirements

### Requirement: A relaxed dependency pin is verified by running the tool

When a package relaxes an upstream version constraint in order to build against
this flake's nixpkgs, the resulting program SHALL be observed running before
any capability is claimed for it. A successful build MUST NOT be reported as
evidence that the tool works.

#### Scenario: Relaxed build is exercised

- **WHEN** a package sets a relaxed dependency constraint
- **THEN** the tool is started and its behaviour is recorded in
  `docs/method.md` alongside the versions it was built against

#### Scenario: A start check is not treated as proof of function

- **WHEN** a pty start check passes for a tool built with relaxed pins
- **THEN** the matrix still marks any capability not directly observed as
  partial or undetermined
