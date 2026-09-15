{
  description = "Every known OpenSpec TUI, built from source, side by side on one fixture";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Every upstream TUI enters as a pinned, non-flake source, including the two
    # that ship their own flake. This repo is a comparison artifact, not a
    # redistribution channel, so packaging stays uniform and in one place.
    src-specgetty = {
      url = "github:speclib/specgetty";
      flake = false;
    };
    src-dossier = {
      url = "github:fselich/dossier";
      flake = false;
    };
    src-neosam = {
      url = "github:neosam/openspec-tui";
      flake = false;
    };
    # The branch is named explicitly: bare HEAD resolution for this repo fails
    # with an upstream 504 on api.github.com. See the design note in
    # openspec/changes/archive/*-add-flake-skeleton/design.md.
    src-mstanton = {
      url = "github:mstanton/openspec-tui/main";
      flake = false;
    };
    src-itslame = {
      url = "github:ItsLame/openspec-tui";
      flake = false;
    };
    src-opsx = {
      url = "github:fsmw/opsx-tui";
      flake = false;
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      # x86_64-darwin is deliberately absent. Nixpkgs 26.11 dropped it:
      # "Nixpkgs 26.11 has dropped support for x86_64-darwin." Declaring it
      # makes every output fail to evaluate on that system rather than merely
      # fail to build. See docs/method.md.
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      forAllSystems =
        f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});

      mkVersion = import ./lib/version.nix { lib = nixpkgs.lib; };
    in
    {
      lib = {
        inherit mkVersion systems;

        # The upstream snapshot each package is built from. The README and
        # docs/method.md read these so the comparison states its own date.
        versions = {
          specgetty = mkVersion inputs.src-specgetty;
          dossier = mkVersion inputs.src-dossier;
          neosam = mkVersion inputs.src-neosam;
          mstanton = mkVersion inputs.src-mstanton;
          itslame = mkVersion inputs.src-itslame;
          opsx = mkVersion inputs.src-opsx;
        };
      };

      packages = forAllSystems (pkgs: import ./pkgs { inherit pkgs inputs; });

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          name = "opsx-tuis-compare-flake";
          packages = [
            pkgs.go
            pkgs.cargo
            pkgs.rustc
            pkgs.python3
            pkgs.openspec
            pkgs.git
            pkgs.jq
            pkgs.tmux
            pkgs.jujutsu
            pkgs.nixfmt
          ];
        };
      });

      apps = forAllSystems (pkgs: { });

      checks = forAllSystems (
        pkgs:
        let
          harness = import ./tests { inherit pkgs; };
          packageSet = import ./pkgs { inherit pkgs inputs; };
        in
        harness.scenarioChecks // harness.selfChecks // harness.mkToolChecks packageSet
      );

      formatter = forAllSystems (pkgs: pkgs.nixfmt);
    };
}
