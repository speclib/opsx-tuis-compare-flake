# Design: package neosam openspec-tui

## No toolchain input was needed

The briefing allows adding `rust-overlay` or `fenix` if the nixpkgs rustc is
too old for edition 2024, but only if the plain build fails. It did not fail.
The pinned nixpkgs carries rustc 1.98.1, which accepts edition 2024, and
`cargoLock.lockFile` resolved all 249 locked packages. No input was added.

## This tool cannot answer --help

Every other tool so far has a non-interactive entry point. neosam has none. Run
without a terminal it exits 1:

```
$ openspec-tui --help
Error: Os { code: 6, kind: Uncategorized, message: "No such device or address" }
$ echo $?
1
```

Code 6 is ENXIO from opening `/dev/tty`. The argument is not rejected, it is
never looked at: the program goes straight to the terminal.

So the link-and-help check is not merely inconvenient here, it is unavailable.
Faking a TTY is forbidden by the briefing, and it would also be dishonest: the
thing worth proving is that the binary links and reaches its first frame.

`mkStartCheck` does exactly that. It gives a real pty, waits a bounded time,
and passes only if the program is still up. It asserts nothing about what was
drawn, which keeps it stable against every future redesign of the interface.

Verified inside the Nix build sandbox, so `/dev/ptmx` is available there and no
sandbox relaxation was needed.

## Falsification

Pointed at a binary that exits 4 immediately:

```
> pty-run: exited 4 before the 3.0s deadline: FAIL
error: Cannot build '...-smoke-dying-starts-on-a-pty.drv'
```

## Check mode selection

`passthru.smoke.mode` defaults to `"help"`, so the three Go tools are
unaffected. neosam sets `"pty"`. The mode lives with the package rather than in
the harness, because which mode is honest is a fact about the tool.
