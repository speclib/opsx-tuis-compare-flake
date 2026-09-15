# The shared fixture every tool is judged on.
#
# Its shape is deliberate. One change is partially complete and one has nothing
# done, so progress indicators have something to differ on. One change has no
# design.md, so artifact-status displays differ. There is an archived change,
# because several of the tools browse archives separately. Every change
# directory carries .openspec.yaml, because dossier refuses a change directory
# passed directly without one.
{
  lib,
  runCommand,
  openspec,
  coreutils,
  # callTool passes these to every package; this one needs neither.
  inputs,
  mkVersion,
}:

runCommand "openspec-demo-project"
  {
    src = ../fixture;

    nativeBuildInputs = [
      openspec
      coreutils
    ];

    meta = {
      description = "Shared OpenSpec fixture project for comparing terminal interfaces";
      license = lib.licenses.mit;
    };
  }
  ''
    mkdir -p "$out"
    cp -r "$src"/. "$out/"
    chmod -R u+w "$out"

    export HOME="$TMPDIR/home"
    export XDG_DATA_HOME="$HOME/.local/share"
    export XDG_CONFIG_HOME="$HOME/.config"
    mkdir -p "$XDG_DATA_HOME" "$XDG_CONFIG_HOME/openspec"

    # The CLI writes a telemetry anonymousId on first run. Seeding the config
    # keeps it from trying, since a Nix build has no network.
    export DO_NOT_TRACK=1
    printf '%s\n' '{"telemetry":{"noticeSeen":true,"enabled":false}}' \
      > "$XDG_CONFIG_HOME/openspec/config.json"

    # The fixture is worthless if it stops being a valid OpenSpec project: a
    # tool failing on it would look like the tool's fault. So validate here, at
    # build time.
    #
    # Output is captured to a file rather than left on the builder's stdout.
    # With stdout attached directly to the build log the CLI redraws its
    # progress spinner without bound and never returns; one attempt reached an
    # 821 MB log before it was killed. Writing to a file also bounds what a
    # failure prints. See docs/method.md.
    cd "$out"
    if ! timeout 120 openspec validate --all --strict > "$TMPDIR/validate.log" 2>&1; then
      echo "fixture failed openspec validation:" >&2
      head -c 8000 "$TMPDIR/validate.log" >&2
      exit 1
    fi

    grep -aE '(Totals|change/|spec/)' "$TMPDIR/validate.log" | head -20 || true
  ''
