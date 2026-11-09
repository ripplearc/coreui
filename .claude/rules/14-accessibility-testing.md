# RULE 14: Accessibility (A11y) Testing

## Name
Accessibility

## Category
Testing - Accessibility

## Severity Levels
- **Critical:** An interactive part with no semantic label, or `excludeSemantics` on an interactive part
- **Major:** A changed interactive component whose `*_a11y_test.dart` was not updated; a tap target under 48×48 dp; layout that breaks at text scale 2.0
- **Minor:** The a11y test runs in one theme only
- **Suggestion:** Consider a semantics label that says the action, not the icon

## Description

Every coreui component is used by assistive-technology users in the app. A component that is not accessible here is not accessible anywhere it is used, so each interactive component has an a11y test next to its other tests.

**GATED:** applies when an interactive component (something with a tap, focus, or value change) is added or changed.

## Applicability

Changed interactive files under `lib/src/components/`, and their tests at `test/components/<component>/*_a11y_test.dart`.

---

## For Coding Agents (Prescriptive)

### Making Components Accessible

- **Labels:** every tap target has a label — `Semantics(label:, button: true)` or the label parameter the component takes (`semanticsLabel`, `removeSemanticsLabel` on `CoreChip`). Never `excludeSemantics: true` on something the user can act on.
- **Tap targets ≥ 48×48 dp**, even when the visible part is smaller (pad the hit area, not the drawing).
- **Text scale 2.0:** the component still lays out without overflow or clipping.
- **Contrast:** colors come from `AppColorsExtension.of(context)` (Design Tokens rule), which are checked in both themes.
- **Keyboard:** a focusable part can be reached with Tab and shows a focus ring.

### Writing A11y Tests — Use the Shared Helpers

All a11y tests use **`test/utils/a11y_guidelines.dart`**:

- `setupA11yTest(tester)` — sets the standard a11y surface size and restores it afterwards.
- `expectMeetsTapTargetAndLabelGuidelines(tester, finder)` — Android + iOS tap target, labeled tap target, text contrast.
- `expectMeetsTapTargetAndLabelGuidelinesForEachTheme(tester, buildWidget, finder)` — the same checks in `CoreTheme.light()` and `CoreTheme.dark()`.

```dart
testWidgets('meets tap target and label guidelines in both themes', (tester) async {
  await setupA11yTest(tester);
  await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
    tester,
    (theme) => CoreChip(
      label: 'Concrete',
      selected: ValueNotifier<bool>(false),
      onTap: () {},
    ),
    find.byType(CoreChip),
  );
});
```

Existing examples: `test/components/chips/core_chip_a11y_test.dart`, `test/components/toast/toast_a11y_test.dart`.

---

## For Review Agents (Detective)

### Detection Patterns

| Pattern | Grep | Severity |
|---|---|---|
| `IconButton` without tooltip | grep 1 below, then read the whole call: `tooltip:` is usually on a later line | Critical |
| `excludeSemantics` on interactive widgets | grep 2 below, then check the subtree for `onTap`/`onPressed` | Critical |
| Small custom tap targets | `GestureDetector` / `InkWell` with `width:` or `height:` under 48 and no larger hit area | Major |
| Component changed, a11y test not touched | a component file in the diff but no `*_a11y_test.dart` for it. Find the test by the part's file name anywhere under `test/`, not by folder: `alerts/toast.dart` is tested in `test/components/toast/`. Skip when the change keeps every label, role, tap size and focus | Major |
| A11y test in one theme only | new `_a11y_test.dart` calls `expectMeetsTapTargetAndLabelGuidelines` but not `…ForEachTheme` | Minor |

The greps sit in a code block, not in the table, so each `|` is a plain regex "or":

```bash
# 1. IconButton (no \b: Apple Git's `git grep -E` does not know it)
grep -nE "(^|[^A-Za-z0-9_])IconButton\(" <changed lib files>
# 2. excludeSemantics
grep -nE "excludeSemantics: true" <changed lib files>
```

### Common Violations

| ❌ Violation | ✅ Fix | Severity |
|---|---|---|
| Close `×` with no label | Label it with the action ("Remove Concrete") | Critical |
| 24×24 dp tap target | Grow the hit area to 48×48 dp | Major |
| Component restyled, `*_a11y_test.dart` unchanged | Update or add the a11y test | Major |
| Light theme only | `expectMeetsTapTargetAndLabelGuidelinesForEachTheme` | Minor |

---

## References

- Shared helpers: **`test/utils/a11y_guidelines.dart`**
- [Flutter Accessibility Guide](https://flutter.dev/docs/development/accessibility-and-localization/accessibility)
- [WCAG 2.1 Quickref](https://www.w3.org/WAI/WCAG21/quickref/)
