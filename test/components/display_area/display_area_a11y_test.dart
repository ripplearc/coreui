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
      expect(semantics.label, 'Close');
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
  });
}
