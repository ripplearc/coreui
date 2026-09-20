import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

ThemeData _withRoboto(ThemeData base) {
  return base.copyWith(
    textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto'),
  );
}

void _noopDelete(String id) {}
void _noopReorder(int oldIndex, int newIndex) {}

/// A fixed table: no callbacks and no add label, so it renders without drag
/// handles, an add action or swipe-to-delete.
const CoreSizesTableData _readOnlyTable = CoreSizesTableData(
  id: 'read-only',
  title: 'Rates & waste for 1,750.7yd³',
  columns: [
    CoreSizesColumn(title: 'Per unit'),
    CoreSizesColumn(title: 'Rate'),
    CoreSizesColumn(title: 'Waste'),
    CoreSizesColumn(title: 'Cost'),
  ],
  rows: [
    CoreSizeCardData(id: 'ft3', values: ['ft³', r'$6.5', '0%', r'$307,247.85']),
    CoreSizeCardData(id: 'yd3', values: ['yd³', r'$150', '7%', r'$280,987.35']),
  ],
);

/// The standard four-column fixture shared by most goldens.
CoreSizesTableData _fourColumnTable({
  void Function(String id)? onDeleted = _noopDelete,
  void Function(int oldIndex, int newIndex)? onReordered = _noopReorder,
}) {
  return CoreSizesTableData(
    id: 'four-column',
    title: 'Concrete volumes for 70ft',
    addLabel: 'Add size',
    editLabel: 'Edit size',
    dragHandleLabel: 'Reorder',
    columns: const [
      CoreSizesColumn(title: 'Rails /section'),
      CoreSizesColumn(title: 'O.C.'),
      CoreSizesColumn(title: 'No. of posts'),
      CoreSizesColumn(title: 'No. of rails'),
    ],
    rows: const [
      CoreSizeCardData(id: '1', values: ['2', '6', '14', '26']),
      CoreSizeCardData(id: '2', values: ['3', '6', '14', '39']),
    ],
    onSaved: (_) {},
    onDeleted: onDeleted,
    onReordered: onReordered,
  );
}

/// The narrower fixture used by the drag golden.
CoreSizesTableData _twoColumnTable({
  void Function(String id)? onDeleted = _noopDelete,
  void Function(int oldIndex, int newIndex)? onReordered = _noopReorder,
}) {
  return CoreSizesTableData(
    id: 'two-column',
    title: 'Concrete volumes for 70ft',
    addLabel: 'Add size',
    editLabel: 'Edit size',
    dragHandleLabel: 'Reorder',
    columns: const [
      CoreSizesColumn(title: 'Rails /section'),
      CoreSizesColumn(title: 'O.C.'),
    ],
    rows: const [
      CoreSizeCardData(id: '1', values: ['2', '6']),
      CoreSizeCardData(id: '2', values: ['3', '6']),
    ],
    onSaved: (_) {},
    onDeleted: onDeleted,
    onReordered: onReordered,
  );
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await loadFonts();
  });

  testWidgets('CoreGeometryArea Component Visual Regression Test',
      (WidgetTester tester) async {
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() => tester.view.resetDevicePixelRatio());
    await tester.binding.setSurfaceSize(const Size(412, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final widget = MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: CoreTheme.light().copyWith(
        textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto'),
      ),
      home: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text('Geometry Area'),
            const SizedBox(height: CoreSpacing.space8),
            CoreGeometryArea(
              onMediaButtonPressed: () {},
              onDocumentButtonPressed: () {},
              isCollapsed: true,
              tables: [_fourColumnTable()],
              dimensions: const [
                CoreDimensionData(label: 'Area', value: '50.27ft²'),
                CoreDimensionData(label: 'Diameter', value: '8ft'),
                CoreDimensionData(label: 'Radius', value: '4ft'),
                CoreDimensionData(label: 'Circumference', value: '25.13ft'),
              ],
            ),
          ],
        ),
      ),
    );

    await tester.pumpWidget(widget);
    await tester.pump();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_geometry_area_component.png'),
    );
  });

  testWidgets('CoreGeometryArea Component Visual Regression Test (Expanded)',
      (WidgetTester tester) async {
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() => tester.view.resetDevicePixelRatio());
    await tester.binding.setSurfaceSize(const Size(412, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final widget = MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: CoreTheme.light().copyWith(
        textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto'),
      ),
      home: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text('Geometry Area (Expanded)'),
            const SizedBox(height: CoreSpacing.space8),
            CoreGeometryArea(
              onMediaButtonPressed: () {},
              onDocumentButtonPressed: () {},
              isCollapsed: false,
              tables: [_fourColumnTable()],
              dimensions: const [
                CoreDimensionData(label: 'Area', value: '50.27ft²'),
                CoreDimensionData(label: 'Diameter', value: '8ft'),
                CoreDimensionData(label: 'Radius', value: '4ft'),
                CoreDimensionData(label: 'Circumference', value: '25.13ft'),
              ],
            ),
          ],
        ),
      ),
    );

    await tester.pumpWidget(widget);
    await tester.pump();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_geometry_area_component_expanded.png'),
    );
  });

  testWidgets(
      'CoreGeometryArea Component Visual Regression Test (Dragging/Highlighted)',
      (WidgetTester tester) async {
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() => tester.view.resetDevicePixelRatio());
    await tester.binding.setSurfaceSize(const Size(412, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final widget = MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: CoreTheme.light().copyWith(
        textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto'),
      ),
      home: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text('Geometry Area (Dragging)'),
            const SizedBox(height: CoreSpacing.space8),
            CoreGeometryArea(
              onMediaButtonPressed: () {},
              onDocumentButtonPressed: () {},
              isCollapsed: true,
              tables: [_twoColumnTable()],
            ),
          ],
        ),
      ),
    );

    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    final dragHandles = find.byWidgetPredicate(
      (widget) =>
          widget is CoreIconWidget && widget.icon == CoreIcons.dragIndicator,
    );
    final gesture =
        await tester.startGesture(tester.getCenter(dragHandles.first));
    await tester.pump();

    await tester.pump(const Duration(milliseconds: 100));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_geometry_area_component_dragging.png'),
    );

    await gesture.up();
  });

  testWidgets('CoreGeometryArea Component Visual Regression Test (Deleting)',
      (WidgetTester tester) async {
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() => tester.view.resetDevicePixelRatio());
    await tester.binding.setSurfaceSize(const Size(412, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final widget = MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: CoreTheme.light().copyWith(
        textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto'),
      ),
      home: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text('Geometry Area (Deleting)'),
            const SizedBox(height: CoreSpacing.space8),
            CoreGeometryArea(
              onMediaButtonPressed: () {},
              onDocumentButtonPressed: () {},
              isCollapsed: false,
              tables: [_fourColumnTable()],
              dimensions: const [
                CoreDimensionData(label: 'Area', value: '50.27ft²'),
                CoreDimensionData(label: 'Diameter', value: '8ft'),
                CoreDimensionData(label: 'Radius', value: '4ft'),
                CoreDimensionData(label: 'Circumference', value: '25.13ft'),
              ],
            ),
          ],
        ),
      ),
    );

    await tester.pumpWidget(widget);
    await tester.pump();
    final itemToSwipe = find.text('26');
    await tester.drag(itemToSwipe, const Offset(-168.0, 0.0));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_geometry_area_component_deleting.png'),
    );
  });

  testWidgets(
      'CoreGeometryArea Component Visual Regression Test (With Attachments)',
      (WidgetTester tester) async {
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() => tester.view.resetDevicePixelRatio());
    await tester.binding.setSurfaceSize(const Size(412, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final widget = MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: CoreTheme.light().copyWith(
        textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto'),
      ),
      home: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text('Geometry Area (With Attachments)'),
            const SizedBox(height: CoreSpacing.space8),
            CoreGeometryArea(
              onMediaButtonPressed: () {},
              onDocumentButtonPressed: () {},
              isCollapsed: true,
              tables: [_fourColumnTable()],
              dimensions: const [
                CoreDimensionData(label: 'Area', value: '50.27ft²'),
                CoreDimensionData(label: 'Diameter', value: '8ft'),
                CoreDimensionData(label: 'Radius', value: '4ft'),
                CoreDimensionData(label: 'Circumference', value: '25.13ft'),
              ],
              onViewAllAttachmentsPressed: () {},
            ),
          ],
        ),
      ),
    );

    await tester.pumpWidget(widget);
    await tester.pump();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile(
          'goldens/core_geometry_area_component_with_attachments.png'),
    );
  });

  testWidgets('CoreGeometryArea Component Visual Regression Test — Dark',
      (WidgetTester tester) async {
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() => tester.view.resetDevicePixelRatio());
    await tester.binding.setSurfaceSize(const Size(412, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final widget = MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _withRoboto(CoreTheme.dark()),
      home: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Builder(
              builder: (context) => Text(
                'Geometry Area (Dark)',
                style: Theme.of(context).coreTypography.bodyLargeRegular.copyWith(
                  color: Theme.of(context).coreColors.textInverse,
                ),
              ),
            ),
            const SizedBox(height: CoreSpacing.space8),
            CoreGeometryArea(
              onMediaButtonPressed: () {},
              onDocumentButtonPressed: () {},
              isCollapsed: true,
              tables: [_fourColumnTable()],
              dimensions: const [
                CoreDimensionData(label: 'Area', value: '50.27ft²'),
                CoreDimensionData(label: 'Diameter', value: '8ft'),
                CoreDimensionData(label: 'Radius', value: '4ft'),
                CoreDimensionData(label: 'Circumference', value: '25.13ft'),
              ],
            ),
          ],
        ),
      ),
    );

    await tester.pumpWidget(widget);
    await tester.pump();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_geometry_area_component_dark.png'),
    );
  });

  testWidgets(
      'CoreGeometryArea Component Visual Regression Test (Expanded) — Dark',
      (WidgetTester tester) async {
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() => tester.view.resetDevicePixelRatio());
    await tester.binding.setSurfaceSize(const Size(412, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final widget = MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _withRoboto(CoreTheme.dark()),
      home: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Builder(
              builder: (context) => Text(
                'Geometry Area (Expanded, Dark)',
                style: Theme.of(context).coreTypography.bodyLargeRegular.copyWith(
                  color: Theme.of(context).coreColors.textInverse,
                ),
              ),
            ),
            const SizedBox(height: CoreSpacing.space8),
            CoreGeometryArea(
              onMediaButtonPressed: () {},
              onDocumentButtonPressed: () {},
              isCollapsed: false,
              tables: [_fourColumnTable()],
              dimensions: const [
                CoreDimensionData(label: 'Area', value: '50.27ft²'),
                CoreDimensionData(label: 'Diameter', value: '8ft'),
                CoreDimensionData(label: 'Radius', value: '4ft'),
                CoreDimensionData(label: 'Circumference', value: '25.13ft'),
              ],
            ),
          ],
        ),
      ),
    );

    await tester.pumpWidget(widget);
    await tester.pump();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile(
          'goldens/core_geometry_area_component_expanded_dark.png'),
    );
  });

  testWidgets(
      'CoreGeometryArea Component Visual Regression Test (Multiple Tables)',
      (WidgetTester tester) async {
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() => tester.view.resetDevicePixelRatio());
    await tester.binding.setSurfaceSize(const Size(412, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final widget = MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: CoreTheme.light().copyWith(
        textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto'),
      ),
      home: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text('Geometry Area — multiple tables'),
            const SizedBox(height: CoreSpacing.space8),
            CoreGeometryArea(
              onMediaButtonPressed: () {},
              onDocumentButtonPressed: () {},
              isCollapsed: false,
              tables: [
                // Reorderable and deletable, with an add action.
                _twoColumnTable(),
                // Read-only: no callbacks and no addLabel, so no drag handles
                // and no add action render.
                _readOnlyTable,
              ],
            ),
          ],
        ),
      ),
    );

    await tester.pumpWidget(widget);
    await tester.pump();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_geometry_area_component_tables.png'),
    );
  });

  // The dark sibling of the test above. The other dark goldens each render a
  // single table, so without this one nothing covers the suppressed handles and
  // absent add action of a read-only table against the dark tokens.
  testWidgets(
      'CoreGeometryArea Component Visual Regression Test (Multiple Tables) — Dark',
      (WidgetTester tester) async {
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() => tester.view.resetDevicePixelRatio());
    await tester.binding.setSurfaceSize(const Size(412, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final widget = MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _withRoboto(CoreTheme.dark()),
      home: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Builder(
              builder: (context) => Text(
                'Geometry Area — multiple tables (Dark)',
                style:
                    Theme.of(context).coreTypography.bodyLargeRegular.copyWith(
                          color: Theme.of(context).coreColors.textInverse,
                        ),
              ),
            ),
            const SizedBox(height: CoreSpacing.space8),
            CoreGeometryArea(
              onMediaButtonPressed: () {},
              onDocumentButtonPressed: () {},
              isCollapsed: false,
              tables: [
                // Reorderable and deletable, with an add action.
                _twoColumnTable(),
                // Read-only: no callbacks and no addLabel, so no drag handles
                // and no add action render.
                _readOnlyTable,
              ],
            ),
          ],
        ),
      ),
    );

    await tester.pumpWidget(widget);
    await tester.pump();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_geometry_area_component_tables_dark.png'),
    );
  });
}
