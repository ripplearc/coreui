# RULE 3: Test Double Pattern

## Name
Test Double Pattern

## Category
Testing Strategy

## Severity Levels
- **Critical:** Using mocks or stubs (`mockito`, `mocktail`, `when(…)`, `verify(…)`), which are forbidden in RippleArc repos
- **Major:** Faking a coreui widget or part instead of pumping the real one
- **Minor:** Test could use the real parent (sheet, keyboard, list) instead of a stand-in
- **Suggestion:** Consider testing the component inside its real container

## Description

Test the real widget. Only fake what coreui does not own: the platform (clipboard, haptics, text input), the test view (size, padding, insets) and time. Never fake a coreui widget, part or controller.

**Core Principle:** A component test pumps the real component, with its real parts, in the real theme, and checks what the user sees and what the callbacks receive.

## Applicability

All tests in `test/`.

---

## For Coding Agents (Prescriptive)

### What to Fake — and What Not to Fake

| Fake it | Don't fake it |
|---|---|
| Platform channels (`tester.binding.defaultBinaryMessenger.setMockMethodCallHandler`) for clipboard, haptics, text input | coreui widgets, `parts/` widgets, controllers (`DisplayAreaStageController`, …) |
| The test view: `tester.view.physicalSize`, `tester.view.viewInsets = const FakeViewPadding(bottom: 600)` | `AppColorsExtension` / `AppTypographyExtension` — use `CoreTheme.light()` / `CoreTheme.dark()` |
| Time, via `tester.pump(duration)` | A parent component — open the real `CoreQuickSheet`, or pump the real keyboard or list it lives in |

### Callbacks: record, don't verify

```dart
testWidgets('tapping × calls onRemove once', (tester) async {
  var removeCount = 0;

  await tester.pumpWidget(buildTestApp(
    CoreChip(
      label: 'Concrete',
      selected: ValueNotifier<bool>(false),
      withCloseIcon: true,
      onRemove: () => removeCount++,
    ),
    theme: CoreTheme.light(),
  ));
  await tester.tap(find.byKey(const Key('close_icon')));
  await tester.pump();

  expect(removeCount, 1); // ✅ observable result, no mock
});
```

`buildTestApp` (in `test/utils/test_harness.dart`) is the shared wrapper. Use it, so every test has the same `MaterialApp` + `Scaffold` shell.

---

## For Review Agents (Detective)

### Detection

1. Forbidden tooling: `grep -nE "package:(mockito|mocktail)|\bwhen\(|\bverify\(|@GenerateMocks" <changed test files>`. **Critical.**
2. A test-only class that `implements` or `extends` a coreui widget or controller (`class FakeCoreChip extends CoreChip`). **Major.**
3. A component meant to live in a sheet, keyboard or list is tested only in a bare `Scaffold`, while the bug class it fixes depends on the parent (size, insets, color). **Minor.**

### Common Violations

| ❌ Violation | ✅ Fix | Severity |
|---|---|---|
| `final onRemove = MockCallback(); verify(onRemove()).called(1);` | Count calls in a closure and `expect` the count | Critical |
| `class FakeStageController extends DisplayAreaStageController` | Use the real controller and drive it through the widget | Major |
| Theme stubbed with a hand-made `ThemeData(extensions: [...])` | `CoreTheme.light()` / `CoreTheme.dark()` | Major |

---

## References

- [Test Double Pattern Gist](https://gist.github.com/ripplearcgit/89687b7414f62a8c042b16b52e9ceb0b)
- Shared harness: `test/utils/test_harness.dart`
- Related: Widget Test Finders
