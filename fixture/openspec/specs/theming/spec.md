# theming Specification

## Purpose
Controls how the interface is coloured, so that the product is readable in the
environments its users work in.

## Requirements

### Requirement: A theme can be chosen

The system SHALL let a user choose a theme, and SHALL apply it to every screen.

#### Scenario: Theme applies everywhere

- **WHEN** a user selects a theme
- **THEN** every screen renders with that theme without a restart

### Requirement: An unreadable combination is refused

The system SHALL refuse a foreground and background pairing below the minimum
contrast ratio.

#### Scenario: Low contrast pairing

- **WHEN** a user picks a pairing below the minimum contrast ratio
- **THEN** the system refuses it and says which ratio was required
