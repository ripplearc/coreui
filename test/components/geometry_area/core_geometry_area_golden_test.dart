import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

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
      home: const Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Geometry Area'),
            SizedBox(height: CoreSpacing.space8),
            CoreGeometryArea(
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
              dimensions: [
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
      home: const Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Geometry Area (Expanded)'),
            SizedBox(height: CoreSpacing.space8),
            CoreGeometryArea(
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
              dimensions: [
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
      home: const Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Geometry Area (Dragging)'),
            SizedBox(height: CoreSpacing.space8),
            CoreGeometryArea(
              isCollapsed: true,
              sizesTitleLabel: 'Concrete volumes for 70ft',
              sizesTableTitles: const [
                'Rails /section',
                'O.C.',
              ],
              sizesTableData: [
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
      home: const Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Geometry Area (Deleting)'),
            SizedBox(height: CoreSpacing.space8),
            CoreGeometryArea(
              isCollapsed: false,
              sizesTitleLabel: 'Concrete volumes for 70ft',
              sizesTableTitles: [
                'Rails /section',
                'O.C.',
                'No. of posts',
                'No. of rails',
              ],
              sizesTableData: [
                CoreSizeCardData(id: '1', values: ['2', '6', '14', '26']),
                CoreSizeCardData(id: '2', values: ['3', '6', '14', '39']),
              ],
              dimensions: [
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
}
