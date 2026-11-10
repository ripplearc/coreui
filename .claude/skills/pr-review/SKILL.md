---
name: pr-review
description: |
  Modular PR review for coreui (the RippleArc Flutter component library).
  Auto-detects which rules apply to each changed file, applies the rule set in
  .claude/rules/ (referenced by name), and returns a copy-paste-ready markdown
  PR description + review table.

  Use when a user asks to review a PR, review a branch, compare branches, or
  check naming, design tokens, tests, accessibility, ink splashes, or whether
  the PR text matches the diff (pass the PR number).

  Trigger phrases: "review this PR", "review my PR", "review feat/X to main",
  "check my branch", "code review", "analyze my changes".
disable-model-invocation: false
allowed-tools: Bash, Read, Grep, Write
---

# PR Review Skill

Reviews a branch diff against a base, routes each changed file to only the rules
that apply, and reports findings. Default output is a markdown document ready to
paste into a PR (see [Output](#output)).

## Rules

The full rule set lives in `.claude/rules/`. Each rule file owns its detection
patterns (its `Detective` section), severity levels, and fix guidance — load a
rule only when it's routed to a changed file.

| Rule | File | Applies to |
|------|------|-----------|
| Digestible PR | `01-digestible-pr.md` | Production-code diff size (PR-level) |
| Naming & Abstraction | `02-naming-conventions.md` | `lib/src/` |
| Test Double Pattern | `03-test-double-pattern.md` | `test/` |
| Design Tokens | `04-design-tokens.md` | `lib/src/components/` |
| Self-Documenting Code | `07-self-documenting-code.md` | `lib/src/` |
| Widget Test Finders | `08-widget-test-finders.md` | `test/components/` |
| Accessibility | `14-accessibility-testing.md` | **Gated:** interactive `lib/src/components/` + `*_a11y_test.dart` |
| PR Text Matches Diff | `16-pr-text-matches-diff.md` | **Gated:** PR text vs diff (PR-level, needs `pr_number`) |
| Ink Needs Material | `17-ink-needs-material.md` | `lib/src/` using `Ink`/`InkWell`/`InkResponse` |

File numbers match the construculator-app rules, so a rule has the same number
in both repos. Three app rules need code coreui does not have: UI / Business
Separation (no BLoC in `lib/`), Stream Lifecycle (no streams) and Sentry
Logging (no Sentry). Three more are not used yet, to keep this first version
small: Unit Test Behavior, Localization and Mutation Testing. The `rules` input
takes only the nine names above; any other name returns `INVALID_ENUM`.

## Input

| Field | Required | Default | Notes |
|-------|----------|---------|-------|
| `pr_branch` | yes | — | branch with changes |
| `base_branch` | no | `main` | target branch |
| `pr_number` | no | — | GitHub PR number; turns on `PR Text Matches Diff` |
| `rules` | no | all | force a subset by name, e.g. `["Naming & Abstraction","Ink Needs Material"]` |
| `output_format` | no | `markdown` | `markdown` \| `json` \| `both` |
| `output_dir` | no | `reviews/` | directory (repo-root-relative) the `.md` review file is written to |

On missing/invalid input, return an error object (see [Errors](#errors)).

## Workflow

1. **Collect** changed files — pipe `{"pr_branch","base_branch"}` into
   `scripts/collect_changes.sh`. It already excludes generated (`*.g.dart`,
   `*.freezed.dart`, …) and binary files, so every returned file is relevant.
   No files → return empty issues with all rules in `rules_skipped`.
   Files under `example/`, `docs/` and `assets/` are not routed to any rule.
   If `pr_number` is given, also pipe `{"pr_number"}` into
   `scripts/collect_pr_text.sh` to get the PR title and body.

2. **Route** each file to rules using the *Applies to* column above. Path-based
   buckets come from `scripts/filter_files.sh` (patterns `lib/src/`,
   `lib/src/components/`, `test/`, `test/components/`); the `ink_using` bucket
   is confirmed by grepping the file
   (`grep -lE "\b(Ink|InkWell|InkResponse)\(|Ink\.image\(" …`).
   `Digestible PR` always runs once over the production-code diff size.

3. **Gate** `Accessibility` and `PR Text Matches Diff`:
   - `Accessibility` only if an interactive component file changed (it has a
     tap, focus or value-change callback); then find its a11y test the way
     rule 14 says: by the part's file name anywhere under `test/`, not by
     folder (`alerts/toast.dart` is tested in `test/components/toast/`).
     Rule 14 also skips a change that keeps every label, role, tap size and
     focus. Else skip: `"No interactive component changed"`.
   - `PR Text Matches Diff` only if `pr_number` was given — else skip:
     `"No pr_number given"`. It runs once per PR, like `Digestible PR`.
   If the user passed `rules`, apply only those; record the rest in
   `rules_skipped` with reason `"User specified rules: [...]"`.

4. **Apply** each routed rule: `cat` its module from `.claude/rules/`, read the
   file (`git show "$PR_BRANCH:path"`), get diff context via
   `scripts/generate_diff.sh`, and use the rule's own detection patterns. Record
   each violation as an issue: `file`, `line`, `snippet` (3 lines context),
   `severity`, `suggested_fix`, and `references` (the rule module). Rules that
   say so check only the lines the PR adds, not older code in a touched file.

5. **Compile** statistics (counts by severity and rule) and build the output
   object below.

Any rule with an empty routed bucket is skipped with a reason. Cache file
contents to avoid re-reading.

## Output

The findings are modeled as JSON matching `schemas/output.schema.json`:
`summary`, `metadata`, `issues[]`, `rules_applied`, `rules_skipped[]`,
`next_steps`, `statistics`.

Each issue: `{ id, name, description, rule, severity, file, line, snippet,
suggested_fix, references[] }` with severity ∈ `critical|major|minor|suggestion`.

**`markdown` (default) / `both`** — render the JSON as one self-contained
document the user pastes straight into the PR. Output *only* the markdown (no
outer code fence, no JSON), derive every value from the computed issues, and
leave `Status`/`Notes` blank for the author. With zero issues, omit the table
and write `✅ No issues found — all applied rules passed.` With `both`, emit the
JSON, then `---`, then the markdown. With `json`, skip the markdown.

````markdown
# PR Review: <pr_branch> → <base_branch>

## 📝 PR Description

<2–4 plain-language sentences on what this PR does and why — no rule jargon.>

**Type:** <Feature | Bugfix | Refactor | Chore | Test | Docs> ·
**Version:** <pubspec version on the PR branch> ·
**Size:** <XS | S | M | L> (<N> production lines) ·
**Rules applied:** <rule names>

### What changed
- <key change tied to a concrete file/feature>
- <key change>

---

## 🔍 Review Summary

> Found <N> issue(s): <X> 🔴 critical · <Y> 🟠 major · <Z> 🟡 minor · <W> 🔵 suggestion — across <M> file(s).

| # | Issue | Severity | Location | Description | Suggested Fix | Status | Notes |
|---|-------|----------|----------|-------------|---------------|--------|-------|
| 1 | <name> | 🔴 Critical | `<file>:<line>` | <what & why> | <fix> | | |

**Status (author fills):** ✅ Addressed · 📋 Future Story (add YouTrack ID) ·
❌ Disagree (justify) · 🔄 In Progress

<!-- Skipped: <rule name> (reason), <rule name> (reason) -->
````

Sort rows by severity (critical→suggestion) then file; number the `#` column;
collapse newlines and escape `|` as `\|` in cells; omit `:<line>` for PR-level
issues (`Digestible PR`, `PR Text Matches Diff`); build the blockquote from `statistics.by_severity`.

### Saving the review file

Whenever the output includes markdown (`markdown` or `both`), **also persist it to a
file** — don't only print it. Steps:

1. Ensure the output directory exists: `mkdir -p "$OUTPUT_DIR"` (default
   `reviews/`, repo-root-relative).
2. Build a slug from the branches by replacing every non-alphanumeric character
   (including `/`) with `-`: `<pr_slug>__to__<base_slug>.md`. Example:
   `CA-1322-fix/chip-close-target` → `CA-1322-fix-chip-close-target`, base
   `main` → `main`, so the file is
   `reviews/CA-1322-fix-chip-close-target__to__main.md`.
3. Write the exact rendered markdown document (the same content described above,
   no outer code fence) to that path with the `Write` tool, overwriting any
   existing file for the same branch pair.
4. Report the written file path to the user, then show the markdown inline.

For `output_format: json` (no markdown), skip file creation. The `reviews/`
directory is a working artifact — assume it may be git-ignored; create it if
missing rather than failing.

## Errors

Scripts and this skill return JSON on failure:
`{ "error", "code", "details?", "suggestions" }`.

Codes: `MISSING_REQUIRED_FIELD`, `INVALID_ENUM`, `INVALID_BRANCH`, `GIT_ERROR`,
`PARSE_ERROR`, `FILE_NOT_FOUND`, `INVALID_PR_NUMBER`, `PR_NOT_FOUND`, `AUTH_ERROR`,
`GH_ERROR`. On a git/branch failure, return the branch names to verify; on
`PR_NOT_FOUND`, check the PR number; on `AUTH_ERROR`, run `gh auth status`; on
`GH_ERROR`, show `details.gh_error`. Or rerun without `pr_number`; a missing
rule module means the file was likely deleted.

## Notes

- Scripts are idempotent. `scripts/review.sh` at the repo root is the older
  review-document generator; this skill does not use it.
- Always record gate results (`Accessibility`/`PR Text Matches Diff`) in
  `rules_applied` or `rules_skipped` so coverage is auditable.

