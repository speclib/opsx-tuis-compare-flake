# Tasks: package itslame openspec-tui

- [x] 1.1 Read `go.mod`, `main.go` and `internal/openspec/client.go`
- [x] 1.2 Write `pkgs/itslame.nix` with `buildGoModule` on the repo root
- [x] 1.3 Resolve the vendor hash by building and reading the mismatch
- [x] 1.4 Stamp the snapshot with `-X main.version=`, replacing the `dev` default
- [x] 1.5 Record the runtime `openspec` dependency in `passthru.runtimeDeps`
- [x] 1.6 Register the package and its `passthru.smoke`
- [x] 2.1 `nix build .#itslame` succeeds
- [x] 2.2 `result/bin/openspec-tui --help` exits zero and shows `-store`
- [x] 2.3 `result/bin/openspec-tui --version` reports the snapshot, not `dev`
- [x] 2.4 Observe the failure with no `openspec` on `PATH` and record it
- [x] 2.5 `nix build .#checks.x86_64-linux.smoke-itslame` passes
- [x] 2.6 `grep -rn fakeHash pkgs/` finds nothing
- [x] 2.7 `nix flake check --all-systems` passes
- [x] 2.8 `openspec validate package-itslame --strict` passes
