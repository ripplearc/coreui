import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/test_harness.dart';

void main() {
  const cardKey = Key('card');

  CoreEstimateSummaryCard totalsCard({
    CoreEstimateSummaryCharge? extraCharge,
    String estimateName = 'Bedroom 2',
  }) {
    return CoreEstimateSummaryCard(
      key: cardKey,
      title: 'Adds to this estimate',
      lineTotal: r'$520.00',
      extraCharge: extraCharge,
      estimateName: estimateName,
      totalBeforeSuffix: r' total  $2,993.62 →',
      totalAfter: r'$3,513.62',
    );
  }

  const emptyCard = CoreEstimateSummaryCard.empty(
    key: cardKey,
    title: 'Adds to this estimate',
    note: 'Needs a rate before it can total',
  );

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
      expect(find.text('Bedroom 2'), findsOneWidget);
      expect(find.text(r' total  $2,993.62 →'), findsOneWidget);
      expect(find.text(r'$3,513.62'), findsOneWidget);
      expect(find.text(CoreEstimateSummaryCard.emptyAmount), findsNothing);
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

    testWidgets('ellipsises a long estimate name and keeps both totals whole',
        (tester) async {
      const name = 'Primary bedroom and walk-in closet suite';
      await pump(
        tester,
        totalsCard(estimateName: name),
        theme: CoreTheme.light(),
      );

      expect(tester.takeException(), isNull);
      expect(tester.widget<Text>(find.text(name)).overflow,
          TextOverflow.ellipsis);
      final cardRight = tester.getTopRight(find.byKey(cardKey)).dx - 15;
      expect(
        tester.getTopRight(find.text(r' total  $2,993.62 →')).dx,
        lessThan(tester.getTopLeft(find.text(r'$3,513.62')).dx),
      );
      expect(tester.getTopRight(find.text(r'$3,513.62')).dx, cardRight);
    });

    testWidgets('shrinks the totals rather than clip them on a narrow card',
        (tester) async {
      // Pumped directly: pump() would force the card back to 372 wide.
      await tester.pumpWidget(
        buildTestApp(
          const SizedBox(
            width: 200,
            child: CoreEstimateSummaryCard(
              key: cardKey,
              title: 'Adds to this estimate',
              lineTotal: r'$1,234,567.89',
              estimateName: 'Bedroom 2',
              totalBeforeSuffix: r' total  $9,876,543.21 →',
              totalAfter: r'$11,111,111.10',
            ),
          ),
          theme: CoreTheme.light(),
        ),
      );

      expect(tester.getSize(find.byKey(cardKey)).width, 200);
      expect(tester.takeException(), isNull);
      final contentRight = tester.getTopRight(find.byKey(cardKey)).dx - 15;
      final amount = tester.getRect(find.text(r'$1,234,567.89'));
      // Scaled down to one line; a wrapped amount would fill its 40 dp slot.
      expect(amount.height, lessThan(40));
      expect(amount.right, lessThanOrEqualTo(contentRight));
      expect(
        tester.getTopRight(find.text(r'$11,111,111.10')).dx,
        lessThanOrEqualTo(contentRight),
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

  group('CoreEstimateSummaryCard.empty', () {
    testWidgets('shows a dash and the note in place of the numbers',
        (tester) async {
      await pump(tester, emptyCard, theme: CoreTheme.light());

      expect(find.text(CoreEstimateSummaryCard.emptyAmount), findsOneWidget);
      expect(find.text('Needs a rate before it can total'), findsOneWidget);
      expect(find.text(r' total  $2,993.62 →'), findsNothing);
      expect(find.byType(CoreDivider), findsOneWidget);
    });

    testWidgets('is as tall as the storyboard frame: four parts, no totals row',
        (tester) async {
      // Short enough to stay on one line in the test font.
      await pump(
        tester,
        const CoreEstimateSummaryCard.empty(
          key: cardKey,
          title: 'Adds to',
          note: 'Needs a rate',
        ),
        theme: CoreTheme.light(),
      );

      // 13 + 16 + 1 + 40 + 1 + 17 + 1 + 16 + 12: the note is one 16 dp line.
      expect(tester.getSize(find.byKey(cardKey)).height, 117);
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
          tester.widget<Text>(find.text('Bedroom 2')).style!.color,
          colors.textBody,
        );
      });
    }
  });
}
