import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  testGoldens('CoreButton Medium - Narrow View - With Pressed State', (tester) async {
    final builder = GoldenBuilder.grid(columns: 2, widthToHeightRatio: 2);
    builder
      ..addScenario('Primary', CoreButton(
        label: 'Primary',
        onPressed: () {},
        variant: CoreButtonVariant.primary,
        size: CoreButtonSize.medium,
      ))
      ..addScenario('Primary + Icon', CoreButton(
        label: 'Primary',
        onPressed: () {},
        variant: CoreButtonVariant.primary,
        size: CoreButtonSize.medium,
        icon: const CoreIconWidget(icon: CoreIcons.arrowLeft, color: CoreTextColors.inverse),
      ))
      ..addScenario('Primary Disabled + Icon', CoreButton(
        label: 'Primary',
        onPressed: () {},
        isDisabled: true,
        variant: CoreButtonVariant.primary,
        size: CoreButtonSize.medium,
        icon: const CoreIconWidget(icon: CoreIcons.arrowLeft, color: CoreTextColors.body),
      ))
      ..addScenario('Primary Focused', CoreButton(
        label: 'Primary',
        onPressed: () {},
        variant: CoreButtonVariant.primary,
        size: CoreButtonSize.medium,
        autofocus: true,
        icon: const CoreIconWidget(icon: CoreIcons.arrowLeft, color: CoreTextColors.inverse),
      ))
      ..addScenario('Primary Pressed', CoreButton(
        key: const Key('pressed_primary'),
        label: 'Primary',
        onPressed: () {},
        variant: CoreButtonVariant.primary,
        size: CoreButtonSize.medium,
        icon: const CoreIconWidget(icon: CoreIcons.arrowLeft, color: CoreTextColors.inverse),
      ))
      ..addScenario('Secondary', CoreButton(
        label: 'Secondary',
        onPressed: () {},
        variant: CoreButtonVariant.secondary,
        size: CoreButtonSize.medium,
      ))
      ..addScenario('Secondary + Icon', CoreButton(
        label: 'Secondary',
        onPressed: () {},
        variant: CoreButtonVariant.secondary,
        size: CoreButtonSize.medium,
        icon: const CoreIconWidget(icon: CoreIcons.arrowLeft,color: CoreButtonColors.surface,),
      ))
      ..addScenario('Secondary Disabled + Icon', CoreButton(
        label: 'Secondary',
        onPressed: () {},
        isDisabled: true,
        variant: CoreButtonVariant.secondary,
        size: CoreButtonSize.medium,
        icon: const CoreIconWidget(icon: CoreIcons.arrowLeft,color: CoreTextColors.disable),
      ))
      ..addScenario('Secondary Focused', CoreButton(
        label: 'Secondary',
        onPressed: () {},
        variant: CoreButtonVariant.secondary,
        size: CoreButtonSize.medium,
        autofocus: true,
        icon: const CoreIconWidget(icon: CoreIcons.arrowLeft,color: CoreButtonColors.hover),
      ))
      ..addScenario('Secondary Pressed', CoreButton(
        key: const Key('pressed_secondary'),
        label: 'Secondary',
        onPressed: () {},
        variant: CoreButtonVariant.secondary,
        size: CoreButtonSize.medium,
        icon: const CoreIconWidget(icon: CoreIcons.arrowLeft,color: CoreButtonColors.press,),
      ));

    await tester.pumpWidgetBuilder(
      Container(
        color: CoreBackgroundColors.pageBackground,
        child: builder.build(),
      ),
      surfaceSize: const Size(500, 900),
    );

    final primaryFinder = find.byKey(const Key('pressed_primary'));
    final primaryGesture = await tester.startGesture(tester.getCenter(primaryFinder));
    await tester.pumpAndSettle();

    final secondaryFinder = find.byKey(const Key('pressed_secondary'));
    final secondaryGesture = await tester.startGesture(tester.getCenter(secondaryFinder));
    await tester.pumpAndSettle();

    await screenMatchesGolden(tester, 'core_button_medium');

    await primaryGesture.up();
    await secondaryGesture.up();
  });
}
