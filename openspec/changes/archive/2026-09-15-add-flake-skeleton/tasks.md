# Tasks: flake skeleton

## 1. Inputs and systems

- [x] 1.1 Write `flake.nix` with `nixpkgs` plus six `flake = false` upstream
      inputs, using `github:mstanton/openspec-tui/main` for mstanton
- [x] 1.2 Declare `systems` as a literal list and map it with
      `nixpkgs.lib.genAttrs`
- [x] 1.3 Confirm no `flake-utils` or `flake-parts` input is present:
      `grep -E 'flake-utils|flake-parts' flake.nix` returns nothing

## 2. Version helper

- [x] 2.1 Write `lib/version.nix` deriving a version from `shortRev` and
      `lastModifiedDate`, falling back to `dirty` when `shortRev` is absent
- [x] 2.2 Verify with
      `nix eval --raw .#lib.versions.specgetty` that it yields a date and a rev

## 3. Package set and outputs

- [x] 3.1 Write `pkgs/default.nix` taking `{ pkgs, inputs }` and returning the
      package set
- [x] 3.2 Wire `packages`, `devShells`, `apps` and `checks` through the same
      `forAllSystems` helper
- [x] 3.3 Add `devShells.<system>.default` with go, cargo, python3, openspec,
      jq, tmux and nixfmt

## 4. Lock

- [x] 4.1 Run `nix flake lock` and commit `flake.lock`
- [x] 4.2 Verify all seven nodes are pinned to an exact `rev`

## 5. Test gate

- [x] 5.1 `nix flake check` passes
- [x] 5.2 `nix flake check --all-systems` passes for every declared system
- [x] 5.3 `nix develop --command sh -c 'go version && cargo --version && python3 --version && openspec --version'` succeeds
- [x] 5.4 `openspec validate add-flake-skeleton --strict` passes
