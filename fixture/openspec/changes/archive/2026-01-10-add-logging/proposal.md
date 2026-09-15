# Add structured logging

## Why

Failures were reported as screenshots of a stack trace, which made it
impossible to tell how often anything happened. Structured logging replaces
that with something countable.

## What Changes

- Emit one structured record per request.
- Record the change a task belongs to, so task-tracking failures are traceable.

## Capabilities

### Modified Capabilities

- `task-tracking`: a rejected task records why it was rejected.

### New Capabilities

None.

## Impact

- A log sink and a record format.
