# Tasks: package dossier

- [x] 1.1 Read `go.mod`, the `cmd/dossier` entrypoint and `internal/openspec/loader.go`
- [x] 1.2 Write `pkgs/dossier.nix` with `buildGoModule` and `subPackages = [ "cmd/dossier" ]`
- [x] 1.3 Resolve the vendor hash by building and reading the mismatch error
- [x] 1.4 Commit the real hash, leaving no placeholder in the tree
- [x] 1.5 Stamp the snapshot with `-X main.version=`
- [x] 1.6 Register the package and its `passthru.smoke`
- [x] 2.1 `nix build .#dossier` succeeds
- [x] 2.2 `result/bin/dossier --help` exits zero
- [x] 2.3 `result/bin/dossier --version` reports the snapshot, not an empty string
- [x] 2.4 `nix build .#checks.x86_64-linux.smoke-dossier` passes
- [x] 2.5 `grep -rn fakeHash pkgs/` finds nothing
- [x] 2.6 `nix flake check --all-systems` passes
- [x] 2.7 `openspec validate package-dossier --strict` passes
