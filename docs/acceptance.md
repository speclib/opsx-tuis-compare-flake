# Acceptance verification

Run from a clean clone, not from the working tree, so that an untracked file or
an uncommitted hash would show up as a failure.

```
git clone --depth 1 <this repo> /tmp/clean && cd /tmp/clean
```

Verified at commit `178d1be` on 2026-09-15, x86_64-linux.

## The six criteria

### 1. `nix flake check` passes

```
$ nix flake check --all-systems
all checks passed!
exit=0
```

Eighteen checks: six smoke checks, ten end-to-end scenarios, and two
self-checks. All three declared systems evaluate.

### 2. All six tools build, with real hashes committed

```
$ nix build .#specgetty .#dossier .#neosam .#mstanton .#itslame .#opsx
exit=0

$ grep -rn fakeHash pkgs lib flake.nix tests
none
```

No tool degraded, against the briefing's expectation that `opsx` or `mstanton`
might have to.

### 3. `nix shell .` exposes exactly the nine expected commands

```
$ nix build .#default && ls result/bin
openspec
ost-compare
ost-demo
ost-dossier
ost-itslame
ost-mstanton
ost-neosam
ost-opsx
ost-specgetty

count: 9
bare colliding names: 0
```

No `openspec-tui` and no `opsx-tui`.

### 4. Every check runs the binary non-interactively and proves it starts

```
smoke-dossier    -> smoke-dossier-link-and-help
smoke-itslame    -> smoke-itslame-link-and-help
smoke-mstanton   -> smoke-mstanton-starts-on-a-pty
smoke-neosam     -> smoke-neosam-starts-on-a-pty
smoke-opsx       -> smoke-opsx-link-and-help
smoke-specgetty  -> smoke-specgetty-link-and-help
```

Each check's derivation name states what it proved. Four are link-and-help
checks. Two are pty start checks, for the tools with no non-interactive entry
point at all; no TTY is faked and no assertion is made about rendered output.

### 5. `ost-demo` lands you in a writable fixture where all six start

```
$ ost-demo
cwd=/tmp/ost-demo-d0NE3CAB/project
writable=yes

Changes:
  add-user-auth     0/7 tasks
  add-dark-mode     3/7 tasks
```

That all six start against it is asserted separately by
`checks.<system>.e2e-each-tool-starts`.

### 6. `README.md` contains both matrices with no `TODO` cells

```
feature matrix: present
properties matrix: present
no TODO cells
```

Thirty-two table rows. Every partial and undetermined cell carries a footnote,
enforced by `checks.<system>.e2e-comparison-data`.

## Degradations

None.

## Host state after the full run

```
$ ls -la ~/.local/share/openspec/stores/registry.yaml
-rw------- 1 pim users 167  1 sep 22:48 registry.yaml
```

Dated two weeks before this run and still containing only the user's own store.
Nothing in the comparison registered anything there, which is also asserted
against a decoy home by `checks.<system>.e2e-no-host-writes`.

## Known gaps

These are recorded rather than fixed, and none of them blocks the criteria
above.

- `x86_64-darwin` is not a declared system, because the pinned nixpkgs throws on
  it during evaluation. See `docs/method.md`.
- Several feature cells are undetermined. Each names what was checked. They are
  gaps in the evidence, not in the tools.
- The CI workflow has not been observed running, since the repository's remote
  had no prior push at the time of writing. The workflow file is valid YAML and
  runs the same gate that passes locally.
