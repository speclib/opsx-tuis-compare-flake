# Design: package mstanton openspec-tui

## The pin had to be relaxed, and that is a risk not a formality

`pyproject.toml` requires `textual>=0.41.0,<1.0.0`. The pinned nixpkgs carries
textual 8.2.8. There is one nixpkgs for the whole flake, so the options were to
relax the constraint or to drop the tool. Relaxing crosses a major-version
boundary that upstream explicitly excluded, so a green build proves nothing
about whether the program still runs.

`pythonRelaxDeps = true` is used rather than the briefing's suggested
`pythonRelaxDeps = [ "*" ]`, because the boolean form is what current nixpkgs
takes for relaxing everything, and `pythonRelaxDepsHook` no longer needs to be
listed separately.

## Observed running, not assumed

The pty start check passes, but a Textual program that crashes into the
framework's own error screen also stays up, so the check alone cannot separate
those two cases. Run by hand on a real pty and the drawn output read back, it
renders its real menu:

```
OpenSpec TUI Editor
Spec-driven development for AI coding assistants

  Create New Change
  Open Existing Change
  List Changes
```

So the tool works against textual 8.2.8 despite the `<1.0` pin. That is an
observation about this snapshot pair, and `docs/method.md` records both
versions so it can be rechecked when either moves.

This is also why `mkStartCheck` is not allowed to grow an assertion about
rendered output: the frames are exactly what upstream is free to change, and a
check that breaks on a redesign would be worse than one that proves less.

## Three entry points

`pyproject.toml` declares `openspec-tui`, `openspec-tui-editor` and a gui script
`openspec-tui-gui`, all pointing at the same `openspec_tui:main`. The package
installs all three because that is what upstream ships. The combined
environment will expose exactly one of them as `ost-mstanton`.

## License

`pyproject.toml` says `license = "MIT"` and the README repeats it. There is no
LICENSE file in the tree, and the GitHub API reports no license for the repo.
`meta.license` is set to MIT with a comment recording where the claim comes
from. The properties matrix states the missing file rather than presenting MIT
as settled.
