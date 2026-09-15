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
  specgetty = callTool ./specgetty.nix { };
  dossier = callTool ./dossier.nix { };
  itslame = callTool ./itslame.nix { };
  neosam = callTool ./neosam.nix { };
  mstanton = callTool ./mstanton.nix { };
}
