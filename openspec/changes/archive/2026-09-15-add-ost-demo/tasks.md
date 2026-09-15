# Tasks: ost-demo

- [x] 1.1 Copy the fixture and the store root to a throwaway directory
- [x] 1.2 Make the copies writable
- [x] 1.3 Redirect `HOME` and every `XDG_*` base into the throwaway directory
- [x] 1.4 Register the demo store there, and report it if that fails
- [x] 1.5 Print a banner naming the paths, on stderr
- [x] 1.6 Run a given command, or drop into a shell when given none
- [x] 1.7 Add it to `packages.default`
- [x] 2.1 Add the `fixture-writable` scenario
- [x] 2.2 Assert a later run does not inherit an earlier run's edit
- [x] 2.3 Assert the store copy is unchanged
- [x] 3.1 Add the `no-host-writes` scenario with a decoy home
- [x] 3.2 Give the decoy a registry with a pre-existing store in it
- [x] 3.3 Compare a fingerprint of every file and its contents
- [x] 3.4 Falsify the fingerprint by writing to the decoy on purpose
- [x] 4.1 Both scenarios pass
- [x] 4.2 `nix flake check --all-systems` passes
- [x] 4.3 `openspec validate add-ost-demo --strict` passes
