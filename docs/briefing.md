# Dispatch briefing: `opsx-tuis-compare-flake`

> Normalized copy of the original dispatch briefing. Content is preserved;
> punctuation was rewritten to satisfy this repo's prose rules (no em dashes,
> no en dashes, straight quotes). This file is the source of truth for scope.

**Target repo:** `github:speclib/opsx-tuis-compare-flake`

**One-line goal:** one flake that builds every known OpenSpec TUI so
`nix shell github:speclib/opsx-tuis-compare-flake` gives you all of them side by
side, on a shared fixture project, with a README that compares them.

---

## 0. Scope

**In scope (this PoC):**

1. A multi-system flake packaging all six OpenSpec TUIs from source, each under a
   non-colliding command name.
2. A shared demo/fixture OpenSpec project so every tool is judged on the same data.
3. A `README.md` with the comparison tables (feature matrix plus properties matrix).
4. A small comparison harness (`ost-compare`, tmux side-by-side launcher).

**Out of scope (separate briefing, see section 7 for the carry-over notes):**
building the new TUI.

**Known correction:** the list is **six** distinct repos, not seven. The repo
`neosam/openspec-tui` appears twice in the original list. Three of the six are
named `openspec-tui` and install a binary called `openspec-tui`. Name collision is
the single most important constraint in this design.

---

## 1. Inventory (verified against the repos)

| # | Repo | Command name upstream | Language / stack | Build inputs present | License | Notes |
|---|------|----------------------|------------------|----------------------|---------|-------|
| 1 | `speclib/specgetty` | `spg` | Go | `go.mod`, `go.sum`, **`flake.nix` + `package.nix`**, goreleaser | MIT | Multi-project scanner: finds all OpenSpec projects on disk and reports status. Different category from the rest. |
| 2 | `fselich/dossier` | `dossier` | Go 1.25, Bubble Tea-style | `go.mod`, `go.sum`, goreleaser, Makefile | MIT | Reads the filesystem directly. Requires `.openspec.yaml` inside each change dir. 90 commits, most mature of the readers. |
| 3 | `neosam/openspec-tui` | `openspec-tui` | Rust (ratatui + crossterm, edition 2024) | `Cargo.toml`, **`Cargo.lock`**, `flake.nix` (devshell) | MIT | Not a reader but an **implementation runner**: batch runs, dependency graph between changes, launches `claude`, config editor. |
| 4 | `mstanton/openspec-tui` | `openspec-tui`, `openspec-tui-editor` | Python 3.8+, Textual | `pyproject.toml` (no lockfile) | MIT per README, **no LICENSE file in tree** | Authoring/editor angle: creates changes from templates. 3 commits. README contains copy-paste errors (points at `Fission-AI/openspec-tui`). Treat as low-fidelity. |
| 5 | `ItsLame/openspec-tui` | `openspec-tui` | Go, Bubble Tea + Glamour | `go.mod`, `go.sum`, goreleaser, Makefile | MIT | **Shells out to the `openspec` CLI JSON API** rather than parsing files. Already has `--store <id>`. Validate/archive/task-toggle from the TUI. 1 commit (squashed). |
| 6 | `fsmw/opsx-tui` | `opsx-tui` | Python 3.11 to 3.14, Textual + Pydantic 2 + watchfiles + platformdirs + SQLite + keyring | `pyproject.toml` (no lockfile), `src/opsx_tui/` | **GitHub says GPL-3.0; README says "license has yet to be defined"** | Largest ambition (Kanban board, agent runner/backends, security model), but README describes a roadmap. 8 commits. **Assume it may not run.** |

### Consequences for packaging

- **Three binaries called `openspec-tui`.** They cannot coexist on one `PATH`. Every
  app gets a stable, unambiguous wrapper name (section 2.2).
- **Only two repos ship a lockfile-equivalent that Nix likes for free:** neosam
  (`Cargo.lock`) and the Go ones (`go.sum` gives `vendorHash`). Both Python projects
  are unlocked; pull their deps from nixpkgs and relax version pins.
- **`openspec` itself is in nixpkgs** (`pkgs.openspec`, `mainProgram = "openspec"`)
  and upstream also ships a `flake.nix`. ItsLame's TUI hard-requires it at runtime;
  opsx-tui wants it; the others do not. Wrap it onto `PATH` for all of them anyway so
  the comparison is fair.
- **fsmw/opsx-tui licensing is ambiguous.** Do not silently assert a license. Set
  `meta.license = lib.licenses.gpl3Only;` with an adjacent comment recording the
  README contradiction, and add a line about it in the README's properties table. If
  a build or eval of that one fails, degrade gracefully (section 5).

---

## 2. Flake design

### 2.1 Inputs

```nix
inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  # each TUI as a pinned, non-flake source
  src-specgetty = { url = "github:speclib/specgetty";        flake = false; };
  src-dossier   = { url = "github:fselich/dossier";          flake = false; };
  src-neosam    = { url = "github:neosam/openspec-tui";      flake = false; };
  src-mstanton  = { url = "github:mstanton/openspec-tui";    flake = false; };
  src-itslame   = { url = "github:ItsLame/openspec-tui";     flake = false; };
  src-opsx      = { url = "github:fsmw/opsx-tui";            flake = false; };
};
```

Rationale: `flake = false` for **all six**, including the two that have their own
flakes. Uniform packaging in one place means uniform wrapper names, uniform `meta`,
uniform version strings, and no coupling to upstream output naming that can break the
compare flake. Say this explicitly in the README: it is a comparison artifact, not a
redistribution channel.

Pin everything in `flake.lock`. Derive each package `version` from the input's
`shortRev` / `lastModifiedDate` so the README and `--version` output are honest about
"this is a snapshot of $DATE".

### 2.2 Naming scheme (non-negotiable)

Prefix `ost-` (for "OpenSpec TUI"), suffixed by author, because two of the three
colliding tools are indistinguishable by project name:

| Package attr | Exposed command | Wraps          |
|--------------|-----------------|----------------|
| `specgetty`  | `ost-specgetty` | `spg`          |
| `dossier`    | `ost-dossier`   | `dossier`      |
| `neosam`     | `ost-neosam`    | `openspec-tui` |
| `mstanton`   | `ost-mstanton`  | `openspec-tui` |
| `itslame`    | `ost-itslame`   | `openspec-tui` |
| `opsx`       | `ost-opsx`      | `opsx-tui`     |

Implement each as: build the real package, then `makeWrapper` / `writeShellApplication`
into `$out/bin/ost-<author>` with
`--prefix PATH : ${lib.makeBinPath [ pkgs.openspec pkgs.git ]}`. Keep the original
binary name available inside the individual package output; only the combined env
exposes the `ost-*` names, to avoid three `openspec-tui` symlinks racing in one
`buildEnv`.

### 2.3 Outputs

```
packages.<system>.default   # symlinkJoin/buildEnv: all six wrappers + ost-compare + ost-demo + openspec CLI
packages.<system>.<name>    # specgetty | dossier | neosam | mstanton | itslame | opsx
packages.<system>.demo-project
apps.<system>.<name>        # nix run .#itslame
devShells.<system>.default  # everything + go, cargo, python, for hacking on the flake
checks.<system>.<name>      # smoke checks, see section 5
```

`packages.default` must be what `nix shell github:speclib/opsx-tuis-compare-flake`
lands you in, with all six `ost-*` commands plus `openspec` on `PATH`. That exact
invocation is the headline promise of the README. Verify it.

### 2.4 Per-language recipes

- **Go (specgetty, dossier, itslame):** `buildGoModule`. `vendorHash` must be resolved
  for real: build with `lib.fakeHash`, take the hash from the error, commit it. Never
  leave a fake hash in the tree. dossier's entrypoint is `cmd/dossier`; itslame's is
  the repo root `main.go`; specgetty already has a working `package.nix` you can read
  for its build quirks before rewriting it.
- **Rust (neosam):** `rustPlatform.buildRustPackage` with
  `cargoLock.lockFile = "${src}/Cargo.lock"`. Edition 2024 needs a recent toolchain. If
  nixpkgs' default rustc is too old, pull it from `rust-bin` / `fenix`, but only add
  that input if the plain build fails.
- **Python (mstanton, opsx):** `python3Packages.buildPythonApplication` with
  `pyproject = true`, `build-system = [ setuptools ]` (check each `pyproject.toml` for
  the real backend; opsx may use hatchling). Dependencies from nixpkgs: `textual` for
  mstanton; `textual pydantic watchfiles platformdirs keyring` for opsx. Add
  `pythonRelaxDepsHook` plus `pythonRelaxDeps = [ "*" ]` since neither repo pins
  against nixpkgs' versions. Set `doCheck = false` for both.

### 2.5 The fixture project

`packages.demo-project` builds a directory tree that satisfies **all** six tools'
expectations simultaneously, since their assumptions differ:

```
openspec/
  config.yaml                      # so the openspec CLI recognises the root
  specs/<spec-id>/spec.md          # "### Requirement: ..." + WHEN/THEN scenarios
  changes/
    add-dark-mode/
      .openspec.yaml               # REQUIRED by dossier to see the change at all
      proposal.md  design.md  tasks.md   # tasks.md mixes - [ ] and - [x]
      specs/<spec-id>/spec.md      # delta with ADDED / MODIFIED / REMOVED
    add-user-auth/ ...             # a second change, no design.md, 0% tasks
    archive/2026-01-10-add-logging/ ...    # an archived change
```

Ship `ost-demo`: copies the fixture to `$(mktemp -d)` (read-write, since several tools
toggle checkboxes and write files), changes into it, prints the path, and drops you in
a shell. Nothing in the comparison should mutate the user's real projects.

Also make the fixture cover **stores**, since that is the decision axis that matters
most (section 7): a second fixture root registered as a store, so
`ost-itslame --store ...` can be exercised and the other five can be observed failing
or ignoring it. Keep store registration inside the temp `XDG_DATA_HOME` the harness
sets up. `openspec store register` writes to
`~/.local/share/openspec/stores/registry.yaml` and must not touch the user's real
registry.

### 2.6 The harness

- `ost-compare` prints the six commands with one-line descriptions and what each is
  good at. `ost-compare --tmux` opens a tmux session with the fixture project and one
  window per tool, so you can flip through them with the same project state.
- Optional, cheap, high value: `ost-compare --matrix` re-prints the README's feature
  table in the terminal.

---

## 3. README structure

Order matters. Someone landing on this repo wants the verdict, then the evidence.

1. **What this is:** one paragraph, plus the
   `nix shell github:speclib/opsx-tuis-compare-flake` line and `ost-compare`.
2. **The contenders:** one short paragraph per tool, covering what it is for. Be
   explicit that they are not all the same kind of program (specgetty is a fleet-level
   scanner; dossier and itslame are readers; neosam is a runner; mstanton is an author;
   opsx is an aspiring control center).
3. **Feature matrix:** rows are features, columns are the six tools, cells are
   yes / no / partial plus a footnote. Minimum rows:
   browse active changes, browse archived changes, browse project specs, render
   markdown (and how), toggle tasks in place, task progress indicator, validate change,
   archive change, open in `$EDITOR`, live reload on disk change, filter/search,
   single-change path argument, **`--store` support**, multi-project / multi-root view,
   run an agent to implement a change, batch/dependency ordering, Kanban / lifecycle
   view, in-app config editor, help overlay.
4. **Properties matrix:** rows are properties: language, TUI framework, data source
   (filesystem versus `openspec` CLI JSON), requires Node / `openspec` on PATH, config
   file location, license, distribution channels (go install / brew / PyPI / nix), repo
   activity at snapshot date, upstream flake, binary name, startup time on the fixture.
5. **Notes and caveats:** the `openspec-tui` name collision; fsmw's license
   contradiction; that this is a snapshot of pinned revs with the date; that partial
   cells mean "present but incomplete".
6. **Method:** how to reproduce: the fixture, the harness, what "supported" meant for
   each cell.
7. **Bias disclosure:** specgetty is authored by the owner of this compare repo. Say so
   in the README, in one line. The whole artifact is worthless as a comparison if that
   is not on the page.
8. **Adding a tool:** a short "open a PR: add input, add package, add table rows"
   section. This is what makes the repo a *concept* rather than a one-off.

Tone: neutral, evidence-backed, no marketing. Every "yes" cell must correspond to
something the agent observed in the source or README, not inferred. Where it was
inferred from the README and not verified by running it, mark it partial and say so in
the footnote.

---

## 4. Repo layout

```
flake.nix
flake.lock
README.md
pkgs/
  specgetty.nix  dossier.nix  neosam.nix  mstanton.nix  itslame.nix  opsx.nix
  demo-project.nix
  ost-compare.nix
fixture/            # the demo OpenSpec project, plain files, no nix
docs/
  method.md         # how each matrix cell was determined
  adding-a-tool.md
.github/workflows/build.yml   # nix flake check on ubuntu-latest, x86_64-linux only
```

Systems: `x86_64-linux`, `aarch64-linux`, `aarch64-darwin`, `x86_64-darwin`. CI only
needs to prove one.

---

## 5. Acceptance criteria

The PoC is done when, from a clean checkout:

1. `nix flake check` passes.
2. `nix build .#specgetty .#dossier .#neosam .#mstanton .#itslame .#opsx` all succeed,
   with real hashes committed.
3. `nix shell .` exposes exactly
   `ost-specgetty ost-dossier ost-neosam ost-mstanton ost-itslame ost-opsx ost-compare ost-demo openspec`
   and no bare `openspec-tui`.
4. Each `checks.<name>` runs the binary non-interactively (`--version` / `--help`, or
   `timeout 2s <cmd>` with a dumb terminal accepting a non-zero exit) and proves it
   starts. TUIs need a TTY. Do not fake one; a "binary exists, links, and prints help"
   check is enough and should be labelled as such.
5. `ost-demo` lands you in a writable fixture where all six start against the same data.
6. `README.md` contains both filled matrices with no `TODO` cells.

**Degradation rule:** if one tool cannot be made to build within the PoC (most likely
`opsx` or `mstanton`), do **not** block the flake. Keep its package attr, mark it
`meta.broken = true`, exclude it from `packages.default`, and record exactly what
failed in `docs/method.md` and as a row footnote in the README. A five-of-six flake
that works beats a six-of-six flake that does not evaluate. Report which ones degraded
at the end of the run.

---

## 6. Constraints for the implementing agent

- Read each repo's actual build files before writing its `.nix`. The table above is a
  briefing, not a substitute for looking.
- No invented features in the matrices. If a cell cannot be determined, `?` with a
  footnote beats a guess.
- No vendoring of upstream source into this repo; inputs only.
- No network access at build time beyond fixed-output derivations (that is what the
  hashes are for).
- Do not modify anything outside this repo. In particular do not touch the user's
  `~/.local/share/openspec` registry; the harness uses a temp `XDG_DATA_HOME`.
- Commit in logical steps: skeleton flake, then the Go three, then Rust, then the
  Python two, then the fixture, then the harness, then the README.

---

## 7. Carry-over notes for the next briefing (the new TUI)

Not to be built in this PoC. Captured here so the evaluation is aimed at something.

**What the comparison should settle:**

- **Filesystem parsing versus `openspec` CLI JSON.** ItsLame's shells out to the CLI;
  dossier and specgetty parse files. The CLI route is the only one that gets `--store`,
  `openspec context`, `doctor`, and workset resolution for free, and it survives
  OpenSpec's file-format churn, at the cost of a Node dependency and process spawn
  latency. Judge that latency on the fixture; it is the main argument against.
- **Stores are a resolution problem, not a directory problem.** OpenSpec resolves a
  root in precedence order: `--store <id>`, then the nearest `openspec/` walking up
  from cwd, then a `store:` pointer in `openspec/config.yaml`, then the global
  `defaultStore`, then error or selection hint. A TUI launched from a tmux popup in an
  arbitrary project dir must reproduce that exactly, and must show *which* case it
  landed in. OpenSpec prints a `Using OpenSpec root:` line and a `root` block in
  `--json` for precisely this reason. Getting this wrong means silently editing plans
  in the wrong repo.
- **Stores make the single-project TUI shape wrong.** A store is a standalone planning
  repo shared by several code repos, and a code repo can *reference* stores read-only.
  So the new TUI needs at minimum: a root banner showing id, path and resolution
  source; a way to switch between root and referenced stores; and an indication that
  referenced material is read-only. `openspec context --json` hands you the whole
  working set.
- **Per-machine state is per-machine.** The store registry and worksets live under
  `~/.local/share/openspec` (or `$XDG_DATA_HOME`), never in the shared repo. The TUI
  must not write plan-adjacent state into the store.
- **Beta means moving.** Stores landed in OpenSpec v1.5.0 and the docs warn that
  command names, flags, file formats and JSON keys may change; there is a known casing
  split in the agent JSON (store-family snake_case, workflow-family camelCase). Isolate
  every CLI call behind one adapter module, and pin a minimum `openspec` version at
  startup.
- **tmux popup is a design constraint, not a keybinding.** Target shape:
  `bind-key C-o display-popup -E -d "#{pane_current_path}" -w 90% -h 90% "<tui>"`. That
  implies: sub-200ms to first paint, honours `$PWD` for root resolution, renders
  correctly in a small non-fullscreen pane, and exits cleanly to the popup rather than
  leaving the terminal dirty. Time each of the six on exactly this invocation during
  the comparison. It is the most decision-relevant number in the whole exercise and
  none of their READMEs will tell you.

**Personal lessons to collect while comparing (fill these in as you use them):** what
made you quit each tool within 30 seconds; which one you reached for a second time;
which keymap fought your muscle memory.

---

## 8. Resolved open question

The original briefing asked whether the new TUI's skeleton should be generated in the
same run. Answer: no. This repo stays scoped to the compare flake. The section 7 notes
are tracked as a deferred epic so they are not lost.
