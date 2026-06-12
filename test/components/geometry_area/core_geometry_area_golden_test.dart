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
              sizesTableData: [
                CoreSizeCardData(values: ['2', '6', '14', '26']),
                CoreSizeCardData(values: ['3', '6', '14', '39']),
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
              sizesTableData: [
                CoreSizeCardData(values: ['2', '6', '14', '26']),
                CoreSizeCardData(values: ['3', '6', '14', '39']),
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
}
