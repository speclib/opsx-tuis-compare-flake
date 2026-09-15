# Design: ost-demo

## HOME is redirected, not only the XDG bases

The briefing asks for a temporary `XDG_DATA_HOME`. That covers the store
registry and, as packaging opsx showed, `recent-projects.json` too. It does not
cover a tool that ignores the XDG specification and writes to `~/.config`
directly, and with six tools from four ecosystems that is not a risk worth
taking on trust. `HOME` goes into the throwaway directory as well.

## It takes a command

Without arguments it drops into a shell, which is what a person wants. With
arguments it runs them and exits, which is what a test needs: an interactive
shell cannot be driven from a check, and a demo entry point that cannot be
tested would be the one part of the harness nothing guarantees.

The banner goes to stderr for the same reason. With arguments, stdout is the
caller's data, and a banner mixed into it would corrupt a capture.

## Why no-host-writes needed a decoy

The obvious version of that scenario asserts the invoking user's home has no
OpenSpec state after a run. Inside a Nix build there is no user home at all, so
that assertion is true before anything runs and the test proves nothing.

So the scenario builds a decoy home that looks like a real one, including a
registry with a store already in it, points `HOME` at it, runs a full pass
through `ost-demo` including a store registration and a file edit, and then
compares a fingerprint of every file and its contents.

Its falsification is the last step: it appends a byte to a file in the decoy and
requires the fingerprint to change. Without that, a fingerprint function that
silently returned nothing would make the whole scenario pass.
