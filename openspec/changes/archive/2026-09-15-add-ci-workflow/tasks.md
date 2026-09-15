# Tasks: CI workflow

- [x] 1.1 Add `.github/workflows/build.yml` for push to `main` and pull requests
- [x] 1.2 Install Nix with flakes enabled on `ubuntu-latest`
- [x] 1.3 Run `nix flake check -L`
- [x] 1.4 Build `packages.default` only when the attribute exists
- [x] 1.5 Validate the workflow YAML parses
- [x] 1.6 `nix flake check` still passes locally
- [x] 1.7 `openspec validate add-ci-workflow --strict` passes
