# The second demo root, the one registered as an OpenSpec store.
#
# A store is a standalone planning repo shared by several code repos. This
# exists so the comparison can exercise the --store axis: one tool of the six
# accepts the flag, and the other five can be observed ignoring or rejecting it.
{
  lib,
  runCommand,
  openspec,
  coreutils,
  inputs,
  mkVersion,
}:

runCommand "openspec-demo-store"
  {
    src = ../fixture-store;

    nativeBuildInputs = [
      openspec
      coreutils
    ];

    meta = {
      description = "Second OpenSpec root, registered as a store, for the --store axis";
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
    export DO_NOT_TRACK=1
    printf '%s\n' '{"telemetry":{"noticeSeen":true,"enabled":false}}' \
      > "$XDG_CONFIG_HOME/openspec/config.json"

    # Redirected for the same reason as the fixture: the CLI's spinner runs
    # away when its stdout is a build log. See docs/method.md.
    cd "$out"
    if ! timeout 120 openspec validate --all --strict > "$TMPDIR/validate.log" 2>&1; then
      echo "store fixture failed openspec validation:" >&2
      head -c 8000 "$TMPDIR/validate.log" >&2
      exit 1
    fi

    grep -aE '(Totals|change/|spec/)' "$TMPDIR/validate.log" | head -20 || true
  ''
