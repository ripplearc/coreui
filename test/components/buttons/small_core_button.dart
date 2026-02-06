import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

void main() {
  setUpAll(() async {
    await loadFonts();
  });

  final typography = AppTypographyExtension.create();
  final colors = AppColorsExtension.create();

  testWidgets(
    'CoreButton Small - Narrow View - With Pressed State (All Variants)',
    (tester) async {
      const pressedPrimaryKey = Key('pressed_primary');
      const pressedSecondaryKey = Key('pressed_secondary');

      Widget scenario(String title, Widget button) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: typography.bodySmallRegular.copyWith(
                fontSize: 12,
                color: colors.textDark,
              ),
            ),
            const SizedBox(height: 4),
            button,
          ],
        );
      }

      final widget = Container(
        color: colors.pageBackground,
        child: Wrap(
          spacing: 8,
          runSpacing: 12,
          children: [
            scenario(
              'Primary',
              CoreButton(
                label: 'Primary',
                onPressed: () {},
                variant: CoreButtonVariant.primary,
                size: CoreButtonSize.small,
              ),
            ),
            scenario(
              'Primary + Icon',
              CoreButton(
                label: 'Primary',
                onPressed: () {},
                variant: CoreButtonVariant.primary,
                size: CoreButtonSize.small,
                icon: CoreIconWidget(
                  icon: CoreIcons.arrowLeft,
                  color: colors.textInverse,
                ),
              ),
            ),
            scenario(
              'Primary Disabled + Icon',
              CoreButton(
                label: 'Primary',
                onPressed: () {},
                isDisabled: true,
                variant: CoreButtonVariant.primary,
                size: CoreButtonSize.small,
                icon: CoreIconWidget(
                  icon: CoreIcons.arrowLeft,
                  color: colors.textBody,
                ),
              ),
            ),
            scenario(
              'Primary Focused',
              CoreButton(
                label: 'Primary',
                onPressed: () {},
                variant: CoreButtonVariant.primary,
                size: CoreButtonSize.small,
                autofocus: true,
                icon: CoreIconWidget(
                  icon: CoreIcons.arrowLeft,
                  color: colors.textInverse,
                ),
              ),
            ),
            scenario(
              'Primary Pressed',
              CoreButton(
                key: pressedPrimaryKey,
                label: 'Primary',
                onPressed: () {},
                variant: CoreButtonVariant.primary,
                size: CoreButtonSize.small,
                icon: CoreIconWidget(
                  icon: CoreIcons.arrowLeft,
                  color: colors.textInverse,
                ),
              ),
            ),
            scenario(
              'Secondary',
              CoreButton(
                label: 'Secondary',
                onPressed: () {},
                variant: CoreButtonVariant.secondary,
                size: CoreButtonSize.small,
              ),
            ),
            scenario(
              'Secondary + Icon',
              CoreButton(
                label: 'Secondary',
                onPressed: () {},
                variant: CoreButtonVariant.secondary,
                size: CoreButtonSize.small,
                icon: CoreIconWidget(
                  icon: CoreIcons.arrowLeft,
                  color: colors.buttonSurface,
                ),
              ),
            ),
            scenario(
              'Secondary Disabled + Icon',
              CoreButton(
                label: 'Secondary',
                onPressed: () {},
                isDisabled: true,
                variant: CoreButtonVariant.secondary,
                size: CoreButtonSize.small,
                icon: CoreIconWidget(
                  icon: CoreIcons.arrowLeft,
                  color: colors.textDisable,
                ),
              ),
            ),
            scenario(
              'Secondary Focused',
              CoreButton(
                label: 'Secondary',
                onPressed: () {},
                variant: CoreButtonVariant.secondary,
                size: CoreButtonSize.small,
                autofocus: true,
                icon: CoreIconWidget(
                  icon: CoreIcons.arrowLeft,
                  color: colors.buttonHover,
                ),
              ),
            ),
            scenario(
              'Secondary Pressed',
              CoreButton(
                key: pressedSecondaryKey,
                label: 'Secondary',
                onPressed: () {},
                variant: CoreButtonVariant.secondary,
                size: CoreButtonSize.small,
                icon: CoreIconWidget(
                  icon: CoreIcons.arrowLeft,
                  color: colors.buttonPress,
                ),
              ),
            ),
          ],
        ),
      );
      await tester.binding.setSurfaceSize(const Size(300, 800));

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: [typography, colors],
          ),
          home: Scaffold(
            body: Center(
              child: SizedBox(width: 250, height: 800, child: widget),
            ),
          ),
        ),
      );

      final primaryGesture = await tester.startGesture(
        tester.getCenter(find.byKey(pressedPrimaryKey)),
      );
      await tester.pumpAndSettle();

      final secondaryGesture = await tester.startGesture(
        tester.getCenter(find.byKey(pressedSecondaryKey)),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/core_button_small.png'),
      );

      await primaryGesture.up();
      await secondaryGesture.up();
    },
  );
}
