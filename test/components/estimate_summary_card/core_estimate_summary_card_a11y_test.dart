import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';

void main() {
  const cardKey = Key('card');

  const totalsCard = CoreEstimateSummaryCard(
    key: cardKey,
    title: 'Adds to this estimate',
    lineTotal: r'$605.00',
    extraCharge: CoreEstimateSummaryCharge(
      label: 'incl. delivery',
      amount: r'+$85.00',
    ),
    estimateName: 'Bedroom 2',
    totalBeforeSuffix: r' total  $2,993.62 →',
    totalAfter: r'$3,598.62',
  );

  const emptyCard = CoreEstimateSummaryCard.empty(
    key: cardKey,
    title: 'Adds to this estimate',
    note: 'Needs a rate before it can total',
  );

  double contrast(Color a, Color b) {
    final la = a.computeLuminance();
    final lb = b.computeLuminance();
    return (max(la, lb) + 0.05) / (min(la, lb) + 0.05);
  }

  // The card is one merged semantics node, so Flutter's textContrastGuideline
  // samples the whole card, dark headline included, and passes whatever the
  // grey text is. Each text colour is checked against the fill instead.
  for (final theme in kA11yTestThemes) {
    for (final (name, card) in [('totals', totalsCard), ('empty', emptyCard)]) {
      testWidgets(
          'a11y: every text on the $name card is at least 4.5:1 on the fill '
          '(${theme.brightness.name})', (tester) async {
        await tester.pumpWidget(
          MaterialApp(theme: theme, home: Scaffold(body: card)),
        );
        final fill = theme.coreColors.backgroundBlueLight;

        final texts = tester.widgetList<Text>(
          find.descendant(
            of: find.byKey(cardKey),
            matching: find.byType(Text),
          ),
        );
        expect(texts, isNotEmpty);
        for (final text in texts) {
          expect(
            contrast(text.style!.color!, fill),
            greaterThanOrEqualTo(4.5),
            reason: '"${text.data}"',
          );
        }
      });
    }
  }

  testWidgets('a11y: the card meets the guidelines in both themes',
      (tester) async {
    await setupA11yTest(tester);
    // Contrast is checked per text above: the merged node hides it here.
    await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
      tester,
      (_) => totalsCard,
      find.byKey(cardKey),
      checkTextContrast: false,
    );
  });

  testWidgets('a11y: the totals are read as one live region', (tester) async {
    final handle = tester.ensureSemantics();
    try {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(body: totalsCard),
        ),
      );

      final semantics = tester.getSemantics(find.byKey(cardKey));
      expect(semantics.flagsCollection.isLiveRegion, isTrue);
      expect(semantics.label, contains('Adds to this estimate'));
      expect(semantics.label, contains(r'$605.00'));
      expect(semantics.label, contains('incl. delivery'));
      expect(semantics.label, contains(r'$3,598.62'));
    } finally {
      handle.dispose();
    }
  });


  testWidgets('a11y: the empty card reads the note and not the dash',
      (tester) async {
    final handle = tester.ensureSemantics();
    try {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(body: emptyCard),
        ),
      );

      final label = tester.getSemantics(find.byKey(cardKey)).label;
      expect(label, contains('Needs a rate before it can total'));
      expect(label, isNot(contains(CoreEstimateSummaryCard.emptyAmount)));
    } finally {
      handle.dispose();
    }
  });
}
