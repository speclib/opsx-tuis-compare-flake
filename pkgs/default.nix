# The package set. Each packaging epic adds exactly one entry here, so that a
# new tool never has to touch flake.nix.
{ pkgs, inputs }:

let
  inherit (pkgs) lib;

  mkVersion = import ../lib/version.nix { inherit lib; };

  # callPackage with the things every tool package needs.
  callTool =
    path: args:
    pkgs.callPackage path ({ inherit inputs mkVersion; } // args);
in
{
  # Populated by milestones 02 through 06.
}
