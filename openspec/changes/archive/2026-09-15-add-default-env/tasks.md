# Tasks: the combined environment

- [x] 1.1 Write `pkgs/ost-env.nix` building a `buildEnv` of wrappers
- [x] 1.2 Derive the tool list from the package set, excluding broken ones
- [x] 1.3 Wrap each tool as `ost-<author>` with `makeWrapper`
- [x] 1.4 Give every wrapper the openspec CLI and git on its PATH
- [x] 1.5 Expose the resulting names as `passthru.toolNames`
- [x] 2.1 Add `apps.<system>.<name>` derived from the same filter
- [x] 3.1 Add the `default-env` scenario, including the exactly-and-no-more check
- [x] 3.2 Add the `no-name-collision` scenario for all four colliding names
- [x] 3.3 Prove the wrapper supplies the CLI by running with an empty PATH
- [x] 4.1 `nix build .#default && ls result/bin` lists the expected set
- [x] 4.2 Both scenarios pass
- [x] 4.3 `nix flake check --all-systems` passes
- [x] 4.4 `openspec validate add-default-env --strict` passes
