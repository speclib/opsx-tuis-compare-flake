#!/usr/bin/env bash
# requires: python3
#
# The matrices are only worth reading if every cell is decided and every
# undecided cell says what was checked. This is the acceptance criterion "no
# TODO cells", enforced rather than eyeballed.
set -euo pipefail

. "$OST_TEST_LIB/sandbox.sh"

export OST_COMPARE_DATA="$OST_ENV/share/comparison.json"
test -f "$OST_COMPARE_DATA" || {
  echo "   FAIL no comparison data at $OST_COMPARE_DATA" >&2; exit 1; }

python3 - "$OST_COMPARE_DATA" <<'PY'
import json, sys

data = json.load(open(sys.argv[1], encoding="utf-8"))
tools = [t["id"] for t in data["tools"]]
notes = set(data["notes"])
allowed = {"yes", "no", "part", "unknown"}
problems = []

print(f"-- {len(tools)} tools, {len(data['features'])} feature rows, "
      f"{len(data['properties'])} property rows, {len(notes)} notes")

for section in ("features", "properties"):
    for row in data[section]:
        rid = row["id"]
        for tool in tools:
            if tool not in row["cells"]:
                problems.append(f"{section}/{rid}: no cell for {tool}")
                continue
            value = row["cells"][tool]
            if not str(value).strip():
                problems.append(f"{section}/{rid}/{tool}: empty cell")
            if "TODO" in str(value).upper():
                problems.append(f"{section}/{rid}/{tool}: TODO cell")
            # Anything not a plain yes or no owes the reader an explanation.
            if section == "features":
                if value not in allowed:
                    problems.append(f"{section}/{rid}/{tool}: {value!r} is not a marker")
                if value in ("part", "unknown") and tool not in (row.get("notes") or {}):
                    problems.append(f"{section}/{rid}/{tool}: {value} with no note")
        for tool, key in (row.get("notes") or {}).items():
            if key not in notes:
                problems.append(f"{section}/{rid}/{tool}: note {key!r} does not exist")
            if tool not in tools:
                problems.append(f"{section}/{rid}: note for unknown tool {tool!r}")

used = {k for s in ("features", "properties") for r in data[s]
        for k in (r.get("notes") or {}).values()}
for orphan in sorted(notes - used):
    problems.append(f"note {orphan!r} is never referenced")

for tool in data["tools"]:
    for field in ("id", "command", "upstream", "binary", "category", "blurb"):
        if not tool.get(field):
            problems.append(f"tool {tool.get('id')!r}: missing {field}")
    if not tool["command"].startswith("ost-"):
        problems.append(f"tool {tool['id']!r}: command is not ost- prefixed")

if problems:
    print("   FAIL")
    for p in problems:
        print(f"     {p}")
    sys.exit(1)

print("   ok  every cell decided, every soft cell explained, every note used")
PY

echo "-- the renderer agrees with the environment's tool list"
for command in $(python3 -c "
import json,os
print(' '.join(t['command'] for t in json.load(open(os.environ['OST_COMPARE_DATA']))['tools']))
"); do
  test -x "$OST_ENV/bin/$command" || {
    echo "   FAIL $command is in the data but not in the environment" >&2; exit 1; }
done
echo "   ok  every documented command exists"

echo "-- falsification: a cell with no note is rejected"
python3 - "$OST_COMPARE_DATA" <<'PY'
import json, subprocess, sys, tempfile, os, textwrap

data = json.load(open(sys.argv[1], encoding="utf-8"))
# Make a soft cell lose its note.
row = next(r for r in data["features"] if r.get("notes"))
tool = next(iter(row["notes"]))
row["cells"][tool] = "part"
row["notes"].pop(tool)

with tempfile.NamedTemporaryFile("w", suffix=".json", delete=False) as fh:
    json.dump(data, fh)
    broken = fh.name

check = textwrap.dedent('''
    import json, sys
    d = json.load(open(sys.argv[1]))
    for r in d["features"]:
        for t, v in r["cells"].items():
            if v in ("part", "unknown") and t not in (r.get("notes") or {}):
                sys.exit(1)
    sys.exit(0)
''')
rc = subprocess.run([sys.executable, "-c", check, broken]).returncode
os.unlink(broken)
if rc == 0:
    print("   FAIL the completeness check accepted an unexplained cell")
    sys.exit(1)
print("   ok  an unexplained cell is rejected")
PY
