# Adding a tool

Four files, and one of them is the comparison data. Nothing in `flake.nix`
needs editing: the package set drives the wrappers, the apps, the checks and
the README.

## 1. Add the input

In `flake.nix`:

```nix
src-yourtool = {
  url = "github:owner/repo";
  flake = false;
};
```

`flake = false` even if upstream ships its own flake. This repo packages all of
them the same way on purpose; see `docs/briefing.md` section 2.1.

Then `nix flake lock` and commit `flake.lock`.

## 2. Write the package

`pkgs/yourtool.nix`. Read the upstream's real build files first: a briefing is
not a substitute for looking.

```nix
{ lib, buildGoModule, inputs, mkVersion }:

buildGoModule {
  pname = "yourtool";
  version = mkVersion inputs.src-yourtool;
  src = inputs.src-yourtool;

  vendorHash = "sha256-...";   # resolved by building, never lib.fakeHash

  # How the harness checks it. This is what makes it appear in checks.
  passthru.smoke = {
    bin = "yourtool";          # the name upstream installs
    args = [ "--help" ];
  };

  meta = {
    description = "...";
    homepage = "https://github.com/owner/repo";
    license = lib.licenses.mit;
    mainProgram = "yourtool";
    platforms = lib.platforms.unix;
  };
}
```

Register it in `pkgs/default.nix`:

```nix
yourtool = callTool ./yourtool.nix { };
```

Keep the upstream binary name. The `ost-` name is added by the combined
environment, not by the package, because three of the existing six install a
binary called `openspec-tui` and they must not race inside one `buildEnv`.

### If the tool has no `--help`

Some do not: they open the terminal immediately and exit non-zero without one.
Use a pty start check instead, and say so:

```nix
passthru.smoke = {
  mode = "pty";
  bin = "yourtool";
  timeout = 5;
};
```

### If the tool needs another program at runtime

```nix
passthru.runtimeDeps = [ "openspec" ];
```

The wrapper reads this.

### Resolving the hash

Build with `vendorHash = lib.fakeHash;`, read the real hash out of the
mismatch error, and commit that. A placeholder must never reach a commit;
`nix flake check` is not what catches it, a reviewer is.

## 3. Add it to the comparison

`data/comparison.json`. Add an entry to `tools`, then a cell for your tool in
every row of `features` and `properties`.

Markers are `yes`, `no`, `part` and `unknown`:

| Marker    | Means                                                          |
|-----------|-----------------------------------------------------------------|
| `yes`     | You ran it, or read it in the source                            |
| `no`      | You ran it and it was not there, or the source has nothing      |
| `part`    | Present but incomplete, or a README claim you did not verify    |
| `unknown` | You could not determine it. The note says what you tried        |

`part` and `unknown` need a note in the `notes` map, and the check will fail
without one. That is deliberate: the easy failure mode of a comparison is a
confident `no` where the truth is "did not find it".

Do not guess. `unknown` with an honest note is worth more than a wrong `yes`.

## 4. Regenerate the README

```bash
nix build .#readme && cp result/README.md README.md
```

The README's tables are generated from the data file. Editing them by hand is
caught by `checks.<system>.readme-is-current`.

## 5. Run the gate

```bash
nix flake check --all-systems
nix build .#yourtool && ./result/bin/yourtool --help
nix build .#default && ls result/bin
```

Your tool should now appear in `ls result/bin` as `ost-yourtool`, have a
`checks.<system>.smoke-yourtool`, and show up in `ost-compare` and
`ost-compare --matrix`.

If `e2e-default-env` fails, it is telling you the expected command list changed.
Update the `expected` line in `tests/e2e/default-env.sh`; that test exists to
make the addition deliberate.

## If it will not build

Do not block the flake. Keep the package, mark it, and record what happened:

```nix
meta.broken = true;
```

It then leaves `packages.default`, the apps and the checks automatically, and
it keeps its package attribute so the failure stays reproducible. Add the real
error text to the degradations section of `docs/method.md` and a note in
`data/comparison.json`.

A five-of-six flake that works beats a six-of-six flake that does not evaluate.
