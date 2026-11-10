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

  Widget captioned(String title, TextStyle style, CoreCalculatorChip chip) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: style),
        const SizedBox(height: CoreSpacing.space2),
        chip,
      ],
    );
  }

  Future<void> pumpVariants(WidgetTester tester, ThemeData theme) async {
    final colors = theme.coreColors;
    final caption =
        theme.coreTypography.bodySmallRegular.copyWith(color: colors.textBody);

    debugDisableShadows = false;
    addTearDown(() => debugDisableShadows = true);

    // physicalSize is in physical pixels; logical size = physicalSize / DPR.
    // 1040x604 @ 2.0 => 520x302 logical: four rows of captioned chips (four,
    // four, three, four) with space4 padding and no dead space below the last
    // row.
    tester.view.physicalSize = const Size(1040, 604);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: Scaffold(
          backgroundColor: colors.pageBackground,
          body: Padding(
            padding: const EdgeInsets.all(CoreSpacing.space4),
            child: Wrap(
              spacing: CoreSpacing.space6,
              runSpacing: CoreSpacing.space4,
              children: [
                captioned(
                  'Editable',
                  caption,
                  CoreCalculatorChip(
                    type: CoreCalculatorChipType.editable,
                    label: 'Length',
                    value: '22ft',
                    onTap: () {},
                  ),
                ),
                captioned(
                  'Editable + factor',
                  caption,
                  CoreCalculatorChip(
                    type: CoreCalculatorChipType.editable,
                    value: '4in',
                    factor: CoreIcons.addOperator,
                    onTap: () {},
                  ),
                ),
                captioned(
                  'Active',
                  caption,
                  CoreCalculatorChip(
                    type: CoreCalculatorChipType.active,
                    label: 'Width',
                    value: '10ft',
                    onTap: () {},
                  ),
                ),
                captioned(
                  'Disabled',
                  caption,
                  const CoreCalculatorChip(
                    type: CoreCalculatorChipType.disabled,
                    label: 'Area',
                    value: '410.67ft²',
                  ),
                ),
                captioned(
                  'Result',
                  caption,
                  CoreCalculatorChip(
                    type: CoreCalculatorChipType.result,
                    label: 'Area',
                    value: '410.67ft²',
                    onLongPress: () {},
                  ),
                ),
                captioned(
                  'Result + factor',
                  caption,
                  CoreCalculatorChip(
                    type: CoreCalculatorChipType.result,
                    value: '4in',
                    factor: CoreIcons.addOperator,
                    onLongPress: () {},
                  ),
                ),
                captioned(
                  'Dashed',
                  caption,
                  CoreCalculatorChip(
                    type: CoreCalculatorChipType.dashed,
                    label: 'Height',
                    value: '8ft ?',
                    onTap: () {},
                  ),
                ),
                captioned(
                  'Dashed + factor',
                  caption,
                  CoreCalculatorChip(
                    type: CoreCalculatorChipType.dashed,
                    value: '8ft ?',
                    factor: CoreIcons.addOperator,
                    onTap: () {},
                  ),
                ),
                captioned(
                  'Error',
                  caption,
                  const CoreCalculatorChip(
                    type: CoreCalculatorChipType.error,
                    value: 'Dimension error',
                  ),
                ),
                captioned(
                  'Error + factor',
                  caption,
                  const CoreCalculatorChip(
                    type: CoreCalculatorChipType.error,
                    value: 'Dimension error',
                    factor: CoreIcons.addOperator,
                  ),
                ),
                captioned(
                  'Bracket open',
                  caption,
                  const CoreCalculatorChip(
                    type: CoreCalculatorChipType.bracketOpen,
                    value: '3×4',
                    factor: CoreIcons.addOperator,
                  ),
                ),
                captioned(
                  'Bracket closed',
                  caption,
                  CoreCalculatorChip(
                    type: CoreCalculatorChipType.bracketClosed,
                    value: '3×4',
                    factor: CoreIcons.addOperator,
                    onTap: () {},
                  ),
                ),
                captioned(
                  'Stale',
                  caption,
                  const CoreCalculatorChip(
                    type: CoreCalculatorChipType.stale,
                    label: 'Calc',
                    semanticsLabel: 'Calc, pending',
                  ),
                ),
                captioned(
                  'Inert',
                  caption,
                  const CoreCalculatorChip(
                    type: CoreCalculatorChipType.editable,
                    value: '5',
                    factor: CoreIcons.multiplyOperator,
                    inert: true,
                  ),
                ),
                captioned(
                  'Stale + inert',
                  caption,
                  const CoreCalculatorChip(
                    type: CoreCalculatorChipType.stale,
                    label: 'Calc',
                    semanticsLabel: 'Calc, pending',
                    inert: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
  }

  testWidgets('CoreCalculatorChip Visual Regression - Light',
      (WidgetTester tester) async {
    await pumpVariants(tester, _withRoboto(CoreTheme.light()));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_calculator_chip_light.png'),
    );
    debugDisableShadows = true;
  });

  testWidgets('CoreCalculatorChip Visual Regression - Dark',
      (WidgetTester tester) async {
    await pumpVariants(tester, _withRoboto(CoreTheme.dark()));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_calculator_chip_dark.png'),
    );
    debugDisableShadows = true;
  });

  Future<void> pumpLongNames(WidgetTester tester, ThemeData theme) async {
    final colors = theme.coreColors;

    debugDisableShadows = false;
    addTearDown(() => debugDisableShadows = true);

    // physicalSize is in physical pixels; logical size = physicalSize / DPR.
    // 448x220 @ 2.0 => 224x110 logical: a 192-wide tape row holding a chip
    // whose name ends in an ellipsis over a value-only chip that shortens its
    // value, with space4 padding and no dead space.
    tester.view.physicalSize = const Size(448, 220);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: _withRoboto(theme),
        home: Scaffold(
          backgroundColor: colors.pageBackground,
          body: const Padding(
            padding: EdgeInsets.all(CoreSpacing.space4),
            child: SizedBox(
              width: CoreSpacing.space48,
              child: Wrap(
                spacing: CoreSpacing.space2,
                runSpacing: CoreSpacing.space2,
                children: [
                  CoreCalculatorChip(
                    type: CoreCalculatorChipType.editable,
                    label: 'Pitch-rise per 12in run',
                    value: '6in/12in',
                  ),
                  CoreCalculatorChip(
                    type: CoreCalculatorChipType.error,
                    value: 'Area and length cannot be added together',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 100));
  }

  testWidgets('CoreCalculatorChip long names Golden Test - Light',
      (WidgetTester tester) async {
    await pumpLongNames(tester, CoreTheme.light());

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_calculator_chip_long_names_light.png'),
    );
    debugDisableShadows = true;
  });

  testWidgets('CoreCalculatorChip long names Golden Test - Dark',
      (WidgetTester tester) async {
    await pumpLongNames(tester, CoreTheme.dark());

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_calculator_chip_long_names_dark.png'),
    );
    debugDisableShadows = true;
  });
}
