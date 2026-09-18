import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';

Future<void> setTestViewport(WidgetTester tester) async {
  addTearDown(() => tester.view.resetPhysicalSize());
  tester.view.physicalSize = const ui.Size(1100, 1600);
}

const String _sizesTitle = 'Concrete volumes';
const String _addSizeLabel = 'Add size';
const String _dragHandleLabel = 'Reorder';

/// The fixture table used across the accessibility tests.
CoreSizesTableData _a11yTable({
  required List<CoreSizeCardData> rows,
  void Function(String id)? onDeleted,
  void Function(int oldIndex, int newIndex)? onReordered,
}) {
  return CoreSizesTableData(
    id: 'a11y-table',
    title: _sizesTitle,
    addLabel: _addSizeLabel,
    editLabel: 'Edit size',
    addResultLabel: 'Add',
    editResultLabel: 'Update',
    unitOptions: const ['m', 'cm', 'mm'],
    unitGroupLabel: 'Unit',
    dragHandleLabel: _dragHandleLabel,
    editRowSemanticsLabelBuilder: (row) => 'Edit ${row.values.first}',
    deleteRowSemanticsLabelBuilder: (row) => 'Delete ${row.values.first}',
    columns: const [
      CoreSizesColumn(title: 'area'),
      CoreSizesColumn(title: 'volume'),
    ],
    rows: rows,
    onSaved: (_) {},
    onDeleted: onDeleted,
    onReordered: onReordered,
  );
}

void main() {
  group('CoreGeometryArea – accessibility', () {
    testWidgets('meets basic accessibility guidelines',
        (WidgetTester tester) async {
      await setTestViewport(tester);

      await setupA11yTest(tester);
      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => CoreGeometryArea(
          onMediaButtonPressed: () {},
          onDocumentButtonPressed: () {},
          dimensions: [
            const CoreDimensionData(label: 'Area', value: '50.27ft²'),
          ],
        ),
        find.byType(CoreGeometryArea),
        checkLabeledTapTarget: false,
        checkTextContrast: false,
      );
    });

    testWidgets(
        'DimensionCard and SizeCard text meets contrast guidelines in both themes',
        (WidgetTester tester) async {
      await setupA11yTest(tester, screenSize: const Size(1100, 1600));

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (_) => CoreGeometryArea(
          onMediaButtonPressed: () {},
          onDocumentButtonPressed: () {},
          dimensions: [
            const CoreDimensionData(label: 'Area', value: '50.27ft²'),
          ],
          tables: [_a11yTable(rows: const [
            CoreSizeCardData(id: '1', values: ['10', '20']),
          ])],
        ),
        find.byType(CoreGeometryArea),
        checkLabeledTapTarget: false,
      );
    });

    testWidgets('text elements expose correct semantics and meet guidelines',
        (WidgetTester tester) async {
      await setTestViewport(tester);

      await setupA11yTest(tester);
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreGeometryArea(
              onMediaButtonPressed: () {},
              onDocumentButtonPressed: () {},
              onViewAllAttachmentsPressed: () {},
              dimensions: [
                const CoreDimensionData(label: 'Area', value: '50.27ft²'),
              ],
              tables: [
                _a11yTable(
                  rows: const [
                    CoreSizeCardData(id: '1', values: ['10', '20']),
                    CoreSizeCardData(id: '2', values: ['30', '40']),
                  ],
                  onDeleted: (_) {},
                  onReordered: (_, __) {},
                ),
              ],
            ),
          ),
        ),
      );

      final dimensionsText = find.text(CoreGeometryArea.defaultDimensionsLabel);
      final expandText = find.text(CoreGeometryArea.defaultExpandLabel);
      final sizesTitleText = find.text(_sizesTitle);
      final addSizeText = find.text(_addSizeLabel);
      final attachmentsText =
          find.text(CoreGeometryArea.defaultAttachmentsTitleLabel);
      final viewAllText =
          find.text(CoreGeometryArea.defaultViewAllAttachmentsLabel);
      final mediaText = find.text(CoreGeometryArea.defaultMediaButtonLabel);
      final documentText =
          find.text(CoreGeometryArea.defaultDocumentButtonLabel);

      expect(dimensionsText, findsOneWidget);
      expect(expandText, findsOneWidget);
      expect(sizesTitleText, findsOneWidget);
      expect(addSizeText, findsOneWidget);
      expect(attachmentsText, findsOneWidget);
      expect(viewAllText, findsOneWidget);
      expect(mediaText, findsOneWidget);
      expect(documentText, findsOneWidget);

      final viewAllFinder = find
          .bySemanticsLabel(CoreGeometryArea.defaultViewAllAttachmentsLabel);
      expect(viewAllFinder, findsOneWidget);
      final viewAllSemantics = tester.getSemantics(viewAllFinder);
      expect(viewAllSemantics.flagsCollection.isButton, isTrue);

      final dimSemantics = tester.getSemantics(dimensionsText);
      expect(dimSemantics.label, CoreGeometryArea.defaultDimensionsLabel);

      final sizesTitleSemantics = tester.getSemantics(sizesTitleText);
      expect(sizesTitleSemantics.label, _sizesTitle);

      final expSemantics = tester.getSemantics(expandText);
      expect(expSemantics.label, CoreGeometryArea.defaultExpandLabel);

      final addSizeSemantics = tester.getSemantics(addSizeText);
      expect(addSizeSemantics.label, _addSizeLabel);

      // Assert the icons that matter are present and labelled, rather than a
      // total that any unrelated icon change would break.
      for (final label in [
        CoreGeometryArea.defaultExpandLabel,
        'Edit 10',
        'Delete 10',
        'Edit 30',
        'Delete 30',
      ]) {
        expect(find.bySemanticsLabel(label), findsOneWidget, reason: label);
      }

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

      expect(semanticsWidgets, hasLength(4),
          reason:
              'A 2-row list produces 4 action-bearing Semantics widgets (2 for reorder, 2 for delete)');

      final element = tester.element(find.byType(CoreGeometryArea));
      final materialLocalizations = MaterialLocalizations.of(element);
      final widgetsLocalizations = WidgetsLocalizations.of(element);

      final actionSets = semanticsWidgets
          .map((w) =>
              w.properties.customSemanticsActions!.keys.map((a) => a.label))
          .toList();

      expect(actionSets[0], contains(widgetsLocalizations.reorderItemDown));
      expect(
          actionSets[1], contains(materialLocalizations.deleteButtonTooltip));
      expect(actionSets[2], contains(widgetsLocalizations.reorderItemUp));
      expect(
          actionSets[3], contains(materialLocalizations.deleteButtonTooltip));

      final dragHandleFinder = find.byWidgetPredicate(
        (widget) =>
            widget is CoreIconWidget && widget.icon == CoreIcons.dragIndicator,
      );
      expect(tester.getSemantics(dragHandleFinder.first).label,
          startsWith(_dragHandleLabel));
    });

    testWidgets('the row action buttons are activatable, not just labelled',
        (WidgetTester tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreGeometryArea(
              onMediaButtonPressed: () {},
              onDocumentButtonPressed: () {},
              tables: [
                _a11yTable(
                  rows: const [
                    CoreSizeCardData(id: '1', values: ['10', '20']),
                  ],
                  onDeleted: (_) {},
                ),
              ],
            ),
          ),
        ),
      );

      // excludeSemantics drops the GestureDetector's own node, so without an
      // onTap on the Semantics itself these would announce as buttons that
      // refuse to activate — and the tap-target guideline, which only inspects
      // nodes carrying a tap action, would pass vacuously.
      for (final label in ['Edit 10', 'Delete 10']) {
        final data =
            tester.getSemantics(find.bySemanticsLabel(label)).getSemanticsData();
        expect(data.flagsCollection.isButton, isTrue, reason: label);
        expect(data.hasAction(SemanticsAction.tap), isTrue, reason: label);
      }

      handle.dispose();
    });

    testWidgets('a read-only row advertises no custom semantics actions',
        (WidgetTester tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreGeometryArea(
              onMediaButtonPressed: () {},
              onDocumentButtonPressed: () {},
              tables: [
                _a11yTable(
                  rows: const [
                    CoreSizeCardData(id: 'ft3', values: ['10', '20']),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      // An empty customSemanticsActions map still sets
      // SemanticsAction.customAction, which makes a screen reader offer an
      // empty actions menu on every read-only row.
      expect(
        tester.getSemantics(find.text('10')).getSemanticsData().hasAction(
              SemanticsAction.customAction,
            ),
        isFalse,
      );

      handle.dispose();
    });
  });
}
