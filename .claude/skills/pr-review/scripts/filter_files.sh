#!/bin/bash
#
# filter_files.sh
#
# Purpose:
#   Filters a list of files based on a glob pattern. Used to narrow down which
#   files should be analyzed by rules (e.g., only component files).
#   Enables efficient rule application by pre-filtering irrelevant files.
#
# Input (via stdin as JSON):
#   {
#     "files": [                          # Required: array of file paths
#       "lib/src/components/chips/core_chip.dart",
#       "lib/src/theme/spacing.dart",
#       "test/components/chips/core_chip_test.dart"
#     ],
#     "pattern": "lib/src/components/"    # Required: path prefix to match
#   }
#
# Output (JSON):
#   Success:
#     {
#       "files": [
#         {"path": "lib/src/components/chips/core_chip.dart"}
#       ]
#     }
#
#   Error:
#     {
#       "error": "Human-readable message",
#       "code": "ERROR_CODE"
#     }
#
# Error Codes:
#   - PARSE_ERROR: Invalid JSON input
#   - MISSING_REQUIRED_FIELD: pattern parameter not provided
#
# Pattern Examples:
#   - "lib/src/components/" → matches component source files
#   - "lib/src/" → matches all library source files
#   - "test/components/" → matches component tests
#
# Example Usage:
#   echo '{
#     "files": ["lib/src/components/chips/core_chip.dart", "lib/src/theme/spacing.dart"],
#     "pattern": "lib/src/components/"
#   }' | bash .claude/skills/pr-review/scripts/filter_files.sh
#
# Workflow Position: Step 3 (Filter Applicable Files)
#   Used by: PR Review Skill to narrow down to component files before rule application

set -euo pipefail

# Helper function to output error as JSON
error_exit() {
  local message="$1"
  local code="$2"

  echo "{\"error\":\"$message\",\"code\":\"$code\"}"
  exit 1
}

# Parse and validate input
INPUT=$(cat) || error_exit "Failed to read input" "PARSE_ERROR"

FILES=$(echo "$INPUT" | jq -r '.files[]?' 2>/dev/null) || error_exit "Invalid JSON input" "PARSE_ERROR"
PATTERN=$(echo "$INPUT" | jq -r '.pattern // empty' 2>/dev/null) || error_exit "Invalid JSON input" "PARSE_ERROR"

if [[ -z "${PATTERN}" ]]; then
  error_exit "pattern is required (e.g., 'lib/src/components/')" "MISSING_REQUIRED_FIELD"
fi

if [[ -z "${FILES:-}" ]]; then
  jq -n '{files: []}'
  exit 0
fi

OUTPUT='{"files": []}'

# Match files against pattern using bash glob matching
while IFS= read -r FILE; do
  if [[ -n "$FILE" ]]; then
    # Prefix match of the provided pattern, Dart files only. coreui's buckets
    # are plain path prefixes, so no '**' handling is needed, and an
    # example/test/ file or a component .md file is not routed to a rule.
    MATCHED=false
    if [[ "$FILE" == "$PATTERN"* && "$FILE" == *.dart ]]; then
      MATCHED=true
    fi

    if [[ "$MATCHED" == true ]]; then
      FILE_JSON=$(jq -n --arg path "$FILE" '{path: $path}')
      OUTPUT=$(echo "$OUTPUT" | jq --argjson file "$FILE_JSON" '.files += [$file]')
    fi
  fi
done <<< "$FILES"

echo "$OUTPUT"
