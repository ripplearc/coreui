import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';
import '../../utils/test_harness.dart';

void main() {
  Future<void> pumpField(
    WidgetTester tester,
    CoreUnderlineTextField field, {
    ThemeData? theme,
  }) async {
    await tester.pumpWidget(
      buildTestApp(
        SizedBox(width: 372, child: field),
        theme: theme ?? CoreTheme.light(),
      ),
    );
    await tester.pumpAndSettle();
  }

  const compact = CoreUnderlineTextFieldSize.compact;
  final underline = find.byKey(CoreUnderlineTextField.underlineKey);
  final fieldFinder = find.byType(CoreUnderlineTextField);

  group('CoreUnderlineTextField – compact', () {
    testWidgets('is 52px tall, 2px shorter than regular', (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(label: 'Note', size: compact),
      );

      expect(tester.getSize(fieldFinder).height, 52);
    });

    testWidgets('the underline sits 8px under the value row', (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(
          label: 'Waste',
          initialValue: '10',
          size: compact,
        ),
      );

      final valueBottom = tester.getBottomLeft(find.byType(EditableText)).dy;
      final underlineTop = tester.getTopLeft(underline).dy;

      expect(underlineTop - valueBottom, 8);
    });

    testWidgets('the regular underline stays 10px under the value row',
        (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(label: 'Waste', initialValue: '10'),
      );

      final valueBottom = tester.getBottomLeft(find.byType(EditableText)).dy;

      expect(tester.getTopLeft(underline).dy - valueBottom, 10);
    });

    testWidgets('keeps the regular label, value, weight and colors',
        (tester) async {
      for (final theme in kA11yTestThemes) {
        await pumpField(
          tester,
          const CoreUnderlineTextField(
            label: 'Note',
            initialValue: 'Add a note',
            size: compact,
          ),
          theme: theme,
        );
        final label = tester.widget<Text>(find.text('Note')).style as TextStyle;
        final value =
            tester.widget<TextField>(find.byType(TextField)).style as TextStyle;

        expect(label.fontSize, 12);
        expect(label.height, 16 / 12);
        expect(value.fontSize, 16);
        expect(value.height, 24 / 16);
        expect(tester.getSize(underline).height, 1);
        expect(
          tester.widget<Container>(underline).color,
          theme.coreColors.lineDarkOutline,
        );
        expect(
            tester.getTopLeft(find.text('Note')).dx -
                tester.getTopLeft(fieldFinder).dx,
            2);
      }
    });

    testWidgets('turns outlineHover on focus and statusError on error',
        (tester) async {
      final colors = CoreTheme.light().coreColors;

      await pumpField(
        tester,
        const CoreUnderlineTextField(label: 'Delivery', size: compact),
      );
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      expect(tester.widget<Container>(underline).color, colors.outlineHover);

      await pumpField(
        tester,
        const CoreUnderlineTextField(
          label: 'Delivery',
          size: compact,
          errorText: 'An error',
        ),
      );
      expect(tester.widget<Container>(underline).color, colors.statusError);
    });

    testWidgets('a label badge keeps the field 52px tall', (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(
          label: 'Rate',
          size: compact,
          labelTrailing: SizedBox(width: 89, height: 20),
        ),
      );

      expect(tester.getSize(fieldFinder).height, 52);
    });

    testWidgets('a helper or error line adds the same 24px', (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(
          label: 'Note',
          size: compact,
          helperText: 'A hint',
        ),
      );

      expect(tester.getSize(fieldFinder).height, 52 + 24);
    });

    testWidgets('takes prefix, unit and suffix like regular', (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(
          label: 'Delivery',
          size: compact,
          prefixText: r'$',
          initialValue: '85',
          unitText: '/day',
          suffixText: '%',
        ),
      );

      expect(find.text(r'$'), findsOneWidget);
      expect(find.text('%'), findsOneWidget);
      expect(find.text('/day'), findsOneWidget);
      expect(tester.getSize(fieldFinder).height, 52);
    });

    testWidgets('meets the accessibility guidelines in both themes',
        (tester) async {
      await setupA11yTest(tester);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => const CoreUnderlineTextField(
          label: 'Note',
          initialValue: 'Add a note',
          size: compact,
        ),
        fieldFinder,
      );
    });
  });
}
