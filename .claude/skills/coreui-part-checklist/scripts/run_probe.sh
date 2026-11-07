#!/usr/bin/env bash
# Runs the coreui part checklist probe on one or more parts.
#
# Usage, from the coreui repo root:
#   .claude/skills/coreui-part-checklist/scripts/run_probe.sh \
#     "CoreFilterChip(label: 'Tags', onTap: () {})" \
#     "CoreSwitch(value: true, onChanged: (_) {})"
#
# Each argument is a Dart expression that builds one part. The probe prints
# one block per part and writes a picture of each run (rest, each press,
# each Tab stop, coloured parent, no Material, 1.5 and 2.0 text) to
# $PROBE_OUT. With no PROBE_OUT, a new empty folder is made for each run,
# so pictures from an earlier run never mix in. The probe file is deleted
# afterwards, and the example/pubspec.lock change that `flutter test` makes
# is undone.
set -euo pipefail

if [ "$#" -eq 0 ]; then
  echo "usage: $0 \"<Dart expression for a part>\" ..." >&2
  exit 2
fi

root="$(git rev-parse --show-toplevel)"
here="$(cd "$(dirname "$0")" && pwd)"
probe="$root/test/zz_checklist_probe_test.dart"
lock="$root/example/pubspec.lock"

# The probe deletes this file when it ends, so never write over one that
# is already there.
if [ -e "$probe" ]; then
  echo "$probe already exists. Move it away, then run the probe again." >&2
  exit 2
fi

if [ -z "${PROBE_OUT:-}" ]; then
  PROBE_OUT="$(mktemp -d -t coreui-probe.XXXXXX)"
fi
export PROBE_OUT

lock_copy="$(mktemp)"
log="$(mktemp)"

cp "$lock" "$lock_copy"
cleanup() {
  rm -f "$probe"
  cp "$lock_copy" "$lock"
  rm -f "$lock_copy" "$log"
}
trap cleanup EXIT

cases=""
# Numbered, so two cases of one class keep their own output block and
# pictures.
n=0
for part in "$@"; do
  n=$((n + 1))
  name="$n ${part%%(*}"
  cases+="  Case('$name', () => $part),"$'\n'
done

# ENVIRON, unlike awk -v, keeps a backslash in an expression as it is.
CASES="$cases" awk '
  /\/\/ CASES/ { printf "%s", ENVIRON["CASES"]; next }
  { print }
' "$here/checklist_probe.dart.tmpl" > "$probe"

flutter_cmd=(flutter)
if command -v fvm > /dev/null; then
  flutter_cmd=(fvm flutter)
fi

cd "$root"
status=0
"${flutter_cmd[@]}" test "$probe" > "$log" 2>&1 || status=$?

if ! grep -q '^### ' "$log"; then
  # No part was measured, most often because an expression does not
  # compile. Show what flutter test said instead of printing nothing.
  echo "The probe measured no part. flutter test said:" >&2
  grep -v -E '^[0-9][0-9]:[0-9][0-9] ' "$log" >&2
  exit 1
fi

sed -n '/^### /,/^[0-9][0-9]:[0-9][0-9] /p' "$log" \
  | grep -v -E '^[0-9][0-9]:[0-9][0-9] '
echo "Pictures: $PROBE_OUT"

if [ "$status" -ne 0 ]; then
  # A part whose test failed prints no block. Name it, with the first
  # line of its error, so it does not disappear from the output.
  echo >&2
  echo "These parts were not measured; their test failed:" >&2
  awk '
    # The error comes before the [E] line: the line after "The following
    # ... was thrown ...:".
    grab { error = $0; grab = 0 }
    /^The following .* was thrown/ { grab = 1 }
    /^[0-9][0-9]:[0-9][0-9] .* PROBE .* \[E\]$/ {
      sub(/^.* PROBE /, "  "); sub(/ \[E\]$/, ""); print $0 ": " error
    }
  ' "$log" | grep . >&2 || {
    # No [E] line to name a part: show what flutter test said.
    grep -v -E '^[0-9][0-9]:[0-9][0-9] ' "$log" | tail -20 >&2
  }
fi
exit "$status"
