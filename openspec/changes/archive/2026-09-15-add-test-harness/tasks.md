# Tasks: test harness

## 1. Sandbox helper

- [x] 1.1 Write `tests/lib/sandbox.sh` setting `HOME` and all `XDG_*` bases
      under a build-local `sandbox/` directory
- [x] 1.2 Export `assert_sandboxed`, failing when `HOME` is outside
      `OST_SANDBOX_ROOT`

## 2. Pty helper

- [x] 2.1 Write `tests/lib/pty-run.py` allocating a real pty, bounded by a
      timeout, terminating cleanly
- [x] 2.2 Implement the three-way exit rule: still running is pass, clean exit
      is pass, non-zero before the deadline is fail
- [x] 2.3 Make it assert nothing about rendered output

## 3. Check constructors

- [x] 3.1 Write `tests/default.nix` with `mkSmokeCheck`, naming every check so
      it reads as a link-and-help check
- [x] 3.2 Add `mkE2E` running a scenario script under the sandbox
- [x] 3.3 Discover `tests/e2e/*.sh` with `builtins.readDir` and expose each as
      `checks.<system>.e2e-<name>`
- [x] 3.4 Parse the `# requires:` line of each scenario to build its `PATH`

## 4. First scenarios

- [x] 4.1 `tests/e2e/sandbox-isolates-home.sh` asserting `HOME` and
      `XDG_DATA_HOME` resolve inside the sandbox
- [x] 4.2 The same scenario falsifies `assert_sandboxed` by calling it with
      `HOME=/tmp` and requiring a non-zero exit
- [x] 4.3 `tests/e2e/pty-helper-behaviour.sh` covering all three exit cases of
      the pty helper, including the failing one

## 5. Test gate

- [x] 5.1 `nix flake check --all-systems` passes and runs the new checks
- [x] 5.2 `nix build .#checks.x86_64-linux.e2e-sandbox-isolates-home` passes
- [x] 5.3 Temporarily breaking `assert_sandboxed` makes the scenario fail
- [x] 5.4 `openspec validate add-test-harness --strict` passes
