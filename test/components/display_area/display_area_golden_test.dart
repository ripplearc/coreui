import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await loadFonts();
  });

  testWidgets('DisplayArea Component Visual Regression Test',
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
            Text('Display Area'),
            SizedBox(height: CoreSpacing.space8),
            CoreDisplayArea(
              label: 'Area',
              chipsList: [
                CoreCalculatorChip(
                  label: "Length",
                  value: "16ft 14in",
                  type: CoreCalculatorChipType.editable,
                ),
                CoreCalculatorChip(
                  label: "Length",
                  value: "16ft 14in",
                  type: CoreCalculatorChipType.active,
                ),
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
      matchesGoldenFile('goldens/display_area_component.png'),
    );
  });

  testWidgets(
      'DisplayArea Component with all chip types Visual Regression Test',
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
            Text('Display Area - two rows of chips'),
            SizedBox(height: CoreSpacing.space8),
            CoreDisplayArea(
              label: 'Length',
              isTyping: true,
              chipsList: [
                CoreCalculatorChip(
                  label: "Length",
                  value: "16ft 14in",
                  type: CoreCalculatorChipType.editable,
                ),
                CoreCalculatorChip(
                  label: "Length",
                  value: "16ft 14in",
                  type: CoreCalculatorChipType.active,
                ),
                CoreCalculatorChip(
                  label: "Length",
                  value: "16ft 14in",
                  type: CoreCalculatorChipType.disabled,
                ),
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
      matchesGoldenFile('goldens/display_area_component_two_rows_chips.png'),
    );
  });

  testWidgets('DisplayArea Component empty state Visual Regression Test',
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
            Text('Display Area - empty state'),
            SizedBox(height: CoreSpacing.space8),
            CoreDisplayArea(),
          ],
        ),
      ),
    );

    await tester.pumpWidget(widget);
    await tester.pump();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/display_area_component_empty_state.png'),
    );
  });

  testWidgets(
      'DisplayArea Component with more than two rows of chips Visual Regression Test',
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
            const Text('Display Area - more than two rows'),
            const SizedBox(height: CoreSpacing.space8),
            CoreDisplayArea(
              onClose: () {},
              label: 'Length',
              isTyping: true,
              value: '16ft 14in',
              chipsList: const [
                CoreCalculatorChip(
                  label: "Length",
                  value: "16ft 14in",
                  type: CoreCalculatorChipType.editable,
                ),
                CoreCalculatorChip(
                  label: "Length",
                  value: "16ft 14in",
                  type: CoreCalculatorChipType.active,
                ),
                CoreCalculatorChip(
                  label: "Length",
                  value: "16ft 14in",
                  type: CoreCalculatorChipType.disabled,
                ),
                CoreCalculatorChip(
                  label: "Width",
                  value: "10ft",
                  type: CoreCalculatorChipType.editable,
                ),
                CoreCalculatorChip(
                  label: "Height",
                  value: "8ft",
                  type: CoreCalculatorChipType.active,
                ),
                CoreCalculatorChip(
                  label: "Weight",
                  value: "20lbs",
                  type: CoreCalculatorChipType.disabled,
                ),
                CoreCalculatorChip(
                  label: "Volume",
                  value: "100gal",
                  type: CoreCalculatorChipType.editable,
                ),
                CoreCalculatorChip(
                  label: "Width",
                  value: "10ft",
                  type: CoreCalculatorChipType.editable,
                ),
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
          'goldens/display_area_component_more_than_two_rows.png'),
    );
  });

  testWidgets(
      'DisplayArea Component with all chip types Visual Regression Test',
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
            Text('Display Area - Error state'),
            SizedBox(height: CoreSpacing.space8),
            CoreDisplayArea(
              label: 'Length',
              hasError: true,
              errorTitle: 'Error',
              chipsList: [
                CoreCalculatorChip(
                  label: "Length",
                  value: "16ft 14in",
                  type: CoreCalculatorChipType.editable,
                ),
                CoreCalculatorChip(
                  label: "Length",
                  value: "16ft 14in",
                  type: CoreCalculatorChipType.active,
                ),
                CoreCalculatorChip(
                  label: "Length",
                  value: "16ft 14in",
                  type: CoreCalculatorChipType.disabled,
                ),
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
      matchesGoldenFile('goldens/display_area_component_error_state.png'),
    );
  });
}
