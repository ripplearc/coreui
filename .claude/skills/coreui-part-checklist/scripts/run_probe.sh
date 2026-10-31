#!/usr/bin/env bash
# Runs the coreui part checklist probe on one or more parts.
#
# Usage, from the coreui repo root:
#   .claude/skills/coreui-part-checklist/scripts/run_probe.sh \
#     "CoreFilterChip(label: 'Tags', onTap: () {})" \
#     "CoreSwitch(value: true, onChanged: (_) {})"
#
# Each argument is a Dart expression that builds one part. The probe prints
# one block per part and writes pictures of each state to $PROBE_OUT
# (default /tmp). The probe file is deleted afterwards, and the
# example/pubspec.lock change that `flutter test` makes is undone.
set -euo pipefail

if [ "$#" -eq 0 ]; then
  echo "usage: $0 \"<Dart expression for a part>\" ..." >&2
  exit 2
fi

root="$(git rev-parse --show-toplevel)"
here="$(cd "$(dirname "$0")" && pwd)"
probe="$root/test/zz_checklist_probe_test.dart"
lock="$root/example/pubspec.lock"
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
for part in "$@"; do
  name="${part%%(*}"
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
exit "$status"
