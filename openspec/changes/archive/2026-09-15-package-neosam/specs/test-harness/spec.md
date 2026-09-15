## ADDED Requirements

### Requirement: A tool with no non-interactive entry point gets a start check

When a tool cannot answer `--help` or `--version` because it opens the terminal
immediately, its check SHALL start it on a real pty and prove it stays up for a
bounded time. The check's name MUST say that is what it did.

#### Scenario: A tool that stays up passes

- **WHEN** a tool with no argument parsing is started on a pty
- **THEN** the check passes if the tool is still running at the deadline

#### Scenario: A tool that dies on startup fails

- **WHEN** the program exits non-zero before the deadline
- **THEN** the check fails and reports the exit code

#### Scenario: The check name states what it proved

- **WHEN** the check derivation is inspected
- **THEN** its name identifies it as a pty start check, not a functional check
