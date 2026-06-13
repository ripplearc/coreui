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
              sizesTableTitles: const ['area', 'volume'],
              sizesTableData: const [
                CoreSizeCardData(id: '1', values: ['10', '20']),
                CoreSizeCardData(id: '2', values: ['30', '40']),
              ],
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
      expect(allIconsFinder, findsNWidgets(5));

      final firstIconSemantics = tester.getSemantics(allIconsFinder.first);
      expect(firstIconSemantics.label, CoreGeometryArea.defaultExpandLabel);

      final areaLabelFinder = find.text('Area');
      final areaValueFinder = find.text('50.27ft²');
      expect(areaLabelFinder, findsOneWidget);
      expect(areaValueFinder, findsOneWidget);

      expect(find.bySemanticsLabel('Area: 50.27ft²'), findsOneWidget);

      expect(find.bySemanticsLabel('area'), findsOneWidget);
      expect(find.bySemanticsLabel('volume'), findsOneWidget);

      expect(find.text('10'), findsOneWidget);
      expect(find.text('20'), findsOneWidget);

      final semanticsWidgets = tester.widgetList<Semantics>(
        find.byWidgetPredicate((w) {
          if (w is Semantics) {
            final actions = w.properties.customSemanticsActions;
            return actions != null && actions.isNotEmpty;
          }
          return false;
        }),
      ).toList();

      final localizations = MaterialLocalizations.of(
          tester.element(find.byType(CoreGeometryArea)));

      final actionSets = semanticsWidgets
          .map((w) =>
              w.properties.customSemanticsActions!.keys.map((a) => a.label))
          .toList();

      expect(actionSets, contains(equals([localizations.reorderItemDown])));
      expect(actionSets, contains(equals([localizations.reorderItemUp])));

      final dragHandleFinder = find.byWidgetPredicate(
        (widget) =>
            widget is CoreIconWidget && widget.icon == CoreIcons.dragIndicator,
      );
      expect(tester.getSemantics(dragHandleFinder.first).label,
          startsWith(CoreGeometryArea.defaultDragHandleLabel));
    });
  });
}
