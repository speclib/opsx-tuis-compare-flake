# Tasks: package mstanton openspec-tui

- [x] 1.1 Read `pyproject.toml`, confirm the setuptools backend and entry points
- [x] 1.2 Check the nixpkgs textual version against the upstream pin
- [x] 1.3 Write `pkgs/mstanton.nix` with `buildPythonApplication` and `pyproject = true`
- [x] 1.4 Relax the dependency pins and say in the file why it was unavoidable
- [x] 1.5 Set `doCheck = false`
- [x] 1.6 Record the license claim and the missing LICENSE file in `meta`
- [x] 2.1 `nix build .#mstanton` succeeds
- [x] 2.2 The package installs the entry points upstream declares
- [x] 2.3 Start it on a real pty and read back what it draws
- [x] 2.4 Confirm it renders its menu rather than a framework error screen
- [x] 2.5 Record both versions in `docs/method.md`
- [x] 3.1 `nix build .#checks.x86_64-linux.smoke-mstanton` passes
- [x] 3.2 `nix flake check --all-systems` passes
- [x] 3.3 `openspec validate package-mstanton --strict` passes
