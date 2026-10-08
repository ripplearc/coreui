import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/test_harness.dart';

void main() {
  const cardKey = Key('card');

  CoreEstimateSummaryCard totalsCard({
    CoreEstimateSummaryCharge? extraCharge,
  }) {
    return CoreEstimateSummaryCard(
      key: cardKey,
      title: 'Adds to this estimate',
      lineTotal: r'$520.00',
      extraCharge: extraCharge,
      estimateName: 'Bedroom 2',
      totalBeforeSuffix: r' total  $2,993.62 →',
      totalAfter: r'$3,513.62',
    );
  }

  Future<void> pump(
    WidgetTester tester,
    Widget card, {
    required ThemeData theme,
  }) {
    return tester.pumpWidget(
      buildTestApp(
        SizedBox(width: 372, child: card),
        theme: theme,
      ),
    );
  }

  group('CoreEstimateSummaryCard – totals', () {
    testWidgets('shows the line total, the estimate and its total after',
        (tester) async {
      await pump(tester, totalsCard(), theme: CoreTheme.light());

      expect(find.text('Adds to this estimate'), findsOneWidget);
      expect(find.text(r'$520.00'), findsOneWidget);
      expect(find.text(r'Bedroom 2 total  $2,993.62 →'), findsOneWidget);
      expect(find.text(r'$3,513.62'), findsOneWidget);
    });

    testWidgets('is 125 tall without an extra charge, as in Figma',
        (tester) async {
      await pump(tester, totalsCard(), theme: CoreTheme.light());

      expect(tester.getSize(find.byKey(cardKey)).height, 125);
    });

    testWidgets('shows the extra charge in a 24 px row under the amount',
        (tester) async {
      await pump(
        tester,
        totalsCard(
          extraCharge: const CoreEstimateSummaryCharge(
            label: 'incl. delivery',
            amount: r'+$85.00',
          ),
        ),
        theme: CoreTheme.light(),
      );

      expect(find.text('incl. delivery'), findsOneWidget);
      expect(find.text(r'+$85.00'), findsOneWidget);
      expect(tester.getSize(find.byKey(cardKey)).height, 125 + 1 + 24);
      expect(
        tester.getTopLeft(find.text('incl. delivery')).dy,
        greaterThan(tester.getBottomLeft(find.text(r'$520.00')).dy),
      );
    });

    testWidgets('puts the new total at the right edge, inside the padding',
        (tester) async {
      await pump(tester, totalsCard(), theme: CoreTheme.light());

      expect(
        tester.getTopRight(find.text(r'$3,513.62')).dx,
        tester.getTopRight(find.byKey(cardKey)).dx - 15,
      );
    });

    testWidgets('draws the amount at 32/40 with -0.32 letter spacing',
        (tester) async {
      await pump(tester, totalsCard(), theme: CoreTheme.light());

      final style = tester.widget<Text>(find.text(r'$520.00')).style!;
      expect(style.fontSize, 32);
      expect(style.letterSpacing, -0.32);
    });
  });

  group('CoreEstimateSummaryCard – theme', () {
    for (final (name, theme) in [
      ('light', CoreTheme.light()),
      ('dark', CoreTheme.dark()),
    ]) {
      testWidgets('$name: blue fill, lineBlue rule, textBody before row',
          (tester) async {
        await pump(tester, totalsCard(), theme: theme);
        final colors = theme.coreColors;

        final box = tester.widget<DecoratedBox>(
          find.ancestor(
            of: find.text('Adds to this estimate'),
            matching: find.byType(DecoratedBox),
          ),
        );
        final decoration = box.decoration as BoxDecoration;
        expect(decoration.color, colors.backgroundBlueLight);
        expect(decoration.borderRadius, BorderRadius.circular(14));
        expect(
          tester.widget<CoreDivider>(find.byType(CoreDivider)).color,
          colors.lineBlue,
        );
        expect(
          tester
              .widget<Text>(find.text(r'Bedroom 2 total  $2,993.62 →'))
              .style!
              .color,
          colors.textBody,
        );
      });
    }
  });
}
