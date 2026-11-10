# RULE 2: Naming Conventions & Abstraction Levels

## Name
Naming & Abstraction

## Category
API Design

## Severity Levels
- **Critical:** Forbidden suffixes (`Helper`, `Util`, `Utils`, bare `Manager`)
- **Major:** A new exported widget has no `Core` prefix, or its name says how it is built instead of what it is
- **Minor:** Parameter or enum names do not follow the existing component APIs
- **Suggestion:** Name could be more descriptive

## Description

coreui is a public package. Its names are its API: the app and every later PR read them. Names say **what a component is for**, not how it is drawn, and follow the patterns already in `lib/src/components/`.

## Applicability

All production code in `lib/src/`.

---

## For Coding Agents (Prescriptive)

### Quick Reference

| Kind | Pattern | Example |
|---|---|---|
| Exported widget | `Core` + noun | `CoreChip`, `CoreButton`, `CoreSearchBox` |
| Variant / size / state enum | `Core<Widget><Axis>` | `CoreButtonVariant`, `CoreButtonSize`, `CoreSuggestionLayout` |
| Theme data for a widget | `Core<Widget>Theme` | `CoreChipTheme` |
| Internal part | noun, in the component's `parts/` folder, not exported | `parts/toggle_button.dart` |
| Callback | `on` + event | `onPressed`, `onChanged`, `onRemove` |
| Boolean | `is…` / `has…` / `with…` / `enabled` | `isSelected`, `hasError`, `withCloseIcon` |

### 🚫 Forbidden Suffixes

- ❌ `Helper`, `Util`, `Utils` — pick a role: `Formatter`, `Painter`, `Decoration`, `Metrics`, `Controller`.
- ❌ bare `Manager` — say what it manages (`DisplayAreaStageController`).

### Abstraction Level

Public names stay at the level of the design system (`CoreChip`, `variant: CoreButtonVariant.secondary`). Names of internals can be concrete (`UnderlineFieldMetrics`, `FunctionKeyTile`). A public name must not leak the internal one (`CoreRoundedInkContainer` ❌ → `CoreChip` ✅).

---

## For Review Agents (Detective)

### Check For

1. Forbidden suffixes: `grep -nE "class [A-Za-z]+(Helper|Utils?|Manager)\b" <changed lib files>`.
2. New public widget without `Core` prefix: a new `class X extends (StatelessWidget|StatefulWidget)` that is exported from `lib/ripplearc_coreui.dart` (or a file it exports) and whose name does not start with `Core`.
3. New enum or parameter that names the same idea differently from an existing component (`kind:` where siblings use `variant:`, `small` where siblings use `CoreButtonSize.small`).
4. Public name that says how it is built (`…Container`, `…Stack`, `…Painter` on a widget).

### Common Violations

| ❌ Violation | ✅ Fix | Severity |
|---|---|---|
| `class ChipHelper` | `class ChipLabelFormatter` (or the real role) | Critical |
| New exported `class TagPill extends StatelessWidget` | `class CoreTag` | Major |
| New `CoreTag(kind: …)` where other widgets use `variant:` | `variant:` | Minor |
| `CoreRoundedInkContainer` | Name what it is: `CoreSelectTile` | Major |

---

## References

- [Naming & Abstraction Gist: Class Naming Convention](https://gist.github.com/ripplearcgit/89f05e4f83e087f63148bbbb1d99a178)
- Public API: `lib/ripplearc_coreui.dart`
