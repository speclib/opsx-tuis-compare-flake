# tool-packaging Specification

## Purpose
Defines what it means for an upstream OpenSpec TUI to be packaged by this
flake: which binary a consumer gets, what a package promises about its own
provenance, and how a tool enters the check set.

## Requirements

### Requirement: A packaged tool keeps its upstream binary name

An individual package SHALL install the binary under the name its upstream
ships. Renaming to the comparison's `ost-` scheme SHALL happen only in the
combined environment.

#### Scenario: Upstream name is preserved

- **WHEN** `packages.<system>.specgetty` is built
- **THEN** `result/bin/spg` exists, matching the name upstream installs

### Requirement: A packaged tool records its snapshot

Each package's `version` SHALL identify the upstream revision and date it was
built from.

#### Scenario: Version names the revision

- **WHEN** a package's version string is read
- **THEN** it contains the date and the short revision of its pinned input

### Requirement: Fixed-output hashes are real

A package requiring a fixed-output hash, such as a Go module vendor hash, SHALL
carry the hash of the content it actually fetches. A placeholder hash MUST NOT
be committed.

#### Scenario: The vendor hash matches

- **WHEN** the package is built from a clean store
- **THEN** the build succeeds without a hash mismatch error

#### Scenario: No placeholder hashes in the tree

- **WHEN** the repository is searched for `fakeHash` or `lib.fakeHash`
- **THEN** no package file matches

### Requirement: Packaging a tool registers its check

A package SHALL declare how it is smoke-checked, and the check set SHALL be
derived from the package set. Adding a tool MUST NOT require editing
`flake.nix`.

#### Scenario: A declared tool gains a check

- **WHEN** a package declaring `passthru.smoke` is added to the package set
- **THEN** `checks.<system>.smoke-<name>` exists without `flake.nix` changing

#### Scenario: A broken tool is excluded from checks

- **WHEN** a package is marked `meta.broken`
- **THEN** no smoke check is generated for it

### Requirement: An unset upstream version is stamped at build time

When an upstream declares a version variable and leaves it empty outside its
own release process, the package SHALL stamp the snapshot into it, so that the
tool's own `--version` output agrees with the package version.

#### Scenario: Version output names the snapshot

- **WHEN** a tool whose upstream leaves its version variable unset is built and
  run with `--version`
- **THEN** the output contains the same snapshot string as the package version

#### Scenario: An upstream that sets its own version is left alone

- **WHEN** an upstream compiles its version in as a constant
- **THEN** the package does not overwrite it

### Requirement: Runtime program dependencies are declared by the package

A package whose tool requires another program at runtime SHALL record that
dependency, and the combined environment SHALL put that program on `PATH`. A
user MUST NOT have to install it separately for the tool to start.

#### Scenario: A CLI-backed tool finds its CLI

- **WHEN** a tool that shells out to the `openspec` CLI is started from the
  combined environment
- **THEN** it finds the CLI and does not exit with an installation hint

#### Scenario: The dependency is visible in the package

- **WHEN** a package for a tool with a runtime program dependency is inspected
- **THEN** the dependency is recorded there rather than only in documentation

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
