import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  testGoldens('CoreButton Large - Narrow View - With Pressed State', (tester) async {
    final builder = GoldenBuilder.grid(columns: 2, widthToHeightRatio: 2);
    builder
      ..addScenario('Primary', CoreButton(
        label: 'Primary',
        onPressed: () {},
        variant: CoreButtonVariant.primary,
        size: CoreButtonSize.large,
      ))
      ..addScenario('Primary + Icon', CoreButton(
        label: 'Primary',
        onPressed: () {},
        variant: CoreButtonVariant.primary,
        size: CoreButtonSize.large,
        icon: const CoreIconWidget(icon: CoreIcons.arrowLeft, color: CoreTextColors.inverse),
      ))
      ..addScenario('Primary Disabled + Icon', CoreButton(
        label: 'Primary',
        onPressed: () {},
        isDisabled: true,
        variant: CoreButtonVariant.primary,
        size: CoreButtonSize.large,
        icon: const CoreIconWidget(icon: CoreIcons.arrowLeft, color: CoreTextColors.body),
      ))
      ..addScenario('Primary Focused', CoreButton(
        label: 'Primary',
        onPressed: () {},
        variant: CoreButtonVariant.primary,
        size: CoreButtonSize.large,
        autofocus: true,
        icon: const CoreIconWidget(icon: CoreIcons.arrowLeft, color: CoreTextColors.inverse),
      ))
      ..addScenario('Primary Pressed', CoreButton(
        key: const Key('pressed_primary'),
        label: 'Primary',
        onPressed: () {},
        variant: CoreButtonVariant.primary,
        size: CoreButtonSize.large,
        icon: const CoreIconWidget(icon: CoreIcons.arrowLeft, color: CoreTextColors.inverse),
      ))
      ..addScenario('Secondary', CoreButton(
        label: 'Secondary',
        onPressed: () {},
        variant: CoreButtonVariant.secondary,
        size: CoreButtonSize.large,
      ))
      ..addScenario('Secondary + Icon', CoreButton(
        label: 'Secondary',
        onPressed: () {},
        variant: CoreButtonVariant.secondary,
        size: CoreButtonSize.large,
        icon: const CoreIconWidget(icon: CoreIcons.arrowLeft,color: CoreButtonColors.surface),
      ))
      ..addScenario('Secondary Disabled + Icon', CoreButton(
        label: 'Secondary',
        onPressed: () {},
        isDisabled: true,
        variant: CoreButtonVariant.secondary,
        size: CoreButtonSize.large,
        icon: const CoreIconWidget(icon: CoreIcons.arrowLeft,color: CoreTextColors.disable),
      ))
      ..addScenario('Secondary Focused', CoreButton(
        label: 'Secondary',
        onPressed: () {},
        variant: CoreButtonVariant.secondary,
        size: CoreButtonSize.large,
        autofocus: true,
        icon: const CoreIconWidget(icon: CoreIcons.arrowLeft,color: CoreButtonColors.hover),
      ))
      ..addScenario('Secondary Pressed', CoreButton(
        key: const Key('pressed_secondary'),
        label: 'Secondary',
        onPressed: () {},
        variant: CoreButtonVariant.secondary,
        size: CoreButtonSize.large,
        icon: const CoreIconWidget(icon: CoreIcons.arrowLeft,color: CoreButtonColors.press,),
      ))
      ..addScenario('Social', CoreButton(
        label: 'Continue with Google',
        onPressed: () {},
        variant: CoreButtonVariant.social,
        size: CoreButtonSize.large,
      ))
      ..addScenario('Social + Icon', CoreButton(
        label: 'Continue with Google',
        onPressed: () {},
        variant: CoreButtonVariant.social,
        size: CoreButtonSize.large,
        icon: const CoreIconWidget(icon: CoreIcons.google),
      ))
      ..addScenario('Social Disabled + Icon', CoreButton(
        label: 'Continue with Google',
        onPressed: () {},
        isDisabled: true,
        variant: CoreButtonVariant.social,
        size: CoreButtonSize.large,
        icon: const CoreIconWidget(icon: CoreIcons.google),
      ))
      ..addScenario('Social Focused', CoreButton(
        label: 'Continue with Google',
        onPressed: () {},
        variant: CoreButtonVariant.social,
        size: CoreButtonSize.large,
        autofocus: true,
        icon: const CoreIconWidget(icon: CoreIcons.google),
      ))
      ..addScenario('Social Pressed', CoreButton(
        key: const Key('pressed_social'),
        label: 'Continue with Google',
        onPressed: () {},
        variant: CoreButtonVariant.social,
        size: CoreButtonSize.large,
        icon: const CoreIconWidget(icon: CoreIcons.google),
      ));

    await tester.pumpWidgetBuilder(
      Container(
        color: CoreBackgroundColors.pageBackground,
        child: builder.build(),
      ),
      surfaceSize: const Size(550, 1400),
    );

    final primaryFinder = find.byKey(const Key('pressed_primary'));
    final primaryGesture = await tester.startGesture(tester.getCenter(primaryFinder));

    final secondaryFinder = find.byKey(const Key('pressed_secondary'));
    final secondaryGesture = await tester.startGesture(tester.getCenter(secondaryFinder));

    final socialFinder = find.byKey(const Key('pressed_social'));
    final socialGesture = await tester.startGesture(tester.getCenter(socialFinder));

    await tester.pumpAndSettle();

    await screenMatchesGolden(tester, 'core_button_large');

    await primaryGesture.up();
    await secondaryGesture.up();
    await socialGesture.up();
  });
}
