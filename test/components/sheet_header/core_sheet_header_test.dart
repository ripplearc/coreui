import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/test_harness.dart';

void _noop() {}

void main() {
  const title = 'Excavator';
  const subtitle = 'Metered rate';
  const backLabel = 'Back';

  Future<void> pumpHeader(
    WidgetTester tester, {
    String? subtitle,
    VoidCallback onBack = _noop,
    ThemeData? theme,
  }) async {
    await tester.pumpWidget(
      buildTestApp(
        SizedBox(
          width: 412,
          child: CoreSheetHeader(
            title: title,
            subtitle: subtitle,
            backSemanticLabel: backLabel,
            onBack: onBack,
          ),
        ),
        theme: theme ?? CoreTheme.light(),
      ),
    );
  }

  Finder backButton() => find.byKey(CoreSheetHeader.backButtonKey);

  Offset offsetInHeader(WidgetTester tester, Finder finder) =>
      tester.getTopLeft(finder) -
      tester.getTopLeft(find.byType(CoreSheetHeader));

  group('CoreSheetHeader', () {
    testWidgets('shows the title and the subtitle', (tester) async {
      await pumpHeader(tester, subtitle: subtitle);

      expect(find.text(title), findsOneWidget);
      expect(find.text(subtitle), findsOneWidget);
    });

    testWidgets('draws no second line without a subtitle', (tester) async {
      await pumpHeader(tester);

      expect(find.text(title), findsOneWidget);
      expect(find.text(subtitle), findsNothing);
    });

    testWidgets('calls onBack once when the arrow is tapped', (tester) async {
      var taps = 0;
      await pumpHeader(tester, onBack: () => taps++);

      await tester.tap(backButton());

      expect(taps, 1);
    });

    testWidgets('gives the arrow a 48 x 48 dp tap area', (tester) async {
      await pumpHeader(tester);

      expect(tester.getSize(backButton()), const Size(48, 48));
    });

    testWidgets('draws a 24 dp arrow, 12 dp from the left and top edges',
        (tester) async {
      await pumpHeader(tester);

      final arrow = find.descendant(
        of: backButton(),
        matching: find.byType(Icon),
      );
      expect(tester.getSize(arrow), const Size(24, 24));
      expect(offsetInHeader(tester, arrow), const Offset(12, 12));
    });

    testWidgets('starts the title 48 dp from the left and 11 dp from the top',
        (tester) async {
      await pumpHeader(tester);

      expect(offsetInHeader(tester, find.text(title)), const Offset(48, 11));
    });

    testWidgets('leaves 20 dp right of the text', (tester) async {
      await pumpHeader(tester);

      final textColumn = find.byKey(CoreSheetHeader.textColumnKey);
      expect(
        tester.getTopRight(find.byType(CoreSheetHeader)).dx -
            tester.getTopRight(textColumn).dx,
        20,
      );
    });

    testWidgets('is 72 dp tall with a subtitle: 11 + 26 + 20 + 15',
        (tester) async {
      await pumpHeader(tester, subtitle: subtitle);

      expect(tester.getSize(find.byType(CoreSheetHeader)).height, 72);
    });

    testWidgets('is 52 dp tall without a subtitle: 11 + 26 + 15',
        (tester) async {
      await pumpHeader(tester);

      expect(tester.getSize(find.byType(CoreSheetHeader)).height, 52);
    });

    testWidgets('cuts a long title with an ellipsis on one line',
        (tester) async {
      await pumpHeader(tester);

      final text = tester.widget<Text>(find.text(title));
      expect(text.maxLines, 1);
      expect(text.overflow, TextOverflow.ellipsis);
    });

    for (final theme in [CoreTheme.light(), CoreTheme.dark()]) {
      testWidgets('uses the theme colours (${theme.brightness.name})',
          (tester) async {
        await pumpHeader(tester, subtitle: subtitle, theme: theme);
        final colors = theme.coreColors;

        expect(
          tester.widget<Text>(find.text(title)).style,
          isA<TextStyle>()
              .having((s) => s.color, 'color', colors.textHeadline),
        );
        expect(
          tester.widget<Text>(find.text(subtitle)).style,
          isA<TextStyle>().having((s) => s.color, 'color', colors.textBody),
        );
        final arrow = find.descendant(
          of: backButton(),
          matching: find.byType(Icon),
        );
        expect(tester.widget<Icon>(arrow).color, colors.textLink);
      });
    }

    testWidgets('uses titleMediumSemiBold and bodyMediumRegular',
        (tester) async {
      await pumpHeader(tester, subtitle: subtitle);
      final typography = CoreTheme.light().coreTypography;

      Matcher sizeAndWeightOf(TextStyle style) => isA<TextStyle>()
          .having((s) => s.fontSize, 'fontSize', style.fontSize)
          .having((s) => s.fontWeight, 'fontWeight', style.fontWeight);

      expect(
        tester.widget<Text>(find.text(title)).style,
        sizeAndWeightOf(typography.titleMediumSemiBold),
      );
      expect(
        tester.widget<Text>(find.text(subtitle)).style,
        sizeAndWeightOf(typography.bodyMediumRegular),
      );
    });
  });
}
