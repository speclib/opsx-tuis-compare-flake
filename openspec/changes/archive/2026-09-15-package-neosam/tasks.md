# Tasks: package neosam openspec-tui

- [x] 1.1 Read `Cargo.toml` and confirm edition 2024 and the dependency set
- [x] 1.2 Write `pkgs/neosam.nix` with `rustPlatform.buildRustPackage` and
      `cargoLock.lockFile`
- [x] 1.3 Try the plain nixpkgs toolchain first and add no input unless it fails
- [x] 1.4 Register the package
- [x] 2.1 Observe that `--help` exits 1 without a terminal, and record the error
- [x] 2.2 Add `mkStartCheck` to the harness using the pty runner
- [x] 2.3 Let a package select its mode with `passthru.smoke.mode`
- [x] 2.4 Name the check so it reads as a pty start check
- [x] 3.1 `nix build .#neosam` succeeds
- [x] 3.2 The binary stays up under the pty runner
- [x] 3.3 `nix build .#checks.x86_64-linux.smoke-neosam` passes
- [x] 3.4 Falsify `mkStartCheck` with a binary that exits non-zero
- [x] 3.5 `nix flake check --all-systems` passes
- [x] 3.6 `openspec validate package-neosam --strict` passes
