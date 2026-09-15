## ADDED Requirements

### Requirement: A dark theme is available

The system SHALL provide a dark theme that meets the same contrast floor as
every other theme.

#### Scenario: Dark theme selected

- **WHEN** a user selects the dark theme
- **THEN** every screen renders with the dark palette

### Requirement: The system preference can be followed

The system SHALL offer a follow-the-system setting, distinct from choosing
light or dark explicitly, and SHALL apply changes to the system preference
without a restart.

#### Scenario: System preference changes while running

- **WHEN** the setting is follow-the-system and the operating system switches
  to dark
- **THEN** the interface switches to dark without a restart

#### Scenario: An explicit choice is not overridden

- **WHEN** a user has chosen light explicitly and the operating system switches
  to dark
- **THEN** the interface stays light

## MODIFIED Requirements

### Requirement: A theme can be chosen

The system SHALL let a user choose a theme, and SHALL apply it to every screen.
The choice SHALL be one of light, dark, or follow-the-system.

#### Scenario: Theme applies everywhere

- **WHEN** a user selects a theme
- **THEN** every screen renders with that theme without a restart

#### Scenario: Follow-the-system is a distinct choice

- **WHEN** a user has never chosen a theme
- **THEN** the setting reads as follow-the-system rather than as light
