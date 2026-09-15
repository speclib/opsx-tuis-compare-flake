# Tasks: the store fixture

- [x] 1.1 Write `fixture-store/` as a second valid OpenSpec root
- [x] 1.2 Write `pkgs/demo-store.nix`, validating at build time
- [x] 1.3 Register the package
- [x] 2.1 Add the `store-resolution` scenario
- [x] 2.2 Register the store inside the build sandbox, never on the host
- [x] 2.3 Assert the registry file is inside the sandbox root
- [x] 2.4 Assert `--store` and cwd resolution give different roots
- [x] 2.5 Falsify with an unregistered store id
- [x] 3.1 `nix build .#demo-store` succeeds
- [x] 3.2 `nix build .#checks.x86_64-linux.e2e-store-resolution` passes
- [x] 3.3 The host `~/.local/share/openspec` is untouched
- [x] 3.4 `nix flake check --all-systems` passes
- [x] 3.5 `openspec validate add-store-fixture --strict` passes
