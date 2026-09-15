# specgetty: a fleet-level scanner. It finds every OpenSpec project on disk and
# reports status, which makes it a different category from the readers.
#
# Upstream ships its own package.nix. It was read before this file was written
# (that is where subPackages and the binary rename come from) but it is not
# imported: the briefing keeps packaging uniform and in one place.
{
  lib,
  buildGoModule,
  inputs,
  mkVersion,
}:

buildGoModule {
  pname = "specgetty";
  version = mkVersion inputs.src-specgetty;

  src = inputs.src-specgetty;

  # The module's main package lives in src/, so the built binary is called
  # "src" and has to be renamed to the name upstream ships.
  subPackages = [ "src" ];

  postInstall = ''
    mv "$out/bin/src" "$out/bin/spg"
  '';

  vendorHash = "sha256-DWWzfif21IDuYdwa6PwiBQFa0gAi4NZ6YDKbE9/C4eE=";

  doCheck = false;

  # How the harness smoke-checks this tool. Declaring it here means adding a
  # tool never touches flake.nix.
  passthru.smoke = {
    bin = "spg";
    args = [ "--help" ];
  };

  meta = {
    description = "Find and report status of every OpenSpec project on disk";
    homepage = "https://github.com/speclib/specgetty";
    license = lib.licenses.mit;
    mainProgram = "spg";
    platforms = lib.platforms.unix;
  };
}
