# Design: package opsx-tui

## It builds, and it runs

The briefing said to assume it may not run. It does. `--help` answers:

```
usage: opsx-tui [-h] [--project PROJECT]
OPSX TUI - OpenSpec terminal UI
```

and given a project it starts and stays up, drawing a header of
`OPSX TUI | <path> |` and a board tab.

The dependency relaxation is the widest of the run: upstream pins
`textual>=1.0,<3.0` and nixpkgs carries 8.2.8. As with mstanton there is one
nixpkgs for the whole flake, so it was relax or drop the tool, and as with
mstanton the build proves nothing on its own. It was run and observed.

The briefing's dependency list mentions SQLite and keyring. Neither appears in
`pyproject.toml` nor anywhere under `src/opsx_tui/`, so neither is a dependency
of this snapshot. That is a README-roadmap claim rather than shipped code, which
is the pattern the briefing warned about for this repo.

## It fails silently with no project

With a clean `HOME` and a working directory containing no OpenSpec root, it
exits 0 after writing 239 bytes of terminal setup and teardown, drawing nothing
and printing no error:

```
exit: 0 | bytes drawn: 239
```

Given `--project <root>`, or with a remembered recent project, it starts
normally. It does not walk up from the working directory the way the `openspec`
CLI does, and it does not report that it found nothing.

This is why the smoke check for this tool stays in help mode rather than pty
mode. A pty start check would pass on that silent exit, since exiting zero
before the deadline is a pass, and it would be claiming the tool started when
it had not. `--help` proves strictly less but does not lie.

Milestone 08's `each-tool-starts` has to pass this tool an explicit project for
the same reason.

## It writes per-user state

Observed after one run, under a redirected `HOME`:

```
$XDG_DATA_HOME/opsx-tui/recent-projects.json
$XDG_CONFIG_HOME/openspec/config.json
```

The first is this tool remembering projects through platformdirs. The second is
a telemetry `anonymousId` written by the `openspec` CLI itself.

Both land in the user's real directories if nothing redirects them, which is
exactly the failure mode the briefing's sandbox constraint exists to prevent,
and the first explains an earlier confusing observation: a second run appeared
to find a project from a directory that had none, because it had remembered it.

`ost-demo` therefore has to set `XDG_DATA_HOME` and `XDG_CONFIG_HOME`, not only
`HOME`.

## License

The tree carries a GPL-3.0 LICENSE file and GitHub reports GPL-3.0. The README
says:

```
## License

The project's license has yet to be defined.

Until an explicit license exists, redistribution permission must not be assumed.
```

`meta.license` is `gpl3Only` with a comment recording the contradiction. The
properties matrix states both, because asserting either one silently would be
inventing evidence.
