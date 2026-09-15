# neosam/openspec-tui: not a reader but an implementation runner. It batches
# runs, models a dependency graph between changes, launches an agent, and has
# an in-app config editor.
{
  lib,
  rustPlatform,
  inputs,
  mkVersion,
}:

rustPlatform.buildRustPackage {
  pname = "neosam-openspec-tui";
  version = mkVersion inputs.src-neosam;

  src = inputs.src-neosam;

  cargoLock.lockFile = "${inputs.src-neosam}/Cargo.lock";

  doCheck = false;

  # This tool has no argument parsing: it opens the terminal immediately and
  # exits 1 with `Os { code: 6, ... "No such device or address" }` when there is
  # none, so `--help` is not available as a check. A pty start check is the
  # honest substitute.
  passthru.smoke = {
    mode = "pty";
    bin = "openspec-tui";
    timeout = 5;
  };

  meta = {
    description = "Terminal runner for implementing OpenSpec changes, with batch runs and a dependency graph";
    homepage = "https://github.com/neosam/openspec-tui";
    license = lib.licenses.mit;
    mainProgram = "openspec-tui";
    platforms = lib.platforms.unix;
  };
}
