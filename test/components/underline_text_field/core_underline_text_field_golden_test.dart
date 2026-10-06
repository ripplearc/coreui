import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

ThemeData _withRoboto(ThemeData base) {
  return base.copyWith(
    textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto'),
  );
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await loadFonts();
  });

  final themes = [
    ('light', _withRoboto(CoreTheme.light())),
    ('dark', _withRoboto(CoreTheme.dark())),
  ];

  Future<void> pumpScenarios(
    WidgetTester tester,
    ThemeData theme,
    Size logicalSize,
    List<(String, Widget)> scenarios,
  ) async {
    tester.view.physicalSize = logicalSize * 2;
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final typography = theme.coreTypography;
    final colors = theme.coreColors;

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: Scaffold(
          backgroundColor: colors.pageBackground,
          body: Padding(
            padding: const EdgeInsets.all(CoreSpacing.space4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final (caption, field) in scenarios) ...[
                  Text(
                    caption,
                    style: typography.bodySmallSemiBold.copyWith(
                      color: colors.textBody,
                    ),
                  ),
                  const SizedBox(height: CoreSpacing.space2),
                  SizedBox(width: 372, child: field),
                  const SizedBox(height: CoreSpacing.space5),
                ],
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  for (final (name, theme) in themes) {
    testWidgets('CoreUnderlineTextField at rest - $name', (tester) async {
      await pumpScenarios(tester, theme, const Size(404, 540), [
        (
          'Regular, empty with placeholder',
          const CoreUnderlineTextField(
            label: 'Equipment',
            hintText: 'Name the equipment',
          ),
        ),
        (
          'Regular, filled',
          const CoreUnderlineTextField(
            label: 'Equipment',
            initialValue: 'Mini excavator - 1.5 ton',
          ),
        ),
        (
          'Large, empty with placeholder',
          const CoreUnderlineTextField(
            size: CoreUnderlineTextFieldSize.large,
            label: 'How many days?',
            hintText: '0',
          ),
        ),
        (
          'Large, filled',
          const CoreUnderlineTextField(
            size: CoreUnderlineTextFieldSize.large,
            label: 'How many days?',
            initialValue: '3',
          ),
        ),
      ]);

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/core_underline_text_field_rest_$name.png'),
      );
    });

    testWidgets('CoreUnderlineTextField with affixes and slots - $name',
        (tester) async {
      Widget badge(BuildContext context) {
        final colors = Theme.of(context).coreColors;
        final typography = Theme.of(context).coreTypography;
        return Container(
          height: 20,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colors.backgroundOrangeLight,
            border: Border.all(color: colors.textWarning),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            'Sample rate',
            style: typography.bodySmallSemiBold.copyWith(
              color: colors.textWarning,
            ),
          ),
        );
      }

      Widget unitChip(BuildContext context) {
        final colors = Theme.of(context).coreColors;
        final typography = Theme.of(context).coreTypography;
        return Container(
          height: 32,
          padding: const EdgeInsets.fromLTRB(12, 6, 8, 6),
          decoration: BoxDecoration(
            color: colors.pageBackground,
            border: Border.all(color: colors.lineMid),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'gal',
                style: typography.bodySmallRegular.copyWith(
                  color: colors.textHeadline,
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.expand_more, size: 20, color: colors.iconGrayMid),
            ],
          ),
        );
      }

      Widget lookup(BuildContext context) {
        final colors = Theme.of(context).coreColors;
        return Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: colors.pageBackground,
            border: Border.all(color: colors.lineMid),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(Icons.search, size: 20, color: colors.iconGrayMid),
        );
      }

      await pumpScenarios(tester, theme, const Size(404, 980), [
        (
          'Prefix, empty',
          const CoreUnderlineTextField(label: 'Delivery', prefixText: r'$'),
        ),
        (
          'Prefix, filled',
          const CoreUnderlineTextField(
            label: 'Delivery',
            prefixText: r'$',
            initialValue: '85',
          ),
        ),
        (
          'Suffix',
          const CoreUnderlineTextField(
            label: 'Waste',
            suffixText: '%',
            initialValue: '10',
          ),
        ),
        (
          'Unit',
          const CoreUnderlineTextField(
            label: 'Duration',
            initialValue: '4',
            unitText: 'days',
          ),
        ),
        (
          'Prefix, unit and a label badge',
          Builder(
            builder: (context) => CoreUnderlineTextField(
              label: 'Rate',
              prefixText: r'$',
              initialValue: '145.00',
              unitText: '/day',
              labelTrailing: badge(context),
            ),
          ),
        ),
        (
          'Inline accessory',
          Builder(
            builder: (context) => CoreUnderlineTextField(
              label: 'Quantity',
              initialValue: '3',
              inlineAccessory: unitChip(context),
            ),
          ),
        ),
        (
          'Trailing lookup, empty with placeholder',
          Builder(
            builder: (context) => CoreUnderlineTextField(
              label: 'Rate',
              hintText: 'Set your rate',
              trailing: lookup(context),
            ),
          ),
        ),
        (
          'Large, prefix and unit',
          const CoreUnderlineTextField(
            size: CoreUnderlineTextFieldSize.large,
            label: 'Amount',
            prefixText: r'$',
            initialValue: '450.00',
            unitText: 'job',
          ),
        ),
        (
          'Large, unit',
          const CoreUnderlineTextField(
            size: CoreUnderlineTextFieldSize.large,
            label: 'How many sheets?',
            initialValue: '25',
            unitText: 'sheets',
          ),
        ),
      ]);

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile(
          'goldens/core_underline_text_field_affixes_$name.png',
        ),
      );
    });

    testWidgets('CoreUnderlineTextField helper and error lines - $name',
        (tester) async {
      await pumpScenarios(tester, theme, const Size(404, 940), [
        (
          'Helper line',
          const CoreUnderlineTextField(
            label: 'Rate',
            hintText: 'Set your rate',
            helperText:
                'Never priced this? Use the search icon above to look it up '
                'in the cost file.',
          ),
        ),
        (
          'Error, filled',
          const CoreUnderlineTextField(
            label: 'Quantity',
            initialValue: '0',
            errorText: 'Quantity must be more than zero.',
          ),
        ),
        (
          'Error, empty with placeholder',
          const CoreUnderlineTextField(
            label: 'Quantity',
            hintText: 'Set the quantity',
            errorText: 'Quantity must be more than zero.',
          ),
        ),
        (
          'Error with a unit',
          const CoreUnderlineTextField(
            label: 'Duration',
            initialValue: '0',
            unitText: 'days',
            errorText: 'Duration must be more than zero.',
          ),
        ),
        (
          'Helper line with a label badge',
          Builder(
            builder: (context) {
              final colors = Theme.of(context).coreColors;
              return CoreUnderlineTextField(
                label: 'Rate',
                initialValue: '52.00',
                prefixText: r'$',
                labelTrailing: Container(
                  height: 20,
                  width: 89,
                  decoration: BoxDecoration(
                    color: colors.backgroundOrangeLight,
                    border: Border.all(color: colors.textWarning),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                helperText: 'Saved to Your rates.',
              );
            },
          ),
        ),
        (
          'Helper line, large',
          const CoreUnderlineTextField(
            size: CoreUnderlineTextFieldSize.large,
            label: 'Amount',
            prefixText: r'$',
            initialValue: '400.00',
            helperText: 'Used on this line only.',
          ),
        ),
        (
          'Error, large',
          const CoreUnderlineTextField(
            size: CoreUnderlineTextFieldSize.large,
            label: 'Amount',
            prefixText: r'$',
            initialValue: '0',
            errorText: 'Needs an amount above zero.',
          ),
        ),
      ]);

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile(
            'goldens/core_underline_text_field_messages_$name.png'),
      );
    });

    final focusedCases = <(String, String, Widget Function(FocusNode))>[
      (
        'regular_empty',
        'Regular, focused, empty with placeholder',
        (focusNode) => CoreUnderlineTextField(
              focusNode: focusNode,
              label: 'Equipment',
              hintText: 'Name the equipment',
            ),
      ),
      (
        'regular_filled',
        'Regular, focused, filled',
        (focusNode) => CoreUnderlineTextField(
              focusNode: focusNode,
              label: 'Equipment',
              initialValue: 'Mini excavator - 1.5 ton',
            ),
      ),
      (
        'regular_error',
        'Regular, focused, error',
        (focusNode) => CoreUnderlineTextField(
              focusNode: focusNode,
              label: 'Quantity',
              initialValue: '0',
              errorText: 'Quantity must be more than zero.',
            ),
      ),
      (
        'large_filled',
        'Large, focused, filled',
        (focusNode) => CoreUnderlineTextField(
              focusNode: focusNode,
              size: CoreUnderlineTextFieldSize.large,
              label: 'How many days?',
              initialValue: '3',
            ),
      ),
    ];

    for (final (id, caption, build) in focusedCases) {
      testWidgets('CoreUnderlineTextField $id focused - $name', (tester) async {
        final focusNode = FocusNode();
        addTearDown(focusNode.dispose);

        await pumpScenarios(tester, theme, const Size(404, 164), [
          (caption, build(focusNode)),
        ]);
        focusNode.requestFocus();
        await tester.pump();
        await tester.pump();

        await expectLater(
          find.byType(Scaffold),
          matchesGoldenFile(
            'goldens/core_underline_text_field_focused_${id}_$name.png',
          ),
        );
      });
    }
  }
}
