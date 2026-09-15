# opsx-tuis-compare-flake

Several people have written a terminal interface for [OpenSpec](https://github.com/Fission-AI/OpenSpec),
and three of them called the binary `openspec-tui`, so you cannot install more
than one and decide for yourself. This flake builds all seven from source under
names that do not collide, on one shared fixture project, and reports what they
actually do.

```
nix shell github:speclib/opsx-tuis-compare-flake
ost-compare          # what each one is for
ost-demo             # a throwaway copy of the fixture to try them on
```

Ten commands land on your `PATH`: `ost-specgetty`, `ost-dossier`, `ost-neosam`,
`ost-mstanton`, `ost-itslame`, `ost-lazyopenspec`, `ost-opsx`, plus
`ost-compare`, `ost-demo` and the `openspec` CLI. Nothing here writes to your
projects or to your OpenSpec store registry.

## Bias disclosure

specgetty is written by the owner of this repository. It is packaged, measured
and marked by the same rules as the other five, and the rules are in
[docs/method.md](docs/method.md) so you can check that claim rather than take it.

## The contenders

They are not seven versions of one program. Three are readers, one scans your
whole machine, one runs changes, one writes them, and one wants to be a control
centre. Read the categories before reading the matrix, or the matrix will
mislead you.

Two of them are by the same author. `ItsLame/openspec-tui` and
`ItsLame/lazyopenspec` share a lineage and a CLI-backed design, but they are
different programs to use, and neither repo mentions the other, so this page
does not declare either one dead.

### `ost-specgetty` (fleet scanner)

Upstream `speclib/specgetty`, installs `spg`.

Finds every OpenSpec project on disk and reports status across all of them. The only tool here whose unit is the machine rather than one project.

### `ost-dossier` (reader)

Upstream `fselich/dossier`, installs `dossier`.

A reader for one project, parsing the filesystem directly. The most finished of the six: tabbed artifacts, rendered markdown, filtering, and task toggling.

### `ost-neosam` (implementation runner)

Upstream `neosam/openspec-tui`, installs `openspec-tui`.

Not a reader. It runs changes: batch execution, a dependency graph between them, a configurable agent command, and an in-app config editor.

### `ost-mstanton` (author)

Upstream `mstanton/openspec-tui`, installs `openspec-tui`.

An authoring front end. Its opening screen offers creating a change, opening one, and listing them. Three commits, and its README points at a different repository.

### `ost-itslame` (reader)

Upstream `ItsLame/openspec-tui`, installs `openspec-tui`.

The only tool that drives the openspec CLI JSON API instead of parsing files, which is why it is also the only one with --store. Validate, archive and task toggling from inside the interface.

### `ost-lazyopenspec` (reader)

Upstream `ItsLame/lazyopenspec`, installs `lazyopenspec`.

The same author's second interface, and the newer one. lazygit-style stacked numbered panels with a command log, workflow actions behind a confirm menu, and search that steps between matches. Also CLI-backed, and it inherits the five second startup.

### `ost-opsx` (control center)

Upstream `fsmw/opsx-tui`, installs `opsx-tui`.

The widest ambition: a Kanban board, an agent runner with its own logs and runs views, settings, and diagnostics. Eight commits, and the README reads as a roadmap.


## Feature matrix

`yes` and `no` mean observed, by running the tool or by reading its source.
`part` means present but incomplete, or claimed by a README and not verified.
`?` means undetermined, and the footnote says what was checked. There is no
cell here that means "probably".

| Feature                             | specgetty | dossier   | neosam   | mstanton | itslame  | lazyopenspec | opsx     |
|-------------------------------------|-----------|-----------|----------|----------|----------|--------------|----------|
| Browse active changes               | yes       | yes       | yes      | yes      | yes      | yes [1]      | no [2]   |
| Browse archived changes             | yes       | yes       | yes      | no [3]   | yes      | yes [1]      | no [2]   |
| Browse project specs                | yes       | yes       | part [4] | ? [3]    | yes      | yes [1]      | no [2]   |
| Renders markdown                    | no [5]    | yes [6]   | yes [7]  | part [8] | yes [6]  | yes [6]      | no [2]   |
| Toggle tasks in place               | no        | yes [9]   | no       | no       | yes [10] | yes [11]     | no [2]   |
| Task progress indicator             | yes [12]  | yes       | yes [13] | no       | yes      | yes [14]     | no [2]   |
| Validate a change                   | no        | no        | no       | no       | yes [10] | yes [15]     | no [2]   |
| Archive a change                    | yes [16]  | no        | ? [17]   | no       | yes [10] | yes [15]     | no       |
| Open in $EDITOR                     | no        | yes [18]  | yes      | no       | yes [10] | no [19]      | no [2]   |
| Live reload on disk change          | no [20]   | yes [21]  | no       | no       | no [22]  | no [23]      | ? [2]    |
| Filter or search                    | ? [24]    | yes [25]  | ? [26]   | no       | yes [10] | yes [27]     | no [2]   |
| Takes a path argument               | yes [28]  | yes [29]  | no [30]  | no       | yes [31] | no [32]      | yes [33] |
| --store support                     | no        | no        | no       | no       | yes [34] | yes [34]     | no       |
| Multi-project or multi-root view    | yes [35]  | no        | no       | no       | no       | no           | no [2]   |
| Runs an agent to implement a change | no        | no        | yes [36] | no       | no       | no           | no [2]   |
| Batch runs and dependency ordering  | no        | no        | yes [37] | no       | no       | no           | no       |
| Kanban or lifecycle board           | no        | no        | no       | no       | no       | no           | no [2]   |
| In-app config editor                | part [38] | no        | yes [39] | no       | no       | no           | no [2]   |
| Help overlay                        | ? [40]    | part [41] | no [42]  | no       | yes [10] | yes [43]     | yes [44] |


1. Observed by running it: panel [1] Changes, [2] Specs and [3] Archive are stacked down the left, with a tabbed detail pane on the right.
2. Observed by running it: opsx draws its header, switches between views, and shows its help overlay, but every pane is empty. Its source declares this feature (a TabPane, a view, or a binding), so the capability is written; it does not reach the screen in this build. Most likely a consequence of relaxing the textual pin from the declared >=1.0,<3.0 to nixpkgs' 8.2.8, not of the tool as its author intended it. Testing that would need a textual in the declared range, which this nixpkgs does not carry.
3. The observed opening screen offers creating a change, opening one, and listing them. Nothing about archives or specs appeared.
4. Observed by running it: opening a change lists Proposal, Design, Tasks, Specs and Dependencies, where Specs holds that change's delta specs. There is no project-level specs view; the root screen offers only Active and Archived.
5. Observed by running it: spec and artifact text is shown with its markdown markers intact, so it displays markdown rather than rendering it. go.mod declares no renderer.
6. Uses the glamour markdown renderer, present in go.mod.
7. Uses tui-markdown with the highlight-code feature, declared in Cargo.toml.
8. A Preview binding exists on ctrl+p. Whether it renders markdown was not confirmed.
9. Observed by running it: Space on the tasks tab wrote through to tasks.md, and `openspec list` then reported 2/7 instead of 3/7.
10. From the key table in the source: `/` filter, space toggle task, `e` edit in $EDITOR, `v` validate, `A` archive, `r` refresh, `?` help.
11. Observed by running it: space in the tasks tab wrote through to tasks.md and `openspec list` then reported 4/7 instead of 3/7.
12. Source aggregates task statistics across changes, so the progress it reports is per project rather than per change.
13. Source renders batch change progress.
14. Observed by running it on the fixture.
15. Observed by running it: `x` opens an Actions menu offering validate, show apply instructions, and archive change. `v`, `a` and `A` reach them directly.
16. Source carries an archive flow with idle, confirming and running states. Not exercised in this comparison.
17. An Archived tab exists for browsing. Whether a change can be archived from the interface was not confirmed.
18. From the README key table: Space toggles the task under the cursor on the tasks tab, and `e` opens the artifact in $EDITOR.
19. No reference to $EDITOR anywhere in the source. Its own design document says authoring is delegated to $EDITOR rather than done in the interface, so this is a deliberate narrowing: the predecessor binds `e` to open an artifact.
20. The README documents `s` to rescan, which is a manual refresh rather than a watcher.
21. Observed by running it: a task checkbox edited from outside while the tasks tab was open moved the progress bar from 3/7 to 4/7 with no keypress.
22. `r` refreshes manually. No watcher was found.
23. `r` refreshes manually, and go.mod declares no file watcher.
24. No filter or search key appears in the README key table, and no filter string was found in the source. Not confirmed absent.
25. Filter mode is confirmed in the source, which tests entering it with `/`, cancelling with Esc and confirming with Enter.
26. Some filter-shaped references appear in the source, too few to call it either way.
27. Observed by running it: `/` filters a panel, and in the preview `n` and `N` step between matches. Its predecessor filters but does not step.
28. Observed by running it: started in a project directory with no config it reports 'No OpenSpec projects found.' It wants --zoom --path, or a configured scan root.
29. --help shows an optional [path] argument. A change directory passed directly must contain .openspec.yaml.
30. The tool parses no arguments at all. Without a terminal it exits 1 with ENXIO from opening /dev/tty.
31. --help documents a positional path argument: a directory containing an openspec/ root.
32. --help documents only --store and --version. There is no positional path argument, which its predecessor has.
33. Observed: --project selects the root, and the header shows the path given.
34. --help documents a --store flag taking an OpenSpec store id to use as the workspace root. Only the two CLI-backed tools have it, which is the point: the CLI does root resolution, so a tool that delegates to it gets stores for free.
35. Scanning the disk for every OpenSpec project is the tool's purpose.
36. The configurable command defaults to variants of `claude`, including `claude --print --dangerously-skip-permissions {prompt}`.
37. Batch execution is the most heavily represented feature in the source, together with an explicit Add Dependency action between changes.
38. Observed by running it: the zoomed project view carries a config tab alongside specs, changes and archive. Whether it edits or only displays was not confirmed.
39. A Config screen with an edit mode is present in the source, backed by a config.yaml.
40. No help key appears in the README key table. --help works from the command line. An in-interface overlay was not confirmed either way.
41. The interface carries a persistent status line listing keys rather than a dismissable overlay.
42. Observed by running it: `?` does nothing, and no help key appears in the source.
43. Observed by running it: `?` opens a Keybindings overlay listing thirteen bindings.
44. Observed working: `?` opens a Keyboard Bindings overlay listing the six view keys and quit.

## Properties

| Property                                | specgetty                             | dossier       | neosam                         | mstanton                         | itslame               | lazyopenspec          | opsx                         |
|-----------------------------------------|---------------------------------------|---------------|--------------------------------|----------------------------------|-----------------------|-----------------------|------------------------------|
| Language                                | Go                                    | Go            | Rust                           | Python                           | Go                    | Go                    | Python                       |
| Interface framework                     | Bubble Tea                            | Bubble Tea v2 | ratatui                        | Textual                          | Bubble Tea            | Bubble Tea            | Textual                      |
| Data source                             | filesystem                            | filesystem    | filesystem                     | filesystem                       | openspec CLI JSON [1] | openspec CLI JSON [1] | filesystem                   |
| Needs the openspec CLI at runtime       | no                                    | no            | no                             | no                               | yes [1]               | yes [1]               | no                           |
| Config location                         | $XDG_CONFIG_HOME/specgetty/config.yml | none observed | config.yaml in the project [2] | none observed                    | none observed         | none observed         | $XDG_DATA_HOME/opsx-tui/ [3] |
| License                                 | MIT                                   | MIT           | MIT                            | MIT claimed, no LICENSE file [4] | MIT                   | none declared [5]     | contradictory [6]            |
| Ships its own flake                     | yes [7]                               | no            | yes [7]                        | no                               | no                    | no                    | no                           |
| Binary name upstream installs           | spg                                   | dossier       | openspec-tui [8]               | openspec-tui [8]                 | openspec-tui [8]      | lazyopenspec          | opsx-tui                     |
| Answers --help without a terminal       | yes                                   | yes           | no [9]                         | no [10]                          | yes                   | yes                   | yes                          |
| Starts with no OpenSpec root in sight   | yes                                   | ? [11]        | yes                            | yes                              | ? [11]                | ? [11]                | no [12]                      |
| Time to a usable screen (median of 5)   | 65 ms [13]                            | 130 ms [13]   | 756 ms [13]                    | 374 ms [13]                      | 5101 ms [14]          | 5109 ms [15]          | never [16]                   |
| Time to first byte (not responsiveness) | 10 ms [17]                            | 21 ms [17]    | 7 ms [17]                      | 239 ms [17]                      | 23 ms [17]            | 27 ms [17]            | 362 ms [17]                  |


1. main.go calls exec.LookPath("openspec") before anything else and exits 1 with an install hint if it fails. All commands go through the CLI.
2. A Config screen with an edit mode is present in the source, backed by a config.yaml.
3. Writes $XDG_DATA_HOME/opsx-tui/recent-projects.json.
4. MIT is claimed in pyproject.toml and the README. There is no LICENSE file in the tree, and the GitHub API reports no license for the repository.
5. No LICENSE file in the tree and the GitHub API reports no license. The same author's older repo is MIT. Nothing is asserted here: meta.license is left unset rather than inheriting the neighbour's.
6. The tree carries a GPL-3.0 LICENSE file and GitHub reports GPL-3.0, but the README says the license has yet to be defined and that redistribution permission must not be assumed.
7. Upstream ships a flake, but this repo takes it as a flake = false input anyway, so packaging stays uniform across all six.
8. Three upstream projects install a binary with this name. They cannot coexist on one PATH, which is why this flake exposes ost- prefixed names instead.
9. The tool parses no arguments at all. Without a terminal it exits 1 with ENXIO from opening /dev/tty.
10. No argument parsing was found; the tool opens its interface immediately.
11. Not measured in this run.
12. With a clean HOME and no OpenSpec root in the working directory it exits 0 after 239 bytes, drawing nothing and printing no error. It does not walk up the way the CLI does.
13. Time from exec until the rendered screen carries at least 200 printable characters, measured in tmux with a client attached through a pty, five runs, median reported. Each tool is invoked the way it actually works: specgetty with --zoom --path, opsx with --project, the rest bare. This replaces an earlier time-to-first-byte figure, which measured terminal setup and ranked the tools in almost the opposite order.
14. 5101 ms median, and 2 of 5 runs never reached a usable screen at all. The figure is tightly clustered (5097 to 5129 ms), which is the signature of a five second timeout. It is not the CLI: a counting shim recorded exactly 3 calls per startup at about 0.32 s each, all returning 0. The wait happens inside the tool, behind a 'Loading OpenSpec workspace...' spinner, and was not isolated further.
15. 5109 ms median, and only 2 of 5 runs reached a usable screen, which is the same figure and the same failure rate as its predecessor. Whatever costs itslame five seconds survived the rewrite.
16. No run reached a usable screen. It draws a header within about 360 ms and then nothing else. See the note on its empty panes.
17. Time from exec to the first byte written to the terminal. Published here only because it is easy to mistake for responsiveness: for a full-screen program it is the terminal setup sequence, and it says nothing about when content appears. Compare the row above.

## What the numbers say

The measurement that matters is how long until you can read something, and none
of the upstream READMEs report it. It decides whether a tool can live behind a
tmux popup binding:

```
bind-key C-o display-popup -E -d "#{pane_current_path}" -w 90% -h 90% "<tui>"
```

That shape wants something on screen in a few hundred milliseconds. Two tools
clear it comfortably, two are usable, and two are not:

- **specgetty at 65 ms and dossier at 130 ms** are the only two that feel
  instant.
- **mstanton at 374 ms and neosam at 756 ms** are usable but noticeable.
- **both ItsLame tools take about 5.1 seconds**, and only two runs in five
  finish. itslame sits behind a "Loading OpenSpec workspace..." spinner;
  lazyopenspec reproduces the figure almost exactly, so whatever costs the
  five seconds survived a rewrite. This is not the cost of shelling out to the
  CLI: a counting shim recorded three calls per startup at about 0.32 s each,
  all succeeding. The wait is inside the tools.
- **opsx never reaches a usable screen.** It draws a header and nothing else.

Note what this does not correlate with. The fastest is Go and the second slowest
is Rust; a Python tool beats the Rust one. Startup cost here is about what each
tool decides to do before drawing, not what it was written in.

If you are looking for the popup-binding tool, it is dossier, with specgetty if
your unit of work is the machine rather than one project.

## Notes and caveats

**The name collision is the whole reason this repo has a naming scheme.**
`neosam/openspec-tui`, `mstanton/openspec-tui` and `ItsLame/openspec-tui` all
install a binary called `openspec-tui`. Each package here keeps that upstream
name, and only the combined environment renames them, so what you see in the
properties matrix is what upstream really installs.

The suffix is the author, except where one author ships two tools. ItsLame has
both, so those two are named by project: `ost-itslame` and `ost-lazyopenspec`.

**`ItsLame/lazyopenspec` carries no license file at all**, where the same
author's older repo is MIT. This page asserts nothing about it, and the package
leaves `meta.license` unset rather than inheriting the neighbour's.

**fsmw/opsx-tui has contradictory licensing.** The tree carries a GPL-3.0
`LICENSE` file and GitHub reports GPL-3.0, while its README says the license
has yet to be defined and that redistribution permission must not be assumed.
This repo records both and asserts neither.

**mstanton/openspec-tui claims MIT with no LICENSE file.** The claim is in
`pyproject.toml` and the README; there is no file in the tree and the GitHub
API reports no license.

**This is a snapshot.** Every tool is built from a revision pinned in
`flake.lock`, and the package versions carry the date. Run
`nix eval --json .#lib.versions` for the exact set. A tool that gained a feature
last week will still be reported as it was at its pinned revision.

**opsx does not render anything in this build.** It starts, switches between
views and shows its help overlay, but every pane is empty. Most of its `no`
cells are that, not a tool that never had the feature: its source declares the
views. The likeliest cause is the point below, and it is the reason this page
does not credit opsx with the board and runner its README describes.

**Both Python tools are built with their dependency pins relaxed.** Neither
ships a lockfile, and there is one nixpkgs for the whole flake, so opsx's
declared `textual>=1.0,<3.0` is built against textual 8.2.8. mstanton survives
the same treatment and renders fine. Testing whether a textual in the declared
range fixes opsx would need a version this nixpkgs does not carry, so the claim
here is what was observed, not a diagnosis. See
[docs/method.md](docs/method.md).

**This is a comparison artifact, not a redistribution channel.** All six enter
as `flake = false` inputs, including the two that ship their own flake, so
packaging stays uniform and an upstream output rename cannot break this repo.

## Method

Every cell traces to something observed. The rules, the falsifications, and the
things that were checked and left undetermined are in
[docs/method.md](docs/method.md).

The short version: the fixture is one OpenSpec project with two active changes
at different task completion, one archived change, and two specs, plus a second
root registered as a store. Every tool is judged on that same data.
`nix flake check` builds all six, runs a link-and-help or pty start check for
each, and runs the end-to-end scenarios, each of which has been deliberately
broken to prove it can fail.

Cells were first filled from source, then corrected by driving every tool on the
fixture and reading back what it drew. That pass changed a dozen cells and
reversed the timing conclusion, which is worth knowing before trusting any
comparison assembled only from reading code.

## Adding a tool

Open a pull request. See [docs/adding-a-tool.md](docs/adding-a-tool.md); it is
four files and one of them is this table's data.

## License

This repository is MIT. Each packaged tool keeps its own license, recorded in
the properties matrix above.
