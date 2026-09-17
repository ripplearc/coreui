import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

import 'display_area_test_helpers.dart';

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
              closeSemanticLabel: testCloseSemanticLabel,
              historyPlaceholder: testHistoryPlaceholder,
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
              closeSemanticLabel: testCloseSemanticLabel,
              historyPlaceholder: testHistoryPlaceholder,
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
      home: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text('Display Area - empty state'),
            const SizedBox(height: CoreSpacing.space8),
            CoreDisplayArea(
              closeSemanticLabel: testCloseSemanticLabel,
              historyPlaceholder: testHistoryPlaceholder,
              onClose: () {},
            ),
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
              closeSemanticLabel: testCloseSemanticLabel,
              historyPlaceholder: testHistoryPlaceholder,
              onClose: () {},
              label: 'Length',
              isTyping: true,
              value: '16ft 14in',
              dependentKeys: [
                CoreDependentKeyData(
                  label: 'O.C',
                  value: '16in',
                  kind: CoreDependentKeyKind.editable,
                  onPressed: () {},
                ),
              ],
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
              closeSemanticLabel: testCloseSemanticLabel,
              historyPlaceholder: testHistoryPlaceholder,
              label: 'Length',
              hasError: true,
              errorMessage: 'Dimension Error',
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

  Future<void> pumpDependentKeys(WidgetTester tester, ThemeData theme) async {
    final colors = theme.coreColors;

    debugDisableShadows = false;
    addTearDown(() => debugDisableShadows = true);

    // physicalSize is in physical pixels; logical size = physicalSize / DPR.
    // 824x456 @ 2.0 => 412x228 logical: exactly the collapsed display area
    // (CoreSpacing.space57 tall), so the golden holds the area and nothing
    // else. Four pills outgrow the width on purpose: the row anchors the
    // trailing pill and scrolls the leading one off the start edge.
    tester.view.physicalSize = const Size(824, 456);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme.copyWith(
          textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto'),
        ),
        home: Scaffold(
          backgroundColor: colors.pageBackground,
          body: CoreDisplayArea(
            closeSemanticLabel: testCloseSemanticLabel,
            historyPlaceholder: testHistoryPlaceholder,
            label: 'Cost',
            value: '\$84.25',
            chipsList: const [
              CoreCalculatorChip(
                label: 'Length',
                value: '20ft',
                type: CoreCalculatorChipType.editable,
              ),
              CoreCalculatorChip(
                label: 'Height',
                value: '9ft',
                type: CoreCalculatorChipType.editable,
              ),
              CoreCalculatorChip(
                label: 'Sheets',
                value: '5.81',
                type: CoreCalculatorChipType.result,
              ),
            ],
            dependentKeys: [
              CoreDependentKeyData(
                label: 'Re-input 38.30° as',
                value: '38°30′',
                kind: CoreDependentKeyKind.offer,
                onPressed: () {},
              ),
              CoreDependentKeyData(
                label: 'Shown as',
                value: 'in/12in',
                kind: CoreDependentKeyKind.toggle,
                onPressed: () {},
              ),
              CoreDependentKeyData(
                label: 'Rate',
                value: '\$14.5/sheet',
                kind: CoreDependentKeyKind.editable,
                onPressed: () {},
              ),
              CoreDependentKeyData(
                label: 'Waste',
                value: '10%',
                kind: CoreDependentKeyKind.editable,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 100));
  }

  testWidgets('DisplayArea dependent keys Golden Test - Light',
      (WidgetTester tester) async {
    await pumpDependentKeys(tester, CoreTheme.light());

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/display_area_dependent_keys_light.png'),
    );
    debugDisableShadows = true;
  });

  testWidgets('DisplayArea dependent keys Golden Test - Dark',
      (WidgetTester tester) async {
    await pumpDependentKeys(tester, CoreTheme.dark());

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/display_area_dependent_keys_dark.png'),
    );
    debugDisableShadows = true;
  });
}
