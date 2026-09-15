# Add a dark mode

## Why

Users working in low light report eye strain, and the single light theme is the
most common support request. The theming capability already exists, so this is
an addition to it rather than a new subsystem.

## What Changes

- Add a dark theme alongside the existing light one.
- Follow the operating system preference by default.
- Keep the contrast floor that theming already enforces.

## Capabilities

### Modified Capabilities

- `theming`: a theme can follow the system preference, and a dark theme exists.

### New Capabilities

None.

## Impact

- Theme definitions and the preference store.
- No change to any data format.
