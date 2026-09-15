{
  lib,
  buildGoModule,
  inputs,
  mkVersion,
}:

buildGoModule {
  pname = "dossier";
  version = mkVersion inputs.src-dossier;

  src = inputs.src-dossier;

  subPackages = [ "cmd/dossier" ];

  # main.go declares `var version string` and prints it for --version. Upstream
  # fills it at release time; an unset one makes `dossier --version` print a
  # bare "dossier ". Stamping the snapshot keeps the comparison honest about
  # which revision answered.
  ldflags = [
    "-s"
    "-w"
    "-X main.version=${mkVersion inputs.src-dossier}"
  ];

  vendorHash = "sha256-i/egmQk0UHU4RqeKZtHXRQ2mSpWO0I9cLJNmKQ0ED5A=";

  doCheck = false;

  passthru.smoke = {
    bin = "dossier";
    args = [ "--help" ];
  };

  meta = {
    description = "Terminal reader for OpenSpec changes, parsing the filesystem directly";
    homepage = "https://github.com/fselich/dossier";
    license = lib.licenses.mit;
    mainProgram = "dossier";
    platforms = lib.platforms.unix;
  };
}
