import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';

void main() {
  group('DisplayArea – accessibility', () {
    testWidgets('meets basic accessibility guidelines',
        (WidgetTester tester) async {
      addTearDown(() => tester.view.resetPhysicalSize());
      tester.view.physicalSize = const ui.Size(1100, 1600);

      await setupA11yTest(tester);
      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => const CoreDisplayArea(),
        find.byType(CoreDisplayArea),
        checkTapTargetSize: false,
        checkLabeledTapTarget: false,
        checkTextContrast: false,
      );
    });

    testWidgets('close icon has correct semantics',
        (WidgetTester tester) async {
      await setupA11yTest(tester);
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreDisplayArea(
              onClose: () {},
            ),
          ),
        ),
      );

      final closeIconFinder = find.byType(CoreIconWidget);
      expect(closeIconFinder, findsOneWidget);

      final semantics = tester.getSemantics(closeIconFinder);
      expect(semantics.label, CoreDisplayArea.defaultCloseSemanticLabel);
      expect(semantics.hasFlag(ui.SemanticsFlag.isButton), isTrue);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => CoreDisplayArea(onClose: () {}),
        closeIconFinder,
        checkTapTargetSize: true,
        checkLabeledTapTarget: false,
        checkTextContrast: true,
      );
    });

    testWidgets('history chips expose correct semantic labels',
        (WidgetTester tester) async {
      addTearDown(() => tester.view.resetPhysicalSize());
      tester.view.physicalSize = const ui.Size(1100, 1600);

      await setupA11yTest(tester);
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreDisplayArea(
              chipsList: [
                CoreCalculatorChip(
                  label: 'Length',
                  value: '16ft 14in',
                  type: CoreCalculatorChipType.editable,
                ),
                CoreCalculatorChip(
                  label: 'Width',
                  value: '10ft',
                  type: CoreCalculatorChipType.active,
                ),
              ],
            ),
          ),
        ),
      );

      final chipFinder = find.byType(CoreCalculatorChip);
      expect(chipFinder, findsNWidgets(2));

      final firstChipSemantics = tester.getSemantics(chipFinder.first);
      expect(firstChipSemantics.label, 'Length, 16ft 14in');
      expect(firstChipSemantics.hasFlag(ui.SemanticsFlag.isButton), isTrue);
    });

    testWidgets('history chips meet accessibility guidelines',
        (WidgetTester tester) async {
      addTearDown(() => tester.view.resetPhysicalSize());
      tester.view.physicalSize = const ui.Size(1100, 1600);

      await setupA11yTest(tester);
      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => const CoreDisplayArea(
          chipsList: [
            CoreCalculatorChip(
              label: 'Length',
              value: '16ft 14in',
              type: CoreCalculatorChipType.editable,
            ),
            CoreCalculatorChip(
              label: 'Length',
              value: '16ft 14in',
              type: CoreCalculatorChipType.active,
            ),
          ],
        ),
        find.byType(CoreDisplayArea),
        checkTapTargetSize: false,
        checkLabeledTapTarget: false,
        checkTextContrast: false,
      );
    });

    testWidgets('placeholder text is visible when history is empty',
        (WidgetTester tester) async {
      addTearDown(() => tester.view.resetPhysicalSize());
      tester.view.physicalSize = const ui.Size(1100, 1600);

      await setupA11yTest(tester);
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreDisplayArea(),
          ),
        ),
      );

      expect(
          find.text(CoreDisplayArea.defaultHistoryPlaceholder), findsOneWidget);
    });

    testWidgets('empty state meets accessibility guidelines',
        (WidgetTester tester) async {
      addTearDown(() => tester.view.resetPhysicalSize());
      tester.view.physicalSize = const ui.Size(1100, 1600);

      await setupA11yTest(tester);
      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => const CoreDisplayArea(),
        find.byType(CoreDisplayArea),
        checkTapTargetSize: false,
        checkLabeledTapTarget: false,
        checkTextContrast: false,
      );
    });
  });
}
