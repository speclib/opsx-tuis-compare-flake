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
