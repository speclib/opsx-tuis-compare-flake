---
# opsx-tuis-compare-flake-pzo1
title: 'ost-demo: writable fixture sandbox'
status: completed
type: epic
priority: high
created_at: 2026-09-15T10:17:15Z
updated_at: 2026-09-15T11:49:23Z
parent: opsx-tuis-compare-flake-41i5
blocked_by:
    - opsx-tuis-compare-flake-ix26
    - opsx-tuis-compare-flake-j56p
---

OpenSpec change: `add-ost-demo`

Briefing: section 2.5, last paragraph.

Nothing in the comparison may mutate the user's real projects. Several tools
toggle checkboxes and write files, so the fixture has to be handed over as a
writable copy.

## Scope
`ost-demo` copies the fixture to `$(mktemp -d)`, makes it writable, changes into
it, prints the path, and drops you in a shell. It sets a temp `XDG_DATA_HOME` for
the session so store registration stays sandboxed.

## Acceptance
- [ ] `ost-demo` prints a path under a temp directory and the shell starts there
- [ ] The copy is writable: toggling a task checkbox succeeds
- [ ] `fixture/` in the nix store is unchanged afterwards
- [ ] e2e scenario `fixture-writable` passes
- [ ] e2e scenario `no-host-writes` passes

## Summary of Changes

`ost-demo` copies the fixture and the store root to a throwaway directory,
redirects HOME and every XDG base into it, registers the demo store there, and
drops you in a shell. Verified end to end: toggling a checkbox moves the count
from 3/7 to 4/7, a later run starts from 3/7 again, and the store copy is
unchanged.

HOME is redirected, not only the XDG bases. The briefing asks for a temp
XDG_DATA_HOME, which covers the registry and opsx's recent-projects file, but
not a tool that ignores XDG and writes to ~/.config directly. With six tools
from four ecosystems that is not worth taking on trust.

It takes a command as well as dropping into a shell, because an interactive
shell cannot be driven from a check, and the demo entry point should not be the
one part of the harness nothing guarantees. The banner goes to stderr so a
capture is not corrupted.

`no-host-writes` needed a decoy home to mean anything: inside a Nix build there
is no user home, so asserting one is clean is true before anything runs. It now
builds a home containing a registry with a store already in it, runs a full pass
including a registration and an edit, and diffs a fingerprint of every file and
its contents. Falsified by appending a byte to the decoy.

`default-env` caught the new command immediately, which is the test working.
