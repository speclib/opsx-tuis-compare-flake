# mstanton/openspec-tui: the authoring and editing angle. It creates changes
# from templates.
#
# Low-fidelity upstream: three commits, and its README points at a different
# repository (Fission-AI/openspec-tui) in several places. The license claim is
# in pyproject.toml and the README only; there is no LICENSE file in the tree.
{
  lib,
  python3Packages,
  inputs,
  mkVersion,
}:

python3Packages.buildPythonApplication {
  pname = "mstanton-openspec-tui";
  version = mkVersion inputs.src-mstanton;

  src = inputs.src-mstanton;

  pyproject = true;

  build-system = [
    python3Packages.setuptools
    python3Packages.wheel
  ];

  dependencies = [ python3Packages.textual ];

  # Upstream pins textual >=0.41,<1.0. Nixpkgs ships 8.x, and this repo does not
  # get to choose a different nixpkgs per tool. Relaxing is the only way to
  # build it at all; whether it still runs is a matrix observation, not a build
  # guarantee.
  pythonRelaxDeps = true;

  doCheck = false;

  passthru.smoke = {
    mode = "pty";
    bin = "openspec-tui";
    timeout = 5;
  };

  meta = {
    description = "Terminal editor for authoring OpenSpec changes from templates";
    homepage = "https://github.com/mstanton/openspec-tui";
    # MIT is claimed in pyproject.toml and the README. There is no LICENSE file
    # in the tree, which the README properties matrix records.
    license = lib.licenses.mit;
    mainProgram = "openspec-tui";
    platforms = lib.platforms.unix;
  };
}
