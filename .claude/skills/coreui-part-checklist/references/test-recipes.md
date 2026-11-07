# Test recipes for the 6 checks

Copy these into the part's test file and change the part. Each recipe is a
test that stays in the PR. `pumpPart` is the usual harness. The part sits on
a `Material` in the page colour inside a `RepaintBoundary`, so `pixels`
reads it on the real page colour, not on a transparent box:

```dart
const partBoundary = Key('part-boundary');

Future<void> pumpPart(
  WidgetTester tester,
  Widget part, {
  double textScale = 1,
  Color? parentColour,
}) async {
  final theme = CoreTheme.light();
  await tester.pumpWidget(
    MaterialApp(
      theme: theme,
      home: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
        child: Scaffold(
          body: Center(
            child: RepaintBoundary(
              key: partBoundary,
              child: Material(
                color: theme.scaffoldBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: parentColour == null
                      ? part
                      : Container(color: parentColour, child: part),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

/// The drawn pixels inside [partBoundary], as RGBA bytes.
Future<Uint8List> pixels(WidgetTester tester) async {
  final boundary =
      tester.renderObject<RenderRepaintBoundary>(find.byKey(partBoundary));
  final bytes = await tester.runAsync(() async {
    final image = await boundary.toImage();
    return image.toByteData(format: ui.ImageByteFormat.rawRgba);
  });
  return bytes!.buffer.asUint8List();
}

/// The box around every pixel that differs, in global coordinates, or
/// [Rect.zero] if none does.
Rect changedBox(WidgetTester tester, Uint8List a, Uint8List b) {
  final origin = tester.getTopLeft(find.byKey(partBoundary));
  // The image is the part width rounded up.
  final width = tester.getSize(find.byKey(partBoundary)).width.ceil();
  var left = 1 << 30, top = 1 << 30, right = -1, bottom = -1;
  for (var i = 0; i < a.length; i += 4) {
    if (a[i] != b[i] || a[i + 1] != b[i + 1] || a[i + 2] != b[i + 2]) {
      final x = (i ~/ 4) % width, y = (i ~/ 4) ~/ width;
      if (x < left) left = x;
      if (y < top) top = y;
      if (x > right) right = x;
      if (y > bottom) bottom = y;
    }
  }
  if (right < 0) return Rect.zero;
  return Rect.fromLTRB(
    origin.dx + left,
    origin.dy + top,
    origin.dx + right + 1,
    origin.dy + bottom + 1,
  );
}
```

Imports: `dart:typed_data`, `dart:ui as ui`, `package:flutter/rendering.dart`,
`package:flutter/foundation.dart` (for `listEquals`) and
`package:flutter/services.dart` (for `LogicalKeyboardKey`).

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

**The press shows on the page, and the tint stays inside the shape.** Read
the tint from pixels, not from the `InkWell`: the `InkWell` is the 48 dp
touch area, and the tint must stay inside the smaller visible shape. Because
`pumpPart` paints the page colour, a press in the page colour gives
`Rect.zero` and fails the first `expect` (#252):

```dart
testWidgets('the press shows on the page and stays inside the pill',
    (tester) async {
  await pumpPart(tester, part);
  final rest = await pixels(tester);
  final gesture = await tester.startGesture(
    tester.getCenter(find.byType(CoreFilterChip)),
  );
  // Three frames, as the probe pumps: one frame is drawn at the start of
  // an animated press, before anything has changed.
  await tester.pump(const Duration(milliseconds: 150));
  await tester.pump(const Duration(milliseconds: 150));
  await tester.pump(const Duration(milliseconds: 150));
  final tint = changedBox(tester, rest, await pixels(tester));
  await gesture.up();

  expect(tint, isNot(Rect.zero)); // the press shows on the page colour
  final pill = tester.getRect(find.byKey(CoreFilterChip.pillKey));
  expect(tint.left, greaterThanOrEqualTo(pill.left));
  expect(tint.top, greaterThanOrEqualTo(pill.top));
  expect(tint.right, lessThanOrEqualTo(pill.right));
  expect(tint.bottom, lessThanOrEqualTo(pill.bottom));
});
```

**Two focus stops look different.** Tab, read the pixels, Tab again. Focus
must move, and the second look must differ from the first (#237, #262):

```dart
testWidgets('the chip and its x look different when focused',
    (tester) async {
  await pumpPart(tester, chipWithClose(CoreChipSize.medium));
  await tester.sendKeyEvent(LogicalKeyboardKey.tab);
  await tester.pumpAndSettle();
  final firstStop = FocusManager.instance.primaryFocus;
  final first = await pixels(tester);

  await tester.sendKeyEvent(LogicalKeyboardKey.tab);
  await tester.pumpAndSettle();

  expect(FocusManager.instance.primaryFocus, isNot(firstStop));
  expect(listEquals(first, await pixels(tester)), isFalse);
});
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
  // With no Material, Text does not throw: it draws in the fallback style,
  // a yellow double underline (#253).
  final fallback = tester
      .widgetList<RichText>(find.byType(RichText))
      .where((r) => r.text.style?.decorationStyle == TextDecorationStyle.double);
  expect(fallback, isEmpty);
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

    final shape = tester.getRect(find.byKey(CoreFilterChip.pillKey));
    expect(shape.top, lessThanOrEqualTo(label.top));
    expect(shape.bottom, greaterThanOrEqualTo(label.bottom));
  });
}
```

## 4. Tap size

Measure every tap target yourself, for every value of the size enum. Do not
rely on `meetsGuideline(androidTapTargetGuideline)`: it skips a node that
touches the screen edge. First check that the finder finds the targets, or
the loop passes with nothing checked. Change the finder to what the part
uses: `CoreSwitch` has no `InkWell`.

```dart
Widget chipWithClose(CoreChipSize size) => CoreChip(
      label: 'Tags',
      size: size,
      selected: ValueNotifier(false),
      withCloseIcon: true,
      onTap: () {},
      onRemove: () {},
    );

for (final size in CoreChipSize.values) {
  testWidgets('every tap target is at least 48 x 48 at $size',
      (tester) async {
    await pumpPart(tester, chipWithClose(size));
    final targets = find.byType(InkWell);
    expect(targets, findsWidgets);
    for (final target in targets.evaluate()) {
      final box = tester.getSize(find.byElementPredicate((e) => e == target));
      expect(box.width, greaterThanOrEqualTo(48));
      expect(box.height, greaterThanOrEqualTo(48));
    }
  });
}
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
disabled), light and dark. Golden pictures differ between platforms, so
make them inside the Docker container, as the README says in
[Golden Tests with Docker](../../../../README.md#golden-tests-with-docker).
A run on the host, on a Mac for example, fails on parts that did not
change. Regenerate only the goldens you meant to change, in the container:

```sh
flutter test --update-goldens test/components/<folder>/<file>_golden_test.dart
```

For example, `test/components/chips/core_chip_golden_test.dart`.

Then open each changed `.png` and look at it before you commit.
