# The two check constructors every later epic uses, plus scenario discovery.
#
# A smoke check proves a binary exists, links, and answers --help. It does not
# prove the tool works, and its derivation name says so.
#
# An e2e scenario is a shell script under tests/e2e/. Adding one is adding a
# file: nothing in flake.nix needs editing.
{ pkgs }:

let
  inherit (pkgs) lib;

  libDir = ./lib;

  pyRun = pkgs.writeShellScriptBin "ost-pty-run" ''
    exec ${pkgs.python3}/bin/python3 ${libDir}/pty-run.py "$@"
  '';

  # Shared preamble: capture the real home before the sandbox replaces it, then
  # redirect HOME and every XDG base into the build directory.
  preamble = ''
    set -euo pipefail
    export OST_HOST_HOME="''${HOME:-/nonexistent}"
    export OST_TEST_LIB="${libDir}"
    mkdir -p "$TMPDIR/work"
    cd "$TMPDIR/work"
    . "${libDir}/sandbox.sh"
    ost_sandbox_init "$TMPDIR/work/sandbox"
    assert_sandboxed
  '';

  # Proves the binary exists, dynamically links, and answers --help.
  # Deliberately not a functional check. The name carries that caveat.
  mkSmokeCheck =
    {
      name,
      package,
      bin,
      args ? [ "--help" ],
      acceptExit ? [ 0 ],
    }:
    pkgs.runCommand "smoke-${name}-link-and-help"
      {
        nativeBuildInputs = [
          pkgs.bash
          pkgs.coreutils
        ];
        meta = {
          description =
            "Link-and-help check for ${name}: the binary exists, links, and answers "
            + "${lib.concatStringsSep " " args}. Not a functional check.";
        };
      }
      ''
        ${preamble}

        target="${package}/bin/${bin}"

        if [ ! -x "$target" ]; then
          echo "smoke-${name}: no executable at $target" >&2
          echo "package contains:" >&2
          ls -la "${package}/bin" >&2 || true
          exit 1
        fi

        set +e
        "$target" ${lib.escapeShellArgs args} > help.out 2> help.err
        rc=$?
        set -e

        accepted=0
        for code in ${lib.concatStringsSep " " (map toString acceptExit)}; do
          if [ "$rc" = "$code" ]; then accepted=1; fi
        done

        if [ "$accepted" != "1" ]; then
          echo "smoke-${name}: ${bin} ${lib.concatStringsSep " " args} exited $rc" >&2
          echo "--- stdout ---" >&2; cat help.out >&2
          echo "--- stderr ---" >&2; cat help.err >&2
          exit 1
        fi

        if [ ! -s help.out ] && [ ! -s help.err ]; then
          echo "smoke-${name}: ${bin} produced no output at all" >&2
          exit 1
        fi

        echo "smoke-${name}: link-and-help OK (exit $rc)"
        mkdir -p "$out"
        cp help.out help.err "$out/" 2>/dev/null || true
      '';

  # Proves a terminal program starts and stays up on a real pty.
  #
  # Some tools have no argument parsing at all: they open the terminal
  # immediately and exit non-zero without one, so a link-and-help check is not
  # available for them. This is the honest substitute. It still asserts nothing
  # about rendered output.
  mkStartCheck =
    {
      name,
      package,
      bin,
      timeout ? 5,
      extraPackages ? [ ],
    }:
    pkgs.runCommand "smoke-${name}-starts-on-a-pty"
      {
        nativeBuildInputs = [
          pkgs.bash
          pkgs.coreutils
          pyRun
        ]
        ++ extraPackages;
        meta = {
          description =
            "Pty start check for ${name}: the binary exists, links, and stays up for "
            + "${toString timeout}s on a real terminal. Not a functional check, and it "
            + "asserts nothing about what was drawn.";
        };
      }
      ''
        ${preamble}

        target="${package}/bin/${bin}"

        if [ ! -x "$target" ]; then
          echo "smoke-${name}: no executable at $target" >&2
          ls -la "${package}/bin" >&2 || true
          exit 1
        fi

        mkdir -p run && cd run
        ost-pty-run --timeout ${toString timeout} -- "$target"

        echo "smoke-${name}: started and stayed up on a pty"
        mkdir -p "$out"
        echo "${name}" > "$out/started"
      '';

  # Runs one scenario script under the sandbox.
  mkE2E =
    {
      name,
      script,
      packages ? [ ],
    }:
    pkgs.runCommand "e2e-${name}"
      {
        nativeBuildInputs = [
          pkgs.bash
          pkgs.coreutils
          pyRun
        ]
        ++ packages;
        meta.description = "End-to-end scenario: ${name}";
      }
      ''
        ${preamble}

        echo "=== e2e-${name} ==="
        bash ${script}

        echo "=== e2e-${name}: OK ==="
        mkdir -p "$out"
        echo "${name}" > "$out/scenario"
      '';

  # Second line of a scenario declares what it needs:
  #   # requires: openspec git
  parseRequires =
    content:
    let
      lines = lib.splitString "\n" content;
      marker = "# requires:";
      hit = lib.findFirst (l: lib.hasPrefix marker l) null lines;
      words = if hit == null then [ ] else lib.splitString " " (lib.removePrefix marker hit);
    in
    lib.filter (w: w != "") words;

  scenarioFiles = lib.filterAttrs (
    fileName: kind: kind == "regular" && lib.hasSuffix ".sh" fileName
  ) (builtins.readDir ./e2e);

  mkScenarioCheck =
    fileName: _kind:
    let
      name = lib.removeSuffix ".sh" fileName;
      script = ./e2e + "/${fileName}";
      requires = parseRequires (builtins.readFile script);
    in
    mkE2E {
      inherit name script;
      packages = map (p: pkgs.${p}) requires;
    };

  # checks.<system>.e2e-<name>, one per script found on disk.
  scenarioChecks = lib.mapAttrs' (
    fileName: kind:
    lib.nameValuePair "e2e-${lib.removeSuffix ".sh" fileName}" (mkScenarioCheck fileName kind)
  ) scenarioFiles;
  # One smoke check per packaged tool that declares passthru.smoke and is not
  # marked broken. Driven off the package set, so adding a tool adds a check.
  mkToolChecks =
    packageSet:
    let
      checkable = lib.filterAttrs (
        _name: pkg: (pkg.passthru or { }) ? smoke && !(pkg.meta.broken or false)
      ) packageSet;
    in
    lib.mapAttrs' (
      name: pkg:
      let
        smoke = pkg.passthru.smoke;
      in
      lib.nameValuePair "smoke-${name}" (
        if (smoke.mode or "help") == "pty" then
          mkStartCheck {
            inherit name;
            package = pkg;
            inherit (smoke) bin;
            timeout = smoke.timeout or 5;
            extraPackages = map (p: pkgs.${p}) (pkg.passthru.runtimeDeps or [ ]);
          }
        else
          mkSmokeCheck {
            inherit name;
            package = pkg;
            inherit (smoke) bin;
            args = smoke.args or [ "--help" ];
            acceptExit = smoke.acceptExit or [ 0 ];
          }
      )
    ) checkable;

  # Proves the smoke constructor itself works, before any tool is packaged.
  # Its falsification (a bin name that does not exist) is exercised by hand and
  # recorded in docs/method.md, because a check that must fail cannot live in
  # `nix flake check`.
  selfChecks = {
    smoke-selftest = mkSmokeCheck {
      name = "selftest";
      package = pkgs.hello;
      bin = "hello";
      args = [ "--help" ];
    };
  };
in
{
  inherit
    mkSmokeCheck
    mkStartCheck
    mkToolChecks
    mkE2E
    scenarioChecks
    selfChecks
    pyRun
    libDir
    ;
}
