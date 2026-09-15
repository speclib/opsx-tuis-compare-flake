# Tasks: the comparison README

- [x] 1.1 Write `docs/README.template.md` with the prose and three placeholders
- [x] 1.2 Cover all eight sections the briefing requires
- [x] 1.3 Put the bias disclosure above the matrices
- [x] 1.4 State the name collision, both license problems, and the snapshot
- [x] 1.5 State that relaxed Python pins were observed rather than assumed
- [x] 2.1 Write `pkgs/readme.nix` substituting the generated sections
- [x] 2.2 Fail the build if any placeholder survives
- [x] 2.3 Generate and commit `README.md`
- [x] 3.1 Add `checks.<system>.readme-is-current`
- [x] 3.2 Falsify it by appending a line to the committed README
- [x] 4.1 No `TODO` and no placeholder in the generated README
- [x] 4.2 Prose passes the repo rules: no em dash, no en dash, straight quotes
- [x] 4.3 `nix flake check --all-systems` passes
- [x] 4.4 `openspec validate write-comparison-readme --strict` passes
