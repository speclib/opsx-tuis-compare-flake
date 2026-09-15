# ost-demo: hands you a writable copy of the fixture in a throwaway directory,
# with every per-user path redirected into it.
#
# Several tools toggle task checkboxes and write files, and the point of the
# comparison is to let them. What must not happen is that they do it to the
# user's real projects or their real OpenSpec store registry.
{
  lib,
  writeShellApplication,
  coreutils,
  openspec,
  git,
  bashInteractive,
  demo-project,
  demo-store,
  inputs,
  mkVersion,
}:

writeShellApplication {
  name = "ost-demo";

  runtimeInputs = [
    coreutils
    openspec
    git
  ];

  text = ''
    root=$(mktemp -d -t ost-demo-XXXXXXXX)

    cp -r ${demo-project} "$root/project"
    cp -r ${demo-store} "$root/store"
    chmod -R u+w "$root/project" "$root/store"

    # Everything per-user goes inside the throwaway directory. HOME is
    # redirected too, not only the XDG bases: a tool that ignores XDG and
    # writes to ~/.config directly would otherwise reach the real one.
    export HOME="$root/home"
    export XDG_DATA_HOME="$HOME/.local/share"
    export XDG_CONFIG_HOME="$HOME/.config"
    export XDG_CACHE_HOME="$HOME/.cache"
    export XDG_STATE_HOME="$HOME/.local/state"
    mkdir -p "$XDG_DATA_HOME" "$XDG_CONFIG_HOME" "$XDG_CACHE_HOME" "$XDG_STATE_HOME"
    mkdir -p "$XDG_CONFIG_HOME/openspec"

    export DO_NOT_TRACK=1
    printf '%s\n' '{"telemetry":{"noticeSeen":true,"enabled":false}}' \
      > "$XDG_CONFIG_HOME/openspec/config.json"

    export OST_DEMO_ROOT="$root"
    export OST_FIXTURE="$root/project"
    export OST_STORE_ROOT="$root/store"

    # Registered here rather than in the user's registry. This is the only
    # place the comparison registers a store outside a build sandbox, and it is
    # pointed at the temporary XDG_DATA_HOME above.
    if openspec store register "$root/store" --id ost-demo-store --yes \
         > "$root/store-register.log" 2>&1; then
      export OST_STORE_ID=ost-demo-store
    else
      echo "ost-demo: could not register the demo store; --store will not work" >&2
      sed -n '1,20p' "$root/store-register.log" >&2
    fi

    # The banner goes to stderr: with arguments this command's stdout is the
    # caller's data, and a banner mixed into it would corrupt a capture.
    cat >&2 <<BANNER
ost-demo

  project      $OST_FIXTURE
  store root   $OST_STORE_ROOT
  store id     ''${OST_STORE_ID:-<not registered>}
  HOME         $HOME

This is a throwaway copy. Edit it, toggle tasks, let the tools write to it.
Your real projects and your real OpenSpec store registry are untouched.

Run ost-compare to see what each tool is for.

BANNER

    cd "$OST_FIXTURE"

    # With arguments, run them and leave. Without, drop into a shell. The first
    # form is what lets a test drive this without a terminal.
    if [ "$#" -gt 0 ]; then
      exec ${bashInteractive}/bin/bash --noprofile --norc -c "$*"
    fi
    exec ${bashInteractive}/bin/bash --noprofile --norc -i
  '';

  meta = {
    description = "Drop into a writable copy of the comparison fixture";
    license = lib.licenses.mit;
    mainProgram = "ost-demo";
  };
}
