import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../await_images_extension.dart';
import '../../load_fonts.dart';

ThemeData _createThemeWithFonts() {
  final baseTheme = CoreTheme.light();
  final typography = baseTheme.extension<TypographyExtension>()!;

  final testTypography = TypographyExtension(
    headlineLargeRegular:
        typography.headlineLargeRegular.copyWith(fontFamily: 'Roboto'),
    headlineLargeSemiBold:
        typography.headlineLargeSemiBold.copyWith(fontFamily: 'Roboto'),
    headlineMediumRegular:
        typography.headlineMediumRegular.copyWith(fontFamily: 'Roboto'),
    headlineMediumSemiBold:
        typography.headlineMediumSemiBold.copyWith(fontFamily: 'Roboto'),
    titleLargeRegular:
        typography.titleLargeRegular.copyWith(fontFamily: 'Roboto'),
    titleLargeMedium:
        typography.titleLargeMedium.copyWith(fontFamily: 'Roboto'),
    titleLargeSemiBold:
        typography.titleLargeSemiBold.copyWith(fontFamily: 'Roboto'),
    titleMediumRegular:
        typography.titleMediumRegular.copyWith(fontFamily: 'Roboto'),
    titleMediumMedium:
        typography.titleMediumMedium.copyWith(fontFamily: 'Roboto'),
    titleMediumSemiBold:
        typography.titleMediumSemiBold.copyWith(fontFamily: 'Roboto'),
    bodyLargeRegular:
        typography.bodyLargeRegular.copyWith(fontFamily: 'Roboto'),
    bodyLargeMedium: typography.bodyLargeMedium.copyWith(fontFamily: 'Roboto'),
    bodyLargeSemiBold:
        typography.bodyLargeSemiBold.copyWith(fontFamily: 'Roboto'),
    bodyMediumRegular:
        typography.bodyMediumRegular.copyWith(fontFamily: 'Roboto'),
    bodyMediumMedium:
        typography.bodyMediumMedium.copyWith(fontFamily: 'Roboto'),
    bodyMediumSemiBold:
        typography.bodyMediumSemiBold.copyWith(fontFamily: 'Roboto'),
    bodySmallRegular:
        typography.bodySmallRegular.copyWith(fontFamily: 'Roboto'),
    bodySmallMedium: typography.bodySmallMedium.copyWith(fontFamily: 'Roboto'),
    bodySmallSemiBold:
        typography.bodySmallSemiBold.copyWith(fontFamily: 'Roboto'),
  );

  return ThemeData(
    fontFamily: 'Roboto',
    materialTapTargetSize: baseTheme.materialTapTargetSize,
    primaryColor: baseTheme.primaryColor,
    colorScheme: baseTheme.colorScheme,
    useMaterial3: baseTheme.useMaterial3,
    extensions: [
      baseTheme.extension<AppColorsExtension>()!,
      testTypography,
    ],
  );
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await loadFonts();
  });

  testWidgets('Keyboard Buttons Grid View Golden Test', (tester) async {
    final buttons = <Widget>[
      CoreDigitInput(
        digit: DigitType.zero,
        onDigitPressed: (_) {},
        height: 60,
        width: 60,
      ),
      CoreDigitInput(
          digit: DigitType.one,
          onDigitPressed: (_) {},
          height: 60,
          width: 60,
          size: 60),
      CoreDigitInput(
        digit: DigitType.two,
        onDigitPressed: (_) {},
        height: 60,
        width: 60,
      ),
      CoreDigitInput(
        digit: DigitType.three,
        onDigitPressed: (_) {},
        height: 60,
        width: 60,
      ),
      CoreDigitInput(
        digit: DigitType.four,
        onDigitPressed: (_) {},
        height: 60,
        width: 60,
      ),
      CoreDigitInput(
        digit: DigitType.five,
        onDigitPressed: (_) {},
        height: 60,
        width: 60,
      ),
      CoreDigitInput(
        digit: DigitType.six,
        onDigitPressed: (_) {},
        height: 60,
        width: 60,
      ),
      CoreDigitInput(
        digit: DigitType.seven,
        onDigitPressed: (_) {},
        height: 60,
        width: 60,
      ),
      CoreDigitInput(
        digit: DigitType.eight,
        onDigitPressed: (_) {},
        height: 60,
        width: 60,
      ),
      CoreDigitInput(
        digit: DigitType.nine,
        onDigitPressed: (_) {},
        height: 60,
        width: 60,
      ),
      CoreDigitInput(
        digit: DigitType.decimal,
        onDigitPressed: (_) {},
        height: 60,
        width: 60,
      ),
      CoreDigitInput(
        digit: DigitType.zero,
        onDigitPressed: (_) {},
        isEmphasized: true,
        height: 60,
        width: 60,
      ),
      CoreOperatorButton(
        operatorType: OperatorType.add,
        onOperatorPressed: (_) {},
        height: 60,
        width: 60,
      ),
      CoreOperatorButton(
        operatorType: OperatorType.subtract,
        onOperatorPressed: (_) {},
        height: 60,
        width: 60,
      ),
      CoreOperatorButton(
        operatorType: OperatorType.multiply,
        onOperatorPressed: (_) {},
        height: 60,
        width: 60,
      ),
      CoreOperatorButton(
        operatorType: OperatorType.divide,
        onOperatorPressed: (_) {},
        height: 60,
        width: 60,
      ),
      CoreOperatorButton(
        operatorType: OperatorType.percent,
        onOperatorPressed: (_) {},
        height: 60,
        width: 60,
      ),
      CoreUnitButton(
        unit: UnitType.feet,
        onUnitSelected: (_) {},
        height: 60,
        width: 80,
      ),
      CoreUnitButton(
        unit: UnitType.yards,
        onUnitSelected: (_) {},
        height: 60,
        width: 80,
      ),
      CoreUnitButton(
        unit: UnitType.inch,
        onUnitSelected: (_) {},
        height: 60,
        width: 80,
      ),
      CoreUnitButton(
        unit: UnitType.meter,
        onUnitSelected: (_) {},
        height: 60,
        width: 80,
      ),
      CoreUnitButton(
        unit: UnitType.centimeter,
        onUnitSelected: (_) {},
        height: 60,
        width: 80,
      ),
      CoreUnitButton(
        unit: UnitType.millimeter,
        onUnitSelected: (_) {},
        height: 60,
        width: 80,
      ),
      CoreUnitButton(
        unit: UnitType.divideSymbol,
        onUnitSelected: (_) {},
        height: 60,
        width: 60,
      ),
      CoreControlButton(
        action: ControlAction.delete,
        onControlAction: (_) {},
        height: 60,
        width: 60,
      ),
      CoreControlButton(
        action: ControlAction.clearAll,
        onControlAction: (_) {},
        height: 60,
        width: 60,
      ),
      CoreControlButton(
        action: ControlAction.moreOptions,
        onControlAction: (_) {},
        height: 60,
        width: 60,
      ),
      CoreResultButton(
        resultType: const ResultType(label: '='),
        onTap: () {},
        height: 60,
        width: 60,
      ),
      CoreResultButton(
        resultType: const ResultType(label: 'Area'),
        onTap: () {},
        height: 60,
        width: 80,
      ),
      CoreResultButton(
        resultType: const ResultType(label: 'Volume'),
        onTap: () {},
        height: 60,
        width: 80,
      ),
    ];

    final widget = MaterialApp(
      theme: _createThemeWithFonts(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: CoreTheme.light().scaffoldBackgroundColor,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Keyboard Buttons Grid View',
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 6,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.0,
                children: buttons,
              ),
            ],
          ),
        ),
      ),
    );

    await tester.binding.setSurfaceSize(const Size(800, 1200));
    await tester.pumpWidget(widget);

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    await tester.awaitImages();

    await tester.pump(const Duration(milliseconds: 100));

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/keyboard_buttons_grid_view.png'),
    );
  });
}
