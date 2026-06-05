import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';

Future<void> setTestViewport(WidgetTester tester) async {
  addTearDown(() => tester.view.resetPhysicalSize());
  tester.view.physicalSize = const ui.Size(1100, 1600);
}

void main() {
  group('CoreGeometryArea – accessibility', () {
    testWidgets('meets basic accessibility guidelines',
        (WidgetTester tester) async {
      await setTestViewport(tester);

      await setupA11yTest(tester);
      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => const CoreGeometryArea(),
        find.byType(CoreGeometryArea),
        checkTapTargetSize: false,
        checkLabeledTapTarget: false,
        checkTextContrast: false,
      );
    });

    testWidgets('text elements expose correct semantics and meet guidelines',
        (WidgetTester tester) async {
      await setTestViewport(tester);

      await setupA11yTest(tester);
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreGeometryArea(),
          ),
        ),
      );

      final dimensionsText = find.text(CoreGeometryArea.defaultDimensionsLabel);
      final expandText = find.text(CoreGeometryArea.defaultExpandLabel);

      expect(dimensionsText, findsOneWidget);
      expect(expandText, findsOneWidget);

      final dimSemantics = tester.getSemantics(dimensionsText);
      expect(dimSemantics.label, CoreGeometryArea.defaultDimensionsLabel);

      final expSemantics = tester.getSemantics(expandText);
      expect(expSemantics.label, CoreGeometryArea.defaultExpandLabel);

      final iconFinder = find.byType(CoreIconWidget);
      expect(iconFinder, findsOneWidget);
      final iconSemantics = tester.getSemantics(iconFinder);
      expect(iconSemantics.label, CoreGeometryArea.defaultExpandLabel);
    });
  });
}
