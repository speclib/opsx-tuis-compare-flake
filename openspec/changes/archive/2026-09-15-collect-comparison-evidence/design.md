# Design: collecting the evidence

## The evidence hierarchy

Four kinds, in descending strength: running the tool; a key table or binding
list in its source; a dependency manifest; a README. A README alone never
justifies a `yes`.

An early attempt counted grep hits per feature per tool. That was abandoned
after it reported zero `--store` hits for itslame, which visibly has the flag in
its `--help`. Counts measure vocabulary, not behaviour. What replaced them is
narrower and checkable: `--help` output captured verbatim, `key.WithHelp` and
`Binding` calls extracted whole, and manifests read directly.

## Absence of evidence is not evidence of absence

A feature a search did not find is `unknown` with a note saying what was
searched, not `no`. This is the rule that costs the most cells and is worth the
most: a confident `no` that is wrong is the failure mode a reader cannot detect,
because nothing in the page marks it.

## Time to first paint

`tests/lib/first-paint.py` opens a real pty, runs the tool with the working
directory set to the fixture, and records the delay from `exec` to the first
byte written to the terminal. Five runs, median reported.

First byte, not first frame. Time to a fully drawn frame would need an assertion
about frame content, which the briefing forbids and which would break on any
redesign. First byte is stable, and it is the quantity a popup binding cares
about: when does something appear.

The split is clean and larger than the measurement error:

| Tool          | Median  | Language |
|---------------|---------|----------|
| ost-neosam    | 7 ms    | Rust     |
| ost-specgetty | 10 ms   | Go       |
| ost-dossier   | 21 ms   | Go       |
| ost-itslame   | 28 ms   | Go       |
| ost-mstanton  | 239 ms  | Python   |
| ost-opsx      | 355 ms  | Python   |

Interpreter and framework startup dominate, so neither Python tool will improve
with a smaller project. itslame at 28 ms is worth noting separately: it shells
out to a Node CLI, and it still paints first well inside the budget, which
weakens the latency argument against the CLI route that the next briefing was
expecting to make.

`ost-opsx` had to be measured with an explicit `--project`, because without one
it exits without drawing.
