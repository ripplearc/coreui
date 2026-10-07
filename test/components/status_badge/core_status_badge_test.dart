import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/test_harness.dart';

void main() {
  Future<void> pumpBadge(
    WidgetTester tester,
    CoreStatusBadge badge, {
    ThemeData? theme,
  }) async {
    await tester
        .pumpWidget(buildTestApp(badge, theme: theme ?? CoreTheme.light()));
  }

  BoxDecoration decorationOf(WidgetTester tester) {
    final container = tester.widget<Container>(
      find.descendant(
        of: find.byType(CoreStatusBadge),
        matching: find.byType(Container),
      ),
    );
    return container.decoration! as BoxDecoration;
  }

  group('CoreStatusBadge', () {
    testWidgets('shows the label it is given', (tester) async {
      await pumpBadge(tester, const CoreStatusBadge(label: 'Sample rate'));

      expect(find.text('Sample rate'), findsOneWidget);
    });

    testWidgets('is exactly 24 dp tall', (tester) async {
      await pumpBadge(tester, const CoreStatusBadge(label: 'Sample rate'));

      expect(tester.getSize(find.byType(CoreStatusBadge)).height, 24);
    });

    testWidgets(
        'is as wide as its label plus 10 dp padding and 1 dp border '
        'on each side', (tester) async {
      await pumpBadge(tester, const CoreStatusBadge(label: 'Sample rate'));

      final labelWidth = tester.getSize(find.text('Sample rate')).width;
      expect(
        tester.getSize(find.byType(CoreStatusBadge)).width,
        labelWidth + 2 * 10 + 2 * 1,
      );
    });

    testWidgets('draws no icon unless showInfoIcon is set', (tester) async {
      await pumpBadge(tester, const CoreStatusBadge(label: 'Sample rate'));

      expect(find.byType(CoreIconWidget), findsNothing);
    });

    testWidgets(
        'showInfoIcon adds a 14 dp icon 4 dp after the label, '
        'widening the badge by 18 dp', (tester) async {
      await pumpBadge(tester, const CoreStatusBadge(label: 'Sample rate'));
      final plainWidth = tester.getSize(find.byType(CoreStatusBadge)).width;

      await pumpBadge(
        tester,
        const CoreStatusBadge(label: 'Sample rate', showInfoIcon: true),
      );

      final icon = tester.widget<CoreIconWidget>(find.byType(CoreIconWidget));
      expect(icon.size, 14);
      expect(
          tester.getSize(find.byType(CoreStatusBadge)).width, plainWidth + 18);
      expect(
        tester.getTopLeft(find.byType(CoreIconWidget)).dx -
            tester.getTopRight(find.text('Sample rate')).dx,
        4,
      );
    });

    testWidgets(
        'draws the Figma fill, outline and 8 dp radius in the light '
        'theme', (tester) async {
      await pumpBadge(tester, const CoreStatusBadge(label: 'Sample rate'));

      final decoration = decorationOf(tester);
      final colors = CoreTheme.light().coreColors;
      expect(decoration.color, colors.backgroundOrangeMid);
      expect(decoration.borderRadius, BorderRadius.circular(8));
      final border = decoration.border! as Border;
      expect(border.top.color, colors.lineOrange);
      expect(border.top.width, 1);
    });

    testWidgets('draws the label in 12 dp semibold on a 16 dp line',
        (tester) async {
      await pumpBadge(tester, const CoreStatusBadge(label: 'Sample rate'));

      final style = tester.widget<Text>(find.text('Sample rate')).style!;
      expect(style.fontSize, 12);
      expect(style.fontWeight, FontWeight.w600);
      expect(style.height! * style.fontSize!, 16);
    });

    testWidgets('light theme draws label and icon in textWarningStrong',
        (tester) async {
      final colors = CoreTheme.light().coreColors;
      await pumpBadge(
        tester,
        const CoreStatusBadge(label: 'Sample rate', showInfoIcon: true),
      );

      expect(
        tester.widget<Text>(find.text('Sample rate')).style!.color,
        colors.textWarningStrong,
      );
      expect(
        tester.widget<CoreIconWidget>(find.byType(CoreIconWidget)).color,
        colors.textWarningStrong,
      );
    });

    testWidgets(
        'dark theme draws label and icon in textWarningStrong on the dark '
        'fill and outline tokens', (tester) async {
      final theme = CoreTheme.dark();
      await pumpBadge(
        tester,
        const CoreStatusBadge(label: 'Sample rate', showInfoIcon: true),
        theme: theme,
      );

      final colors = theme.coreColors;
      expect(
        tester.widget<Text>(find.text('Sample rate')).style!.color,
        colors.textWarningStrong,
      );
      expect(
        tester.widget<CoreIconWidget>(find.byType(CoreIconWidget)).color,
        colors.textWarningStrong,
      );
      final decoration = decorationOf(tester);
      expect(decoration.color, colors.backgroundOrangeMid);
      expect((decoration.border! as Border).top.color, colors.lineOrange);
    });

    testWidgets(
        'cuts a label wider than its space with an ellipsis instead of '
        'overflowing', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          const SizedBox(
            width: 60,
            child: Align(
              alignment: Alignment.centerLeft,
              child: CoreStatusBadge(label: 'Sample rate'),
            ),
          ),
          theme: CoreTheme.light(),
        ),
      );

      expect(tester.takeException(), isNull);
      final label = tester.widget<Text>(find.text('Sample rate'));
      expect(label.maxLines, 1);
      expect(label.overflow, TextOverflow.ellipsis);
      expect(tester.getSize(find.byType(CoreStatusBadge)).width, 60);
    });
  });

  group('CoreStatusBadge info tap', () {
    testWidgets('tapping the icon calls onInfoTap once', (tester) async {
      var taps = 0;
      await pumpBadge(
        tester,
        CoreStatusBadge(
          label: 'Sample rate',
          showInfoIcon: true,
          onInfoTap: () => taps++,
          infoSemanticLabel: 'About sample rates',
        ),
      );

      await tester.tap(find.byType(CoreIconWidget));

      expect(taps, 1);
    });

    testWidgets('tapping the label does nothing', (tester) async {
      var taps = 0;
      await pumpBadge(
        tester,
        CoreStatusBadge(
          label: 'Sample rate',
          showInfoIcon: true,
          onInfoTap: () => taps++,
          infoSemanticLabel: 'About sample rates',
        ),
      );

      await tester.tap(find.text('Sample rate'));

      expect(taps, 0);
    });

    testWidgets('keeps the badge the same size as the decorative icon',
        (tester) async {
      await pumpBadge(
        tester,
        const CoreStatusBadge(label: 'Sample rate', showInfoIcon: true),
      );
      final decorativeSize = tester.getSize(find.byType(CoreStatusBadge));

      await pumpBadge(
        tester,
        CoreStatusBadge(
          label: 'Sample rate',
          showInfoIcon: true,
          onInfoTap: () {},
          infoSemanticLabel: 'About sample rates',
        ),
      );

      expect(tester.getSize(find.byType(CoreStatusBadge)), decorativeSize);
    });

    testWidgets(
        'the tap area is as tall as the badge and reaches its right '
        'edge', (tester) async {
      await pumpBadge(
        tester,
        CoreStatusBadge(
          label: 'Sample rate',
          showInfoIcon: true,
          onInfoTap: () {},
          infoSemanticLabel: 'About sample rates',
        ),
      );

      final badge = tester.getRect(find.byType(CoreStatusBadge));
      final target = tester.getRect(find.byType(GestureDetector));
      expect(target.height, badge.height - 2);
      expect(target.right, badge.right - 1);
    });

    test('refuses onInfoTap without the icon', () {
      expect(
        () => CoreStatusBadge(
          label: 'Sample rate',
          onInfoTap: () {},
          infoSemanticLabel: 'About sample rates',
        ),
        throwsAssertionError,
      );
    });

    test('refuses onInfoTap without a semantic label', () {
      expect(
        () => CoreStatusBadge(
          label: 'Sample rate',
          showInfoIcon: true,
          onInfoTap: () {},
        ),
        throwsAssertionError,
      );
    });
  });

  group('CoreStatusBadge compact', () {
    const compact = CoreStatusBadge(
      label: 'Sample rate',
      size: CoreStatusBadgeSize.compact,
    );

    testWidgets('is 20 dp tall with 8 dp side padding and a 1 dp border',
        (tester) async {
      await pumpBadge(tester, compact);

      final labelWidth = tester.getSize(find.text('Sample rate')).width;
      final size = tester.getSize(find.byType(CoreStatusBadge));
      expect(size.height, 20);
      expect(size.width, labelWidth + 2 * 8 + 2 * 1);
    });

    testWidgets(
        'draws the lighter orange fill, the orange outline and a 6 dp '
        'radius', (tester) async {
      await pumpBadge(tester, compact);

      final colors = CoreTheme.light().coreColors;
      final decoration = decorationOf(tester);
      expect(decoration.color, colors.backgroundOrangeLight);
      expect(decoration.borderRadius, BorderRadius.circular(6));
      expect((decoration.border! as Border).top.color, colors.lineOrange);
    });

    testWidgets(
        'draws textWarningStrong in the light theme and uses the dark '
        'fill token in the dark theme', (tester) async {
      await pumpBadge(tester, compact);
      expect(
        tester.widget<Text>(find.text('Sample rate')).style!.color,
        CoreTheme.light().coreColors.textWarningStrong,
      );

      final theme = CoreTheme.dark();
      await pumpBadge(tester, compact, theme: theme);
      await tester.pumpAndSettle();
      expect(
          decorationOf(tester).color, theme.coreColors.backgroundOrangeLight);
    });

    testWidgets('refuses an info icon', (tester) async {
      expect(
        () => CoreStatusBadge(
          label: 'Sample rate',
          size: CoreStatusBadgeSize.compact,
          showInfoIcon: true,
        ),
        throwsAssertionError,
      );
    });
  });

  group('CoreStatusBadge neutral', () {
    const neutral = CoreStatusBadge(
      label: 'After first send',
      variant: CoreStatusBadgeVariant.neutral,
    );

    testWidgets('is 22 dp tall with 11 dp side padding and no border',
        (tester) async {
      await pumpBadge(tester, neutral);

      final labelWidth = tester.getSize(find.text('After first send')).width;
      final size = tester.getSize(find.byType(CoreStatusBadge));
      expect(size.height, 22);
      expect(size.width, labelWidth + 2 * 11);
    });

    testWidgets('draws the grey fill with a 6 dp radius and no outline',
        (tester) async {
      await pumpBadge(tester, neutral);

      final decoration = decorationOf(tester);
      expect(decoration.color, CoreTheme.light().coreColors.backgroundGrayMid);
      expect(decoration.borderRadius, BorderRadius.circular(6));
      expect(decoration.border, isNull);
    });

    testWidgets('draws the label in textGrayMid in both themes',
        (tester) async {
      for (final theme in [CoreTheme.light(), CoreTheme.dark()]) {
        await pumpBadge(tester, neutral, theme: theme);
        await tester.pumpAndSettle();

        expect(
          tester.widget<Text>(find.text('After first send')).style!.color,
          theme.coreColors.textGrayMid,
        );
        expect(decorationOf(tester).color, theme.coreColors.backgroundGrayMid);
      }
    });

    testWidgets('refuses a compact size and an info icon', (tester) async {
      expect(
        () => CoreStatusBadge(
          label: 'After first send',
          variant: CoreStatusBadgeVariant.neutral,
          size: CoreStatusBadgeSize.compact,
        ),
        throwsAssertionError,
      );
      expect(
        () => CoreStatusBadge(
          label: 'After first send',
          variant: CoreStatusBadgeVariant.neutral,
          showInfoIcon: true,
        ),
        throwsAssertionError,
      );
    });
  });
}
