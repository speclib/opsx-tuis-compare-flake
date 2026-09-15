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
  opsx = callTool ./opsx.nix { };

  demo-project = callTool ./demo-project.nix { };
  demo-store = callTool ./demo-store.nix { };
}
// (
  let
    self = import ./default.nix { inherit pkgs inputs; };
    tools = lib.filterAttrs (n: _: builtins.elem n toolNames) self;
    toolNames = [
      "specgetty"
      "dossier"
      "neosam"
      "mstanton"
      "itslame"
      "opsx"
    ];
  in
  {
    ost-demo = callTool ./ost-demo.nix {
      inherit (self) demo-project demo-store;
    };

    ost-compare = callTool ./ost-compare.nix {
      inherit (self) ost-demo;
    };

    readme = callTool ./readme.nix {
      inherit (self) ost-compare;
    };

    default = pkgs.callPackage ./ost-env.nix {
      inherit tools;
      extraCommands = [
        self.ost-demo
        self.ost-compare
      ];
    };
  }
)
