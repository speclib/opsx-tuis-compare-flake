# Design: structured logging

## One record per request, not per event

Per-event records were considered and dropped: they multiply with every future
feature, and the questions people were asking were all per-request. A single
record with a field per event keeps the count stable.

## Rejection reasons are part of the record

The task-tracking capability already rejects a task with no change. Until now
the reason existed only in the message shown to the user, so it could not be
counted. It becomes a field.
