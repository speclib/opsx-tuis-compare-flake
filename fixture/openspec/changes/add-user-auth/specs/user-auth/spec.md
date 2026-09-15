## Purpose

Establishes who a user is and how long that claim lasts, so that per-user
settings and an audit trail become possible.

## ADDED Requirements

### Requirement: A user can sign in

The system SHALL accept an email address and a password, and SHALL start a
session when they match a known user.

#### Scenario: Correct credentials

- **WHEN** a user submits an email address and password that match a known user
- **THEN** the system starts a session and returns the user to where they were

#### Scenario: Incorrect credentials

- **WHEN** a user submits credentials that do not match
- **THEN** the system refuses and does not reveal whether the email exists

### Requirement: A session expires

The system SHALL end a session after a fixed period of inactivity.

#### Scenario: Idle past the limit

- **WHEN** a session has been idle past the limit
- **THEN** the next request is refused and the user is asked to sign in again

### Requirement: A user can sign out

The system SHALL end a session immediately on request.

#### Scenario: Sign out

- **WHEN** a signed-in user signs out
- **THEN** the session ends immediately and cannot be resumed
