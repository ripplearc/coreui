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
    editRowSemanticsLabelBuilder: (row) => 'Edit ${row.values.first}',
    deleteRowSemanticsLabelBuilder: (row) => 'Delete ${row.values.first}',
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

/// Drags the first row's handle down by [rows] row-heights, in half-row steps.
///
/// Measured at runtime and stepped rather than one jump: a single large
/// `tester.drag` against `ReorderableListView` lands non-monotonically, and
/// hard-coded pixel offsets break whenever the row height changes.
Future<void> _dragFirstRowDown(WidgetTester tester, double rows) async {
  final rowHeight = tester
      .getSize(find.byWidgetPredicate((w) => w is Dismissible).first)
      .height;
  final gesture = await tester.startGesture(tester.getCenter(_dragHandles.first));
  await tester.pump(const Duration(milliseconds: 200));
  for (var i = 0; i < (rows * 2).round(); i++) {
    await gesture.moveBy(Offset(0, rowHeight / 2));
    await tester.pump();
  }
  await gesture.up();
  await tester.pumpAndSettle();
}

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

    testWidgets('a row must supply one value per column', (tester) async {
      // The failed build substitutes an ErrorWidget tall enough to overflow the
      // column around it, so a second, incidental exception follows the one
      // under test. Collecting them all keeps the assertion on the first.
      final List<FlutterErrorDetails> errors = [];
      final originalOnError = FlutterError.onError;

      FlutterError.onError = (details) => errors.add(details);
      addTearDown(() => FlutterError.onError = originalOnError);

      await tester.pumpWidget(
        _app(CoreGeometryArea(
          onMediaButtonPressed: () {},
          onDocumentButtonPressed: () {},
          tables: [
            _table(
              columnTitles: const ['Col A', 'Col B'],
              rows: const [CoreSizeCardData(id: '1', values: ['Val 1'])],
            ),
          ],
        )),
      );

      // Checked in _buildRows rather than the const constructor, which cannot
      // inspect the rows and stay const. Without the assert the mismatch
      // surfaces deeper, in a message naming _SizeCard's columnWidths — an
      // internal the consumer has no name for, so the message is the point.
      expect(
        errors.map((e) => e.exception).whereType<AssertionError>().any(
              (e) => e.message.toString().contains(
                    'row "1" has 1 values but the table declares 2 columns',
                  ),
            ),
        isTrue,
        reason: 'the mismatch must be named in terms the caller passed in',
      );
    });

    testWidgets('renders each table with independent callbacks',
        (tester) async {
      // Three tables of 72 dp rows exceed the default 600 dp test surface.
      // CoreGeometryArea is mainAxisSize.min and leaves scrolling to its
      // parent, so the fixture supplies the room instead.
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

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

    test('a table id must not be empty', () {
      expect(
        () => CoreSizesTableData(
          id: '',
          title: 'Unidentified',
          columns: const [CoreSizesColumn(title: 'Col')],
          rows: const [],
        ),
        throwsAssertionError,
        reason: 'the id keys the table across rebuilds, so it must name one',
      );
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

    group('row actions', () {
      Finder editButtons() => find.byWidgetPredicate(
            (w) => w is CoreIconWidget && w.icon == CoreIcons.edit,
          );
      Finder deleteButtons() => find.byWidgetPredicate(
            (w) => w is CoreIconWidget && w.icon == CoreIcons.delete,
          );

      testWidgets('an editable, deletable row renders both buttons',
          (tester) async {
        await tester.pumpWidget(
          _app(CoreGeometryArea(
            onMediaButtonPressed: () {},
            onDocumentButtonPressed: () {},
            tables: [
              _table(
                rows: const [
                  CoreSizeCardData(id: '1', values: ['Val 1', 'Val 2']),
                ],
                onDeleted: (_) {},
              ),
            ],
          )),
        );

        expect(editButtons(), findsOneWidget);
        // Only the row's button: Dismissible builds its swipe background
        // lazily, once a drag starts.
        expect(deleteButtons(), findsOneWidget);
      });

      testWidgets('a read-only table renders neither button', (tester) async {
        await tester.pumpWidget(
          _app(CoreGeometryArea(
            onMediaButtonPressed: () {},
            onDocumentButtonPressed: () {},
            tables: const [
              CoreSizesTableData(
                id: 'rates',
                title: 'Rates',
                columns: [CoreSizesColumn(title: 'Per unit')],
                rows: [
                  CoreSizeCardData(id: 'ft3', values: [r'$6.5']),
                ],
              ),
            ],
          )),
        );

        expect(editButtons(), findsNothing);
        expect(deleteButtons(), findsNothing);
      });

      // The reserved action slot is two independent terms, one per callback.
      // "Both buttons" and "neither button" above agree on a flat 96 dp and a
      // flat 0, so neither can tell a per-callback reservation from a
      // table-wide one: reserving two buttons whenever either callback is set
      // passes both of them.
      //
      // Icon count cannot pin it either. The row builds its buttons straight
      // from the callbacks, so the icons stay right even when the reservation
      // is wrong. `actionsWidth` is read by the header, which mirrors the
      // row's action slot so the column titles stay over their columns — and
      // by the scroll threshold. Measuring that header box is what catches the
      // math.
      const trailingSpace = CoreSpacing.space4;

      Future<double> headerActionsSlot(
        WidgetTester tester, {
        required bool editable,
        required bool deletable,
      }) async {
        await tester.pumpWidget(
          _app(CoreGeometryArea(
            onMediaButtonPressed: () {},
            onDocumentButtonPressed: () {},
            tables: [
              _table(
                columnTitles: const ['Col'],
                rows: const [
                  CoreSizeCardData(id: '1', values: ['1a']),
                ],
                editable: editable,
                onDeleted: deletable ? (_) {} : null,
              ),
            ],
          )),
        );
        // The header row is the only Row above the column title; its one
        // SizedBox is the reserved slot.
        final headerRow = find
            .ancestor(of: find.text('Col'), matching: find.byType(Row))
            .first;
        final slot = find.descendant(
          of: headerRow,
          matching: find.byType(SizedBox),
        );
        expect(slot, findsOneWidget);
        return tester.getSize(slot).width;
      }

      testWidgets('an edit-only table reserves one button of width, not two',
          (tester) async {
        final width =
            await headerActionsSlot(tester, editable: true, deletable: false);

        expect(editButtons(), findsOneWidget);
        expect(deleteButtons(), findsNothing);
        // Reserving a flat two-button slot whenever either callback is set
        // would leave 48 dp of empty header over the row's single button.
        expect(width, CoreSpacing.space12 + trailingSpace);
      });

      testWidgets('a delete-only table reserves one button of width, not two',
          (tester) async {
        final width =
            await headerActionsSlot(tester, editable: false, deletable: true);

        expect(editButtons(), findsNothing);
        // Only the row's button: Dismissible builds its swipe background
        // lazily, once a drag starts.
        expect(deleteButtons(), findsOneWidget);
        expect(width, CoreSpacing.space12 + trailingSpace);
      });

      testWidgets('the two-button and no-button slots bracket them',
          (tester) async {
        expect(
          await headerActionsSlot(tester, editable: true, deletable: true),
          CoreSpacing.space12 * 2 + trailingSpace,
        );
        expect(
          await headerActionsSlot(tester, editable: false, deletable: false),
          trailingSpace,
        );
      });

      testWidgets('the delete button reports its row id', (tester) async {
        final deleted = <String>[];

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
                onDeleted: deleted.add,
              ),
            ],
          )),
        );

        await tester.tap(find.byKey(CoreGeometryArea.deleteRowKey('table', 'second')));
        await tester.pumpAndSettle();

        expect(deleted, ['second']);
      });

      testWidgets('the edit button opens the entry sheet pre-filled',
          (tester) async {
        // The sheet carries a full keyboard and does not fit the default
        // surface; its own tests size up the same way.
        await tester.binding.setSurfaceSize(const Size(1080, 2400));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        await tester.pumpWidget(
          _app(CoreGeometryArea(
            onMediaButtonPressed: () {},
            onDocumentButtonPressed: () {},
            tables: [
              _table(
                columnTitles: const ['Rail', 'O.C.'],
                rows: const [
                  CoreSizeCardData(id: '1', values: ['5', '8ft']),
                ],
              ),
            ],
          )),
        );

        await tester.tap(find.byKey(CoreGeometryArea.editRowKey('table', '1')));
        await tester.pumpAndSettle();

        expect(find.text('Edit size'), findsOneWidget);
        expect(find.text('5'), findsWidgets);
        expect(find.text('8ft'), findsWidgets);
      });

      testWidgets('a horizontal drag starting on the delete button does not '
          'dismiss the row', (tester) async {
        final deleted = <String>[];

        await tester.pumpWidget(
          _app(CoreGeometryArea(
            onMediaButtonPressed: () {},
            onDocumentButtonPressed: () {},
            tables: [
              _table(
                rows: const [
                  CoreSizeCardData(id: '1', values: ['Val 1', 'Val 2']),
                ],
                onDeleted: deleted.add,
              ),
            ],
          )),
        );

        // The button claims horizontal drags, so a sloppy swipe that begins on
        // it must not reach the row's Dismissible and delete by gesture.
        await tester.drag(deleteButtons().first, const Offset(-500, 0));
        await tester.pumpAndSettle();

        expect(deleted, isEmpty);
        expect(find.text('Val 1'), findsOneWidget);
      });

      testWidgets('the drag proxy keeps its action buttons', (tester) async {
        await tester.pumpWidget(
          _app(CoreGeometryArea(
            onMediaButtonPressed: () {},
            onDocumentButtonPressed: () {},
            tables: [
              _table(
                columnTitles: const ['Col'],
                rows: const [
                  CoreSizeCardData(id: '1', values: ['1a']),
                  CoreSizeCardData(id: '2', values: ['2a']),
                ],
                onDeleted: (_) {},
                onReordered: (_, __) {},
              ),
            ],
          )),
        );

        final staticWidth = tester.getSize(find.text('1a')).width;
        final gesture =
            await tester.startGesture(tester.getCenter(_dragHandles.first));
        await tester.pump(const Duration(milliseconds: 200));
        await gesture.moveBy(const Offset(0, 40));
        await tester.pump();

        // The floating proxy keeps layout's reserved actionsWidth either way.
        // If it dropped the buttons, the value columns would stretch into the
        // freed space and the text would visibly jump mid-drag.
        // One remaining static row plus the floating proxy. Without the fix
        // the proxy contributes none and this is 1.
        expect(editButtons(), findsNWidgets(2));
        // Within the 3 dp the drop-highlight border takes off the content box.
        // Dropping the proxy's buttons would free the reserved actions width
        // and stretch this cell by tens of pixels instead.
        expect(
          tester.getSize(find.text('1a').first).width,
          closeTo(staticWidth, 4),
        );

        await gesture.up();
        await tester.pumpAndSettle();
        await tester.pump(const Duration(milliseconds: 500));
      });

      testWidgets('a button is no more of a scroll dead zone than the row body',
          (tester) async {
        // A phone-width surface, so eight columns genuinely overflow.
        await tester.binding.setSurfaceSize(const Size(412, 800));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        Future<double> dragAndMeasure({
          required bool deletable,
          required bool fromButton,
        }) async {
          await tester.pumpWidget(
            _app(CoreGeometryArea(
              onMediaButtonPressed: () {},
              onDocumentButtonPressed: () {},
              tables: [
                _table(
                  columnTitles: const ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'],
                  rows: const [
                    CoreSizeCardData(
                      id: '1',
                      values: ['1', '2', '3', '4', '5', '6', '7', '8'],
                    ),
                  ],
                  onDeleted: deletable ? (_) {} : null,
                ),
              ],
            )),
          );

          // The row's buttons sit at its right edge, well past a 412 dp
          // viewport at the initial offset. An earlier version of this test
          // dragged from there: the gesture landed in empty space, scrolled
          // nothing, and the assertion passed without a button involved.
          //
          // Scrolling one into view puts the table at its end, and both cases
          // are measured from there — so the button and the row body differ
          // only in where the drag starts, not in how far the table can move.
          await tester.ensureVisible(
            find.byKey(CoreGeometryArea.editRowKey('table', '1')),
          );
          await tester.pumpAndSettle();

          final target = fromButton
              ? find.byKey(deletable
                  ? CoreGeometryArea.deleteRowKey('table', '1')
                  // A row without onDeleted renders no trash, so the control
                  // is the pencil — guarded by the same onHorizontalDragStart.
                  : CoreGeometryArea.editRowKey('table', '1'))
              // Column F: cells A-C sit off the left edge once the table is
              // scrolled to its end.
              : find.text('6');

          // Checked, not assumed — if a change puts the target back off screen
          // this must fail rather than quietly go vacuous again.
          final rect = tester.getRect(target);
          expect(
            rect.left >= 0 && rect.right <= 412.0,
            isTrue,
            reason: 'the drag must land on $rect, not on empty space',
          );

          final before = tester.getTopLeft(find.text('1')).dx;
          // Towards the start, not the end. Revealing the button means
          // scrolling to the far end, where a further end-ward drag has
          // nowhere left to go and would read as "did not scroll" for every
          // case — vacuous in the other direction.
          await tester.drag(target, const Offset(120, 0));
          await tester.pumpAndSettle();
          return tester.getTopLeft(find.text('1')).dx - before;
        }

        // A deletable row claims horizontal drags across its whole width — the
        // Dismissible over the body, the button's own guard over the button —
        // so neither scrolls the table.
        expect(await dragAndMeasure(deletable: true, fromButton: false), 0);
        expect(await dragAndMeasure(deletable: true, fromButton: true), 0);

        // With nothing to guard, both scroll. The pair is the actual claim:
        // the button is no deader to a scroll than the row body beside it.
        expect(
          await dragAndMeasure(deletable: false, fromButton: false),
          greaterThan(0),
        );
        expect(
          await dragAndMeasure(deletable: false, fromButton: true),
          greaterThan(0),
        );
      });

      testWidgets('swiping the row body still deletes', (tester) async {
        final deleted = <String>[];

        await tester.pumpWidget(
          _app(CoreGeometryArea(
            onMediaButtonPressed: () {},
            onDocumentButtonPressed: () {},
            tables: [
              _table(
                rows: const [
                  CoreSizeCardData(id: '1', values: ['Val 1', 'Val 2']),
                ],
                onDeleted: deleted.add,
              ),
            ],
          )),
        );

        await tester.drag(find.text('Val 1'), const Offset(-500, 0));
        await tester.pumpAndSettle();

        expect(deleted, ['1']);
      });
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

      test('addLabel requires onAdd or onSaved', () {
        expect(
          () => CoreSizesTableData(
            id: 'labelled',
            title: 'Labelled',
            columns: const [CoreSizesColumn(title: 'Col')],
            rows: const [],
            addLabel: 'Add size',
          ),
          throwsAssertionError,
          reason: 'with neither callback the add action has nothing to do, so '
              'the label silently goes missing',
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

      await _dragFirstRowDown(tester, 1);

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

      // Past two rows, so it lands at index 2 rather than the adjacent slot.
      await _dragFirstRowDown(tester, 1.5);

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

      await _dragFirstRowDown(tester, 1);

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
