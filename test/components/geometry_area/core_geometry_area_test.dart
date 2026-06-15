import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

void main() {
  group('CoreGeometryArea', () {
    testWidgets('renders geometry area with default labels', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreGeometryArea(
              onMediaButtonPressed: () {},
              onDocumentButtonPressed: () {},
              sizesTableTitles: ['dummy'],
            ),
          ),
        ),
      );

      expect(find.byType(CoreGeometryArea), findsOneWidget);
      expect(
          find.text(CoreGeometryArea.defaultDimensionsLabel), findsOneWidget);
      expect(find.text(CoreGeometryArea.defaultExpandLabel), findsOneWidget);
      expect(
          find.text(CoreGeometryArea.defaultSizesTitleLabel), findsOneWidget);
      expect(find.text(CoreGeometryArea.defaultAddSizeLabel), findsOneWidget);
    });

    testWidgets('renders geometry area with custom labels', (tester) async {
      const customDimensions = 'Custom Dimensions';
      const customExpand = 'Custom Expand';
      const customSizesTitle = 'Custom Sizes';
      const customAddSize = 'Custom Add Size';

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreGeometryArea(
              onMediaButtonPressed: () {},
              onDocumentButtonPressed: () {},
              dimensionsLabel: customDimensions,
              expandLabel: customExpand,
              sizesTitleLabel: customSizesTitle,
              addSizeLabel: customAddSize,
              sizesTableTitles: const ['dummy'],
            ),
          ),
        ),
      );

      expect(find.byType(CoreGeometryArea), findsOneWidget);
      expect(find.text(customDimensions), findsOneWidget);
      expect(find.text(customExpand), findsOneWidget);
      expect(find.text(customSizesTitle), findsOneWidget);
      expect(find.text(customAddSize), findsOneWidget);
      expect(find.text(CoreGeometryArea.defaultDimensionsLabel), findsNothing);
      expect(find.text(CoreGeometryArea.defaultExpandLabel), findsNothing);
      expect(find.text(CoreGeometryArea.defaultSizesTitleLabel), findsNothing);
      expect(find.text(CoreGeometryArea.defaultAddSizeLabel), findsNothing);
    });

    testWidgets('renders dimensions when provided', (tester) async {
      const dimensions = [
        CoreDimensionData(label: 'Area', value: '50.27ft²'),
        CoreDimensionData(label: 'Diameter', value: '8ft'),
      ];

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreGeometryArea(
              onMediaButtonPressed: () {},
              onDocumentButtonPressed: () {},
              dimensions: dimensions,
              isCollapsed: false,
            ),
          ),
        ),
      );

      expect(find.text('Area'), findsOneWidget);
      expect(find.text('50.27ft²'), findsOneWidget);
      expect(find.text('Diameter'), findsOneWidget);
      expect(find.text('8ft'), findsOneWidget);
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('toggles expand and collapse states on tap', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreGeometryArea(
              onMediaButtonPressed: () {},
              onDocumentButtonPressed: () {},
              dimensions: [
                CoreDimensionData(label: 'Area', value: '50.27ft²'),
                CoreDimensionData(label: 'Diameter', value: '8ft'),
                CoreDimensionData(label: 'Radius', value: '4ft'),
              ],
            ),
          ),
        ),
      );
      expect(find.text(CoreGeometryArea.defaultExpandLabel), findsOneWidget);
      expect(find.text(CoreGeometryArea.defaultCollapseLabel), findsNothing);
      await tester.tap(find.text(CoreGeometryArea.defaultExpandLabel));
      await tester.pumpAndSettle();
      expect(find.text(CoreGeometryArea.defaultCollapseLabel), findsOneWidget);
      expect(find.text(CoreGeometryArea.defaultExpandLabel), findsNothing);
      await tester.tap(find.text(CoreGeometryArea.defaultCollapseLabel));
      await tester.pumpAndSettle();
      expect(find.text(CoreGeometryArea.defaultExpandLabel), findsOneWidget);
    });

    testWidgets('syncs when parent changes isCollapsed prop', (tester) async {
      bool collapsed = true;
      late StateSetter outerSetState;
      await tester.pumpWidget(StatefulBuilder(
        builder: (context, setState) {
          outerSetState = setState;
          return MaterialApp(
            theme: CoreTheme.light(),
            home: Scaffold(
              body: CoreGeometryArea(
                onMediaButtonPressed: () {},
                onDocumentButtonPressed: () {},
                isCollapsed: collapsed,
                dimensions: const [CoreDimensionData(label: 'A', value: '1')],
              ),
            ),
          );
        },
      ));
      expect(find.text(CoreGeometryArea.defaultExpandLabel), findsOneWidget);
      outerSetState(() => collapsed = false);
      await tester.pumpAndSettle();
      expect(find.text(CoreGeometryArea.defaultCollapseLabel), findsOneWidget);
    });

    testWidgets('renders sizesTableTitles when provided', (tester) async {
      const titles = ['Area Header', 'Volume Header'];

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreGeometryArea(
              onMediaButtonPressed: () {},
              onDocumentButtonPressed: () {},
              sizesTableTitles: titles,
            ),
          ),
        ),
      );

      expect(find.text('Area Header'), findsOneWidget);
      expect(find.text('Volume Header'), findsOneWidget);
    });

    testWidgets('does not render header row when sizesTableTitles is empty',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreGeometryArea(
              onMediaButtonPressed: () {},
              onDocumentButtonPressed: () {},
              sizesTableTitles: const [],
            ),
          ),
        ),
      );

      expect(find.text(CoreGeometryArea.defaultSizesTitleLabel), findsNothing);
      expect(find.text(CoreGeometryArea.defaultAddSizeLabel), findsNothing);
    });

    testWidgets('renders sizesTableData correctly and handles edge cases',
        (tester) async {
      const titles = ['Col A', 'Col B'];

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreGeometryArea(
              onMediaButtonPressed: () {},
              onDocumentButtonPressed: () {},
              sizesTableTitles: titles,
              sizesTableData: const [],
            ),
          ),
        ),
      );

      expect(find.text('Val 1'), findsNothing);
      expect(
          find.text(CoreGeometryArea.defaultSizesTitleLabel), findsOneWidget);

      const data = [
        CoreSizeCardData(id: '1', values: ['Val 1', 'Val 2']),
        CoreSizeCardData(id: '2', values: ['Val 3', 'Val 4']),
      ];

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreGeometryArea(
              onMediaButtonPressed: () {},
              onDocumentButtonPressed: () {},
              sizesTableTitles: titles,
              sizesTableData: data,
            ),
          ),
        ),
      );

      expect(find.text('Val 1'), findsOneWidget);
      expect(find.text('Val 2'), findsOneWidget);
      expect(find.text('Val 3'), findsOneWidget);
      expect(find.text('Val 4'), findsOneWidget);
    });

    testWidgets('onReorder fires with adjusted index when dragging downward',
        (WidgetTester tester) async {
      final reorderCalls = <(int, int)>[];
      var data = [
        const CoreSizeCardData(id: '1', values: ['A']),
        const CoreSizeCardData(id: '2', values: ['B']),
        const CoreSizeCardData(id: '3', values: ['C']),
      ];

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return CoreGeometryArea(
                  onMediaButtonPressed: () {},
                  onDocumentButtonPressed: () {},
                  sizesTableTitles: const ['Col'],
                  sizesTableData: data,
                  onSizesReordered: (oldIndex, newIndex) {
                    reorderCalls.add((oldIndex, newIndex));
                    setState(() {
                      final item = data.removeAt(oldIndex);
                      data.insert(newIndex, item);
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      final dragHandles = find.byWidgetPredicate(
        (widget) =>
            widget is CoreIconWidget && widget.icon == CoreIcons.dragIndicator,
      );
      expect(dragHandles, findsNWidgets(3));

      await tester.drag(dragHandles.first, const Offset(0, 100));
      await tester.pumpAndSettle();

      expect(reorderCalls.length, 1);
      expect(reorderCalls.first, (0, 1));
      await tester.pump(const Duration(milliseconds: 500));
    });

    testWidgets('highlights the dropped card and clears it after 500ms',
        (WidgetTester tester) async {
      var data = [
        const CoreSizeCardData(id: '1', values: ['A']),
        const CoreSizeCardData(id: '2', values: ['B']),
      ];

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return CoreGeometryArea(
                  onMediaButtonPressed: () {},
                  onDocumentButtonPressed: () {},
                  sizesTableTitles: const ['Col'],
                  sizesTableData: data,
                  onSizesReordered: (oldIndex, newIndex) {
                    setState(() {
                      final item = data.removeAt(oldIndex);
                      data.insert(newIndex, item);
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      final dragHandles = find.byWidgetPredicate(
        (widget) =>
            widget is CoreIconWidget && widget.icon == CoreIcons.dragIndicator,
      );

      await tester.drag(dragHandles.first, const Offset(0, 100));
      await tester.pumpAndSettle();

      final highlightedCardFinder = find.byWidgetPredicate((w) {
        return w is DecoratedBox &&
            w.decoration is BoxDecoration &&
            (w.decoration as BoxDecoration).border != null &&
            (w.decoration as BoxDecoration).borderRadius ==
                BorderRadius.circular(CoreSpacing.space2);
      });

      expect(highlightedCardFinder, findsOneWidget,
          reason: 'Card should be highlighted immediately after drop');

      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      expect(highlightedCardFinder, findsNothing,
          reason: 'Highlight should be cleared after 500ms');
    });

    testWidgets('swiping a size card triggers onSizeDeleted', (tester) async {
      String? deletedId;

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreGeometryArea(
              onMediaButtonPressed: () {},
              onDocumentButtonPressed: () {},
              sizesTableTitles: const ['Col A'],
              sizesTableData: const [
                CoreSizeCardData(id: '1', values: ['Val 1']),
                CoreSizeCardData(id: '2', values: ['Val 2']),
              ],
              onSizeDeleted: (id) {
                deletedId = id;
              },
            ),
          ),
        ),
      );

      final itemToSwipe = find.text('Val 1');
      expect(itemToSwipe, findsOneWidget);

      await tester.drag(itemToSwipe, const Offset(-500.0, 0.0));
      await tester.pumpAndSettle();

      expect(deletedId, '1');
    });

    testWidgets('renders attachments section by default', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreGeometryArea(
              onMediaButtonPressed: () {},
              onDocumentButtonPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text(CoreGeometryArea.defaultAttachmentsTitleLabel),
          findsOneWidget);
      expect(find.text(CoreGeometryArea.defaultViewAllAttachmentsLabel),
          findsNothing);
    });

    testWidgets('renders attachments button when callback is provided',
        (tester) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreGeometryArea(
              onMediaButtonPressed: () {},
              onDocumentButtonPressed: () {},
              onViewAllAttachmentsPressed: () {
                wasPressed = true;
              },
            ),
          ),
        ),
      );

      expect(find.text(CoreGeometryArea.defaultViewAllAttachmentsLabel),
          findsOneWidget);
      expect(
        find.byWidgetPredicate((widget) =>
            widget is CoreIconWidget && widget.icon == CoreIcons.arrowRight),
        findsOneWidget,
      );

      await tester
          .tap(find.text(CoreGeometryArea.defaultViewAllAttachmentsLabel));
      await tester.pumpAndSettle();

      expect(wasPressed, isTrue);
    });

    testWidgets('media and document buttons render and fire callbacks',
        (tester) async {
      bool mediaPressed = false;
      bool documentPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreGeometryArea(
              onMediaButtonPressed: () {
                mediaPressed = true;
              },
              onDocumentButtonPressed: () {
                documentPressed = true;
              },
            ),
          ),
        ),
      );

      final mediaFinder = find.widgetWithText(
          CoreButton, CoreGeometryArea.defaultMediaButtonLabel);
      final documentFinder = find.widgetWithText(
          CoreButton, CoreGeometryArea.defaultDocumentButtonLabel);

      expect(mediaFinder, findsOneWidget);
      expect(documentFinder, findsOneWidget);

      await tester.tap(mediaFinder);
      await tester.pumpAndSettle();
      expect(mediaPressed, isTrue);

      await tester.tap(documentFinder);
      await tester.pumpAndSettle();
      expect(documentPressed, isTrue);
    });
  });
}
