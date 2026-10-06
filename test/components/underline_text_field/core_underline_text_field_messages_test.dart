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

  final underline = find.byKey(CoreUnderlineTextField.underlineKey);
  final fieldFinder = find.byType(CoreUnderlineTextField);

  Color? underlineColor(WidgetTester tester) =>
      tester.widget<Container>(underline).color;

  Finder icon(CoreIconData data) => find.byWidgetPredicate(
        (widget) => widget is CoreIconWidget && widget.icon == data,
      );

  group('CoreUnderlineTextField – helperText', () {
    testWidgets('shows an info icon and the text 8px under the underline',
        (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(
          label: 'Rate',
          helperText: 'Never priced this?',
        ),
      );

      expect(icon(CoreIcons.info), findsOneWidget);
      expect(
        tester.getTopLeft(find.text('Never priced this?')).dy,
        tester.getBottomLeft(underline).dy + 8,
      );
    });

    testWidgets('draws the icon 16px at a 2px inset, then 8px before the text',
        (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(
          label: 'Rate',
          helperText: 'Never priced this?',
        ),
      );
      final field = tester.getTopLeft(fieldFinder).dx;
      final iconRect = tester.getRect(icon(CoreIcons.info));

      expect(iconRect.left - field, 2);
      expect(iconRect.width, 16);
      expect(
        tester.getTopLeft(find.text('Never priced this?')).dx - iconRect.right,
        8,
      );
    });

    testWidgets('is 12/16 textBody with a grayMid icon in both themes',
        (tester) async {
      for (final theme in kA11yTestThemes) {
        await pumpField(
          tester,
          const CoreUnderlineTextField(label: 'Rate', helperText: 'A hint'),
          theme: theme,
        );
        final text =
            tester.widget<Text>(find.text('A hint')).style as TextStyle;
        final iconColor =
            tester.widget<CoreIconWidget>(icon(CoreIcons.info)).color;

        expect(text.fontSize, 12);
        expect(text.height, 16 / 12);
        expect(text.color, theme.coreColors.textBody);
        expect(iconColor, theme.coreColors.iconGrayMid);
      }
    });

    testWidgets('adds one 24px row and nothing else to the field',
        (tester) async {
      await pumpField(tester, const CoreUnderlineTextField(label: 'Rate'));
      final without = tester.getSize(fieldFinder).height;

      await pumpField(
        tester,
        const CoreUnderlineTextField(label: 'Rate', helperText: 'A hint'),
      );

      expect(tester.getSize(fieldFinder).height, without + 24);
      expect(
          underlineColor(tester), CoreTheme.light().coreColors.lineDarkOutline);
    });

    testWidgets('wraps a long hint inside the field width', (tester) async {
      await pumpField(
        tester,
        CoreUnderlineTextField(label: 'Rate', helperText: 'A hint ' * 30),
      );

      expect(tester.takeException(), isNull);
      expect(tester.getSize(fieldFinder).width, 372);
    });

    testWidgets('is not announced as a live region', (tester) async {
      final handle = tester.ensureSemantics();
      try {
        await pumpField(
          tester,
          const CoreUnderlineTextField(label: 'Rate', helperText: 'A hint'),
        );

        final data =
            tester.getSemantics(find.text('A hint')).getSemanticsData();
        expect(data.flagsCollection.isLiveRegion, isFalse);
      } finally {
        handle.dispose();
      }
    });
  });

  group('CoreUnderlineTextField – errorText', () {
    for (final theme in kA11yTestThemes) {
      final name = theme.brightness.name;

      testWidgets('turns the label, underline and line to error ($name)',
          (tester) async {
        final colors = theme.coreColors;

        await pumpField(
          tester,
          const CoreUnderlineTextField(
            label: 'Quantity',
            initialValue: '0',
            errorText: 'Quantity must be more than zero.',
          ),
          theme: theme,
        );

        expect(
            (tester.widget<Text>(find.text('Quantity')).style as TextStyle)
                .color,
            colors.textError);
        expect(underlineColor(tester), colors.statusError);
        expect(
          (tester
                  .widget<Text>(find.text('Quantity must be more than zero.'))
                  .style as TextStyle)
              .color,
          colors.textError,
        );
        expect(
          tester.widget<CoreIconWidget>(icon(CoreIcons.error)).color,
          colors.iconRed,
        );
      });

      testWidgets('keeps the 2px underline on large ($name)', (tester) async {
        await pumpField(
          tester,
          const CoreUnderlineTextField(
            size: CoreUnderlineTextFieldSize.large,
            label: 'Amount',
            errorText: 'Needs an amount.',
          ),
          theme: theme,
        );

        expect(underlineColor(tester), theme.coreColors.statusError);
        expect(tester.getSize(underline).height, 2);
      });
    }

    testWidgets('an empty errorText is no error and leaves the helper',
        (tester) async {
      final colors = CoreTheme.light().coreColors;

      await pumpField(
        tester,
        const CoreUnderlineTextField(
          label: 'Quantity',
          helperText: 'A hint',
          errorText: '',
        ),
      );

      expect(find.text('A hint'), findsOneWidget);
      expect(icon(CoreIcons.error), findsNothing);
      expect(underlineColor(tester), colors.lineDarkOutline);
      expect(
          (tester.widget<Text>(find.text('Quantity')).style as TextStyle).color,
          colors.textBody);
    });

    testWidgets('an empty errorText with no helper adds no row',
        (tester) async {
      await pumpField(tester, const CoreUnderlineTextField(label: 'Quantity'));
      final without = tester.getSize(fieldFinder).height;

      await pumpField(
        tester,
        const CoreUnderlineTextField(label: 'Quantity', errorText: ''),
      );

      expect(tester.getSize(fieldFinder).height, without);
    });

    testWidgets('keeps the same 8px gap on the large field', (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(
          size: CoreUnderlineTextFieldSize.large,
          label: 'Amount',
          errorText: 'Needs an amount.',
        ),
      );

      expect(
        tester.getTopLeft(find.text('Needs an amount.')).dy,
        tester.getBottomLeft(underline).dy + 8,
      );
      expect(tester.getSize(fieldFinder).height, 66 + 24);
    });

    testWidgets('replaces the helper text', (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(
          label: 'Quantity',
          helperText: 'A hint',
          errorText: 'An error',
        ),
      );

      expect(find.text('An error'), findsOneWidget);
      expect(find.text('A hint'), findsNothing);
      expect(icon(CoreIcons.info), findsNothing);
      expect(icon(CoreIcons.error), findsOneWidget);
    });

    testWidgets('stays the error color while the field has focus',
        (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(label: 'Quantity', errorText: 'An error'),
      );
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      expect(underlineColor(tester), CoreTheme.light().coreColors.statusError);
    });

    testWidgets('pushes what is below down by one 24px line', (tester) async {
      await pumpField(tester, const CoreUnderlineTextField(label: 'Quantity'));
      final without = tester.getSize(fieldFinder).height;

      await pumpField(
        tester,
        const CoreUnderlineTextField(label: 'Quantity', errorText: 'An error'),
      );

      expect(tester.getSize(fieldFinder).height, without + 24);
    });

    testWidgets('goes away as soon as errorText is cleared', (tester) async {
      final colors = CoreTheme.light().coreColors;

      await pumpField(
        tester,
        const CoreUnderlineTextField(label: 'Quantity', errorText: 'An error'),
      );
      await pumpField(tester, const CoreUnderlineTextField(label: 'Quantity'));

      expect(find.text('An error'), findsNothing);
      expect(underlineColor(tester), colors.lineDarkOutline);
      expect(
          (tester.widget<Text>(find.text('Quantity')).style as TextStyle).color,
          colors.textBody);
    });

    testWidgets('an empty field with an error is still drawn red',
        (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(
          label: 'Quantity',
          hintText: 'Set the quantity',
          errorText: 'An error',
        ),
      );

      expect(underlineColor(tester), CoreTheme.light().coreColors.statusError);
    });

    testWidgets('is announced as a live region when it appears',
        (tester) async {
      final handle = tester.ensureSemantics();
      try {
        await pumpField(
          tester,
          const CoreUnderlineTextField(
              label: 'Quantity', errorText: 'An error'),
        );

        final data =
            tester.getSemantics(find.text('An error')).getSemanticsData();
        expect(data.flagsCollection.isLiveRegion, isTrue);
        expect(data.label, 'An error');
      } finally {
        handle.dispose();
      }
    });

    testWidgets('meets text contrast in both themes', (tester) async {
      await setupA11yTest(tester);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => const CoreUnderlineTextField(
          label: 'Quantity',
          initialValue: '0',
          errorText: 'Quantity must be more than zero.',
        ),
        fieldFinder,
      );
    });
  });
}
