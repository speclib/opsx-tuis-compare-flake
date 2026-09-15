# README.md, generated from data/comparison.json.
#
# The briefing asks for the same tables in the terminal and on the page. Rather
# than maintain two copies of a nineteen-row matrix, the page is generated from
# what ost-compare prints, and a check asserts the committed README matches.
{
  lib,
  runCommand,
  ost-compare,
  coreutils,
  gnused,
  inputs,
  mkVersion,
}:

runCommand "opsx-tuis-compare-readme"
  {
    template = ../docs/README.template.md;
    nativeBuildInputs = [
      ost-compare
      coreutils
      gnused
    ];
  }
  ''
    ost-compare --section contenders --markdown > contenders.md
    ost-compare --section features --markdown   > features.md
    ost-compare --section properties --markdown > properties.md

    # Each section's footnotes are numbered per rendering, so the two matrices
    # each carry their own list and neither refers to the other's numbers.
    cp "$template" out.md

    for section in contenders features properties; do
      marker=$(printf '{{%s}}' "$(echo "$section" | tr '[:lower:]' '[:upper:]')")
      # awk, not sed: inserting a multi-line file at a marker is not portable
      # with sed's r command when the marker must also be removed.
      awk -v marker="$marker" -v file="$section.md" '
        $0 == marker { while ((getline line < file) > 0) print line; next }
        { print }
      ' out.md > out.next && mv out.next out.md
    done

    if grep -q '{{' out.md; then
      echo "readme: an unreplaced placeholder is left in the output:" >&2
      grep -n '{{' out.md >&2
      exit 1
    fi

    mkdir -p "$out"
    cp out.md "$out/README.md"
  ''
