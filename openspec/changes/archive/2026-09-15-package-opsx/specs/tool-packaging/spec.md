## ADDED Requirements

### Requirement: Per-user state written by a tool is recorded

When a packaged tool writes state outside the project it is pointed at, the
package SHALL record which paths it writes, and the comparison harness SHALL
redirect those paths into its sandbox.

#### Scenario: State paths are recorded with the package

- **WHEN** a tool is observed writing under a user data or config directory
- **THEN** the paths it writes are recorded in `docs/method.md`

#### Scenario: The harness redirects the recorded paths

- **WHEN** the harness starts a tool known to write per-user state
- **THEN** that state lands inside the sandbox and the real user directory is
  unchanged

### Requirement: A tool that can fail silently is invoked so that failure shows

When a tool exits successfully without starting, a check SHALL invoke it in a
way that distinguishes starting from exiting, so that the check cannot pass
vacuously.

#### Scenario: A silent exit does not pass as a start

- **WHEN** a tool exits zero without rendering anything
- **THEN** a check that claims the tool started fails, or invokes the tool with
  the arguments it needs to actually start
