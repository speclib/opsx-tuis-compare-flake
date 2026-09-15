# Tasks: ost-compare

- [x] 1.1 Write `data/comparison.json` with every tool, feature and property row
- [x] 1.2 Give every partial and undetermined cell a note
- [x] 1.3 Record what each marker means in the file itself
- [x] 2.1 Write the renderer with aligned text and markdown output
- [x] 2.2 Add `--section` for the README generator
- [x] 2.3 Number footnotes per rendering, so they match the table above them
- [x] 3.1 Add `--tmux` building one window per tool from the data file
- [x] 3.2 Share one `ost-demo` copy across all windows
- [x] 3.3 Select the orientation window by name, not index
- [x] 4.1 Publish the data at `share/comparison.json` in the environment
- [x] 4.2 Add it to `packages.default`
- [x] 5.1 Add the `comparison-data` scenario
- [x] 5.2 Falsify it by removing a note from a partial cell
- [x] 5.3 Assert every documented command exists in the environment
- [x] 6.1 `ost-compare` and `ost-compare --matrix` render
- [x] 6.2 `ost-compare --tmux` opens one window per tool
- [x] 6.3 `nix flake check --all-systems` passes
- [x] 6.4 `openspec validate add-ost-compare --strict` passes
