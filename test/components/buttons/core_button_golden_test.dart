import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts(); // Load custom fonts for consistent rendering
  });
  testGoldens('CoreButton Large Variants', (WidgetTester tester) async {
    final builder = GoldenBuilder.grid(columns: 3, widthToHeightRatio: 3)
      ..addScenario(
          'Primary',
          CoreButton(
            label: 'Primary',
            onPressed: () {},
          ))
      ..addScenario(
          'Primary + Leading Icon',
          CoreButton(
            label: 'Primary',
            onPressed: () {},
            icon: const CoreIconWidget(
              icon: CoreIcons.arrowLeft,
              color: CoreButtonColors.inverse,
            ),
          ))
      ..addScenario(
          'Primary + Trailing Icon',
          CoreButton(
            label: 'Primary',
            onPressed: () {},
            icon: const CoreIconWidget(
              icon: CoreIcons.arrowRight,
              color: CoreButtonColors.inverse,
            ),
            trailing: true,
          ))
      ..addScenario(
          'Secondary',
          CoreButton(
            label: 'Secondary',
            onPressed: () {},
            variant: CoreButtonVariant.secondary,
          ))
      ..addScenario(
          'Secondary + Leading Icon',
          CoreButton(
            label: 'Secondary',
            onPressed: () {},
            variant: CoreButtonVariant.secondary,
            icon: const CoreIconWidget(
                icon: CoreIcons.arrowLeft, color: CoreButtonColors.surface),
          ))
      ..addScenario(
          'Secondary + Trailing Icon',
          CoreButton(
            label: 'Secondary',
            onPressed: () {},
            variant: CoreButtonVariant.secondary,
            icon: const CoreIconWidget(
              icon: CoreIcons.arrowRight,
              color: CoreButtonColors.surface,
            ),
            trailing: true,
          ))
      ..addScenario(
          'Social',
          CoreButton(
            label: 'Social',
            onPressed: () {},
            variant: CoreButtonVariant.social,
          ))
      ..addScenario(
          'Social + Leading Icon',
          CoreButton(
            label: 'Social',
            onPressed: () {},
            variant: CoreButtonVariant.social,
            icon: const CoreIconWidget(icon: CoreIcons.google),
          ))
      ..addScenario(
          'Social + Trailing Icon',
          CoreButton(
            label: 'Social',
            onPressed: () {},
            variant: CoreButtonVariant.social,
            icon: const CoreIconWidget(icon: CoreIcons.google),
            trailing: true,
          ))
      ..addScenario(
          'Social + Spaced Out Icon',
          CoreButton(
            label: 'Social',
            onPressed: () {},
            variant: CoreButtonVariant.social,
            icon: const CoreIconWidget(icon: CoreIcons.google),
            spaceOut: true,
          ));

    await tester.pumpWidgetBuilder(
      Container(
        color: CoreBackgroundColors.pageBackground,
        child: builder.build(),
      ),
      surfaceSize: const Size(950, 500),
    );

    await screenMatchesGolden(tester, 'core_button_large');
  });
  testGoldens('CoreButton Medium Variants', (WidgetTester tester) async {
    final builder = GoldenBuilder.grid(columns: 3, widthToHeightRatio: 3)
      ..addScenario(
          'Primary',
          CoreButton(
            label: 'Primary',
            onPressed: () {},
            size: CoreButtonSize.medium,
          ))
      ..addScenario(
          'Primary + Leading Icon',
          CoreButton(
            label: 'Primary',
            onPressed: () {},
            size: CoreButtonSize.medium,
            icon: const CoreIconWidget(
                icon: CoreIcons.arrowLeft, color: CoreButtonColors.inverse),
          ))
      ..addScenario(
          'Primary + Trailing Icon',
          CoreButton(
            label: 'Primary',
            onPressed: () {},
            size: CoreButtonSize.medium,
            icon: const CoreIconWidget(
                icon: CoreIcons.arrowRight, color: CoreButtonColors.inverse),
            trailing: true,
          ))
      ..addScenario(
          'Secondary',
          CoreButton(
            label: 'Secondary',
            onPressed: () {},
            size: CoreButtonSize.medium,
            variant: CoreButtonVariant.secondary,
          ))
      ..addScenario(
          'Secondary + Leading Icon',
          CoreButton(
            label: 'Secondary',
            onPressed: () {},
            size: CoreButtonSize.medium,
            variant: CoreButtonVariant.secondary,
            icon: const CoreIconWidget(
                icon: CoreIcons.arrowLeft, color: CoreButtonColors.surface),
          ))
      ..addScenario(
          'Secondary + Trailing Icon',
          CoreButton(
            label: 'Secondary',
            onPressed: () {},
            size: CoreButtonSize.medium,
            variant: CoreButtonVariant.secondary,
            icon: const CoreIconWidget(
                icon: CoreIcons.arrowRight, color: CoreButtonColors.surface),
            trailing: true,
          ));
      
      await tester.pumpWidgetBuilder(
      Container(
        color: CoreBackgroundColors.pageBackground,
        child: builder.build(),
      ),
      surfaceSize: const Size(900, 400),
    );

    await screenMatchesGolden(tester, 'core_button_medium');
  });
  testGoldens('CoreButton Small Variants', (WidgetTester tester) async {
    final builder = GoldenBuilder.grid(columns: 3, widthToHeightRatio: 3)
      ..addScenario(
          'Primary',
          CoreButton(
            label: 'Primary',
            onPressed: () {},
            size: CoreButtonSize.small,
          ))
      ..addScenario(
          'Primary + Leading Icon',
          CoreButton(
            label: 'Primary',
            onPressed: () {},
            size: CoreButtonSize.small,
            icon: const CoreIconWidget(
                icon: CoreIcons.arrowLeft, color: CoreButtonColors.inverse),
          ))
      ..addScenario(
          'Primary + Trailing Icon',
          CoreButton(
            label: 'Primary',
            onPressed: () {},
            size: CoreButtonSize.small,
            icon: const CoreIconWidget(
                icon: CoreIcons.arrowRight, color: CoreButtonColors.inverse),
            trailing: true,
          ))
      ..addScenario(
          'Secondary',
          CoreButton(
            label: 'Secondary',
            onPressed: () {},
            size: CoreButtonSize.small,
            variant: CoreButtonVariant.secondary,
          ))
      ..addScenario(
          'Secondary + Leading Icon',
          CoreButton(
            label: 'Secondary',
            onPressed: () {},
            size: CoreButtonSize.small,
            variant: CoreButtonVariant.secondary,
            icon: const CoreIconWidget(
                icon: CoreIcons.arrowLeft, color: CoreButtonColors.surface),
          ))
      ..addScenario(
          'Secondary + Trailing Icon',
          CoreButton(
            label: 'Secondary',
            onPressed: () {},
            size: CoreButtonSize.small,
            variant: CoreButtonVariant.secondary,
            icon: const CoreIconWidget(
                icon: CoreIcons.arrowRight, color: CoreButtonColors.surface),
            trailing: true,
          ));

      await tester.pumpWidgetBuilder(
        Container(
          color: CoreBackgroundColors.pageBackground,
          child: builder.build(),
        ),
        surfaceSize: const Size(900, 400),
      );

      await screenMatchesGolden(tester, 'core_button_small');
  });

  testGoldens('CoreButton Large Narrow Space', (WidgetTester tester) async {
    final builder = GoldenBuilder.grid(columns: 2, widthToHeightRatio: 2)
      ..addScenario(
          'Primary',
          CoreButton(
            label: 'Primary',
            onPressed: () {},
          ))
      ..addScenario(
          'Primary + Icon',
          CoreButton(
            label: 'Primary',
            onPressed: () {},
            icon: const CoreIconWidget(
                icon: CoreIcons.arrowLeft, color: CoreTextColors.inverse),
          ))
      ..addScenario(
          'Primary',
          CoreButton(
            label: 'Primary',
            onPressed: () {},
            isDisabled: true,
          ))
      ..addScenario(
          'Primary + Icon',
          CoreButton(
            label: 'Primary',
            onPressed: () {},
            isDisabled: true,
            icon: const CoreIconWidget(
                icon: CoreIcons.arrowLeft, color: CoreTextColors.body),
          ))
      ..addScenario(
          'Secondary',
          CoreButton(
            label: 'Secondary',
            onPressed: () {},
            variant: CoreButtonVariant.secondary,
          ))
      ..addScenario(
          'Secondary + Icon',
          CoreButton(
            label: 'Secondary',
            onPressed: () {},
            variant: CoreButtonVariant.secondary,
            icon: const CoreIconWidget(
                icon: CoreIcons.arrowLeft, color: CoreButtonColors.surface),
          ))
           ..addScenario(
          'Secondary',
          CoreButton(
            label: 'Secondary',
            onPressed: () {},
            isDisabled: true,
            variant: CoreButtonVariant.secondary,
          ))
      ..addScenario(
          'Secondary + Icon',
          CoreButton(
            label: 'Secondary',
            onPressed: () {},
            isDisabled: true,
            variant: CoreButtonVariant.secondary,
            icon: const CoreIconWidget(
                icon: CoreIcons.arrowLeft, color: CoreTextColors.body),
          ))
      ..addScenario(
          'Social',
          CoreButton(
            label: 'Social',
            onPressed: () {},
            variant: CoreButtonVariant.social,
            icon: const CoreIconWidget(
                icon: CoreIcons.google),
          ))
      ..addScenario(
          'Social + Icon',
          CoreButton(
            label: 'Social',
            onPressed: () {},
            isDisabled: true,
            variant: CoreButtonVariant.social,
            icon: const CoreIconWidget(
                icon: CoreIcons.google),
          ));

      await tester.pumpWidgetBuilder(
        Container(
          color: CoreBackgroundColors.pageBackground,
          child: builder.build(),
        ),
        surfaceSize: const Size(450, 800),
      );

      await screenMatchesGolden(tester, 'core_button_large_narrow_space');
  });

   testGoldens('CoreButton Medium Narrow Space', (WidgetTester tester) async {
    final builder = GoldenBuilder.grid(columns: 2, widthToHeightRatio: 2)
      ..addScenario(
          'Primary',
          CoreButton(
            size: CoreButtonSize.medium,
            label: 'Primary',
            onPressed: () {},
          ))
      ..addScenario(
          'Primary + Icon',
          CoreButton(
            size: CoreButtonSize.medium,
            label: 'Primary',
            onPressed: () {},
            icon: const CoreIconWidget(
                icon: CoreIcons.arrowLeft, color: CoreTextColors.inverse),
          ))
      ..addScenario(
          'Primary',
          CoreButton(
            size: CoreButtonSize.medium,
            label: 'Primary',
            onPressed: () {},
            isDisabled: true,
          ))
      ..addScenario(
          'Primary + Icon',
          CoreButton(
            size: CoreButtonSize.medium,
            label: 'Primary',
            onPressed: () {},
            isDisabled: true,
            icon: const CoreIconWidget(
                icon: CoreIcons.arrowLeft, color: CoreTextColors.body),
          ))
      ..addScenario(
          'Secondary',
          CoreButton(
            size: CoreButtonSize.medium,
            label: 'Secondary',
            onPressed: () {},
            variant: CoreButtonVariant.secondary,
          ))
      ..addScenario(
          'Secondary + Icon',
          CoreButton(
            size: CoreButtonSize.medium,
            label: 'Secondary',
            onPressed: () {},
            variant: CoreButtonVariant.secondary,
            icon: const CoreIconWidget(
                icon: CoreIcons.arrowLeft, color: CoreButtonColors.surface),
          ))
           ..addScenario(
          'Secondary',
          CoreButton(
            size: CoreButtonSize.medium,
            label: 'Secondary',
            onPressed: () {},
            isDisabled: true,
            variant: CoreButtonVariant.secondary,
          ))
      ..addScenario(
          'Secondary + Icon',
          CoreButton(
            size: CoreButtonSize.medium,
            label: 'Secondary',
            onPressed: () {},
            isDisabled: true,
            variant: CoreButtonVariant.secondary,
            icon: const CoreIconWidget(
                icon: CoreIcons.arrowLeft, color: CoreTextColors.body),
          ));

    await tester.pumpWidgetBuilder(
      Container(
        color: CoreBackgroundColors.pageBackground,
        child: builder.build(),
      ),
      surfaceSize: const Size(400, 800),
    );

    await screenMatchesGolden(tester, 'core_button_medium_narrow_space');
  });

   testGoldens('CoreButton Small Narrow Space', (WidgetTester tester) async {
    final builder = GoldenBuilder.grid(columns: 2, widthToHeightRatio: 2)
      ..addScenario(
          'Primary',
          CoreButton(
            size: CoreButtonSize.small,
            label: 'Primary',
            onPressed: () {},
          ))
      ..addScenario(
          'Primary + Icon',
          CoreButton(
            size: CoreButtonSize.small,
            label: 'Primary',
            onPressed: () {},
            icon: const CoreIconWidget(
                icon: CoreIcons.arrowLeft, color: CoreTextColors.inverse),
          ))
      ..addScenario(
          'Primary',
          CoreButton(
            size: CoreButtonSize.small,
            label: 'Primary',
            onPressed: () {},
            isDisabled: true,
          ))
      ..addScenario(
          'Primary + Icon',
          CoreButton(
            size: CoreButtonSize.small,
            label: 'Primary',
            onPressed: () {},
            isDisabled: true,
            icon: const CoreIconWidget(
                icon: CoreIcons.arrowLeft, color: CoreTextColors.body),
          ))
      ..addScenario(
          'Secondary',
          CoreButton(
            size: CoreButtonSize.small,
            label: 'Secondary',
            onPressed: () {},
            variant: CoreButtonVariant.secondary,
          ))
      ..addScenario(
          'Secondary + Icon',
          CoreButton(
            size: CoreButtonSize.small,
            label: 'Secondary',
            onPressed: () {},
            variant: CoreButtonVariant.secondary,
            icon: const CoreIconWidget(
                icon: CoreIcons.arrowLeft, color: CoreButtonColors.surface),
          ))
           ..addScenario(
          'Secondary',
          CoreButton(
            size: CoreButtonSize.small,
            label: 'Secondary',
            onPressed: () {},
            isDisabled: true,
            variant: CoreButtonVariant.secondary,
          ))
      ..addScenario(
          'Secondary + Icon',
          CoreButton(
            size: CoreButtonSize.small,
            label: 'Secondary',
            onPressed: () {},
            isDisabled: true,
            variant: CoreButtonVariant.secondary,
            icon: const CoreIconWidget(
                icon: CoreIcons.arrowLeft, color: CoreTextColors.body),
          ));

      await tester.pumpWidgetBuilder(
        Container(
          color: CoreBackgroundColors.pageBackground,
          child: builder.build(),
        ),
        surfaceSize: const Size(400, 800),
      );

      await screenMatchesGolden(tester, 'core_button_small_narrow_space');
  });
}
