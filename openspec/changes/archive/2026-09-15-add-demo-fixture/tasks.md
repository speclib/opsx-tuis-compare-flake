# Tasks: the demo fixture

- [x] 1.1 Write `fixture/openspec/config.yaml`
- [x] 1.2 Write two main specs with requirements and scenarios
- [x] 1.3 Write `add-dark-mode` with all four artifacts and a partial task list
- [x] 1.4 Write `add-user-auth` with no design and no completed tasks
- [x] 1.5 Write an archived change under `changes/archive/`
- [x] 1.6 Put `.openspec.yaml` in every change directory
- [x] 2.1 Write `pkgs/demo-project.nix` and validate at build time
- [x] 2.2 Redirect CLI output to a file so the build log cannot run away
- [x] 2.3 Register the package
- [x] 3.1 Add the `fixture-valid` scenario
- [x] 3.2 Give scenarios a writable fixture copy through `$OST_FIXTURE`
- [x] 3.3 Detect the need for a fixture from the scenario itself
- [x] 4.1 `openspec validate --all --strict` passes in the fixture
- [x] 4.2 `nix build .#demo-project` succeeds
- [x] 4.3 `nix build .#checks.x86_64-linux.e2e-fixture-valid` passes
- [x] 4.4 `nix flake check --all-systems` passes
- [x] 4.5 `openspec validate add-demo-fixture --strict` passes
