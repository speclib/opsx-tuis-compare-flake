# fsmw/opsx-tui: the largest ambition of the six. The README describes a Kanban
# board, an agent runner with backends, and a security model, but it reads as a
# roadmap at 8 commits. Assume the shipped surface is smaller than the README.
{
  lib,
  python3Packages,
  inputs,
  mkVersion,
}:

python3Packages.buildPythonApplication {
  pname = "opsx-tui";
  version = mkVersion inputs.src-opsx;

  src = inputs.src-opsx;

  pyproject = true;

  build-system = [ python3Packages.setuptools ];

  dependencies = [
    python3Packages.textual
    python3Packages.pydantic
    python3Packages.platformdirs
    python3Packages.watchfiles
  ];

  # Upstream pins textual >=1.0,<3.0 and nixpkgs ships 8.x, a wider jump than
  # any other tool here. Relaxing is the only way to build against the one
  # nixpkgs this flake has. Whether it still runs is an observation, recorded
  # in docs/method.md, not something the build proves.
  pythonRelaxDeps = true;

  doCheck = false;

  passthru.smoke = {
    bin = "opsx-tui";
    args = [ "--help" ];
  };

  meta = {
    description = "Terminal control center for OpenSpec projects";
    homepage = "https://github.com/fsmw/opsx-tui";
    # The tree carries a GPL-3.0 LICENSE file and GitHub reports GPL-3.0, but
    # the README says "The project's license has yet to be defined." and adds
    # "Until an explicit license exists, redistribution permission must not be
    # assumed." The contradiction is recorded in the README properties matrix
    # rather than resolved here.
    license = lib.licenses.gpl3Only;
    mainProgram = "opsx-tui";
    platforms = lib.platforms.unix;
  };
}
