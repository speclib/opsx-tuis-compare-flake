# Tasks: package specgetty

- [x] 1.1 Read upstream `package.nix`, `go.mod` and the `src/` entrypoint
- [x] 1.2 Write `pkgs/specgetty.nix` with `buildGoModule`, `subPackages = [ "src" ]`
      and the `spg` rename
- [x] 1.3 Derive `version` from the pinned input
- [x] 1.4 Confirm the vendor hash by building from a clean store
- [x] 1.5 Register the package in `pkgs/default.nix`
- [x] 2.1 Add `passthru.smoke` to the package
- [x] 2.2 Add `mkToolChecks` to the harness, driven off the package set
- [x] 2.3 Filter out packages marked `meta.broken`
- [x] 3.1 `nix build .#specgetty` succeeds
- [x] 3.2 `result/bin/spg --help` exits zero
- [x] 3.3 `nix build .#checks.x86_64-linux.smoke-specgetty` passes
- [x] 3.4 `grep -r fakeHash pkgs/` finds nothing
- [x] 3.5 `nix flake check --all-systems` passes
- [x] 3.6 `openspec validate package-specgetty --strict` passes
