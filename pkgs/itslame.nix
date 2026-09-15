# ItsLame/openspec-tui: a reader that shells out to the `openspec` CLI JSON API
# instead of parsing files, so it gets --store and root resolution for free and
# hard-requires the CLI at runtime.
{
  lib,
  buildGoModule,
  inputs,
  mkVersion,
}:

buildGoModule {
  pname = "itslame-openspec-tui";
  version = mkVersion inputs.src-itslame;

  src = inputs.src-itslame;

  # main.go declares `var version = "dev"`. Stamping the snapshot makes
  # --version agree with the package version.
  ldflags = [
    "-s"
    "-w"
    "-X main.version=${mkVersion inputs.src-itslame}"
  ];

  vendorHash = "sha256-jt2Q+Pq2dpqROcbyhstDgXCMa7E70/XQPQREUiFDSBE=";

  doCheck = false;

  # main.go does exec.LookPath("openspec") before anything else and exits 1
  # with an install hint when it fails. The combined environment reads this to
  # build the wrapper's PATH.
  passthru.runtimeDeps = [ "openspec" ];

  passthru.smoke = {
    bin = "openspec-tui";
    args = [ "--help" ];
  };

  meta = {
    description = "Terminal reader for OpenSpec, driven by the openspec CLI JSON API";
    homepage = "https://github.com/ItsLame/openspec-tui";
    license = lib.licenses.mit;
    mainProgram = "openspec-tui";
    platforms = lib.platforms.unix;
  };
}
