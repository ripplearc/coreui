import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

/// Builds a table whose affordances are all enabled unless overridden, so each
/// test can turn a single callback off and assert what disappears.
CoreSizesTableData _table({
  String id = 'table',
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
  bool editable = true,
}) {
  return CoreSizesTableData(
    id: id,
    title: title,
    columns: columnTitles.map((t) => CoreSizesColumn(title: t)).toList(),
    rows: rows,
    dragHandleLabel: dragHandleLabel,
    onAdd: onAdd,
    // A table is editable unless a test asks otherwise. Defaulting onSaved to a
    // no-op unconditionally would leave a save path on every table a test
    // describes as read-only.
    onSaved: editable ? (onSaved ?? (_) {}) : null,
    editLabel: editable ? editLabel : null,
    addLabel: editable ? addLabel : null,
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

/// The entry sheet mounts a full [CoreKeyboard] over the geometry area, which
/// does not fit the default 800x600 surface. Tests that open the sheet need a
/// phone-sized viewport or the keyboard overflows before it can be tapped.
void _setTestViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}

/// The sheet commits through the keyboard's result button. Anchored on the type
/// rather than its text because the rendered label is currently '=': the sheet
/// passes `customResultLabel: 'Add'`/`'Update'` but [CoreResultButton] renders
/// [ResultType.label] and ignores it — a follow-up noted on PR #169. The type
/// finder keeps these tests honest either way.
Finder get _sheetSubmit => find.byType(CoreResultButton);

/// Scopes a finder to the open entry sheet. The table underneath keeps its own
/// add label and row values in the tree, so an unscoped [find.text] cannot say
/// whether the sheet or the table behind it carries the match.
Finder _inSheet(Finder matching) => find.descendant(
      of: find.byType(SizeEntryBottomSheet),
      matching: matching,
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
              id: 'sheets',
              title: 'Sheet quantities',
              columnTitles: const ['Size'],
              rows: const [
                CoreSizeCardData(id: 'sheet-1', values: ['47.24in']),
              ],
              onDeleted: deletedIds.add,
              onReordered: (o, n) => reorderCalls.add((o, n)),
            ),
            _table(
              id: 'rates',
              title: 'Rates & waste',
              columnTitles: const ['Per unit'],
              rows: const [
                CoreSizeCardData(id: 'rate-1', values: [r'$6.5']),
              ],
              editable: false,
            ),
            _table(
              id: 'densities',
              title: 'Densities',
              columnTitles: const ['Material'],
              rows: const [
                CoreSizeCardData(id: 'density-1', values: ['concrete']),
              ],
              editable: false,
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

    testWidgets('a non-reorderable table still supports swipe-to-delete',
        (tester) async {
      final deleted = <String>[];
      final rows = <CoreSizeCardData>[
        const CoreSizeCardData(id: 'a', values: ['A1', 'A2']),
        const CoreSizeCardData(id: 'b', values: ['B1', 'B2']),
      ];

      await tester.pumpWidget(
        _app(StatefulBuilder(
          builder: (context, setState) => CoreGeometryArea(
            onMediaButtonPressed: () {},
            onDocumentButtonPressed: () {},
            tables: [
              _table(
                rows: rows,
                onDeleted: (id) {
                  deleted.add(id);
                  setState(() => rows.removeWhere((r) => r.id == id));
                },
              ),
            ],
          ),
        )),
      );

      expect(_dragHandles, findsNothing);

      await tester.drag(find.text('A1'), const Offset(-500, 0));
      await tester.pumpAndSettle();

      expect(deleted, ['a']);
      expect(find.text('A1'), findsNothing);
    });

    testWidgets('two tables may share column titles', (tester) async {
      // Keying the tables on their display strings made this throw
      // "Duplicate keys found" — a rates and a waste table legitimately share
      // headers, so identity has to come from the caller's id.
      await tester.pumpWidget(
        _app(CoreGeometryArea(
          onMediaButtonPressed: () {},
          onDocumentButtonPressed: () {},
          tables: [
            _table(
              id: 'rates',
              title: 'Rates',
              columnTitles: const ['Per unit', 'Value'],
              rows: const [
                CoreSizeCardData(id: 'r1', values: ['ft3', r'$6.5']),
              ],
            ),
            _table(
              id: 'waste',
              title: 'Waste',
              columnTitles: const ['Per unit', 'Value'],
              rows: const [
                CoreSizeCardData(id: 'w1', values: ['ft3', '0%']),
              ],
            ),
          ],
        )),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Rates'), findsOneWidget);
      expect(find.text('Waste'), findsOneWidget);
    });

    testWidgets('sibling tables must have unique ids', (tester) async {
      await tester.pumpWidget(
        _app(CoreGeometryArea(
          onMediaButtonPressed: () {},
          onDocumentButtonPressed: () {},
          tables: [
            _table(id: 'same', title: 'First'),
            _table(id: 'same', title: 'Second'),
          ],
        )),
      );

      // Without the assert this is a framework "Duplicate keys found" error
      // that never names CoreSizesTableData.id.
      expect(tester.takeException(), isAssertionError);
    });

    group('label and callback pairing', () {
      test('a reorderable table requires dragHandleLabel', () {
        expect(
          () => CoreSizesTableData(
            id: 'reorderable',
            title: 'Reorderable',
            columns: const [CoreSizesColumn(title: 'Col')],
            rows: const [],
            dragHandleLabel: null,
            onReordered: (_, __) {},
          ),
          throwsAssertionError,
          reason: 'an unlabelled drag handle announces the row text instead',
        );
      });

      test('a table with onSaved requires editLabel', () {
        expect(
          () => CoreSizesTableData(
            id: 'editable',
            title: 'Editable',
            columns: const [CoreSizesColumn(title: 'Col')],
            rows: const [],
            editLabel: null,
            onSaved: (_) {},
          ),
          throwsAssertionError,
          reason: 'the entry sheet would open with no title',
        );
      });

      test('onAdd requires addLabel', () {
        expect(
          () => CoreSizesTableData(
            id: 'addable',
            title: 'Addable',
            columns: const [CoreSizesColumn(title: 'Col')],
            rows: const [],
            addLabel: null,
            onAdd: () {},
          ),
          throwsAssertionError,
          reason: 'addLabel is what renders the add action',
        );
      });
    });

    // The add action picks between three outcomes: an app-owned flow, the
    // built-in entry sheet, or nothing at all. Before several tables there was
    // only ever the sheet, so the fork is new and each arm needs pinning.
    group('add and edit entry points', () {
      testWidgets('onAdd takes over the add action from the built-in sheet',
          (tester) async {
        _setTestViewport(tester);
        var addTaps = 0;

        await tester.pumpWidget(
          _app(CoreGeometryArea(
            onMediaButtonPressed: () {},
            onDocumentButtonPressed: () {},
            tables: [_table(onAdd: () => addTaps++)],
          )),
        );

        await tester.tap(find.bySemanticsLabel('Add size'));
        await tester.pumpAndSettle();

        expect(addTaps, 1);
        expect(
          find.byType(SizeEntryBottomSheet),
          findsNothing,
          reason: 'onAdd means the app owns the flow; the sheet must stay shut',
        );
      });

      testWidgets('the add action falls back to the sheet, which reports '
          'through onSaved', (tester) async {
        _setTestViewport(tester);
        final saved = <SizeEntryResult>[];

        await tester.pumpWidget(
          _app(CoreGeometryArea(
            onMediaButtonPressed: () {},
            onDocumentButtonPressed: () {},
            tables: [_table(onSaved: saved.add)],
          )),
        );

        await tester.tap(find.bySemanticsLabel('Add size'));
        await tester.pumpAndSettle();

        expect(find.byType(SizeEntryBottomSheet), findsOneWidget);
        expect(
          _inSheet(find.text('Add size')),
          findsOneWidget,
          reason: "the sheet's title comes from addLabel",
        );
        expect(_inSheet(find.text('Col A*')), findsOneWidget);
        expect(_inSheet(find.text('Col B*')), findsOneWidget);

        // Typed through the keyboard rather than submitted empty: without a
        // value to carry, the assertions below could not tell a correct commit
        // from one that reports back nothing the user entered. The first field
        // takes focus when the sheet opens, so the digit lands in Col A.
        await tester.tap(_inSheet(find.text('7')));
        await tester.pumpAndSettle();

        await tester.tap(_sheetSubmit);
        await tester.pumpAndSettle();

        expect(saved, hasLength(1));
        expect(saved.single.intent, SizeOperationIntent.add);
        expect(saved.single.values, ['7', '']);
        expect(
          saved.single.index,
          isNull,
          reason: 'an addition has no row to index',
        );
      });

      testWidgets('tapping a row opens the sheet in edit mode',
          (tester) async {
        _setTestViewport(tester);
        final saved = <SizeEntryResult>[];

        await tester.pumpWidget(
          _app(CoreGeometryArea(
            onMediaButtonPressed: () {},
            onDocumentButtonPressed: () {},
            tables: [
              _table(
                rows: const [
                  CoreSizeCardData(id: 'first', values: ['A1', 'A2']),
                  CoreSizeCardData(id: 'second', values: ['B1', 'B2']),
                ],
                onSaved: saved.add,
              ),
            ],
          )),
        );

        await tester.tap(find.text('B1'));
        await tester.pumpAndSettle();

        expect(find.byType(SizeEntryBottomSheet), findsOneWidget);
        expect(
          _inSheet(find.text('Edit size')),
          findsOneWidget,
          reason: 'editing shows editLabel, not addLabel',
        );
        expect(
          _inSheet(find.text('B1')),
          findsOneWidget,
          reason: "the tapped row's values pre-fill the fields",
        );
        expect(
          _inSheet(find.text('B2')),
          findsOneWidget,
          reason: 'every column of the tapped row pre-fills, not just the first',
        );

        await tester.tap(_sheetSubmit);
        await tester.pumpAndSettle();

        expect(saved, hasLength(1));
        expect(saved.single.intent, SizeOperationIntent.edit);
        expect(
          saved.single.index,
          1,
          reason: 'the sheet reports back the row the user tapped',
        );
        expect(saved.single.values, ['B1', 'B2']);
      });

      testWidgets('a read-only row has nothing to tap', (tester) async {
        _setTestViewport(tester);

        await tester.pumpWidget(
          _app(CoreGeometryArea(
            onMediaButtonPressed: () {},
            onDocumentButtonPressed: () {},
            tables: [
              _table(
                rows: const [
                  CoreSizeCardData(id: 'rate', values: [r'$6.5', '10%']),
                ],
                editable: false,
              ),
            ],
          )),
        );

        await tester.tap(find.text(r'$6.5'));
        await tester.pumpAndSettle();

        expect(
          find.byType(SizeEntryBottomSheet),
          findsNothing,
          reason: 'a table with no edit affordance opens nothing',
        );
      });

      testWidgets('it is onSaved, not the labels, that makes a row tappable',
          (tester) async {
        _setTestViewport(tester);

        // Built inline because the _table helper drops onSaved, editLabel and
        // addLabel together, which cannot say which of the three gates the tap.
        // Only editLabel is kept here: the constructor allows it without
        // onSaved, so a caller can reach this combination, whereas addLabel
        // without either callback is asserted against. Gating the tap on the
        // label instead would open a sheet whose submit silently discards the
        // edit, since there is no onSaved to receive it.
        await tester.pumpWidget(
          _app(CoreGeometryArea(
            onMediaButtonPressed: () {},
            onDocumentButtonPressed: () {},
            tables: [
              const CoreSizesTableData(
                id: 'labelled-but-read-only',
                title: 'Table title',
                columns: [
                  CoreSizesColumn(title: 'Col A'),
                  CoreSizesColumn(title: 'Col B'),
                ],
                rows: [
                  CoreSizeCardData(id: 'only', values: ['A1', 'A2']),
                ],
                editLabel: 'Edit size',
                onSaved: null,
              ),
            ],
          )),
        );

        await tester.tap(find.text('A1'));
        await tester.pumpAndSettle();

        expect(
          find.byType(SizeEntryBottomSheet),
          findsNothing,
          reason: 'onSaved is the callback that receives the edit, so it is '
              'what decides whether a row can be tapped at all',
        );
      });
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
