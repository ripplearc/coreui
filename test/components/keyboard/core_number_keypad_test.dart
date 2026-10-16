import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

void main() {
  setUpAll(() async {
    await loadFonts();
  });

  late List<String> pressed;

  Future<void> pumpKeypad(
    WidgetTester tester, {
    bool isConfirmEnabled = true,
    double width = 412,
  }) async {
    pressed = [];
    tester.view.physicalSize = Size(width, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());
    addTearDown(() => tester.view.resetDevicePixelRatio());

    await tester.pumpWidget(
      MaterialApp(
        theme: CoreTheme.light(),
        home: Scaffold(
          body: Align(
            alignment: Alignment.bottomCenter,
            child: CoreNumberKeypad(
              onDigitPressed: (digit) => pressed.add('$digit'),
              onDecimalPressed: () => pressed.add('decimal'),
              onBackspacePressed: () => pressed.add('backspace'),
              onClearPressed: () => pressed.add('clear'),
              onConfirmPressed: () => pressed.add('confirm'),
              clearLabel: 'Clear',
              confirmLabel: 'Add to estimate',
              isConfirmEnabled: isConfirmEnabled,
            ),
          ),
        ),
      ),
    );
  }

  group('CoreNumberKeypad', () {
    for (var digit = 0; digit <= 9; digit++) {
      testWidgets('the $digit key reports $digit', (tester) async {
        await pumpKeypad(tester);

        await tester.tap(find.text('$digit'));
        await tester.pumpAndSettle();

        expect(pressed, ['$digit']);
      });
    }

    testWidgets('the decimal key reports the decimal point', (tester) async {
      await pumpKeypad(tester);

      await tester.tap(find.byKey(DigitType.decimal.testKey));
      await tester.pumpAndSettle();

      expect(pressed, ['decimal']);
    });

    testWidgets('the backspace key reports backspace', (tester) async {
      await pumpKeypad(tester);

      await tester.tap(find.byKey(ControlAction.delete.testKey));
      await tester.pumpAndSettle();

      expect(pressed, ['backspace']);
    });

    testWidgets('the outlined button shows its label and reports clear',
        (tester) async {
      await pumpKeypad(tester);

      await tester.tap(find.text('Clear'));
      await tester.pumpAndSettle();

      expect(pressed, ['clear']);
    });

    testWidgets('the filled button shows its label and reports confirm',
        (tester) async {
      await pumpKeypad(tester);

      await tester.tap(find.text('Add to estimate'));
      await tester.pumpAndSettle();

      expect(pressed, ['confirm']);
    });

    testWidgets('a disabled confirm button ignores taps and reads disabled',
        (tester) async {
      await pumpKeypad(tester, isConfirmEnabled: false);

      await tester.tap(find.byKey(CoreNumberKeypad.confirmButtonKey));
      await tester.pumpAndSettle();

      expect(pressed, isEmpty);
      final data = tester
          .getSemantics(find.byKey(CoreNumberKeypad.confirmButtonKey))
          .getSemanticsData();
      expect(data.flagsCollection.isEnabled, ui.Tristate.isFalse);
      expect(data.hasAction(SemanticsAction.tap), isFalse);
    });

    testWidgets('a disabled confirm button leaves the other keys working',
        (tester) async {
      await pumpKeypad(tester, isConfirmEnabled: false);

      await tester.tap(find.text('5'));
      await tester.tap(find.text('Clear'));
      await tester.pumpAndSettle();

      expect(pressed, ['5', 'clear']);
    });

    testWidgets('the keys sit 7 8 9, 4 5 6, 1 2 3, then . 0 backspace',
        (tester) async {
      await pumpKeypad(tester);

      Offset centre(Key key) => tester.getCenter(find.byKey(key));
      final rows = [
        [DigitType.seven, DigitType.eight, DigitType.nine],
        [DigitType.four, DigitType.five, DigitType.six],
        [DigitType.one, DigitType.two, DigitType.three],
      ].map((row) => row.map((digit) => digit.testKey).toList()).toList()
        ..add([
          DigitType.decimal.testKey,
          DigitType.zero.testKey,
          ControlAction.delete.testKey,
        ]);

      for (var r = 0; r < rows.length; r++) {
        for (var c = 0; c < 3; c++) {
          final key = centre(rows[r][c]);
          expect(key.dy, centre(rows[r][0]).dy, reason: 'row $r col $c');
          expect(key.dx, centre(rows[0][c]).dx, reason: 'row $r col $c');
          if (r > 0) expect(key.dy, greaterThan(centre(rows[r - 1][c]).dy));
          if (c > 0) expect(key.dx, greaterThan(centre(rows[r][c - 1]).dx));
        }
      }
    });

    testWidgets('on a 412 dp phone, keys are 124 x 68 and buttons 188 x 68',
        (tester) async {
      await pumpKeypad(tester);

      expect(tester.getSize(find.byKey(DigitType.seven.testKey)),
          const Size(124, 68));
      expect(tester.getSize(find.byKey(ControlAction.delete.testKey)),
          const Size(124, 68));
      expect(tester.getSize(find.byKey(CoreNumberKeypad.clearButtonKey)),
          const Size(188, 68));
      expect(tester.getSize(find.byKey(CoreNumberKeypad.confirmButtonKey)),
          const Size(188, 68));
      expect(tester.getSize(find.byType(CoreNumberKeypad)).height,
          CoreNumberKeypad.height);
      expect(CoreNumberKeypad.height, 368);
    });

    testWidgets('on a 320 dp phone the keys share the narrower width',
        (tester) async {
      await pumpKeypad(tester, width: 320);

      final keyWidth = (320 - 2 * 16 - 2 * 4) / 3;
      expect(tester.getSize(find.byKey(DigitType.zero.testKey)).width,
          closeTo(keyWidth, 0.001));
      expect(tester.takeException(), isNull);
    });

    testWidgets('long labels at 200 % text do not overflow', (tester) async {
      tester.view.physicalSize = const Size(320, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());
      addTearDown(() => tester.view.resetDevicePixelRatio());

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2)),
            child: Scaffold(
              body: Align(
                alignment: Alignment.bottomCenter,
                child: CoreNumberKeypad(
                  onDigitPressed: (_) {},
                  onDecimalPressed: () {},
                  onBackspacePressed: () {},
                  onClearPressed: () {},
                  onConfirmPressed: () {},
                  clearLabel: r'Back to $1,250.00',
                  confirmLabel: 'Add to estimate',
                ),
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });
  });
}
