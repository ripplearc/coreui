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
        (theme) => const CoreGeometryArea(
          dimensions: [
            CoreDimensionData(label: 'Area', value: '50.27ft²'),
          ],
        ),
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
            body: CoreGeometryArea(
              dimensions: [
                CoreDimensionData(label: 'Area', value: '50.27ft²'),
              ],
              sizesTableTitles: ['area', 'volume'],
            ),
          ),
        ),
      );

      final dimensionsText = find.text(CoreGeometryArea.defaultDimensionsLabel);
      final expandText = find.text(CoreGeometryArea.defaultExpandLabel);
      final sizesTitleText = find.text(CoreGeometryArea.defaultSizesTitleLabel);
      final addSizeText = find.text(CoreGeometryArea.defaultAddSizeLabel);

      expect(dimensionsText, findsOneWidget);
      expect(expandText, findsOneWidget);
      expect(sizesTitleText, findsOneWidget);
      expect(addSizeText, findsOneWidget);

      final dimSemantics = tester.getSemantics(dimensionsText);
      expect(dimSemantics.label, CoreGeometryArea.defaultDimensionsLabel);

      final sizesTitleSemantics = tester.getSemantics(sizesTitleText);
      expect(
          sizesTitleSemantics.label, CoreGeometryArea.defaultSizesTitleLabel);

      final expSemantics = tester.getSemantics(expandText);
      expect(expSemantics.label, CoreGeometryArea.defaultExpandLabel);

      final addSizeSemantics = tester.getSemantics(addSizeText);
      expect(addSizeSemantics.label, CoreGeometryArea.defaultAddSizeLabel);

      final allIconsFinder = find.byType(CoreIconWidget);
      expect(allIconsFinder, findsNWidgets(3));

      final firstIconSemantics = tester.getSemantics(allIconsFinder.first);
      expect(firstIconSemantics.label, CoreGeometryArea.defaultExpandLabel);

      final areaLabelFinder = find.text('Area');
      final areaValueFinder = find.text('50.27ft²');
      expect(areaLabelFinder, findsOneWidget);
      expect(areaValueFinder, findsOneWidget);

      expect(find.bySemanticsLabel('Area: 50.27ft²'), findsOneWidget);

      final sizesTableTitlesText1 = find.text('area');
      final sizesTableTitlesText2 = find.text('volume');
      expect(sizesTableTitlesText1, findsOneWidget);
      expect(sizesTableTitlesText2, findsOneWidget);
    });
  });
}
