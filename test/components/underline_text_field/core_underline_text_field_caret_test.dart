import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/test_harness.dart';

void main() {
  Future<void> pumpField(
    WidgetTester tester,
    CoreUnderlineTextField field,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        SizedBox(width: 372, child: field),
        theme: CoreTheme.light(),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> focus(WidgetTester tester) async {
    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
  }

  const chipKey = Key('chip');
  final input = find.byType(TextField);

  double gapAfterInput(WidgetTester tester, Finder next) =>
      tester.getRect(next).left - tester.getRect(input).right;

  TextField inner(WidgetTester tester) => tester.widget<TextField>(input);

  group('CoreUnderlineTextField – caret room', () {
    testWidgets('an unfocused field draws no caret and reserves no room',
        (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(
          label: 'Duration',
          initialValue: '4',
          unitText: 'days',
        ),
      );

      expect(inner(tester).cursorWidth, 0);
      expect(gapAfterInput(tester, find.text('days')), 5);
    });

    testWidgets('focus draws the 2px caret and moves the unit 2px right',
        (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(
          label: 'Duration',
          initialValue: '4',
          unitText: 'days',
        ),
      );
      await focus(tester);

      expect(inner(tester).cursorWidth, 2);
      expect(gapAfterInput(tester, find.text('days')), 5 + 2);
    });

    testWidgets('the large unit moves by the same 2px', (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(
          size: CoreUnderlineTextFieldSize.large,
          label: 'How many days?',
          initialValue: '3',
          unitText: 'days',
        ),
      );
      expect(gapAfterInput(tester, find.text('days')), 8);

      await focus(tester);
      expect(gapAfterInput(tester, find.text('days')), 8 + 2);
    });

    testWidgets('a suffix touches the value at rest and clears the caret',
        (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(
          label: 'Burden',
          initialValue: '25',
          suffixText: '%',
        ),
      );
      expect(gapAfterInput(tester, find.text('%')), 0);

      await focus(tester);
      expect(gapAfterInput(tester, find.text('%')), 2);
    });

    testWidgets('an accessory right after the value follows the caret',
        (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(
          label: 'Quantity',
          initialValue: '3',
          inlineAccessory: SizedBox(key: chipKey, width: 63, height: 32),
        ),
      );
      expect(gapAfterInput(tester, find.byKey(chipKey)), 12);

      await focus(tester);
      expect(gapAfterInput(tester, find.byKey(chipKey)), 12 + 2);
    });

    testWidgets('an accessory after a unit keeps its 12px from the unit',
        (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(
          label: 'Quantity',
          initialValue: '3',
          unitText: 'gal',
          inlineAccessory: SizedBox(key: chipKey, width: 63, height: 32),
        ),
      );
      double gapAfterUnit() =>
          tester.getRect(find.byKey(chipKey)).left -
          tester.getRect(find.text('gal')).right;
      expect(gapAfterUnit(), 12);

      await focus(tester);
      expect(gapAfterUnit(), 12);
    });

    testWidgets('showCursor false draws no caret and reserves no room',
        (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(
          label: 'Waste',
          initialValue: '10',
          suffixText: '%',
          showCursor: false,
        ),
      );
      await focus(tester);

      expect(inner(tester).showCursor, isFalse);
      expect(inner(tester).cursorWidth, 0);
      expect(gapAfterInput(tester, find.text('%')), 0);
    });

    testWidgets('showCursor true brings the caret to a read-only field',
        (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(
          label: 'Rate',
          initialValue: '150',
          readOnly: true,
          showCursor: true,
          unitText: '/day',
        ),
      );
      await focus(tester);

      expect(inner(tester).cursorWidth, 2);
    });

    testWidgets('a read-only field draws no caret by default', (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(
          label: 'Rate',
          initialValue: '150',
          readOnly: true,
          unitText: '/day',
        ),
      );
      await focus(tester);

      expect(inner(tester).cursorWidth, 0);
      expect(gapAfterInput(tester, find.text('/day')), 5);
    });

    testWidgets('losing focus gives the room back', (tester) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);

      await pumpField(
        tester,
        CoreUnderlineTextField(
          label: 'Duration',
          initialValue: '4',
          unitText: 'days',
          focusNode: focusNode,
        ),
      );
      focusNode.requestFocus();
      await tester.pumpAndSettle();
      expect(gapAfterInput(tester, find.text('days')), 7);

      focusNode.unfocus();
      await tester.pumpAndSettle();
      expect(gapAfterInput(tester, find.text('days')), 5);
    });
  });
}
