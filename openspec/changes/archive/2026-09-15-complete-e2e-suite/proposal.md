# Complete the e2e suite

Beans epic: `opsx-tuis-compare-flake-aw79` (milestone 08).
Briefing: section 5 criterion 4.

## Why

Six of the seven required scenarios landed alongside the work they protect,
which is where they belong. The seventh, starting every tool against the
fixture, could not exist until every tool and the fixture did.

It is also the scenario most at risk of passing without meaning anything, so it
is worth its own change rather than a line in another one.

## What Changes

- Add the `each-tool-starts` scenario.
- Drive every tool on a real pty with a bounded timeout.
- Pass `ost-opsx` an explicit project, because without one it exits zero
  without drawing and a start check would count that as success.
- Assert the number of tools started equals the number the environment exposes.

## Capabilities

### Modified Capabilities

- `test-harness`: add the requirement that a suite covers every tool the
  environment exposes, rather than a list that can fall behind.

### New Capabilities

None.

## Impact

- `checks.<system>.e2e-each-tool-starts` appears. The suite is now eight
  scenarios, plus six smoke checks and two self-checks.
