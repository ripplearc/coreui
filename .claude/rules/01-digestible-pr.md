# RULE 1: Digestible PR

## Name
Digestible PR

## Category
Code Review & PR Structure

## Severity Levels
- Major: PR exceeds Medium size (>200 lines of production code)
- Minor: PR is at Medium size (100-200 lines) but could be split logically
- Suggestion: Consider breaking larger PRs for easier review

## Description

Pull requests should be focused, digestible, and independently testable. Large PRs are harder to review thoroughly, increase risk of bugs slipping through, and slow down the review process.

## Applicability

This rule applies during PR creation and review. It is primarily used by review agents to flag oversized PRs.

---

## For Review Agents (Detective)

### Size Classification (Production Code Only)

**Size Thresholds:**
- **XS:** < 50 lines
- **S:** 50-100 lines
- **M:** 100-200 lines
- **L:** 200+ lines

**What Counts:**
- ✅ Production code (`lib/**/*.dart`), counted as **insertions only**
- ❌ Tests (`test/**`), goldens, `example/`
- ❌ Documentation (`*.md`, including the component `.md` files next to each widget), `CHANGELOG.md`, `pubspec.yaml`

### Detection Pattern

```bash
# Production insertions only
git diff --numstat "$BASE_BRANCH".."$PR_BRANCH" -- 'lib/**/*.dart' \
  | awk '{ inserted += $1 } END { print inserted + 0 }'
```

Quote this number, not GitHub's `+/-` and not insertions + deletions.

### Action Required

**If PR is >M size (200+ lines):**
- Flag as **Major** severity
- Recommend breaking into smaller, focused PRs
- Suggest logical split points

**Example Split Suggestions for a component library:**
- By part: "Ship the `parts/` widgets first, then the public component that composes them"
- By state: "Ship default + pressed first, then focus, disabled and error"
- By concern: "Move the theme-token change to its own PR"

### Key Principle

Each PR has a **single, clear purpose** and **passes CI on its own** (`.github/workflows/ripplearc_lint.yml` and `golden_test.yml`). Goldens render in Docker; regenerate them there, not on the host.

For a **stacked** PR, measure against the parent branch, not `main`; otherwise the parent's lines are counted too.

---

## For Coding Agents (Prescriptive)

### Decision Gate

```
Will this change require >200 lines of production code?
  → YES: Plan to split into multiple PRs
  → NO: Proceed with single PR
```

### Anti-Pattern: "Big Bang" PRs

❌ **Avoid:** a new component + a refactor of another one; touching several unrelated components; "while I'm here" token changes.

✅ **Prefer:** one component (or one state of it) per PR; refactors as separate PRs.

---

## References
- [GitHub Gist: Digestible PR Rule](https://gist.github.com/ripplearcgit/551ccf7208a1dcf3f3edd27cac002214)
- Same rule as construculator-app `.claude/rules/01-digestible-pr.md`
