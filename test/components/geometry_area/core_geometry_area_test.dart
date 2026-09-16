import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

/// Builds a table whose affordances are all enabled unless overridden, so each
/// test can turn a single callback off and assert what disappears.
CoreSizesTableData _table({
  String title = 'Table title',
  List<String> columnTitles = const ['Col A', 'Col B'],
  List<CoreSizeCardData> rows = const [],
  String? addLabel = 'Add size',
  String? editLabel = 'Edit size',
  String? dragHandleLabel = 'Reorder',
  VoidCallback? onAdd,
  void Function(SizeEntryResult result)? onSaved,
  void Function(String id)? onDeleted,
  void Function(int oldIndex, int newIndex)? onReordered,
}) {
  return CoreSizesTableData(
    title: title,
    columns: columnTitles.map((t) => CoreSizesColumn(title: t)).toList(),
    rows: rows,
    addLabel: addLabel,
    editLabel: editLabel,
    dragHandleLabel: dragHandleLabel,
    onAdd: onAdd,
    onSaved: onSaved ?? (_) {},
    onDeleted: onDeleted,
    onReordered: onReordered,
  );
}

Widget _app(Widget child) => MaterialApp(
      theme: CoreTheme.light(),
      home: Scaffold(body: child),
    );

Finder get _dragHandles => find.byWidgetPredicate(
      (widget) =>
          widget is CoreIconWidget && widget.icon == CoreIcons.dragIndicator,
    );

void main() {
  group('CoreGeometryArea', () {
    testWidgets('renders geometry area with default labels', (tester) async {
      await tester.pumpWidget(
        _app(CoreGeometryArea(
          onMediaButtonPressed: () {},
          onDocumentButtonPressed: () {},
          tables: [_table()],
        )),
      );

      expect(find.byType(CoreGeometryArea), findsOneWidget);
      expect(
          find.text(CoreGeometryArea.defaultDimensionsLabel), findsOneWidget);
      expect(find.text(CoreGeometryArea.defaultExpandLabel), findsOneWidget);
      expect(find.text('Table title'), findsOneWidget);
      expect(find.text('Add size'), findsOneWidget);
    });

    testWidgets('renders geometry area with custom labels', (tester) async {
      const customDimensions = 'Custom Dimensions';
      const customExpand = 'Custom Expand';

      await tester.pumpWidget(
        _app(CoreGeometryArea(
          onMediaButtonPressed: () {},
          onDocumentButtonPressed: () {},
          dimensionsLabel: customDimensions,
          expandLabel: customExpand,
          tables: [
            _table(title: 'Custom Sizes', addLabel: 'Custom Add Size'),
          ],
        )),
      );

      expect(find.byType(CoreGeometryArea), findsOneWidget);
      expect(find.text(customDimensions), findsOneWidget);
      expect(find.text(customExpand), findsOneWidget);
      expect(find.text('Custom Sizes'), findsOneWidget);
      expect(find.text('Custom Add Size'), findsOneWidget);
      expect(find.text(CoreGeometryArea.defaultDimensionsLabel), findsNothing);
      expect(find.text(CoreGeometryArea.defaultExpandLabel), findsNothing);
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
              dimensions: const [
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

    testWidgets('renders column titles when provided', (tester) async {
      await tester.pumpWidget(
        _app(CoreGeometryArea(
          onMediaButtonPressed: () {},
          onDocumentButtonPressed: () {},
          tables: [
            _table(columnTitles: const ['Area Header', 'Volume Header']),
          ],
        )),
      );

      expect(find.text('Area Header'), findsOneWidget);
      expect(find.text('Volume Header'), findsOneWidget);
    });

    testWidgets('does not render a table whose columns are empty',
        (tester) async {
      await tester.pumpWidget(
        _app(CoreGeometryArea(
          onMediaButtonPressed: () {},
          onDocumentButtonPressed: () {},
          tables: [_table(columnTitles: const [])],
        )),
      );

      expect(find.text('Table title'), findsNothing);
      expect(find.text('Add size'), findsNothing);
    });

    testWidgets('renders rows correctly and handles edge cases',
        (tester) async {
      await tester.pumpWidget(
        _app(CoreGeometryArea(
          onMediaButtonPressed: () {},
          onDocumentButtonPressed: () {},
          tables: [_table()],
        )),
      );

      expect(find.text('Val 1'), findsNothing);
      expect(find.text('Table title'), findsOneWidget);

      await tester.pumpWidget(
        _app(CoreGeometryArea(
          onMediaButtonPressed: () {},
          onDocumentButtonPressed: () {},
          tables: [
            _table(rows: const [
              CoreSizeCardData(id: '1', values: ['Val 1', 'Val 2']),
              CoreSizeCardData(id: '2', values: ['Val 3', 'Val 4']),
            ]),
          ],
        )),
      );

      expect(find.text('Val 1'), findsOneWidget);
      expect(find.text('Val 2'), findsOneWidget);
      expect(find.text('Val 3'), findsOneWidget);
      expect(find.text('Val 4'), findsOneWidget);
    });

    testWidgets('renders each table with independent callbacks',
        (tester) async {
      final deletedIds = <String>[];
      final reorderCalls = <(int, int)>[];

      await tester.pumpWidget(
        _app(CoreGeometryArea(
          onMediaButtonPressed: () {},
          onDocumentButtonPressed: () {},
          tables: [
            _table(
              title: 'Sheet quantities',
              columnTitles: const ['Size'],
              rows: const [
                CoreSizeCardData(id: 'sheet-1', values: ['47.24in']),
              ],
              onDeleted: deletedIds.add,
              onReordered: (o, n) => reorderCalls.add((o, n)),
            ),
            _table(
              title: 'Rates & waste',
              columnTitles: const ['Per unit'],
              rows: const [
                CoreSizeCardData(id: 'rate-1', values: [r'$6.5']),
              ],
              addLabel: null,
            ),
            _table(
              title: 'Densities',
              columnTitles: const ['Material'],
              rows: const [
                CoreSizeCardData(id: 'density-1', values: ['concrete']),
              ],
              addLabel: null,
            ),
          ],
        )),
      );

      expect(find.text('Sheet quantities'), findsOneWidget);
      expect(find.text('Rates & waste'), findsOneWidget);
      expect(find.text('Densities'), findsOneWidget);

      // Only the first table is reorderable and deletable, so only its rows
      // carry a drag handle and respond to a swipe.
      expect(_dragHandles, findsOneWidget);

      await tester.drag(find.text(r'$6.5'), const Offset(-500, 0));
      await tester.pumpAndSettle();
      expect(deletedIds, isEmpty,
          reason: 'swiping a table without onDeleted must not delete');

      await tester.drag(find.text('47.24in'), const Offset(-500, 0));
      await tester.pumpAndSettle();
      expect(deletedIds, ['sheet-1']);
    });

    testWidgets('hides the add action when addLabel is null', (tester) async {
      await tester.pumpWidget(
        _app(CoreGeometryArea(
          onMediaButtonPressed: () {},
          onDocumentButtonPressed: () {},
          tables: [_table(addLabel: null)],
        )),
      );

      expect(find.text('Table title'), findsOneWidget);
      expect(find.text('Add size'), findsNothing);
    });

    testWidgets('hides drag handles when onReordered is null', (tester) async {
      await tester.pumpWidget(
        _app(CoreGeometryArea(
          onMediaButtonPressed: () {},
          onDocumentButtonPressed: () {},
          tables: [
            _table(rows: const [
              CoreSizeCardData(id: '1', values: ['Val 1', 'Val 2']),
            ]),
          ],
        )),
      );

      expect(find.text('Val 1'), findsOneWidget);
      expect(_dragHandles, findsNothing);
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
                  tables: [
                    _table(
                      columnTitles: const ['Col'],
                      rows: data,
                      onReordered: (oldIndex, newIndex) {
                        reorderCalls.add((oldIndex, newIndex));
                        setState(() {
                          final item = data.removeAt(oldIndex);
                          data.insert(newIndex, item);
                        });
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      final dragHandles = _dragHandles;
      expect(dragHandles, findsNWidgets(3));

      await tester.drag(dragHandles.first, const Offset(0, 100));
      await tester.pumpAndSettle();

      expect(reorderCalls.length, 1);
      expect(reorderCalls.first, (0, 1));
      await tester.pump(const Duration(milliseconds: 500));
    });

    testWidgets(
        'dragging an item to a later, non-adjacent position drops it at the '
        'correct final index', (WidgetTester tester) async {
      final reorderCalls = <(int, int)>[];
      var data = [
        const CoreSizeCardData(id: '1', values: ['A']),
        const CoreSizeCardData(id: '2', values: ['B']),
        const CoreSizeCardData(id: '3', values: ['C']),
        const CoreSizeCardData(id: '4', values: ['D']),
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
                  tables: [
                    _table(
                      columnTitles: const ['Col'],
                      rows: data,
                      onReordered: (oldIndex, newIndex) {
                        reorderCalls.add((oldIndex, newIndex));
                        setState(() {
                          final item = data.removeAt(oldIndex);
                          data.insert(newIndex, item);
                        });
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      final dragHandles = _dragHandles;
      expect(dragHandles, findsNWidgets(4));

      // Drag the first card past two other rows so it lands at index 2,
      // not just the adjacent slot.
      await tester.drag(dragHandles.first, const Offset(0, 150));
      await tester.pumpAndSettle();

      expect(reorderCalls.length, 1);
      expect(reorderCalls.first, (0, 2));
      expect(data.map((e) => e.id).toList(), ['2', '3', '1', '4']);
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
                  tables: [
                    _table(
                      columnTitles: const ['Col'],
                      rows: data,
                      onReordered: (oldIndex, newIndex) {
                        setState(() {
                          final item = data.removeAt(oldIndex);
                          data.insert(newIndex, item);
                        });
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      final dragHandles = _dragHandles;

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

    testWidgets('swiping a size card triggers onDeleted', (tester) async {
      String? deletedId;

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreGeometryArea(
              onMediaButtonPressed: () {},
              onDocumentButtonPressed: () {},
              tables: [
                _table(
                  columnTitles: const ['Col A'],
                  rows: const [
                    CoreSizeCardData(id: '1', values: ['Val 1']),
                    CoreSizeCardData(id: '2', values: ['Val 2']),
                  ],
                  onDeleted: (id) {
                    deletedId = id;
                  },
                ),
              ],
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

    testWidgets('hides media and document buttons when both callbacks are null',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreGeometryArea(),
          ),
        ),
      );

      final mediaFinder = find.widgetWithText(
          CoreButton, CoreGeometryArea.defaultMediaButtonLabel);
      final documentFinder = find.widgetWithText(
          CoreButton, CoreGeometryArea.defaultDocumentButtonLabel);

      expect(mediaFinder, findsNothing);
      expect(documentFinder, findsNothing);
    });

    testWidgets('renders only media button when document callback is null',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreGeometryArea(
              onMediaButtonPressed: () {},
            ),
          ),
        ),
      );

      final mediaFinder = find.widgetWithText(
          CoreButton, CoreGeometryArea.defaultMediaButtonLabel);
      final documentFinder = find.widgetWithText(
          CoreButton, CoreGeometryArea.defaultDocumentButtonLabel);

      expect(mediaFinder, findsOneWidget);
      expect(documentFinder, findsNothing);
    });

    testWidgets('renders only document button when media callback is null',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreGeometryArea(
              onDocumentButtonPressed: () {},
            ),
          ),
        ),
      );

      final mediaFinder = find.widgetWithText(
          CoreButton, CoreGeometryArea.defaultMediaButtonLabel);
      final documentFinder = find.widgetWithText(
          CoreButton, CoreGeometryArea.defaultDocumentButtonLabel);

      expect(mediaFinder, findsNothing);
      expect(documentFinder, findsOneWidget);
    });
  });
}
