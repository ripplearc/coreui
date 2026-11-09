# RULE 8: Widget Test Finders & Behavior

## Name
Widget Test Finders

## Category
Testing - Widget Tests

## Severity Levels
- **Critical:** `findsNWidgets` + `byType` on implementation-specific widgets
- **Major:** Tests rely on exact widget counts, tree structure, or internal implementation
- **Minor:** Positional access (`.first`, `.last`) without semantic context
- **Suggestion:** Prefer Keys or semantic finders for resilience

## Description

Component tests check what the user sees and does, not how the widget is built inside. Use finders that survive a refactor of the component's internals: Keys the component exposes, text, and semantics.

**Core Principle:** If the component is restyled or its parts are reorganized without changing behavior, its tests still pass.

## Applicability

All widget, golden and a11y tests in `test/components/`.

---

## For Coding Agents (Prescriptive)

### Decision Tree: Which Finder Should I Use?

```
What am I trying to find?

├─ User-visible text?                  → find.text('Concrete')
├─ A part tests need to reach?         → find.byKey(CoreChip.surfaceKey)
│                                         (a public static const Key on the component)
├─ Semantically labeled element?       → find.bySemanticsLabel('Remove Concrete')
└─ The component under test itself?    → find.byType(CoreChip)
                                          ONLY if there is exactly one, with no
                                          findsNWidgets and no .first/.last/.at(...)
```

### Keys for parts tests need

When a test must reach a part (the surface, the close target, the focus ring), the component exposes it as a **public static const Key** with a `core_<component>_<part>` value, so tests and the app use the same name:

```dart
class CoreChip extends StatefulWidget {
  static const Key surfaceKey = Key('core_chip_surface');
  static const Key closeFocusRingKey = Key('core_chip_close_focus_ring');
  …
}
```

### Fragile Finder → Stable Finder

| ❌ Fragile | ✅ Stable | Why |
|---|---|---|
| `find.byType(CoreIconWidget), findsNWidgets(2)` | `find.byKey(CoreChip.closeFocusRingKey)` | A new icon in the part breaks the count |
| `find.byType(InkWell).first` | `find.byKey(CoreChip.surfaceKey)` | Order changes with the layout |
| `find.byType(Row)` / `byType(Padding)` / `byType(Container)` | `find.text(...)` / `find.byKey(...)` | Layout widgets are not user-observable |
| `tester.tap(find.byType(GestureDetector))` | `tester.tap(find.byKey(...))` or `find.text(...)` | Says *which* target |

Size and color checks (`tester.getSize`, a decoration's color) are fine when they are the behavior under test — find the widget by its Key, not by `byType(Container).at(2)`.

Tree order is fine to check when the order is the behavior under test, for example ink under a fill: `find.descendant(of: find.byType(AnimatedContainer), matching: find.byType(InkWell))` proves the splash is painted inside the fill (rule 17).

---

## For Review Agents (Detective)

### Detection Patterns

| Pattern | Grep | Severity |
|---|---|---|
| `findsNWidgets` with `byType` | grep 1 below | Critical |
| Positional access | grep 2 below | Major |
| Layout type finders | grep 3 below | Minor |
| Tap by widget type | grep 4 below | Major |
| Key string repeated in a test instead of the component's static Key | grep 5 below | Minor |

The greps sit in a code block, not in the table, so each `|` means what the shell or regex says: a pipe in grep 1, an "or" in greps 2 and 3. Run them on the added lines of the diff only.

```bash
# 1. findsNWidgets with byType
grep -rn "findsNWidgets" test/ | grep "byType"
# 2. Positional access
grep -rnE "find\.[a-zA-Z]+\([^)]*\)\.(first|last|at\()" test/
# 3. Layout type finders
grep -rnE "byType\((Row|Column|Container|Padding|SizedBox)\)" test/
# 4. Tap by widget type
grep -rn "tester.tap(find.byType" test/
# 5. Key string repeated in a test
grep -rn "Key('core_" test/
```

### Common Violations

| ❌ Violation | ✅ Fix | Severity |
|---|---|---|
| `expect(find.byType(CoreIconWidget), findsNWidgets(3))` | One Key per icon the test cares about | Critical |
| `find.byType(CoreButton).first` | Give each button in the test a Key | Major |
| `find.byKey(const Key('core_chip_surface'))` | `find.byKey(CoreChip.surfaceKey)` | Minor |

---

## References

- [Flutter Widget Testing Guide](https://flutter.dev/docs/cookbook/testing/widget/introduction)
- Related: Test Double Pattern, Accessibility
