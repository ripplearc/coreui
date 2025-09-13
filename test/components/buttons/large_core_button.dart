import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';
import '../../load_fonts.dart';

void main() {
  setUpAll(() async {
    await loadFonts();
  });

  testWidgets('CoreButton Large - Narrow View - With Pressed State',
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
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          button,
        ],
      );
    }

    final buttons = [
      scenario(
        'Primary',
        CoreButton(
          label: 'Primary',
          onPressed: () {},
          variant: CoreButtonVariant.primary,
          size: CoreButtonSize.large,
        ),
      ),
      scenario(
        'Primary + Icon',
        CoreButton(
          label: 'Primary',
          onPressed: () {},
          variant: CoreButtonVariant.primary,
          size: CoreButtonSize.large,
          icon: const CoreIconWidget(
            icon: CoreIcons.arrowLeft,
            color: CoreTextColors.inverse,
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
          size: CoreButtonSize.large,
          icon: const CoreIconWidget(
            icon: CoreIcons.arrowLeft,
            color: CoreTextColors.body,
          ),
        ),
      ),
      scenario(
        'Primary Focused',
        CoreButton(
          label: 'Primary',
          onPressed: () {},
          variant: CoreButtonVariant.primary,
          size: CoreButtonSize.large,
          autofocus: true,
          icon: const CoreIconWidget(
            icon: CoreIcons.arrowLeft,
            color: CoreTextColors.inverse,
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
          size: CoreButtonSize.large,
          icon: const CoreIconWidget(
            icon: CoreIcons.arrowLeft,
            color: CoreTextColors.inverse,
          ),
        ),
      ),
      scenario(
        'Secondary',
        CoreButton(
          label: 'Secondary',
          onPressed: () {},
          variant: CoreButtonVariant.secondary,
          size: CoreButtonSize.large,
        ),
      ),
      scenario(
        'Secondary + Icon',
        CoreButton(
          label: 'Secondary',
          onPressed: () {},
          variant: CoreButtonVariant.secondary,
          size: CoreButtonSize.large,
          icon: const CoreIconWidget(
            icon: CoreIcons.arrowLeft,
            color: CoreButtonColors.surface,
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
          size: CoreButtonSize.large,
          icon: const CoreIconWidget(
            icon: CoreIcons.arrowLeft,
            color: CoreTextColors.disable,
          ),
        ),
      ),
      scenario(
        'Secondary Focused',
        CoreButton(
          label: 'Secondary',
          onPressed: () {},
          variant: CoreButtonVariant.secondary,
          size: CoreButtonSize.large,
          autofocus: true,
          icon: const CoreIconWidget(
            icon: CoreIcons.arrowLeft,
            color: CoreButtonColors.hover,
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
          size: CoreButtonSize.large,
          icon: const CoreIconWidget(
            icon: CoreIcons.arrowLeft,
            color: CoreButtonColors.press,
          ),
        ),
      ),
    ];
    await tester.binding.setSurfaceSize(const Size(500, 800));
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          backgroundColor: CoreBackgroundColors.pageBackground,
          body: Center(
            child: SizedBox(
              width: 500,
              height: 900,
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                padding: const EdgeInsets.all(16),
                children: buttons,
              ),
            ),
          ),
        ),
      ),
    );

    // Simulate pressed states
    final primaryGesture = await tester
        .startGesture(tester.getCenter(find.byKey(pressedPrimaryKey)));
    await tester.pumpAndSettle();

    final secondaryGesture = await tester
        .startGesture(tester.getCenter(find.byKey(pressedSecondaryKey)));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/core_button_large.png'),
    );

    await primaryGesture.up();
    await secondaryGesture.up();
  });
}
