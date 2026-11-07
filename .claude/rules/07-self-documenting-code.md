# RULE 7: Self-Documenting & Clean Code

## Name
Self-Documenting Code

## Category
Code Quality & Maintainability

## Severity Levels
- **Critical:** AI-generated artifacts or placeholder comments in production code
- **Major:** Public widget or parameter without dartdoc; step-by-step narrative comments; any comment above a private member
- **Minor:** Obscure naming requiring explanatory comments
- **Suggestion:** Refactor complex logic into descriptive helper methods

## Description

coreui is a public package, so its **public API is documented** and its **internals explain themselves through names**. Dartdoc says what a public widget is for and how to use it. Inside the code, names and structure carry the meaning, not comments.

## Applicability

All production code in `lib/src/`.

---

## For Coding Agents (Prescriptive)

### What TO Write — Documentation

- **Every exported widget:** a dartdoc paragraph — what it is, when to use it, and a short usage example (see `CoreChip`).
- **Every public parameter:** what it controls and its default, when not obvious from the type.
- **Every public enum value:** what it looks like (`/// 48px height.` on `CoreButtonSize.large`).
- The component's `.md` file next to the widget stays in step with the dartdoc.

### What NOT to Write

- **No comment of any kind above a private member** (`_field`, `_method`, `_PrivateClass`, members of a private class or enum). Rename so the name carries the meaning. The reviewers ruled this on many PRs; it applies to "why" comments too. If the why really matters, put it in a named constant, a helper or a test.
- AI residuals (`// <-- ADD THIS`, `// TODO: implement`, `// Fix:`).
- Step-by-step narration and comments that restate the code.
- Commented-out code — git keeps history.
- Inline changelogs (`// Updated 2026-…`) — commit messages and `CHANGELOG.md` own history.

### When Comments ARE Appropriate

Inside a method body, a comment that says **why** stays: a design decision the code cannot show (why the × overlaps the text, why a box has a minimum height), a Flutter workaround with a link, or the storyboard / Figma frame a value comes from. A reviewer asking "is this comment necessary?" is not a request to delete a why-comment. The private-member rule above still wins: no comment directly above a private declaration.

### Refactor Instead of Commenting

- **Complex condition →** a predicate getter (`bool get _showsCloseIcon`).
- **Magic number →** a token (Design Tokens rule) or a named `static const`.
- **Long build method →** a private `_build…` method or a widget in `parts/`.

---

## For Review Agents (Detective)

### Detection Patterns

| Pattern | Grep / Regex | Severity |
|---|---|---|
| AI residuals | `grep -nE "// <--\|// ADD THIS\|// implementation here\|// TODO: implement\|// Fix:"` | Critical |
| Comment above a private member | a `//` or `///` line directly above a declaration whose name starts with `_`, or inside a `class _…` / `enum _…` body | Major |
| Exported widget or public parameter with no dartdoc | new `class Core…` / `final <Type> <name>;` in a public class with no `///` above it | Major |
| Step-by-step narration | 3+ consecutive `//` lines inside a method body that say *what* the next lines do (a block that says *why* is fine) | Major |
| Commented-out code | `grep -nE "^\+?[[:space:]]*//[^/].*(\b(await\|return\|final\|var\|const\|if \(\|for \().*[;{]\|[A-Za-z_]+\(.*(\),\|\);\|\{))$"` (a `//` line, with or without the diff's `+`, that ends like code: `// return foo();`, `// final x = compute();`, `// Text('hello'),`, `// setState(() {`; dartdoc examples and prose are not matched: on main it matches none of the 955 `//` lines in `lib/` and `test/`) | Major |
| Inline changelog | `grep -n "// Updated 20[0-9][0-9]-"` | Minor |

Run the greps on the added lines of the diff only.

### Common Violations

| ❌ Violation | ✅ Fix | Severity |
|---|---|---|
| `/// Ring shown on keyboard focus.` above `final _ringKey` | Delete; name it `_focusRingKey` | Major |
| New `CoreTag` with no class dartdoc | Add purpose + usage example | Major |
| `// TODO: implement` | Delete the placeholder | Critical |
| `// Loop through segments` above a `for` | Delete the comment | Major |

---

## References

- [Effective Dart: Documentation](https://dart.dev/guides/language/effective-dart/documentation)
- Example of a documented public widget: `lib/src/components/chips/core_chip.dart`
