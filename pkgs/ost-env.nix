# The combined environment: what `nix shell github:speclib/opsx-tuis-compare-flake`
# lands you in.
#
# This is the only place the ost- names exist. Each individual package keeps the
# binary name its upstream ships, because three upstreams install a binary
# called openspec-tui and they cannot coexist on one PATH. Wrapping here rather
# than in each package means those three never race as symlinks inside one
# buildEnv.
#
# The suffix is the author, except where one author ships two tools. ItsLame has
# both openspec-tui and lazyopenspec, so the author no longer disambiguates and
# the project name is used instead: ost-itslame and ost-lazyopenspec. The rule
# is "the shortest suffix that identifies the tool", which was the author right
# up until it was not.
{
  lib,
  buildEnv,
  runCommand,
  makeWrapper,
  openspec,
  git,
  tools,
  extraCommands ? [ ],
}:

let
  # Everything a wrapped tool may need to find at runtime. itslame hard-requires
  # the openspec CLI; the others are given it anyway so the comparison is fair.
  runtimePath = lib.makeBinPath [
    openspec
    git
  ];

  # A tool is included when it is not marked broken. The briefing's degradation
  # rule needs exactly this: a tool that will not build keeps its package attr
  # and leaves the combined environment, without a second list to maintain.
  usable = lib.filterAttrs (
    _name: pkg: (pkg.passthru or { }) ? smoke && !(pkg.meta.broken or false)
  ) tools;

  mkWrapper =
    name: pkg:
    runCommand "ost-${name}"
      {
        nativeBuildInputs = [ makeWrapper ];
        # license is carried through only when the package declares one. A tool
        # whose upstream ships no license file gets no license here either,
        # rather than inheriting a neighbour's or being quietly labelled.
        meta = {
          inherit (pkg.meta) description homepage;
          mainProgram = "ost-${name}";
        }
        // lib.optionalAttrs (pkg.meta ? license) { inherit (pkg.meta) license; };
      }
      ''
        mkdir -p "$out/bin"
        makeWrapper "${pkg}/bin/${pkg.passthru.smoke.bin}" "$out/bin/ost-${name}" \
          --prefix PATH : "${runtimePath}"
      '';

  wrappers = lib.mapAttrsToList mkWrapper usable;
in
buildEnv {
  name = "opsx-tuis-compare";

  paths = wrappers ++ extraCommands ++ [
    openspec
  ];

  # Nothing here should pull in a second copy of a tool under its upstream name.
  pathsToLink = [
    "/bin"
    "/share"
  ];

  meta = {
    description = "Every known OpenSpec TUI under a non-colliding name, plus the openspec CLI";
    license = lib.licenses.mit;
  };

  passthru = {
    # The tools actually present, for ost-compare and the e2e scenarios to read
    # instead of hard-coding a list that can drift.
    toolNames = lib.attrNames usable;
    inherit usable;
  };
}
