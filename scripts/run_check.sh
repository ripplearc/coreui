#!/usr/bin/env bash
#
# Runs the coreui CI checks on your machine before you push.
#
#   ./scripts/run_check.sh                    # check the changes against origin/main
#   ./scripts/run_check.sh --base origin/CA-1-feat/x   # a stacked PR: its own base
#   ./scripts/run_check.sh --goldens          # also run golden tests in Docker (CI's Ubuntu)
#
# Steps, in order, stopping at the first failure:
#   1. fvm flutter pub get
#   2. fvm flutter analyze --no-fatal-infos
#   3. ripplearc_linter with the CI rule list (scripts/ripplearc_lint_rules.txt)
#      on every changed Dart file
#   4. fvm flutter test on the changed tests and the tests next to changed lib/ files
#
# The script never rebases, checks out or commits. It exits 0 only when every
# step passed, so it can run from a git pre-push hook.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RULES_FILE="$REPO_ROOT/scripts/ripplearc_lint_rules.txt"

usage() {
  sed -n '3,7p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
}

step() {
  printf '\n==> %s\n' "$1"
}

# Changed files since the branch left $1, deleted files left out. Three dots
# diff against the merge base, so a branch that is behind main does not list
# the files main changed since.
changed_files() {
  git -C "$REPO_ROOT" diff --name-only --diff-filter=d "$1...HEAD"
}

# Matches the file name and the content: test/theme/*_test.dart compare
# goldens without "golden" in the name.
is_golden_test() {
  [[ "$1" == *_golden_test.dart ]] || grep -q 'matchesGoldenFile' "$REPO_ROOT/$1"
}

# lib/src/components/chips/core_chip.dart -> test/components/chips
mirror_test_dir() {
  local dir
  dir="$(dirname "${1#lib/}")"
  dir="${dir#src}"
  dir="${dir#/}"
  if [[ -z "$dir" || "$dir" == "." ]]; then
    echo "test"
  else
    echo "test/$dir"
  fi
}

# The mirrored folder, or its nearest existing parent: parts/ folders have no
# tests of their own, their component's tests cover them.
nearest_test_dir() {
  local dir
  dir="$(mirror_test_dir "$1")"
  while [[ ! -d "$REPO_ROOT/$dir" && "$dir" == */* ]]; do
    dir="$(dirname "$dir")"
  done
  echo "$dir"
}

# test/ and test/components hold many components' tests, so there only the
# tests named after the file count: core_icon.dart -> core_icon_test.dart,
# core_icon_a11y_test.dart. A longer name with the same start also matches;
# an extra test run is harmless, a missed one is not.
tests_for_lib_file() {
  local dir name
  dir="$(nearest_test_dir "$1")"
  [[ -d "$REPO_ROOT/$dir" ]] || return 0
  if [[ "$dir" == "test" || "$dir" == "test/components" ]]; then
    name="$(basename "$1" .dart)"
    (cd "$REPO_ROOT" && find "$dir" -maxdepth 1 \( -name "${name}_test.dart" -o -name "${name}_*_test.dart" \))
  else
    (cd "$REPO_ROOT" && find "$dir" -maxdepth 1 -name '*_test.dart')
  fi
}

# Reads changed paths on stdin and prints the test files to run, sorted and
# unique.
select_tests() {
  local file found
  while IFS= read -r file; do
    case "$file" in
      test/*_test.dart)
        echo "$file"
        ;;
      lib/*.dart)
        found="$(tests_for_lib_file "$file")"
        if [[ -n "$found" ]]; then
          echo "$found"
        else
          echo "warning: no tests found for $file, run its tests by hand" >&2
        fi
        ;;
    esac
  done | sort -u
}

# Refreshes the base when it is a remote branch, so a stacked PR is compared
# with its base as it is on GitHub. This only moves origin/*, never HEAD.
refresh_base() {
  local remote_branch="${1#origin/}"
  if [[ "$1" == origin/* && "$remote_branch" != *[~^]* ]]; then
    git -C "$REPO_ROOT" fetch --quiet origin "$remote_branch"
  fi
}

is_macos() {
  [[ "${RUN_CHECK_OS:-$(uname -s)}" == "Darwin" ]]
}

lint_rules() {
  local rules
  rules="$(grep -v '^[[:space:]]*$' "$RULES_FILE" | paste -sd, -)"
  if [[ -z "$rules" ]]; then
    echo "error: $RULES_FILE has no rules" >&2
    return 1
  fi
  echo "$rules"
}

# One file per call: the checker drops findings when it gets many files at once.
run_linter() {
  local rules file failed=0 count=0
  rules="$(lint_rules)"
  while IFS= read -r file; do
    [[ "$file" == *.dart ]] || continue
    count=$((count + 1))
    fvm dart run ripplearc_linter:standalone_checker --rules "$rules" "$file" || failed=1
  done
  echo "Linted $count file(s) with $(tr ',' '\n' <<<"$rules" | wc -l | tr -d ' ') rules."
  return "$failed"
}

golden_command() {
  printf 'docker compose run --rm --build flutter flutter test'
  printf ' %q' "$@"
  printf '\n'
}

main() {
  local base="origin/main" goldens=false
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --base) base="${2:?--base needs a ref}"; shift 2 ;;
      --goldens) goldens=true; shift ;;
      -h|--help) usage; return 0 ;;
      *) echo "unknown option: $1" >&2; usage >&2; return 2 ;;
    esac
  done

  cd "$REPO_ROOT"
  refresh_base "$base"

  local changed
  changed="$(changed_files "$base")"
  echo "Changed files against $base: $(grep -c . <<<"$changed" || true)"
  # CI sees commits only, so this script does too.
  if [[ -n "$(git status --porcelain --untracked-files=no)" ]]; then
    echo "Note: uncommitted changes are not checked. Commit them first."
  fi

  step "1/4 fvm flutter pub get"
  fvm flutter pub get

  step "2/4 fvm flutter analyze --no-fatal-infos"
  # main carries info-level findings today; warnings and errors still fail.
  fvm flutter analyze --no-fatal-infos

  step "3/4 ripplearc_linter on changed Dart files"
  run_linter <<<"$changed"

  step "4/4 fvm flutter test on changed tests"
  local tests=() goldens_found=() file
  while IFS= read -r file; do
    [[ -n "$file" ]] || continue
    if is_golden_test "$file" && { is_macos || [[ "$goldens" == true ]]; }; then
      goldens_found+=("$file")
    else
      tests+=("$file")
    fi
  done < <(select_tests <<<"$changed")

  if [[ ${#tests[@]} -eq 0 ]]; then
    echo "No tests to run on this machine."
  else
    fvm flutter test "${tests[@]}"
  fi

  if [[ ${#goldens_found[@]} -gt 0 && "$goldens" != true ]]; then
    echo
    echo "Skipped ${#goldens_found[@]} golden test file(s): macOS renders text"
    echo "differently from the Ubuntu CI. Run them in Docker with --goldens."
  fi

  if [[ "$goldens" == true && ${#goldens_found[@]} -gt 0 ]]; then
    step "Golden tests in Docker (Ubuntu 24.04, Flutter 3.44.4, as CI)"
    if ! command -v docker >/dev/null 2>&1; then
      echo "Docker is not installed. Run this where it is:"
      golden_command "${goldens_found[@]}"
      return 1
    fi
    docker compose run --rm --build flutter flutter test "${goldens_found[@]}"
  fi

  echo
  echo "All checks passed."
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main "$@"
fi
