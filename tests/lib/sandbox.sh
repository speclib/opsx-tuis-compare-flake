# Point HOME and every XDG base at a build-local directory.
#
# Source this, do not execute it: it has to mutate the caller's environment.
#
# The Nix build sandbox already isolates the filesystem during `nix flake
# check`. This helper exists because the same scripts run outside Nix, from
# ost-demo and from the comparison harness, where nothing else stops a tool
# from registering a store in the user's real ~/.local/share/openspec.

ost_sandbox_init() {
  OST_SANDBOX_ROOT="${1:-$PWD/sandbox}"
  export OST_SANDBOX_ROOT

  export HOME="$OST_SANDBOX_ROOT/home"
  export XDG_DATA_HOME="$HOME/.local/share"
  export XDG_CONFIG_HOME="$HOME/.config"
  export XDG_CACHE_HOME="$HOME/.cache"
  export XDG_STATE_HOME="$HOME/.local/state"

  mkdir -p \
    "$XDG_DATA_HOME" \
    "$XDG_CONFIG_HOME" \
    "$XDG_CACHE_HOME" \
    "$XDG_STATE_HOME"
}

# Fail when the environment is not actually sandboxed.
#
# Kept as its own function so a scenario can falsify it: call it once in a
# sandboxed state expecting success, and once with HOME outside the root
# expecting failure. A test that cannot fail proves nothing.
assert_sandboxed() {
  if [ -z "${OST_SANDBOX_ROOT:-}" ]; then
    echo "assert_sandboxed: OST_SANDBOX_ROOT is unset" >&2
    return 1
  fi

  for var in HOME XDG_DATA_HOME XDG_CONFIG_HOME XDG_CACHE_HOME XDG_STATE_HOME; do
    eval "value=\${$var:-}"
    case "$value" in
      "$OST_SANDBOX_ROOT"/*) ;;
      *)
        echo "assert_sandboxed: $var is '$value', outside '$OST_SANDBOX_ROOT'" >&2
        return 1
        ;;
    esac
  done

  return 0
}

# Fail when anything openspec-shaped landed in a real user home.
assert_no_host_writes() {
  host_home="${1:?assert_no_host_writes needs the host home path}"

  if [ "$host_home" = "${HOME:-}" ]; then
    echo "assert_no_host_writes: HOME is still the host home '$host_home'" >&2
    return 1
  fi

  if [ -e "$host_home/.local/share/openspec" ]; then
    echo "assert_no_host_writes: $host_home/.local/share/openspec exists" >&2
    return 1
  fi

  return 0
}
