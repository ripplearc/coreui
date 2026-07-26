import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

ThemeData _withRoboto(ThemeData base) {
  return base.copyWith(
    textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto'),
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
              sizesTitleLabel: 'Concrete volumes for 70ft',
              sizesTableTitles: const [
                'Rails /section',
                'O.C.',
                'No. of posts',
                'No. of rails',
              ],
              sizesTableData: const [
                CoreSizeCardData(id: '1', values: ['2', '6', '14', '26']),
                CoreSizeCardData(id: '2', values: ['3', '6', '14', '39']),
              ],
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
              sizesTitleLabel: 'Concrete volumes for 70ft',
              sizesTableTitles: const [
                'Rails /section',
                'O.C.',
                'No. of posts',
                'No. of rails',
              ],
              sizesTableData: const [
                CoreSizeCardData(id: '1', values: ['2', '6', '14', '26']),
                CoreSizeCardData(id: '2', values: ['3', '6', '14', '39']),
              ],
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
              sizesTitleLabel: 'Concrete volumes for 70ft',
              sizesTableTitles: const [
                'Rails /section',
                'O.C.',
              ],
              sizesTableData: const [
                CoreSizeCardData(id: '1', values: ['2', '6']),
                CoreSizeCardData(id: '2', values: ['3', '6']),
              ],
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
              sizesTitleLabel: 'Concrete volumes for 70ft',
              sizesTableTitles: const [
                'Rails /section',
                'O.C.',
                'No. of posts',
                'No. of rails',
              ],
              sizesTableData: const [
                CoreSizeCardData(id: '1', values: ['2', '6', '14', '26']),
                CoreSizeCardData(id: '2', values: ['3', '6', '14', '39']),
              ],
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
              sizesTitleLabel: 'Concrete volumes for 70ft',
              sizesTableTitles: const [
                'Rails /section',
                'O.C.',
                'No. of posts',
                'No. of rails',
              ],
              sizesTableData: const [
                CoreSizeCardData(id: '1', values: ['2', '6', '14', '26']),
                CoreSizeCardData(id: '2', values: ['3', '6', '14', '39']),
              ],
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
            const Text('Geometry Area (Dark)',
                style: TextStyle(color: Colors.white)),
            const SizedBox(height: CoreSpacing.space8),
            CoreGeometryArea(
              onMediaButtonPressed: () {},
              onDocumentButtonPressed: () {},
              isCollapsed: true,
              sizesTitleLabel: 'Concrete volumes for 70ft',
              sizesTableTitles: const [
                'Rails /section',
                'O.C.',
                'No. of posts',
                'No. of rails',
              ],
              sizesTableData: const [
                CoreSizeCardData(id: '1', values: ['2', '6', '14', '26']),
                CoreSizeCardData(id: '2', values: ['3', '6', '14', '39']),
              ],
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
            const Text('Geometry Area (Expanded, Dark)',
                style: TextStyle(color: Colors.white)),
            const SizedBox(height: CoreSpacing.space8),
            CoreGeometryArea(
              onMediaButtonPressed: () {},
              onDocumentButtonPressed: () {},
              isCollapsed: false,
              sizesTitleLabel: 'Concrete volumes for 70ft',
              sizesTableTitles: const [
                'Rails /section',
                'O.C.',
                'No. of posts',
                'No. of rails',
              ],
              sizesTableData: const [
                CoreSizeCardData(id: '1', values: ['2', '6', '14', '26']),
                CoreSizeCardData(id: '2', values: ['3', '6', '14', '39']),
              ],
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
}
