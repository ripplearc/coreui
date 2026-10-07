import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';
import '../../utils/test_harness.dart';

double _contrastRatio(Color foreground, Color background) {
  double channel(double value) {
    return value <= 0.03928
        ? value / 12.92
        : math.pow((value + 0.055) / 1.055, 2.4).toDouble();
  }

  double luminance(Color color) {
    return 0.2126 * channel(color.r) +
        0.7152 * channel(color.g) +
        0.0722 * channel(color.b);
  }

  final a = luminance(foreground);
  final b = luminance(background);
  final lighter = a > b ? a : b;
  final darker = a > b ? b : a;
  return (lighter + 0.05) / (darker + 0.05);
}

void main() {
  const badge = CoreStatusBadge(label: 'Sample rate', showInfoIcon: true);

  testWidgets('announces its label once, and the info icon adds nothing',
      (tester) async {
    final handle = tester.ensureSemantics();
    try {
      await tester.pumpWidget(buildTestApp(badge, theme: CoreTheme.light()));

      expect(find.bySemanticsLabel('Sample rate'), findsOneWidget);
      expect(
        find.semantics.byPredicate(
          (node) => node.getSemanticsData().label.isNotEmpty,
          describeMatch: (plurality) => 'labelled semantics nodes',
        ),
        findsOneWidget,
      );
    } finally {
      handle.dispose();
    }
  });

  testWidgets('is not tappable and exposes no actions', (tester) async {
    final handle = tester.ensureSemantics();
    try {
      await tester.pumpWidget(buildTestApp(badge, theme: CoreTheme.light()));

      expect(
        find.semantics.byPredicate(
          (node) => node.getSemanticsData().actions != 0,
          describeMatch: (plurality) => 'nodes with actions',
        ),
        findsNothing,
      );
    } finally {
      handle.dispose();
    }
  });

  testWidgets('meets the text contrast guideline in both themes',
      (tester) async {
    await setupA11yTest(tester);
    await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
      tester,
      (theme) => badge,
      find.byType(CoreStatusBadge),
      checkTapTargetSize: false,
    );
  });

  testWidgets(
      'label meets 4.5:1 and icon meets 3:1 against the fill in '
      'both themes', (tester) async {
    for (final theme in kA11yTestThemes) {
      await tester.pumpWidget(buildTestApp(badge, theme: theme));
      await tester.pumpAndSettle();

      final fill = theme.coreColors.backgroundOrangeMid;
      final label = tester.widget<Text>(find.text('Sample rate')).style!.color!;
      final icon =
          tester.widget<CoreIconWidget>(find.byType(CoreIconWidget)).color!;

      expect(_contrastRatio(label, fill), greaterThanOrEqualTo(4.5),
          reason: 'label on ${theme.brightness} fill');
      expect(_contrastRatio(icon, fill), greaterThanOrEqualTo(3),
          reason: 'icon on ${theme.brightness} fill');
    }
  });

  testWidgets(
      'a tappable info icon is a labelled button, and the badge label '
      'is still announced', (tester) async {
    final handle = tester.ensureSemantics();
    try {
      var taps = 0;
      await tester.pumpWidget(
        buildTestApp(
          CoreStatusBadge(
            label: 'Sample rate',
            showInfoIcon: true,
            onInfoTap: () => taps++,
            infoSemanticLabel: 'About sample rates',
          ),
          theme: CoreTheme.light(),
        ),
      );

      final button =
          tester.getSemantics(find.bySemanticsLabel('About sample rates'));
      expect(button.flagsCollection.isButton, isTrue);
      expect(find.bySemanticsLabel('Sample rate'), findsOneWidget);

      tester.semantics.tap(find.semantics.byLabel('About sample rates'));
      expect(taps, 1);
    } finally {
      handle.dispose();
    }
  });

  testWidgets(
      'a tappable info icon meets the label and contrast guidelines '
      'in both themes', (tester) async {
    await setupA11yTest(tester);
    await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
      tester,
      (theme) => CoreStatusBadge(
        label: 'Sample rate',
        showInfoIcon: true,
        onInfoTap: () {},
        infoSemanticLabel: 'About sample rates',
      ),
      find.byType(CoreStatusBadge),
      checkTapTargetSize: false,
    );
  });

  testWidgets(
      'every variant and size meets the text contrast guideline and '
      '4.5:1 in both themes', (tester) async {
    const badges = [
      CoreStatusBadge(label: 'Sample rate'),
      CoreStatusBadge(label: 'Sample rate', size: CoreStatusBadgeSize.compact),
      CoreStatusBadge(
        label: 'After first send',
        variant: CoreStatusBadgeVariant.neutral,
      ),
    ];
    await setupA11yTest(tester);

    for (final each in badges) {
      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => each,
        find.byType(CoreStatusBadge),
        checkTapTargetSize: false,
      );

      for (final theme in kA11yTestThemes) {
        await tester.pumpWidget(buildTestApp(each, theme: theme));
        await tester.pumpAndSettle();

        final decoration = tester
            .widget<Container>(
              find.descendant(
                of: find.byType(CoreStatusBadge),
                matching: find.byType(Container),
              ),
            )
            .decoration! as BoxDecoration;
        final label = tester.widget<Text>(find.text(each.label)).style!.color!;

        expect(
          _contrastRatio(label, decoration.color!),
          greaterThanOrEqualTo(4.5),
          reason: '${each.label} ${each.variant} ${each.size} '
              'on ${theme.brightness}',
        );
      }
    }
  });
}
