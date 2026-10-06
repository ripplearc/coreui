import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

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

  const badgeKey = Key('badge');
  const chipKey = Key('chip');
  const lookupKey = Key('lookup');

  Widget badge() => const SizedBox(key: badgeKey, width: 89, height: 20);
  Widget chip() => const SizedBox(key: chipKey, width: 63, height: 32);
  Widget lookup({VoidCallback? onPressed}) => GestureDetector(
        key: lookupKey,
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: const SizedBox(width: 36, height: 36),
      );

  Rect rectOf(WidgetTester tester, Finder finder) => tester.getRect(finder);

  TextStyle styleOf(WidgetTester tester, String text) =>
      tester.widget<Text>(find.text(text)).style as TextStyle;

  final fieldFinder = find.byType(CoreUnderlineTextField);
  final input = find.byType(TextField);

  group('CoreUnderlineTextField – prefixText', () {
    testWidgets('shows while the field is empty, before the value',
        (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(label: 'Delivery', prefixText: r'$'),
      );

      expect(find.text(r'$'), findsOneWidget);
      expect(
        rectOf(tester, find.text(r'$')).right,
        lessThan(rectOf(tester, input).left + 1),
      );
    });

    testWidgets('is not part of the typed text and cannot be deleted',
        (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await pumpField(
        tester,
        CoreUnderlineTextField(
          label: 'Delivery',
          prefixText: r'$',
          controller: controller,
        ),
      );
      await tester.enterText(input, '85');
      expect(controller.text, '85');

      await tester.enterText(input, '');
      expect(controller.text, '');
      expect(find.text(r'$'), findsOneWidget);
    });

    testWidgets('sits 2px before the value in the soft value style',
        (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(
          label: 'Delivery',
          prefixText: r'$',
          initialValue: '85',
        ),
      );
      final colors = CoreTheme.light().coreColors;

      expect(
        rectOf(tester, input).left - rectOf(tester, find.text(r'$')).right,
        2,
      );
      expect(styleOf(tester, r'$').color, colors.textBody);
      expect(styleOf(tester, r'$').fontSize, 16);
    });

    testWidgets('uses the large value size on the large field', (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(
          size: CoreUnderlineTextFieldSize.large,
          label: 'Amount',
          prefixText: r'$',
          initialValue: '450',
        ),
      );

      expect(styleOf(tester, r'$').fontSize, 24);
    });
  });

  group('CoreUnderlineTextField – suffixText and unitText', () {
    testWidgets('suffixText follows the value in the soft value style',
        (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(
          label: 'Waste',
          suffixText: '%',
          initialValue: '10',
        ),
      );

      expect(
        rectOf(tester, find.text('%')).left,
        moreOrLessEquals(rectOf(tester, input).right),
      );
      expect(styleOf(tester, '%').fontSize, 16);
      expect(styleOf(tester, '%').color, CoreTheme.light().coreColors.textBody);
    });

    testWidgets('unitText sits 5px after the value at 12/16 on regular',
        (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(
          label: 'Duration',
          unitText: 'days',
          initialValue: '4',
        ),
      );

      expect(
        rectOf(tester, find.text('days')).left - rectOf(tester, input).right,
        moreOrLessEquals(5),
      );
      expect(styleOf(tester, 'days').fontSize, 12);
      expect(styleOf(tester, 'days').height, 16 / 12);
      expect(
        styleOf(tester, 'days').color,
        CoreTheme.light().coreColors.textBody,
      );
    });

    testWidgets('unitText sits 8px after the value at 16/24 on large',
        (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(
          size: CoreUnderlineTextFieldSize.large,
          label: 'How many days?',
          unitText: 'days',
          initialValue: '3',
        ),
      );

      expect(
        rectOf(tester, find.text('days')).left - rectOf(tester, input).right,
        moreOrLessEquals(8),
      );
      expect(styleOf(tester, 'days').fontSize, 16);
      expect(styleOf(tester, 'days').height, 24 / 16);
    });

    testWidgets('the value hugs its text when something follows it',
        (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(
          label: 'Duration',
          unitText: 'days',
          initialValue: '4',
        ),
      );

      expect(rectOf(tester, input).width, lessThan(40));
    });

    testWidgets('the value fills the row when nothing follows it',
        (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(
          label: 'Equipment',
          prefixText: r'$',
          initialValue: '4',
        ),
      );

      expect(
          rectOf(tester, input).right, rectOf(tester, fieldFinder).right - 2);
    });

    testWidgets('a long value shrinks to the row instead of overflowing',
        (tester) async {
      await pumpField(
        tester,
        CoreUnderlineTextField(
          label: 'Material',
          unitText: 'gal',
          initialValue: 'Interior paint ' * 12,
        ),
      );

      expect(tester.takeException(), isNull);
      expect(
        rectOf(tester, find.text('gal')).right,
        lessThanOrEqualTo(rectOf(tester, fieldFinder).right - 2),
      );
    });
  });

  group('CoreUnderlineTextField – baseline', () {
    double baselineOf(WidgetTester tester, Finder finder, double fontSize) {
      const ahemAscent = 0.8;
      final rect = tester.getRect(finder);
      return rect.top + (rect.height - fontSize) / 2 + ahemAscent * fontSize;
    }

    for (final size in CoreUnderlineTextFieldSize.values) {
      testWidgets(
          'prefix, value, suffix and unit share one baseline (${size.name})',
          (tester) async {
        await pumpField(
          tester,
          CoreUnderlineTextField(
            size: size,
            label: 'Rate',
            prefixText: r'$',
            suffixText: '%',
            unitText: '/day',
            initialValue: '145',
          ),
        );
        final isLarge = size == CoreUnderlineTextFieldSize.large;
        final valueSize = isLarge ? 24.0 : 16.0;
        final unitSize = isLarge ? 16.0 : 12.0;
        final value = baselineOf(tester, find.byType(EditableText), valueSize);

        expect(
          baselineOf(tester, find.text(r'$'), valueSize),
          moreOrLessEquals(value, epsilon: 0.5),
        );
        expect(
          baselineOf(tester, find.text('%'), valueSize),
          moreOrLessEquals(value, epsilon: 0.5),
        );
        expect(
          baselineOf(tester, find.text('/day'), unitSize),
          moreOrLessEquals(value, epsilon: 0.5),
        );
      });
    }

    testWidgets('the smaller unit sits lower than a centered one would',
        (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(
          label: 'Duration',
          initialValue: '4',
          unitText: 'days',
        ),
      );
      final centered = tester.getRect(find.byType(EditableText)).center.dy;

      expect(
          tester.getRect(find.text('days')).center.dy, greaterThan(centered));
    });

    testWidgets('an accessory stays centered against the value row',
        (tester) async {
      await pumpField(
        tester,
        CoreUnderlineTextField(
          label: 'Quantity',
          initialValue: '3',
          unitText: 'gal',
          inlineAccessory: chip(),
        ),
      );

      expect(
        tester.getRect(find.byKey(chipKey)).center.dy,
        moreOrLessEquals(
          tester.getRect(find.byType(CoreUnderlineTextField)).top + 12 + 3 + 16,
          epsilon: 20,
        ),
      );
      expect(
        tester.getRect(find.byType(EditableText)).center.dy,
        moreOrLessEquals(tester.getRect(find.byKey(chipKey)).center.dy,
            epsilon: 1.5),
      );
    });
  });

  group('CoreUnderlineTextField – labelTrailing', () {
    testWidgets('sits 5px after the label in a 20px label row', (tester) async {
      await pumpField(
        tester,
        CoreUnderlineTextField(label: 'Rate', labelTrailing: badge()),
      );

      expect(
        rectOf(tester, find.byKey(badgeKey)).left -
            rectOf(tester, find.text('Rate')).right,
        5,
      );
      expect(rectOf(tester, find.byKey(badgeKey)).height, 20);
    });

    testWidgets('keeps the field as tall as it is without it', (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(label: 'Rate'),
      );
      final without = tester.getSize(fieldFinder).height;
      final underlineWithout =
          tester.getTopLeft(find.byKey(CoreUnderlineTextField.underlineKey)).dy;

      await pumpField(
        tester,
        CoreUnderlineTextField(label: 'Rate', labelTrailing: badge()),
      );

      expect(tester.getSize(fieldFinder).height, without);
      expect(
        tester.getTopLeft(find.byKey(CoreUnderlineTextField.underlineKey)).dy,
        underlineWithout,
      );
    });

    testWidgets('keeps the large field 66px tall', (tester) async {
      await pumpField(
        tester,
        CoreUnderlineTextField(
          size: CoreUnderlineTextFieldSize.large,
          label: 'Amount',
          labelTrailing: badge(),
        ),
      );

      expect(tester.getSize(fieldFinder).height, 66);
    });

    testWidgets('draws the trailing widget when there is no label',
        (tester) async {
      await pumpField(
        tester,
        CoreUnderlineTextField(labelTrailing: badge()),
      );

      expect(find.byKey(badgeKey), findsOneWidget);
    });
  });

  group('CoreUnderlineTextField – inlineAccessory and trailing', () {
    testWidgets('inlineAccessory sits 12px after the value', (tester) async {
      await pumpField(
        tester,
        CoreUnderlineTextField(
          label: 'Quantity',
          initialValue: '3',
          inlineAccessory: chip(),
        ),
      );

      expect(
        rectOf(tester, find.byKey(chipKey)).left - rectOf(tester, input).right,
        moreOrLessEquals(12),
      );
    });

    testWidgets('inlineAccessory sits 12px after the unit', (tester) async {
      await pumpField(
        tester,
        CoreUnderlineTextField(
          label: 'Quantity',
          initialValue: '3',
          unitText: 'gal',
          inlineAccessory: chip(),
        ),
      );

      expect(
        rectOf(tester, find.byKey(chipKey)).left -
            rectOf(tester, find.text('gal')).right,
        12,
      );
    });

    testWidgets('a 32px accessory makes a 62px field and centers the value',
        (tester) async {
      await pumpField(
        tester,
        CoreUnderlineTextField(
          label: 'Quantity',
          initialValue: '3',
          inlineAccessory: chip(),
        ),
      );

      expect(tester.getSize(fieldFinder).height, 62);
      expect(
        rectOf(tester, find.byType(EditableText)).center.dy,
        moreOrLessEquals(rectOf(tester, find.byKey(chipKey)).center.dy),
      );
    });

    testWidgets('trailing sits at the far end and makes a 66px field',
        (tester) async {
      await pumpField(
        tester,
        CoreUnderlineTextField(
          label: 'Rate',
          hintText: 'Set your rate',
          trailing: lookup(),
        ),
      );

      expect(
        rectOf(tester, find.byKey(lookupKey)).right,
        rectOf(tester, fieldFinder).right - 2,
      );
      expect(tester.getSize(fieldFinder).height, 66);
      expect(
        rectOf(tester, find.byType(EditableText)).center.dy,
        moreOrLessEquals(rectOf(tester, find.byKey(lookupKey)).center.dy),
      );
    });

    testWidgets('a tap on the trailing widget reaches it and not the field',
        (tester) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      var taps = 0;

      await pumpField(
        tester,
        CoreUnderlineTextField(
          label: 'Rate',
          focusNode: focusNode,
          trailing: lookup(onPressed: () => taps++),
        ),
      );
      await tester.tap(find.byKey(lookupKey));
      await tester.pump();

      expect(taps, 1);
      expect(focusNode.hasFocus, isFalse);
    });

    testWidgets('the value keeps its room beside a trailing widget',
        (tester) async {
      await pumpField(
        tester,
        CoreUnderlineTextField(
          label: 'Rate',
          hintText: 'Set your rate',
          trailing: lookup(),
        ),
      );

      expect(
        rectOf(tester, input).right,
        lessThanOrEqualTo(rectOf(tester, find.byKey(lookupKey)).left),
      );
    });
  });
}
