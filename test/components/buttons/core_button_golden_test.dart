import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  testGoldens('CoreButton Golden Test', (WidgetTester tester) async {
    await loadAppFonts(); // Required for consistent text rendering

    final builder = GoldenBuilder.column()
      ..addScenario(
        'Primary',
        CoreButton(
          label: 'Primary Button',
          onPressed: () {},
        ),
      )
      ..addScenario(
        'Secondary',
        CoreButton(
          label: 'Secondary Button',
          onPressed: () {},
          variant: CoreButtonVariant.secondary,
        ),
      )
      ..addScenario(
        'Social',
        CoreButton(
          label: 'Social Button',
          onPressed: () {},
          variant: CoreButtonVariant.social,
          icon: CoreIconWidget(icon: CoreIcons.google),
        ),
      )
         ..addScenario(
        'Social Spaced Out',
        CoreButton(
          label: 'Social Button',
          onPressed: () {},
          variant: CoreButtonVariant.social,
          icon: CoreIconWidget(icon: CoreIcons.google),
          spaceOut: true,
        ),
      )
      ..addScenario(
        'Disabled',
        CoreButton(
          label: 'Disabled Button',
          isDisabled: true,
          onPressed: () {},
        ),
      )
      ..addScenario(
        'Small Size',
        CoreButton(
          label: 'Small',
          onPressed: () {},
          size: CoreButtonSize.small,
        ),
      )
      ..addScenario(
        'Medium Size',
        CoreButton(
          label: 'Medium',
          onPressed: () {},
          size: CoreButtonSize.medium,
        ),
      )
      ..addScenario(
        'With Trailing Icon',
        CoreButton(
          label: 'Trailing',
          onPressed: () {},
          icon: CoreIconWidget(icon: CoreIcons.arrowRight,color: CoreTextColors.inverse,),
          trailing: true,
        ),
      )
      ..addScenario(
        'With Leading Icon',
        CoreButton(
          label: 'Leading',
          onPressed: () {},
          icon: CoreIconWidget(icon: CoreIcons.arrowLeft,color: CoreTextColors.inverse,),
        ),
      );

    await tester.pumpWidgetBuilder(
      Container(
        color: CoreBackgroundColors.pageBackground,
        child: builder.build(),
      ),
      surfaceSize: const Size(400, 1200),
    );

    await screenMatchesGolden(tester, 'core_button');
  });
}
