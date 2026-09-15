## Purpose

Defines what this flake exposes to someone who runs it: which systems it
supports, how upstream tools enter it, and what the published outputs are. The
repo is a comparison artifact, so the packaging contract is part of the product
rather than an implementation detail.

## ADDED Requirements

### Requirement: Supported systems are declared explicitly

The flake SHALL declare its supported systems as a literal list and map that
list with `nixpkgs.lib.genAttrs`. The flake MUST NOT depend on `flake-utils`,
`flake-parts`, or any other output-generation input.

#### Scenario: Every declared system evaluates

- **WHEN** `nix flake check --all-systems` is run
- **THEN** it exits zero, having evaluated every output for `x86_64-linux`,
  `aarch64-linux` and `aarch64-darwin`

#### Scenario: A system nixpkgs has dropped is not declared

- **WHEN** the pinned nixpkgs no longer supports a platform
- **THEN** that platform is absent from the declared system list, and the
  reason is recorded in `docs/method.md`

#### Scenario: No output-generation dependency

- **WHEN** `flake.lock` is inspected
- **THEN** no node named `flake-utils`, `flake-parts` or `systems` is present

### Requirement: Upstream tools enter as pinned non-flake inputs

Every upstream TUI SHALL enter the flake as an input declared with
`flake = false` and SHALL be pinned to an exact revision in `flake.lock`. No
upstream source may be copied into this repository.

#### Scenario: All six sources are pinned

- **WHEN** `flake.lock` is inspected
- **THEN** it contains one locked node per upstream tool, each with an exact
  `rev`, for specgetty, dossier, neosam, mstanton, itslame and opsx

#### Scenario: Upstream flakes are not consumed

- **WHEN** an upstream repo ships its own `flake.nix`
- **THEN** this flake still declares it with `flake = false` and does not read
  its outputs

### Requirement: Package versions record the snapshot

Each packaged tool's `version` SHALL be derived from its input's revision and
last-modified date, so that a build identifies which upstream snapshot it came
from.

#### Scenario: Version carries rev and date

- **WHEN** a package built from a pinned input is inspected
- **THEN** its version string contains the input's short revision and the date
  of that revision

### Requirement: A development shell is provided

The flake SHALL expose `devShells.<system>.default` containing the toolchains
needed to build and inspect every packaged tool.

#### Scenario: Toolchains are present

- **WHEN** `nix develop` is entered
- **THEN** `go`, `cargo`, `python3`, `openspec` and `jq` are on `PATH`

### Requirement: Evaluation is always green

`nix flake check` SHALL pass on a clean checkout at every commit on the main
bookmark.

#### Scenario: Clean checkout evaluates

- **WHEN** the repository is cloned to an empty directory and `nix flake check`
  is run
- **THEN** it exits zero
