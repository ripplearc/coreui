# Test recipes for the 6 checks

Copy these into the part's test file and change the part. Each recipe is a
test that stays in the PR. `pumpPart` is the usual harness:

```dart
Future<void> pumpPart(
  WidgetTester tester,
  Widget part, {
  double textScale = 1,
  Color? parentColour,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: CoreTheme.light(),
      home: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
        child: Scaffold(
          body: Center(
            child: parentColour == null
                ? part
                : Container(color: parentColour, child: part),
          ),
        ),
      ),
    ),
  );
}
```

## 1. Pressed and focused looks

Read the drawn state back, not just a flag. Two ways:

**Golden per state** (also covers check 6):

```dart
testWidgets('pressed', (tester) async {
  await pumpPart(tester, part);
  final gesture = await tester.startGesture(
    tester.getCenter(find.byType(CoreFilterChip)),
  );
  await tester.pumpAndSettle();
  await expectLater(
    find.byType(CoreFilterChip),
    matchesGoldenFile('goldens/filter_chip_pressed.png'),
  );
  await gesture.up();
});

testWidgets('focused with Tab', (tester) async {
  await pumpPart(tester, part);
  await tester.sendKeyEvent(LogicalKeyboardKey.tab);
  await tester.pumpAndSettle();
  await expectLater(
    find.byType(CoreFilterChip),
    matchesGoldenFile('goldens/filter_chip_focused.png'),
  );
});
```

**The tint stays inside the shape.** Find the ink's rect and compare it with
the visible shape, not the touch area:

```dart
final ink = tester.widget<InkWell>(find.byType(InkWell));
expect(ink.customBorder, isNotNull); // or a borderRadius matching the pill
expect(
  tester.getSize(find.byType(InkWell)).height,
  32, // the pill, not the 48 dp touch box
);
```

**The ink is not covered.** If the part has a fill, the `InkWell` must be
below it in the tree, with its own `Material`:

```dart
expect(
  find.descendant(
    of: find.byType(AnimatedContainer),
    matching: find.byType(InkWell),
  ),
  findsOneWidget,
);
```

## 2. A coloured parent

```dart
testWidgets('keeps its fill inside a coloured box', (tester) async {
  await pumpPart(tester, part, parentColour: Colors.purple);
  await expectLater(
    find.byType(CoreFilterChip),
    matchesGoldenFile('goldens/filter_chip_on_colour.png'),
  );
});

testWidgets('does not need a Material above it', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: CoreTheme.light(),
      home: Container(color: Colors.white, child: Center(child: part)),
    ),
  );
  expect(tester.takeException(), isNull);
});
```

## 3. Large text

```dart
for (final scale in [1.5, 2.0]) {
  testWidgets('label is not cut or covered at $scale', (tester) async {
    await pumpPart(tester, part, textScale: scale);

    final label = tester.getRect(find.text('Tags'));
    final icon = tester.getRect(find.byType(CoreIconWidget));
    expect(label.overlaps(icon), isFalse);

    final shape = tester.getRect(find.byKey(const Key('pill')));
    expect(shape.top, lessThanOrEqualTo(label.top));
    expect(shape.bottom, greaterThanOrEqualTo(label.bottom));
  });
}
```

## 4. Tap size

Measure every tap target yourself. Do not rely on
`meetsGuideline(androidTapTargetGuideline)`: it skips parts inside a scroll
view.

```dart
testWidgets('every tap target is at least 48 x 48', (tester) async {
  await pumpPart(tester, part);
  for (final target in find.byType(InkWell).evaluate()) {
    final size = tester.getSize(find.byWidget(target.widget));
    expect(size.width, greaterThanOrEqualTo(48));
    expect(size.height, greaterThanOrEqualTo(48));
  }
});
```

## 5. The end of each action

Test the step after the callback, and run it twice:

```dart
testWidgets('View opens the page and closes only the toast', (tester) async {
  // ... show the toast, tap View
  expect(find.byType(DetailsPage), findsOneWidget); // the page stays open
  expect(find.byType(CoreToast), findsNothing); // only the toast closed
});

testWidgets('focus moves after a clear, and only once', (tester) async {
  // clear on the chip: focus goes to the chip
  // clear from another control: focus must NOT jump to the chip again
});
```

## 6. A golden for each state

One `matchesGoldenFile` per state the library draws (rest, pressed, focused,
disabled), light and dark. Regenerate only the goldens you meant to change:

```sh
fvm flutter test --update-goldens test/components/<part>/<part>_golden_test.dart
```

Then open each changed `.png` and look at it before you commit.
