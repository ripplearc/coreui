import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/test_harness.dart';

void main() {
  group('CoreInitialAvatar.initialFor', () {
    test('takes first initial of first token, uppercased', () {
      expect(CoreInitialAvatar.initialFor('John Doe'), 'J');
      expect(CoreInitialAvatar.initialFor('floyd miles'), 'F');
      expect(CoreInitialAvatar.initialFor('Madonna'), 'M');
    });

    test('handles leading whitespace', () {
      expect(CoreInitialAvatar.initialFor('   ali baba'), 'A');
    });

    test('blank name yields empty string', () {
      expect(CoreInitialAvatar.initialFor(''), '');
      expect(CoreInitialAvatar.initialFor('   '), '');
    });
  });

  group('CoreInitialAvatar widget', () {
    testWidgets('renders the derived initial', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          const CoreInitialAvatar(name: 'John Doe'),
          theme: CoreTheme.light(),
        ),
      );

      expect(find.text('J'), findsOneWidget);
    });

    testWidgets('renders no text for a blank name', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          const CoreInitialAvatar(name: '   '),
          theme: CoreTheme.light(),
        ),
      );

      expect(find.byType(Text), findsNothing);
      // The circle still renders.
      expect(find.byType(CoreAvatar), findsOneWidget);
    });

    testWidgets('applies custom textColor to the initial', (tester) async {
      final theme = CoreTheme.light();
      final customColor = theme.coreColors.iconGreen;

      await tester.pumpWidget(
        buildTestApp(
          CoreInitialAvatar(name: 'John Doe', textColor: customColor),
          theme: theme,
        ),
      );

      final text = tester.widget<Text>(find.text('J'));
      expect(text.style!.color, customColor);
      // Custom color overrides the default themed initial color.
      expect(text.style!.color, isNot(theme.coreColors.iconOrient));
    });

    testWidgets('textColor wins over a color set in textStyle',
        (tester) async {
      final theme = CoreTheme.light();
      final customColor = theme.coreColors.iconGreen;
      // A typography token whose own color differs from customColor.
      final overrideStyle = theme.coreTypography.bodyLargeSemiBold
          .copyWith(color: theme.coreColors.iconRed);

      await tester.pumpWidget(
        buildTestApp(
          CoreInitialAvatar(
            name: 'John Doe',
            textColor: customColor,
            textStyle: overrideStyle,
          ),
          theme: theme,
        ),
      );

      final text = tester.widget<Text>(find.text('J'));
      // textColor is applied last, so it wins over the style's own color...
      expect(text.style!.color, customColor);
      // ...but the rest of the overridden style is preserved.
      expect(text.style!.fontSize, overrideStyle.fontSize);
    });

    testWidgets('passes custom backgroundColor to CoreAvatar', (tester) async {
      final theme = CoreTheme.light();
      final customBg = theme.coreColors.backgroundGreenLight;

      await tester.pumpWidget(
        buildTestApp(
          CoreInitialAvatar(name: 'John Doe', backgroundColor: customBg),
          theme: theme,
        ),
      );

      final avatar = tester.widget<CoreAvatar>(find.byType(CoreAvatar));
      expect(avatar.backgroundColor, customBg);
    });

    testWidgets('default semantic label uses the name', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          const CoreInitialAvatar(name: 'John Doe'),
          theme: CoreTheme.light(),
        ),
      );

      final avatar = tester.widget<CoreAvatar>(find.byType(CoreAvatar));
      expect(avatar.semanticLabel, 'Avatar for John Doe');
    });
  });
}
