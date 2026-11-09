#!/usr/bin/env bash
#
# Self-test for the file selection in run_check.sh. Builds a throwaway git repo
# and checks which files the script would lint and test.
#
#   bash scripts/run_check_test.sh

set -euo pipefail

SCRIPT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/run_check.sh"
# shellcheck source=run_check.sh
source "$SCRIPT"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
WORK="$TMP/repo"
ORIGIN="$TMP/origin.git"
mkdir "$WORK"
REPO_ROOT="$WORK"

failures=0
expect() {
  local name="$1" want="$2" got="$3"
  if [[ "$want" == "$got" ]]; then
    echo "ok   $name"
  else
    echo "FAIL $name"
    echo "  want: $(tr '\n' ' ' <<<"$want")"
    echo "  got:  $(tr '\n' ' ' <<<"$got")"
    failures=$((failures + 1))
  fi
}

add() {
  mkdir -p "$WORK/$(dirname "$1")"
  printf '%s\n' "${2:-// $1}" >"$WORK/$1"
}

git -C "$WORK" init -q -b main
git -C "$WORK" config user.email test@example.com
git -C "$WORK" config user.name test
add lib/src/components/chips/core_chip.dart
add lib/src/components/chips/old_chip.dart
add lib/src/theme/colors.dart
add test/components/chips/core_chip_test.dart
add test/components/chips/core_chip_golden_test.dart
add test/components/chips/old_chip_test.dart
add test/components/core_icon_test.dart
add test/components/core_icon_a11y_test.dart
add test/theme/color_tokens_test.dart "expect(x, matchesGoldenFile('a.png'));"
add test/components/toast/toast_widget_test.dart
add test/components/chips/goldens/a.png
add test/components/chips/chip_harness.dart
add test/utils/test_harness.dart
git -C "$WORK" add -A
git -C "$WORK" commit -qm base
git -C "$WORK" checkout -qb feature

# --- mirror_test_dir ---------------------------------------------------------
expect "mirror: component" "test/components/chips" \
  "$(mirror_test_dir lib/src/components/chips/core_chip.dart)"
expect "mirror: lib root" "test" "$(mirror_test_dir lib/ripplearc_coreui.dart)"
expect "mirror: lib/src root" "test" "$(mirror_test_dir lib/src/x.dart)"

# --- changed_files: deletions left out, merge base used ----------------------
add lib/src/components/chips/core_chip.dart "// changed"
git -C "$WORK" rm -q test/components/chips/old_chip_test.dart
git -C "$WORK" commit -qam change
git -C "$WORK" checkout -q main
add lib/src/theme/colors.dart "// changed on main"
git -C "$WORK" commit -qam main-moved
git -C "$WORK" checkout -q feature
expect "changed: no deletions, not main's changes" \
  "lib/src/components/chips/core_chip.dart" "$(changed_files main)"

# --- select_tests ------------------------------------------------------------
expect "select: lib file brings its folder's tests" \
  "test/components/chips/core_chip_golden_test.dart
test/components/chips/core_chip_test.dart" \
  "$(select_tests <<<"lib/src/components/chips/core_chip.dart")"
expect "select: changed test, de-duplicated" \
  "test/components/chips/core_chip_golden_test.dart
test/components/chips/core_chip_test.dart" \
  "$(select_tests <<<"lib/src/components/chips/core_chip.dart
test/components/chips/core_chip_test.dart")"
expect "select: files outside lib/ and test/ ignored" "" \
  "$(select_tests <<<"README.md
example/lib/main.dart")"
expect "select: golden PNG brings its folder's tests" \
  "test/components/chips/core_chip_golden_test.dart
test/components/chips/core_chip_test.dart" \
  "$(select_tests <<<"test/components/chips/goldens/a.png")"
expect "select: helper in a component folder brings that folder's tests" \
  "test/components/chips/core_chip_golden_test.dart
test/components/chips/core_chip_test.dart" \
  "$(select_tests <<<"test/components/chips/chip_harness.dart")"
expect "select: shared helper brings all tests" \
  "$(cd "$WORK" && find test -name '*_test.dart' | sort)" \
  "$(select_tests <<<"test/utils/test_harness.dart")"
expect "select: a test/ path with no folder still selects, and the next file too" \
  "$(cd "$WORK" && find test -name '*_test.dart' | sort)" \
  "$(set -e; select_tests <<<"test/missing/goldens/x.png
test/components/chips/core_chip_test.dart")"
expect "select: parts/ file uses its component's tests" \
  "test/components/chips/core_chip_golden_test.dart
test/components/chips/core_chip_test.dart" \
  "$(select_tests <<<"lib/src/components/chips/parts/x.dart")"
expect "select: file at test/components level takes only its own tests" \
  "test/components/core_icon_a11y_test.dart
test/components/core_icon_test.dart" \
  "$(select_tests <<<"lib/src/components/core_icon.dart")"
expect "select: tests in another folder are found by file name" \
  "test/components/toast/toast_widget_test.dart" \
  "$(select_tests <<<"lib/src/components/alerts/toast.dart")"
expect "select: no tests anywhere warns, selects nothing" \
  "warning: no tests found for lib/src/components/alerts/lonely.dart, run its tests by hand" \
  "$(select_tests <<<"lib/src/components/alerts/lonely.dart" 2>&1)"

# --- differs_from_commit -----------------------------------------------------
expect "differs: clean tree" "" "$(differs_from_commit)"
add lib/src/components/chips/core_chip.dart "// fixed on disk only"
add lib/src/new_file.dart
add example/pubspec.lock "rewritten by pub get"
expect "differs: changed and untracked Dart files, not example/pubspec.lock" \
  " M lib/src/components/chips/core_chip.dart
?? lib/src/new_file.dart" \
  "$(differs_from_commit)"
git -C "$WORK" checkout -q -- lib/src/components/chips/core_chip.dart
rm "$WORK/lib/src/new_file.dart" "$WORK/example/pubspec.lock"
add test/components/chips/goldens/a.png "right image on disk only"
add test/components/chips/goldens/b.png
expect "differs: changed and untracked golden PNGs" \
  " M test/components/chips/goldens/a.png
?? test/components/chips/goldens/b.png" \
  "$(differs_from_commit)"
git -C "$WORK" checkout -q -- test/components/chips/goldens/a.png
rm "$WORK/test/components/chips/goldens/b.png"

# --- is_golden_test ----------------------------------------------------------
golden() { if is_golden_test "$1"; then echo yes; else echo no; fi; }
expect "golden: by name" yes "$(golden test/components/chips/core_chip_golden_test.dart)"
expect "golden: by content" yes "$(golden test/theme/color_tokens_test.dart)"
expect "golden: plain test" no "$(golden test/components/chips/core_chip_test.dart)"

# --- is_macos ----------------------------------------------------------------
mac() { if is_macos; then echo yes; else echo no; fi; }
expect "macos: Darwin" yes "$(RUN_CHECK_OS=Darwin mac)"
expect "macos: Linux" no "$(RUN_CHECK_OS=Linux mac)"

# --- lint_rules --------------------------------------------------------------
RULES_FILE="$WORK/rules.txt"
printf 'a\nb\n\n' >"$RULES_FILE"
expect "rules: comma list, blank lines dropped" "a,b" "$(lint_rules)"
: >"$RULES_FILE"
expect "rules: empty file fails" "fail" "$(lint_rules 2>/dev/null || echo fail)"

# --- refresh_base -----------------------------------------------------------
git -C "$WORK" checkout -q main
git clone -q --bare "$WORK" "$ORIGIN"
git -C "$WORK" remote add origin "$ORIGIN"
git -C "$WORK" fetch -q origin
git -C "$WORK" checkout -q feature
git -C "$WORK" push -q origin feature:stack-base
git -C "$WORK" fetch -q origin
git -C "$WORK" commit -q --allow-empty -m "pushed by someone else"
git -C "$WORK" push -q origin feature:stack-base
git -C "$WORK" reset -q --hard HEAD~1
git -C "$WORK" update-ref refs/remotes/origin/stack-base HEAD
before="$(git -C "$WORK" rev-parse HEAD)"
refresh_base origin/stack-base
expect "refresh: origin/<branch> is fetched" \
  "$(git -C "$ORIGIN" rev-parse stack-base)" \
  "$(git -C "$WORK" rev-parse origin/stack-base)"
expect "refresh: HEAD does not move" "$before" "$(git -C "$WORK" rev-parse HEAD)"

echo
if [[ $failures -gt 0 ]]; then
  echo "$failures check(s) failed."
  exit 1
fi
echo "All checks passed."
