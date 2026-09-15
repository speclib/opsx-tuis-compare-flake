# Design: ost-compare

## One data file, two renderers

`data/comparison.json` holds the tools, nineteen feature rows, ten property
rows and fifty-two notes. `render.py` prints it as aligned text or as markdown,
and `--section` emits one section at a time so the README generator can place
them.

The briefing asks for `--matrix` to reprint the README's table. Doing it the
other way round, generating the README from what the command prints, is the
same requirement with the drift removed.

## Markers and what they oblige

`yes` and `no` mean observed, by running the tool or by reading its source.
`part` means present but incomplete, or claimed by a README and not verified.
`unknown` means undetermined, and the note says what was checked.

The last two are the important ones. The briefing forbids inventing evidence,
and the honest failure mode of a comparison built in one pass is a confident
`no` where the truth is "did not find it". Both are therefore machine-enforced
rather than left to discipline: `comparison-data` fails if any soft cell lacks
a note, and its own falsification removes a note to prove the check bites.

Of the 114 feature cells, the ones that are neither plain yes nor plain no are
all attributable to a specific gap, named in its note.

## Side by side

`--tmux` builds one window per tool from the tool list in the data file, all
sharing a single `ost-demo` copy so the project state is identical. Window zero
is the matrix, for orientation.

Selecting that window is done by name rather than index: a user whose
`tmux.conf` sets `base-index 1` gets `can't find window: 0` otherwise. That was
observed, not anticipated.

## Where the data lives at runtime

The JSON is published into the environment at `share/comparison.json` rather
than being read from the source tree, so a check and the command read the same
bytes.
