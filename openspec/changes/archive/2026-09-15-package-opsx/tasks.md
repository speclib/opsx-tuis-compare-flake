# Tasks: package opsx-tui

- [x] 1.1 Read `pyproject.toml` and the `src/opsx_tui/` layout
- [x] 1.2 Check the briefing's SQLite and keyring claims against the source
- [x] 1.3 Write `pkgs/opsx.nix` with `buildPythonApplication`, setuptools, src layout
- [x] 1.4 Relax the pins and say in the file why it was unavoidable
- [x] 1.5 Record the license contradiction in `meta` without resolving it
- [x] 2.1 `nix build .#opsx` succeeds
- [x] 2.2 `result/bin/opsx-tui --help` exits zero
- [x] 2.3 Start it with `--project` and confirm it renders and stays up
- [x] 2.4 Start it with a clean HOME and no project, and record the silent exit
- [x] 2.5 Choose help mode over pty mode and say why in the design
- [x] 2.6 Record the per-user state paths it writes
- [x] 3.1 `nix build .#checks.x86_64-linux.smoke-opsx` passes
- [x] 3.2 All six tools build: `nix build .#specgetty .#dossier .#neosam .#mstanton .#itslame .#opsx`
- [x] 3.3 `nix flake check --all-systems` passes
- [x] 3.4 `openspec validate package-opsx --strict` passes
