import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';
import '../../utils/test_harness.dart';

void main() {
  group('CoreChip – accessibility', () {
    testWidgets('exposes semantic label and button role',
        (WidgetTester tester) async {
      await setupA11yTest(tester);

      final selected = ValueNotifier<bool>(false);
      const chipLabel = 'Accessible Chip';

      await tester.pumpWidget(
        buildTestApp(
          CoreChip(
            label: chipLabel,
            selected: selected,
            onTap: () {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      final chipFinder = find.byType(CoreChip);
      expect(chipFinder, findsOneWidget);

      final semantics = tester.getSemantics(chipFinder);
      expect(semantics.label, chipLabel);
      expect(semantics.hasFlag(SemanticsFlag.isButton), isTrue);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => CoreChip(
          label: chipLabel,
          selected: selected,
          onTap: () {},
        ),
        chipFinder,
        checkTapTargetSize: true,
        checkLabeledTapTarget: true,
        checkTextContrast: true,
      );
    });

    testWidgets('exposes combined semantic label for multi-part chip',
        (WidgetTester tester) async {
      await setupA11yTest(tester);

      final selected = ValueNotifier<bool>(false);

      await tester.pumpWidget(
        buildTestApp(
          CoreChip(
            label: 'Volume:',
            value: '2700',
            unit: 'ft³',
            selected: selected,
          ),
          theme: CoreTheme.light(),
        ),
      );

      final chipFinder = find.byType(CoreChip);
      expect(chipFinder, findsOneWidget);

      final semantics = tester.getSemantics(chipFinder);
      expect(semantics.label, 'Volume: 2700 ft³');
    });

    testWidgets('close icon has semantics', (WidgetTester tester) async {
      final selected = ValueNotifier<bool>(false);

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreChip(
              label: 'Filter',
              selected: selected,
              withCloseIcon: true,
              onRemove: () {},
            ),
          ),
        ),
      );

      final semantics =
          tester.getSemantics(find.byKey(const Key('close_icon')));

      expect(semantics.hasFlag(SemanticsFlag.isButton), isTrue);
      expect(semantics.label, contains('Remove Filter'));
    });
  });
}
