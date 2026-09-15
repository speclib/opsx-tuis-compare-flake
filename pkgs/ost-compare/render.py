#!/usr/bin/env python3
"""Render the comparison data.

Both this and the README's tables come from data/comparison.json, so the
terminal output and the page cannot drift apart. `--markdown` is what the
README generator calls.
"""

import argparse
import json
import os
import sys

MARKS = {
    "yes": ("yes", "yes"),
    "no": ("no", "no"),
    "part": ("part", "part"),
    "unknown": ("?", "?"),
}


def load(path):
    with open(path, encoding="utf-8") as handle:
        return json.load(handle)


def cell(value, markdown):
    if value in MARKS:
        return MARKS[value][1 if markdown else 0]
    return value


def note_markers(data, row, tool, used):
    """Return the footnote marker for a cell, registering the note."""
    key = (row.get("notes") or {}).get(tool)
    if not key:
        return ""
    if key not in used:
        used[key] = len(used) + 1
    return f" [{used[key]}]"


def table(data, section, markdown, used):
    tools = data["tools"]
    header = ["Feature" if section == "features" else "Property"] + [
        t["id"] for t in tools
    ]
    rows = []
    for row in data[section]:
        line = [row["label"]]
        for tool in tools:
            value = cell(row["cells"][tool["id"]], markdown)
            line.append(value + note_markers(data, row, tool["id"], used))
        rows.append(line)

    widths = [
        max(len(header[i]), max(len(r[i]) for r in rows)) for i in range(len(header))
    ]

    out = []
    if markdown:
        out.append("| " + " | ".join(h.ljust(widths[i]) for i, h in enumerate(header)) + " |")
        out.append("|" + "|".join("-" * (w + 2) for w in widths) + "|")
        for r in rows:
            out.append("| " + " | ".join(c.ljust(widths[i]) for i, c in enumerate(r)) + " |")
    else:
        out.append("  ".join(h.ljust(widths[i]) for i, h in enumerate(header)))
        out.append("  ".join("-" * w for w in widths))
        for r in rows:
            out.append("  ".join(c.ljust(widths[i]) for i, c in enumerate(r)))
    return "\n".join(out)


def footnotes(data, used, markdown):
    if not used:
        return ""
    out = ["", "Notes:" if not markdown else ""]
    for key, number in sorted(used.items(), key=lambda kv: kv[1]):
        text = data["notes"][key]
        out.append(f"{number}. {text}" if markdown else f"  [{number}] {text}")
    return "\n".join(out)


def contenders(data, markdown=False):
    out = []
    for tool in data["tools"]:
        if markdown:
            out.append(f"### `{tool['command']}` ({tool['category']})")
            out.append("")
            out.append(f"Upstream `{tool['upstream']}`, installs `{tool['binary']}`.")
            out.append("")
            out.append(tool["blurb"])
            out.append("")
        else:
            out.append(f"  {tool['command']:<16} {tool['category']}")
            out.append(f"  {'':<16} {tool['blurb']}")
            out.append("")
    return "\n".join(out)


def main():
    parser = argparse.ArgumentParser(
        prog="ost-compare",
        description="What each OpenSpec terminal interface is for, and how they differ.",
    )
    parser.add_argument("--matrix", action="store_true", help="print the feature matrix")
    parser.add_argument(
        "--properties", action="store_true", help="print the properties matrix"
    )
    parser.add_argument(
        "--markdown", action="store_true", help="emit markdown, as the README uses"
    )
    parser.add_argument("--json", action="store_true", help="print the raw data")
    parser.add_argument(
        "--section",
        choices=["contenders", "features", "properties"],
        help="print one section only, for the README generator",
    )
    args = parser.parse_args()

    data = load(os.environ["OST_COMPARE_DATA"])

    if args.json:
        json.dump(data, sys.stdout, indent=2)
        print()
        return 0

    if args.section:
        used = {}
        if args.section == "contenders":
            print(contenders(data, markdown=args.markdown))
        else:
            print(table(data, args.section, args.markdown, used))
            print(footnotes(data, used, args.markdown))
        return 0

    if args.matrix or args.properties:
        used = {}
        if args.matrix:
            print("Feature matrix")
            print()
            print(table(data, "features", args.markdown, used))
        if args.properties:
            if args.matrix:
                print()
            print("Properties")
            print()
            print(table(data, "properties", args.markdown, used))
        print(footnotes(data, used, args.markdown))
        return 0

    print("The contenders")
    print()
    print(contenders(data))
    print("  ost-compare --matrix       the feature matrix")
    print("  ost-compare --properties   language, license, data source and so on")
    print("  ost-compare --tmux         all of them side by side on the fixture")
    print("  ost-demo                   a writable copy of the fixture to try them on")
    print()
    print(f"  {data['snapshotNote']}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
