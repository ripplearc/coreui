import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/test_harness.dart';

void main() {
  group('CoreCheckRowItem.initialFor', () {
    test('takes first initial of first token, uppercased', () {
      expect(CoreCheckRowItem.initialFor('John Doe'), 'J');
      expect(CoreCheckRowItem.initialFor('floyd miles'), 'F');
      expect(CoreCheckRowItem.initialFor('Madonna'), 'M');
    });

    test('handles leading whitespace', () {
      expect(CoreCheckRowItem.initialFor('  Esther Howard'), 'E');
    });

    test('blank name yields empty string', () {
      expect(CoreCheckRowItem.initialFor(''), '');
      expect(CoreCheckRowItem.initialFor('   '), '');
    });
  });

  group('CoreCheckRowItem – general', () {
    testWidgets('renders the title', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CoreCheckRowItem(
            title: 'John Doe',
            selected: false,
            onChanged: (_) {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      expect(find.text('John Doe'), findsOneWidget);
    });

    testWidgets('renders an optional subtitle', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CoreCheckRowItem(
            title: 'Floyd Miles',
            subtitle: 'floyd@acme.com',
            selected: false,
            onChanged: (_) {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      expect(find.text('Floyd Miles'), findsOneWidget);
      expect(find.text('floyd@acme.com'), findsOneWidget);
    });

    testWidgets('defaults the leading widget to a CoreAvatar showing the initial',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CoreCheckRowItem(
            title: 'John Doe',
            selected: false,
            onChanged: (_) {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      expect(find.byType(CoreAvatar), findsOneWidget);
      expect(find.text('J'), findsOneWidget);
    });

    testWidgets('blank title renders an empty avatar without crashing',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CoreCheckRowItem(
            title: '   ',
            selected: false,
            onChanged: (_) {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      expect(find.byType(CoreAvatar), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('custom leading widget replaces the default avatar',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CoreCheckRowItem(
            title: 'John Doe',
            selected: false,
            onChanged: (_) {},
            leading: const Icon(Icons.star),
          ),
          theme: CoreTheme.light(),
        ),
      );

      expect(find.byType(CoreAvatar), findsNothing);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('passes avatar color overrides to the default leading avatar',
        (tester) async {
      final theme = CoreTheme.light();
      final customBg = theme.coreColors.backgroundGreenLight;
      final customText = theme.coreColors.iconGreen;

      await tester.pumpWidget(
        buildTestApp(
          CoreCheckRowItem(
            title: 'John Doe',
            selected: false,
            onChanged: (_) {},
            avatarBackgroundColor: customBg,
            avatarTextColor: customText,
          ),
          theme: theme,
        ),
      );

      final avatar = tester.widget<CoreAvatar>(find.byType(CoreAvatar));
      expect(avatar.backgroundColor, customBg);

      final initialText = tester.widget<Text>(find.text('J'));
      expect(initialText.style!.color, customText);
    });

    testWidgets('avatarTextColor wins over a color set in avatarTextStyle',
        (tester) async {
      final theme = CoreTheme.light();
      final customColor = theme.coreColors.iconGreen;
      final overrideStyle = theme.coreTypography.bodyLargeSemiBold
          .copyWith(color: theme.coreColors.iconRed);

      await tester.pumpWidget(
        buildTestApp(
          CoreCheckRowItem(
            title: 'John Doe',
            selected: false,
            onChanged: (_) {},
            avatarTextColor: customColor,
            avatarTextStyle: overrideStyle,
          ),
          theme: theme,
        ),
      );

      final initialText = tester.widget<Text>(find.text('J'));
      expect(initialText.style!.color, customColor);
      expect(initialText.style!.fontSize, overrideStyle.fontSize);
    });

    testWidgets('shows the checked icon when selected', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CoreCheckRowItem(
            title: 'John Doe',
            selected: true,
            onChanged: (_) {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      final icon = tester.widget<CoreIconWidget>(
        find.byType(CoreIconWidget).first,
      );
      expect(icon.icon, CoreIcons.check);
    });

    testWidgets('shows the unchecked icon when not selected', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CoreCheckRowItem(
            title: 'John Doe',
            selected: false,
            onChanged: (_) {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      final icon = tester.widget<CoreIconWidget>(
        find.byType(CoreIconWidget).first,
      );
      expect(icon.icon, CoreIcons.checkBlank);
    });

    testWidgets('tapping the row toggles selection via onChanged',
        (tester) async {
      bool? newValue;

      await tester.pumpWidget(
        buildTestApp(
          CoreCheckRowItem(
            title: 'John Doe',
            selected: false,
            onChanged: (value) => newValue = value,
          ),
          theme: CoreTheme.light(),
        ),
      );

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      expect(newValue, isTrue);
    });

    testWidgets('tapping a selected row calls onChanged with false',
        (tester) async {
      bool? newValue;

      await tester.pumpWidget(
        buildTestApp(
          CoreCheckRowItem(
            title: 'John Doe',
            selected: true,
            onChanged: (value) => newValue = value,
          ),
          theme: CoreTheme.light(),
        ),
      );

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      expect(newValue, isFalse);
    });

    testWidgets('default semantic label uses the title', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CoreCheckRowItem(
            title: 'John Doe',
            selected: false,
            onChanged: (_) {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      final semantics = tester.getSemantics(find.byType(CoreCheckRowItem));
      expect(semantics.label, 'John Doe');
    });

    testWidgets('custom semantic label overrides the default', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CoreCheckRowItem(
            title: 'John Doe',
            selected: false,
            onChanged: (_) {},
            semanticLabel: 'Owner John Doe, unchecked',
          ),
          theme: CoreTheme.light(),
        ),
      );

      final semantics = tester.getSemantics(find.byType(CoreCheckRowItem));
      expect(semantics.label, 'Owner John Doe, unchecked');
    });

    testWidgets('disabled row ignores taps', (tester) async {
      var calls = 0;

      await tester.pumpWidget(
        buildTestApp(
          CoreCheckRowItem(
            title: 'John Doe',
            selected: false,
            enabled: false,
            onChanged: (_) => calls++,
          ),
          theme: CoreTheme.light(),
        ),
      );

      await tester.tap(find.text('John Doe'));
      await tester.pumpAndSettle();

      expect(calls, 0);
    });

    testWidgets('disabled row paints title, subtitle and initials textDisable',
        (tester) async {
      final theme = CoreTheme.light();

      await tester.pumpWidget(
        buildTestApp(
          CoreCheckRowItem(
            title: 'John Doe',
            subtitle: 'john@acme.com',
            selected: true,
            enabled: false,
            onChanged: (_) {},
          ),
          theme: theme,
        ),
      );

      for (final text in ['John Doe', 'john@acme.com', 'J']) {
        expect(
          tester.widget<Text>(find.text(text)).style!.color,
          theme.coreColors.textDisable,
        );
      }
      final icon = tester.widget<CoreIconWidget>(find.byType(CoreIconWidget));
      expect(icon.color, theme.coreColors.iconDark);
    });

    testWidgets('disabled row keeps a custom avatar text colour',
        (tester) async {
      final theme = CoreTheme.light();

      await tester.pumpWidget(
        buildTestApp(
          CoreCheckRowItem(
            title: 'John Doe',
            selected: false,
            enabled: false,
            avatarTextColor: theme.coreColors.textSuccess,
            onChanged: (_) {},
          ),
          theme: theme,
        ),
      );

      expect(
        tester.widget<Text>(find.text('J')).style!.color,
        theme.coreColors.textSuccess,
      );
    });

    testWidgets('enabled row uses the Figma text styles and colours',
        (tester) async {
      final theme = CoreTheme.light();

      await tester.pumpWidget(
        buildTestApp(
          CoreCheckRowItem(
            title: 'John Doe',
            subtitle: 'john@acme.com',
            selected: false,
            onChanged: (_) {},
          ),
          theme: theme,
        ),
      );

      final colors = theme.coreColors;
      final typography = theme.coreTypography;
      final title = tester.widget<Text>(find.text('John Doe')).style!;
      expect(title.color, colors.textHeadline);
      expect(title.fontSize, typography.bodyLargeMedium.fontSize);
      expect(title.fontWeight, typography.bodyLargeMedium.fontWeight);
      final subtitle = tester.widget<Text>(find.text('john@acme.com')).style!;
      expect(subtitle.color, colors.textBody);
      expect(subtitle.fontSize, typography.bodyMediumRegular.fontSize);
      final initial = tester.widget<Text>(find.text('J')).style!;
      expect(initial.color, colors.textLink);
      expect(initial.fontWeight, typography.bodyLargeSemiBold.fontWeight);
      final avatar = tester.widget<CoreAvatar>(find.byType(CoreAvatar));
      expect(avatar.backgroundColor, colors.backgroundBlueLight);
      expect(avatar.radius, 20);
    });

    testWidgets('icon colour is iconDark when ticked, iconGrayMid when not',
        (tester) async {
      final theme = CoreTheme.light();

      for (final selected in [true, false]) {
        await tester.pumpWidget(
          buildTestApp(
            CoreCheckRowItem(
              title: 'John Doe',
              selected: selected,
              onChanged: (_) {},
            ),
            theme: theme,
          ),
        );

        final icon = tester.widget<CoreIconWidget>(find.byType(CoreIconWidget));
        expect(
          icon.color,
          selected ? theme.coreColors.iconDark : theme.coreColors.iconGrayMid,
        );
      }
    });

    testWidgets('divider is drawn by default and hidden by showDivider: false',
        (tester) async {
      Future<void> pump({required bool showDivider}) => tester.pumpWidget(
            buildTestApp(
              CoreCheckRowItem(
                title: 'John Doe',
                selected: false,
                showDivider: showDivider,
                onChanged: (_) {},
              ),
              theme: CoreTheme.light(),
            ),
          );

      await pump(showDivider: true);
      final divider = tester.widget<CoreDivider>(find.byType(CoreDivider));
      expect(divider.indent, CoreSpacing.space5);
      expect(divider.endIndent, CoreSpacing.space5);

      await pump(showDivider: false);
      expect(find.byType(CoreDivider), findsNothing);
    });

    testWidgets('row is 40 dp avatar plus 24 dp padding high', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CoreCheckRowItem(
            title: 'John Doe',
            selected: false,
            onChanged: (_) {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      expect(tester.getSize(find.byType(CoreCheckRowItem)).height, 64);
      expect(tester.getSize(find.byType(CoreAvatar)), const Size(40, 40));
    });

    testWidgets('row stays 48 dp high around a small custom leading widget',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CoreCheckRowItem(
            title: 'John Doe',
            selected: false,
            leading: const SizedBox(width: 8, height: 8),
            onChanged: (_) {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      expect(
        tester.getSize(find.byType(CoreCheckRowItem)).height,
        greaterThanOrEqualTo(48),
      );
    });
  });
}
