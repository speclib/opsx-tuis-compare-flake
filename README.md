# opsx-tuis-compare-flake

Six people have written a terminal interface for [OpenSpec](https://github.com/Fission-AI/OpenSpec).
Three of them called the binary `openspec-tui`, so you cannot install more than
one and decide for yourself. This flake builds all six from source under names
that do not collide, on one shared fixture project, and reports what they
actually do.

```
nix shell github:speclib/opsx-tuis-compare-flake
ost-compare          # what each one is for
ost-demo             # a throwaway copy of the fixture to try them on
```

Nine commands land on your `PATH`: `ost-specgetty`, `ost-dossier`,
`ost-neosam`, `ost-mstanton`, `ost-itslame`, `ost-opsx`, plus `ost-compare`,
`ost-demo` and the `openspec` CLI. Nothing here writes to your projects or to
your OpenSpec store registry.

## Bias disclosure

specgetty is written by the owner of this repository. It is packaged, measured
and marked by the same rules as the other five, and the rules are in
[docs/method.md](docs/method.md) so you can check that claim rather than take it.

## The contenders

They are not six versions of one program. Two are readers, one scans your whole
machine, one runs changes, one writes them, and one wants to be a control
centre. Read the categories before reading the matrix, or the matrix will
mislead you.

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

### `ost-opsx` (control center)

Upstream `fsmw/opsx-tui`, installs `opsx-tui`.

The widest ambition: a Kanban board, an agent runner with its own logs and runs views, settings, and diagnostics. Eight commits, and the README reads as a roadmap.


## Feature matrix

`yes` and `no` mean observed, by running the tool or by reading its source.
`part` means present but incomplete, or claimed by a README and not verified.
`?` means undetermined, and the footnote says what was checked. There is no
cell here that means "probably".

| Feature                             | specgetty | dossier   | neosam   | mstanton | itslame  | opsx      |
|-------------------------------------|-----------|-----------|----------|----------|----------|-----------|
| Browse active changes               | yes       | yes       | yes      | yes      | yes      | yes       |
| Browse archived changes             | yes       | yes       | yes      | no [1]   | yes      | ? [2]     |
| Browse project specs                | yes       | yes       | ? [3]    | ? [1]    | yes      | yes       |
| Renders markdown                    | no [4]    | yes [5]   | yes [6]  | part [7] | yes [5]  | yes [8]   |
| Toggle tasks in place               | no        | yes [9]   | no       | no       | yes [10] | ? [11]    |
| Task progress indicator             | yes [12]  | yes       | yes [13] | no       | yes      | ? [11]    |
| Validate a change                   | no        | no        | no       | no       | yes [10] | ? [14]    |
| Archive a change                    | yes [15]  | no        | ? [16]   | no       | yes [10] | no        |
| Open in $EDITOR                     | no        | yes [9]   | yes      | no       | yes [10] | part [17] |
| Live reload on disk change          | no [18]   | ? [19]    | no       | no       | no [20]  | yes [21]  |
| Filter or search                    | ? [22]    | yes [23]  | ? [24]   | no       | yes [10] | ? [25]    |
| Takes a path argument               | yes [26]  | yes [27]  | no [28]  | no       | yes [29] | yes [30]  |
| --store support                     | no        | no        | no       | no       | yes [31] | no        |
| Multi-project or multi-root view    | yes [32]  | no        | no       | no       | no       | part [33] |
| Runs an agent to implement a change | no        | no        | yes [34] | no       | no       | part [35] |
| Batch runs and dependency ordering  | no        | no        | yes [36] | no       | no       | no        |
| Kanban or lifecycle board           | no        | no        | no       | no       | no       | yes [37]  |
| In-app config editor                | no        | no        | yes [38] | no       | no       | yes [39]  |
| Help overlay                        | ? [40]    | part [41] | ? [42]   | no       | yes [10] | yes [43]  |


1. The observed opening screen offers creating a change, opening one, and listing them. Nothing about archives or specs appeared.
2. Archive-shaped references appear in the source but no archive view appears in the tab list.
3. The source mentions specs extensively, but this tool's screens are organised around changes and runs. Not confirmed either way.
4. go.mod declares no markdown renderer: the dependencies are bubbletea, bubbles, lipgloss, godirwalk, urfave/cli and yaml.
5. Uses the glamour markdown renderer, present in go.mod.
6. Uses tui-markdown with the highlight-code feature, declared in Cargo.toml.
7. A Preview binding exists on ctrl+p. Whether it renders markdown was not confirmed.
8. Uses Textual's markdown widget.
9. From the README key table: Space toggles the task under the cursor on the tasks tab, and `e` opens the artifact in $EDITOR.
10. From the key table in the source: `/` filter, space toggle task, `e` edit in $EDITOR, `v` validate, `A` archive, `r` refresh, `?` help.
11. A Tasks tab exists. No toggle or progress action was found in the bindings, so neither is confirmed.
12. Source aggregates task statistics across changes, so the progress it reports is per project rather than per change.
13. Source renders batch change progress.
14. A Diagnostics view exists, which may or may not be validation. Not confirmed.
15. Source carries an archive flow with idle, confirming and running states. Not exercised in this comparison.
16. An Archived tab exists for browsing. Whether a change can be archived from the interface was not confirmed.
17. `e` edits metadata in the interface. Opening an external $EDITOR was not confirmed.
18. The README documents `s` to rescan, which is a manual refresh rather than a watcher.
19. A handful of watcher-shaped references appear in the source, too few to call it either way without running a file-change test.
20. `r` refreshes manually. No watcher was found.
21. Declares watchfiles as a dependency in pyproject.toml.
22. No filter or search key appears in the README key table, and no filter string was found in the source. Not confirmed absent.
23. Filter mode is confirmed in the source, which tests entering it with `/`, cancelling with Esc and confirming with Enter.
24. Some filter-shaped references appear in the source, too few to call it either way.
25. Filter-shaped references appear in the source but no filter key appears in the bindings.
26. --path selects a project and --zoom starts inside it. The unit is a project, not a change.
27. --help shows an optional [path] argument. A change directory passed directly must contain .openspec.yaml.
28. The tool parses no arguments at all. Without a terminal it exits 1 with ENXIO from opening /dev/tty.
29. --help documents a positional path argument: a directory containing an openspec/ root.
30. --help documents --project PROJECT, a path to an OpenSpec project root.
31. --help documents `-store string`, an OpenSpec store id to use as the workspace root. This is the only tool of the six with it.
32. Scanning the disk for every OpenSpec project is the tool's purpose.
33. It remembers recently opened projects, but shows one project at a time.
34. The configurable command defaults to variants of `claude`, including `claude --print --dangerously-skip-permissions {prompt}`.
35. Runner, Runs and Logs views exist. Whether an agent actually runs from them was not exercised.
36. Batch execution is the most heavily represented feature in the source, together with an explicit Add Dependency action between changes.
37. The interface opens on a Board tab with collapsible columns and a priority action.
38. A Config screen with an edit mode is present in the source, backed by a config.yaml.
39. A Settings view exists in the source.
40. No help key appears in the README key table. --help works from the command line. An in-interface overlay was not confirmed either way.
41. The interface carries a persistent status line listing keys rather than a dismissable overlay.
42. No help key was found in the source. Not confirmed absent.
43. `?` is bound to a help screen.

## Properties

| Property                              | specgetty                             | dossier       | neosam                         | mstanton                         | itslame               | opsx                         |
|---------------------------------------|---------------------------------------|---------------|--------------------------------|----------------------------------|-----------------------|------------------------------|
| Language                              | Go                                    | Go            | Rust                           | Python                           | Go                    | Python                       |
| Interface framework                   | Bubble Tea                            | Bubble Tea v2 | ratatui                        | Textual                          | Bubble Tea            | Textual                      |
| Data source                           | filesystem                            | filesystem    | filesystem                     | filesystem                       | openspec CLI JSON [1] | filesystem                   |
| Needs the openspec CLI at runtime     | no                                    | no            | no                             | no                               | yes [1]               | no                           |
| Config location                       | $XDG_CONFIG_HOME/specgetty/config.yml | none observed | config.yaml in the project [2] | none observed                    | none observed         | $XDG_DATA_HOME/opsx-tui/ [3] |
| License                               | MIT                                   | MIT           | MIT                            | MIT claimed, no LICENSE file [4] | MIT                   | contradictory [5]            |
| Ships its own flake                   | yes [6]                               | no            | yes [6]                        | no                               | no                    | no                           |
| Binary name upstream installs         | spg                                   | dossier       | openspec-tui [7]               | openspec-tui [7]                 | openspec-tui [7]      | opsx-tui                     |
| Answers --help without a terminal     | yes                                   | yes           | no [8]                         | no [9]                           | yes                   | yes                          |
| Starts with no OpenSpec root in sight | yes                                   | ? [10]        | yes                            | yes                              | ? [10]                | no [11]                      |
| Time to first paint (median of 5)     | 10 ms [12]                            | 21 ms [12]    | 7 ms [12]                      | 239 ms [13]                      | 28 ms [12]            | 355 ms [13]                  |


1. main.go calls exec.LookPath("openspec") before anything else and exits 1 with an install hint if it fails. All commands go through the CLI.
2. A Config screen with an edit mode is present in the source, backed by a config.yaml.
3. Writes $XDG_DATA_HOME/opsx-tui/recent-projects.json.
4. MIT is claimed in pyproject.toml and the README. There is no LICENSE file in the tree, and the GitHub API reports no license for the repository.
5. The tree carries a GPL-3.0 LICENSE file and GitHub reports GPL-3.0, but the README says the license has yet to be defined and that redistribution permission must not be assumed.
6. Upstream ships a flake, but this repo takes it as a flake = false input anyway, so packaging stays uniform across all six.
7. Three upstream projects install a binary with this name. They cannot coexist on one PATH, which is why this flake exposes ost- prefixed names instead.
8. The tool parses no arguments at all. Without a terminal it exits 1 with ENXIO from opening /dev/tty.
9. No argument parsing was found; the tool opens its interface immediately.
10. Not measured in this run.
11. With a clean HOME and no OpenSpec root in the working directory it exits 0 after 239 bytes, drawing nothing and printing no error. It does not walk up the way the CLI does.
12. Measured on a real pty with the working directory set to the fixture, the shape a tmux popup binding uses. Five runs each; the figure is the median of the delay from exec to the first byte the program writes to the terminal. It is not time to a fully drawn frame, which cannot be measured without asserting on frames.
13. Same measurement. Both Python tools are an order of magnitude slower than the compiled ones and both miss the sub-200ms budget a tmux popup wants; interpreter and framework startup dominate, not the project size.

## What the numbers say

The time-to-first-paint row is the one measurement none of the upstream
READMEs report, and it is the one that decides whether a tool can live behind a
tmux popup binding:

```
bind-key C-o display-popup -E -d "#{pane_current_path}" -w 90% -h 90% "<tui>"
```

That shape wants first paint under about 200 ms. The three Go tools and the
Rust one land between 7 and 28 ms. The two Python ones land at 239 ms and
355 ms, and the cost is interpreter and framework startup rather than anything
about the project being opened, so it will not improve with a smaller fixture.

## Notes and caveats

**The name collision is the whole reason this repo has a naming scheme.**
`neosam/openspec-tui`, `mstanton/openspec-tui` and `ItsLame/openspec-tui` all
install a binary called `openspec-tui`. Each package here keeps that upstream
name, and only the combined environment renames them, so what you see in the
properties matrix is what upstream really installs.

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

**Both Python tools are built with their dependency pins relaxed.** Neither
ships a lockfile, and there is one nixpkgs for the whole flake. Both were
started and observed rather than assumed to work; see
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
each, and runs eight end-to-end scenarios, each of which has been deliberately
broken to prove it can fail.

## Adding a tool

Open a pull request. See [docs/adding-a-tool.md](docs/adding-a-tool.md); it is
four files and one of them is this table's data.

## License

This repository is MIT. Each packaged tool keeps its own license, recorded in
the properties matrix above.
