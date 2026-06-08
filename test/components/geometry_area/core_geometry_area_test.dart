import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

void main() {
  group('CoreGeometryArea', () {
    testWidgets('renders geometry area with default labels', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreGeometryArea(),
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
          home: const Scaffold(
            body: CoreGeometryArea(
              dimensionsLabel: customDimensions,
              expandLabel: customExpand,
              sizesTitleLabel: customSizesTitle,
              addSizeLabel: customAddSize,
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
          home: const Scaffold(
            body: CoreGeometryArea(
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
          home: const Scaffold(
            body: CoreGeometryArea(
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
  });
}
