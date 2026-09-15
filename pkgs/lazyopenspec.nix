# ItsLame/lazyopenspec: the same author's second interface, and a different
# program to use. lazygit-style stacked numbered panels, a command log, and the
# workflow actions behind a confirm menu.
#
# Same lineage as pkgs/itslame.nix: it drives the openspec CLI rather than
# parsing files, and it keeps --store. It is packaged separately rather than
# replacing it because neither upstream README mentions the other.
{
  lib,
  buildGoModule,
  inputs,
  mkVersion,
}:

buildGoModule {
  pname = "lazyopenspec";
  version = mkVersion inputs.src-lazyopenspec;

  src = inputs.src-lazyopenspec;

  subPackages = [ "cmd/lazyopenspec" ];

  # main.go declares `var version = "dev"`, same as its predecessor.
  ldflags = [
    "-s"
    "-w"
    "-X main.version=${mkVersion inputs.src-lazyopenspec}"
  ];

  vendorHash = "sha256-6cq0m1iyXTV57e+bh0fYyMM02pV/twAbV4r0hHeDSu0=";

  doCheck = false;

  # Same runtime requirement as itslame: internal/openspec/client.go does an
  # exec.LookPath on the CLI before it will run a command.
  passthru.runtimeDeps = [ "openspec" ];

  passthru.smoke = {
    bin = "lazyopenspec";
    args = [ "--help" ];
  };

  meta = {
    description = "lazygit-style terminal UI for OpenSpec, driven by the openspec CLI";
    homepage = "https://github.com/ItsLame/lazyopenspec";

    # meta.license is deliberately absent. The repository carries no LICENSE
    # file and the GitHub API reports no license, so there is nothing to state.
    # The author's older repo is MIT, but inheriting that here would be exactly
    # the invented evidence the briefing forbids. An unset license is unknown to
    # nixpkgs rather than unfree, so this still builds; the properties matrix
    # says what the situation is.

    mainProgram = "lazyopenspec";
    platforms = lib.platforms.unix;
  };
}
