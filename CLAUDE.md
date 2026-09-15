# opsx-tuis-compare-flake

One Nix flake that builds every known OpenSpec TUI so
`nix shell github:speclib/opsx-tuis-compare-flake` gives you all of them side by
side, on a shared fixture project, with a README that compares them.

**Read `docs/briefing.md` before doing anything.** It is the scope contract. This
file says how to work; the briefing says what to build.

---

## Working agreement

Work is tracked in two systems with a strict division:

| System   | Owns                                                  |
|----------|-------------------------------------------------------|
| beans    | Milestones and epics. Status, ordering, dependencies. |
| OpenSpec | Proposals, specs, design and the task list per epic.  |

One epic maps to exactly one OpenSpec change. Tasks never live in beans; they live
in that change's `tasks.md`.

`docs/roadmap.md` is the human-readable overview of the same data. Keep it
current. `beans roadmap` emits an empty document in beans 0.4.2, reproduced in a
minimal scratch project, so refresh the file from `beans list` until that is
fixed.

### The loop

For each epic, in milestone order:

1. `beans list --json --ready` to pick the next epic. Confirm it is the lowest
   numbered milestone with open work.
2. `beans update <epic-id> -s in-progress`.
3. Run the OpenSpec propose workflow for that epic. Name the change after the
   epic slug recorded in the epic body.
4. Read the generated `tasks.md`. Do the work.
5. Run the full test gate (see Testing below). It must be green.
6. Run the OpenSpec archive workflow for the change.
7. Commit (see Version control). One commit per archived change.
8. `beans update <epic-id> -s completed` with a `## Summary of Changes` section.
9. When every epic under a milestone is completed, mark the milestone completed
   with its own summary.

Do not batch several epics into one commit. Do not archive a change whose tests
are failing. If an epic turns out to be wrong, scrap it with a
`## Reasons for Scrapping` section and create a replacement rather than silently
redefining it.

### When you get stuck

Record the blocker in the epic body, create a bean for the blocker itself, and
move to the next ready epic. Do not stall the run. The degradation rule in
`docs/briefing.md` section 5 is the model for this: a partial result that is
honest about its gaps beats a stalled run.

---

## Non-negotiable constraints

These come from the briefing and override any convenience:

1. **Command naming.** Every tool is exposed as `ost-<author>`. No bare
   `openspec-tui` may ever reach `PATH` from `packages.default`. Three upstream
   projects install that same name.
2. **Plain Nix, no flake-utils.** Supported systems are declared as a literal
   list and mapped with `nixpkgs.lib.genAttrs`. Do not add `flake-utils`,
   `flake-parts`, or any other output-generation input.
3. **Inputs only, no vendoring.** Every upstream TUI enters as a
   `flake = false` input pinned in `flake.lock`. No upstream source is copied
   into this repo.
4. **Real hashes.** `vendorHash` and any fixed-output hash is resolved by
   building and reading the error. `lib.fakeHash` must never be committed.
5. **No writes outside the repo.** The harness and every test use a temporary
   `XDG_DATA_HOME`. Nothing may touch `~/.local/share/openspec`.
6. **No invented evidence.** A matrix cell is filled only from something observed
   in the source or from running the tool. Inferred from a README means a partial
   marker plus a footnote. Undeterminable means `?` plus a footnote.
7. **Degradation over blocking.** A tool that will not build keeps its package
   attr, gets `meta.broken = true`, leaves `packages.default`, and gets its
   failure recorded in `docs/method.md` and as a README footnote.

### Required flake skeleton shape

```nix
outputs = { self, nixpkgs, ... }@inputs:
  let
    systems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    forAllSystems = f:
      nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
  in {
    packages = forAllSystems (pkgs: import ./pkgs { inherit pkgs inputs; });
    # devShells, apps, checks follow the same shape
  };
```

---

## Testing

Three layers. All three must pass before a change is archived.

### 1. Evaluation checks

`nix flake check` must pass on `x86_64-linux`. This covers evaluation of every
package, every app and every check on every declared system.

### 2. Per-package smoke checks

`checks.<system>.smoke-<name>` for each tool. A smoke check proves the binary
exists, links, and responds to `--help` or `--version`. It does not fake a TTY.
Label each one in its `name` and in `docs/method.md` as a link-and-help check,
not a functional check.

### 3. End-to-end tests

`checks.<system>.e2e-<scenario>`, driven from `tests/e2e/`. Each e2e test builds
the fixture, sets `HOME` and `XDG_DATA_HOME` to sandbox paths, and asserts an
observable outcome. The required scenarios:

| Scenario            | Asserts                                                           |
|---------------------|-------------------------------------------------------------------|
| `default-env`       | `packages.default` exposes the nine expected commands and no more  |
| `no-name-collision` | no `openspec-tui` or `opsx-tui` binary is on `PATH`                |
| `fixture-valid`     | `openspec validate` passes on the fixture, and `list` sees it      |
| `fixture-writable`  | `ost-demo` yields a writable copy outside the store                |
| `store-resolution`  | a registered store resolves under the temp `XDG_DATA_HOME` only    |
| `each-tool-starts`  | every non-broken tool starts against the fixture and exits cleanly |
| `no-host-writes`    | a full harness run leaves `$HOME` fixture-free                     |

TUIs need a TTY, so `each-tool-starts` drives them under a pty helper with a
bounded timeout and accepts a non-zero exit from the timeout. Say so in the test
name. Never assert on rendered frames.

### Running the gate

```bash
nix flake check
nix build .#specgetty .#dossier .#neosam .#mstanton .#itslame .#opsx
nix build .#default && ls result/bin
```

---

## Version control

This repo uses **jj** (Jujutsu), colocated with git. The remote is
`git@github.com:speclib/opsx-tuis-compare-flake.git` as `origin`, tracking the
`main` bookmark.

```bash
jj status
jj diff
jj describe -m "<message>"       # set the message on the working copy
jj new                           # start the next change
jj bookmark set main -r @-       # move main to the described commit
jj git push --bookmark main
```

Commit after every archived OpenSpec change, and include the beans files and the
OpenSpec artifacts in that same commit.

**Commit messages.** Author is Pim Snel. Never add `Co-authored-by: Claude`,
`Generated with Claude Code`, or any other attribution to Claude or Anthropic.
Write the message in the imperative, one subject line under 72 characters,
followed by a blank line and a short body when the change needs one.

---

## Prose rules

Every markdown file in this repo, the README included, follows the rules in the
user's global prose config:

- No em dash, no en dash, no spaced double hyphen. Name the relation, or use a
  comma, a colon, parentheses, or two sentences.
- Straight quotes only.
- Drop filler words that carry no meaning: literally, basically, actually,
  simply, just, really.
- Align markdown table borders with space padding when the table is under 90
  characters wide.

Dashes inside code blocks, inline code, commands, paths and URLs are code, not
prose, and are left alone.

---

## Repo layout

```
flake.nix
flake.lock
README.md              # the comparison itself, see briefing section 3
CLAUDE.md              # this file
pkgs/
  default.nix          # assembles the package set
  specgetty.nix  dossier.nix  neosam.nix
  mstanton.nix   itslame.nix  opsx.nix
  demo-project.nix
  ost-compare.nix
  ost-demo.nix
fixture/               # the demo OpenSpec project, plain files, no nix
tests/
  e2e/                 # scenario scripts driven by checks.<system>.e2e-*
docs/
  briefing.md          # scope contract, read first
  method.md            # how each matrix cell was determined
  adding-a-tool.md
  roadmap.md           # milestone overview, kept in step with beans
.github/workflows/build.yml
```

---

## Permissions

`.claude/settings.json` allowlists the read-only and build commands this work
needs, so an autonomous run is not interrupted by routine prompts.

Two things are deliberately left off the allowlist and will prompt every time:

- `openspec store register`, because it writes to the host registry unless a temp
  `XDG_DATA_HOME` is in place. The prompt is the checkpoint that it is.
- `jj git push`, because it is outward-facing.

Do not widen the allowlist to silence either one.
