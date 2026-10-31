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

cp "$lock" "$lock_copy"
cleanup() {
  rm -f "$probe"
  cp "$lock_copy" "$lock"
  rm -f "$lock_copy"
}
trap cleanup EXIT

cases=""
for part in "$@"; do
  name="${part%%(*}"
  cases+="  Case('$name', () => $part),"$'\n'
done

awk -v cases="$cases" '
  /\/\/ CASES/ { printf "%s", cases; next }
  { print }
' "$here/checklist_probe.dart.tmpl" > "$probe"

flutter_cmd=(flutter)
if command -v fvm > /dev/null; then
  flutter_cmd=(fvm flutter)
fi

cd "$root"
"${flutter_cmd[@]}" test "$probe" 2>&1 \
  | sed -n '/^### /,/^[0-9][0-9]:[0-9][0-9] /p' \
  | grep -v -E '^[0-9][0-9]:[0-9][0-9] '
