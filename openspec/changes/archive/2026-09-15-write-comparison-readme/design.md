# Design: the comparison README

## Generated, not written

The briefing asks for `ost-compare --matrix` to reprint the README's table.
Generating the README from what the command prints is the same requirement with
the drift taken out. `pkgs/readme.nix` substitutes three sections into
`docs/README.template.md`, and `readme-is-current` diffs the result against the
committed file.

The generator fails if any placeholder survives substitution, so a renamed
section is a build failure rather than a page with `{{FEATURES}}` in it.

Falsified by appending a line to `README.md`: the check failed with
"README.md is stale."

## What is in the template and what is generated

The template holds the prose: what this is, the bias disclosure, the caveats,
the method pointer, the invitation to add a tool. The three generated sections
are the contender blurbs and the two matrices. Prose about the findings lives in
the template because it is an argument, not data; the numbers it refers to come
from the data file, so the argument cannot quietly outlive them.

## Section order

The briefing's order is followed, with one deviation: the bias disclosure is
moved from item seven to directly under the opening. The briefing's reasoning is
that the artifact is worthless as a comparison without it, and that reasoning
applies more strongly the earlier a reader meets it. A disclosure below the
matrices is one a reader reaches after already having formed a view.
