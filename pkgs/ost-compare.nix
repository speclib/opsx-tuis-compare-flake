# ost-compare: what each tool is for, the two matrices, and a side-by-side run.
#
# The matrices come from data/comparison.json, which is also what the README is
# generated from. One source, so the terminal and the page cannot disagree.
{
  lib,
  writeShellApplication,
  symlinkJoin,
  python3,
  tmux,
  coreutils,
  ost-demo,
  inputs,
  mkVersion,
}:

let
  data = ../data/comparison.json;
  renderer = ./ost-compare/render.py;

  # The windows tmux opens, read from the same data file at build time so a new
  # tool appears here without this file being edited.
  comparison = builtins.fromJSON (builtins.readFile data);
  toolCommands = map (t: t.command) comparison.tools;
  app = writeShellApplication {
  name = "ost-compare";

  runtimeInputs = [
    python3
    tmux
    coreutils
    ost-demo
  ];

  text = ''
    export OST_COMPARE_DATA="${data}"

    if [ "''${1:-}" != "--tmux" ]; then
      exec python3 ${renderer} "$@"
    fi

    # --tmux: one window per tool, all on the same fixture copy, so you can
    # flip between them with the project in the same state.
    session="ost-compare-$$"

    # The single quotes are deliberate: this string is a command for ost-demo
    # to run, so it must reach ost-demo unexpanded.
    # shellcheck disable=SC2016
    root=$(ost-demo 'printf "%s" "$OST_DEMO_ROOT"' 2>/dev/null)
    if [ -z "$root" ] || [ ! -d "$root/project" ]; then
      echo "ost-compare: could not prepare a fixture copy" >&2
      exit 1
    fi
    project="$root/project"

    export HOME="$root/home"
    export XDG_DATA_HOME="$HOME/.local/share"
    export XDG_CONFIG_HOME="$HOME/.config"

    tmux new-session -d -s "$session" -c "$project" -n compare \
      "python3 ${renderer} --matrix; echo; echo 'Press a number key in tmux to switch tool windows.'; read -r _"

    ${lib.concatMapStringsSep "\n" (cmd: ''
      tmux new-window -t "$session" -c "$project" -n "${lib.removePrefix "ost-" cmd}" "${cmd} || read -r _"
    '') toolCommands}

    # By name, not by index: a user with base-index 1 in their tmux.conf makes
    # "$session:0" a "can't find window: 0" error.
    tmux select-window -t "$session:compare"
    exec tmux attach-session -t "$session"
  '';

  meta = {
    description = "Compare the OpenSpec terminal interfaces, on one screen or side by side";
    license = lib.licenses.mit;
    mainProgram = "ost-compare";
  };
  };
in
# The data file is published alongside the command so checks and anything
# downstream read the same bytes this command renders.
symlinkJoin {
  name = "ost-compare";
  paths = [ app ];
  postBuild = ''
    mkdir -p "$out/share"
    cp ${data} "$out/share/comparison.json"
  '';
  inherit (app) meta;
}
