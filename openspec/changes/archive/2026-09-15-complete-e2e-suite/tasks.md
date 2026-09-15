# Tasks: completing the e2e suite

- [x] 1.1 Add the `each-tool-starts` scenario
- [x] 1.2 Drive every tool on a real pty with a bounded timeout
- [x] 1.3 Accept a non-zero exit caused by the timeout
- [x] 1.4 Give `ost-opsx` an explicit project
- [x] 1.5 Assert the started count equals what the environment exposes
- [x] 1.6 Demonstrate the bare `ost-opsx` behaviour in the check's own output
- [x] 1.7 Assert nothing about rendered output
- [x] 2.1 All seven required scenarios exist under `tests/e2e/`
- [x] 2.2 `nix flake check --all-systems` runs all of them and passes
- [x] 2.3 Every scenario has a recorded falsification
- [x] 2.4 `openspec validate complete-e2e-suite --strict` passes
