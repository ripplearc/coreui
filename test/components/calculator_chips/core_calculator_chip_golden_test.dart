import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  // The eight types that take input, each held down, beside a disabled and an
  // inert chip that are held down too and do not change.
  Future<List<TestGesture>> pumpPressed(
    WidgetTester tester,
    ThemeData theme,
  ) async {
    final colors = theme.coreColors;
    final caption =
        theme.coreTypography.bodySmallRegular.copyWith(color: colors.textBody);

    debugDisableShadows = false;
    addTearDown(() => debugDisableShadows = true);

    // 1040x452 @ 2.0 => 520x226 logical: three rows of captioned chips (four,
    // three, three) with space4 padding.
    tester.view.physicalSize = const Size(1040, 452);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final chips = <String, CoreCalculatorChip>{
      'Editable': CoreCalculatorChip(
        type: CoreCalculatorChipType.editable,
        label: 'Length',
        value: '22ft',
        onTap: () {},
      ),
      'Active': CoreCalculatorChip(
        type: CoreCalculatorChipType.active,
        label: 'Width',
        value: '10ft',
        onTap: () {},
      ),
      'Result': CoreCalculatorChip(
        type: CoreCalculatorChipType.result,
        label: 'Area',
        value: '410.67ft²',
        onLongPress: () {},
      ),
      'Error': CoreCalculatorChip(
        type: CoreCalculatorChipType.error,
        value: 'Dimension error',
        onTap: () {},
      ),
      'Dashed': CoreCalculatorChip(
        type: CoreCalculatorChipType.dashed,
        label: 'Height',
        value: '8ft ?',
        onTap: () {},
      ),
      'Bracket open': CoreCalculatorChip(
        type: CoreCalculatorChipType.bracketOpen,
        value: '3×4',
        factor: CoreIcons.addOperator,
        onTap: () {},
      ),
      'Bracket closed': CoreCalculatorChip(
        type: CoreCalculatorChipType.bracketClosed,
        value: '3×4',
        factor: CoreIcons.addOperator,
        onTap: () {},
      ),
      'Stale': CoreCalculatorChip(
        type: CoreCalculatorChipType.stale,
        label: 'Calc',
        semanticsLabel: 'Calc, pending',
        onTap: () {},
      ),
      'Disabled': CoreCalculatorChip(
        type: CoreCalculatorChipType.disabled,
        label: 'Area',
        value: '410.67ft²',
        onTap: () {},
      ),
      'Inert': CoreCalculatorChip(
        type: CoreCalculatorChipType.editable,
        value: '5',
        factor: CoreIcons.multiplyOperator,
        inert: true,
        onTap: () {},
      ),
    };

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
                for (final MapEntry(key: title, value: chip) in chips.entries)
                  captioned('$title, pressed', caption, chip),
              ],
            ),
          ),
        ),
      ),
    );

    final gestures = <TestGesture>[
      for (final chip in find.byType(CoreCalculatorChip).evaluate())
        await tester.startGesture(
          tester.getCenter(find.byWidget(chip.widget)),
        ),
    ];
    await tester.pumpAndSettle();
    return gestures;
  }

  testWidgets('CoreCalculatorChip Pressed - Light',
      (WidgetTester tester) async {
    final gestures = await pumpPressed(tester, _withRoboto(CoreTheme.light()));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_calculator_chip_pressed_light.png'),
    );
    for (final gesture in gestures) {
      await gesture.up();
    }
    debugDisableShadows = true;
  });

  testWidgets('CoreCalculatorChip Pressed - Dark',
      (WidgetTester tester) async {
    final gestures = await pumpPressed(tester, _withRoboto(CoreTheme.dark()));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_calculator_chip_pressed_dark.png'),
    );
    for (final gesture in gestures) {
      await gesture.up();
    }
    debugDisableShadows = true;
  });

  // One chip, focused with Tab, on a small canvas.
  Future<void> pumpFocused(
    WidgetTester tester,
    ThemeData theme,
    CoreCalculatorChip chip,
  ) async {
    // 320x120 @ 2.0 => 160x60 logical: one chip with space4 padding.
    tester.view.physicalSize = const Size(320, 120);
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
          backgroundColor: theme.coreColors.pageBackground,
          body: Padding(
            padding: const EdgeInsets.all(CoreSpacing.space4),
            child: Align(alignment: Alignment.topLeft, child: chip),
          ),
        ),
      ),
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
  }

  final focusedChips = <String, CoreCalculatorChip>{
    'editable': CoreCalculatorChip(
      type: CoreCalculatorChipType.editable,
      label: 'Length',
      value: '22ft',
      onTap: () {},
    ),
    'active': CoreCalculatorChip(
      type: CoreCalculatorChipType.active,
      label: 'Width',
      value: '10ft',
      onTap: () {},
    ),
    'dashed': CoreCalculatorChip(
      type: CoreCalculatorChipType.dashed,
      label: 'Height',
      value: '8ft ?',
      onTap: () {},
    ),
  };

  for (final MapEntry(key: name, value: chip) in focusedChips.entries) {
    for (final (themeName, theme) in [
      ('light', CoreTheme.light()),
      ('dark', CoreTheme.dark()),
    ]) {
      testWidgets('CoreCalculatorChip $name Focused - $themeName',
          (WidgetTester tester) async {
        await pumpFocused(tester, _withRoboto(theme), chip);

        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile(
            'goldens/core_calculator_chip_${name}_focused_$themeName.png',
          ),
        );
      });
    }
  }
}
