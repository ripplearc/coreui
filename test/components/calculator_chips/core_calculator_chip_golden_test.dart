import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

ThemeData _createTestTheme() {
  return CoreTheme.light().copyWith(
    textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto'),
  );
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await loadFonts();
  });

  testWidgets('CoreCalculatorChip Component Visual Regression Test',
      (WidgetTester tester) async {
    final colors = AppColorsExtension.create();
    final typography = AppTypographyExtension.create();
    debugDisableShadows = false;
    addTearDown(() => debugDisableShadows = true);
    await tester.binding.setSurfaceSize(const Size(1200, 400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    Widget buildColumnExample(String title, CoreCalculatorChip chip) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title, style: typography.bodyMediumRegular),
            const SizedBox(height: CoreSpacing.space4),
            chip,
          ],
        );

    final widget = MaterialApp(
      theme: _createTestTheme(),
      home: Scaffold(
        backgroundColor: colors.pageBackground,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: CoreSpacing.space8,
              vertical: CoreSpacing.space8,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildColumnExample(
                  'Editable',
                  CoreCalculatorChip(
                    type: CoreCalculatorChipType.editable,
                    label: 'Length',
                    value: '22ft',
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: CoreSpacing.space8),
                buildColumnExample(
                  'Editable w/ Factor',
                  CoreCalculatorChip(
                    type: CoreCalculatorChipType.editable,
                    value: '4in',
                    factor: CoreIcons.addOperator,
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: CoreSpacing.space8),
                buildColumnExample(
                  'Disabled',
                  CoreCalculatorChip(
                    type: CoreCalculatorChipType.disabled,
                    label: 'Area',
                    value: '410.67ft²',
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: CoreSpacing.space8),
                buildColumnExample(
                  'Active',
                  CoreCalculatorChip(
                    type: CoreCalculatorChipType.active,
                    label: 'Area',
                    value: '410.67ft²',
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: CoreSpacing.space8),
                buildColumnExample(
                  'Active w/ Factor',
                  CoreCalculatorChip(
                    type: CoreCalculatorChipType.active,
                    value: '4in',
                    factor: CoreIcons.addOperator,
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: CoreSpacing.space8),
                buildColumnExample(
                  'Active w/ Factor',
                  CoreCalculatorChip(
                    type: CoreCalculatorChipType.active,
                    factor: CoreIcons.addOperator,
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_calculator_chip_component.png'),
    );

    debugDisableShadows = true;
  });
}
