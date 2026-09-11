import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';
import 'suggestion_area_test_helpers.dart';

final _expandToggleFinder = find.bySemanticsLabel(
  RegExp(r'Show \d+ more suggestions'),
);

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await loadFonts();
  });

  testWidgets('SuggestionArea Component Empty State Test',
      (WidgetTester tester) async {
    final colors = AppColorsExtension.create();

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
        backgroundColor: colors.pageBackground,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text('Suggestion Area - empty state'),
            const SizedBox(height: CoreSpacing.space8),
            testCoreSuggestionArea(),
          ],
        ),
      ),
    );

    await tester.pumpWidget(widget);
    await tester.pump();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/suggestion_area_component.png'),
    );
  });

  testWidgets('SuggestionArea AI List Golden Test',
      (WidgetTester tester) async {
    final colors = AppColorsExtension.create();

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
        backgroundColor: colors.pageBackground,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text('Suggestion Area - AI List'),
            const SizedBox(height: CoreSpacing.space8),
            testCoreSuggestionArea(
              aiSuggestions: [
                SuggestionData(
                    label: 'Volume:', value: '2700', unit: 'ft³', onTap: () {}),
                SuggestionData(
                    label: 'Area:', value: '900', unit: 'sq ft', onTap: () {}),
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
      matchesGoldenFile('goldens/suggestion_area_ai_list_component.png'),
    );
  });

  testWidgets('SuggestionArea Conversion List Golden Test',
      (WidgetTester tester) async {
    final colors = AppColorsExtension.create();

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
        backgroundColor: colors.pageBackground,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text('Suggestion Area - Conversion List'),
            const SizedBox(height: CoreSpacing.space8),
            testCoreSuggestionArea(
              aiSuggestions: [
                SuggestionData(
                    label: 'Volume:', value: '2700', unit: 'ft³', onTap: () {}),
              ],
              conversionSuggestions: [
                SuggestionData(
                    label: 'Meters:', value: '3.048', unit: 'm', onTap: () {}),
                SuggestionData(
                    label: 'CM:', value: '304.8', unit: 'cm', onTap: () {}),
              ],
            ),
          ],
        ),
      ),
    );

    await tester.pumpWidget(widget);
    await tester.pump();
    await tester.tap(find.bySemanticsLabel(testToggleSemanticsLabel));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile(
          'goldens/suggestion_area_conversion_list_component.png'),
    );
  });

  testWidgets('SuggestionArea Conversion List Only Golden Test',
      (WidgetTester tester) async {
    final colors = AppColorsExtension.create();

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
        backgroundColor: colors.pageBackground,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text('Suggestion Area - Conversion List Only'),
            const SizedBox(height: CoreSpacing.space8),
            testCoreSuggestionArea(
              conversionSuggestions: [
                SuggestionData(
                    label: 'Meters:', value: '3.048', unit: 'm', onTap: () {}),
                SuggestionData(
                    label: 'CM:', value: '304.8', unit: 'cm', onTap: () {}),
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
          'goldens/suggestion_area_conversion_list_only_component.png'),
    );
  });

  testWidgets('SuggestionArea overflow collapsed Golden Test',
      (WidgetTester tester) async {
    final colors = AppColorsExtension.create();

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
        backgroundColor: colors.pageBackground,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text('Suggestion List - Collapsed'),
            const SizedBox(height: CoreSpacing.space8),
            testCoreSuggestionArea(
              aiSuggestions: List.generate(
                10,
                (index) => SuggestionData(
                  label: 'Item $index',
                  value: '${index * 10}',
                  unit: 'U',
                  onTap: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );

    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/suggestion_list_collapsed_component.png'),
    );
  });

  testWidgets('SuggestionArea overflow expanded Golden Test',
      (WidgetTester tester) async {
    final colors = AppColorsExtension.create();

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
        backgroundColor: colors.pageBackground,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text('Suggestion List - Expanded'),
            const SizedBox(height: CoreSpacing.space8),
            testCoreSuggestionArea(
              aiSuggestions: List.generate(
                10,
                (index) => SuggestionData(
                  label: 'Item $index',
                  value: '${index * 10}',
                  unit: 'U',
                  onTap: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );

    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();
    await tester.tap(_expandToggleFinder);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/suggestion_list_expanded_component.png'),
    );
  });

  Future<void> pumpBindOffer(WidgetTester tester, ThemeData theme) async {
    final colors = theme.coreColors;

    debugDisableShadows = false;
    addTearDown(() => debugDisableShadows = true);

    // physicalSize is in physical pixels; logical size = physicalSize / DPR.
    // 824x128 @ 2.0 => 412x64 logical: one row of large chips (48 + the
    // chip's own space2 vertical padding) and nothing else.
    tester.view.physicalSize = const Size(824, 128);
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
          body: testCoreSuggestionArea(
            aiSuggestions: [
              SuggestionData(
                label: 'Height:',
                value: '8ft',
                kind: SuggestionKind.bind,
                onTap: () {},
              ),
              SuggestionData(
                label: 'Area:',
                value: '220',
                unit: 'ft²',
                kind: SuggestionKind.deterministic,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 100));
  }

  testWidgets('SuggestionArea bind offer Golden Test - Light',
      (WidgetTester tester) async {
    await pumpBindOffer(tester, CoreTheme.light());

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/suggestion_area_bind_light.png'),
    );
    debugDisableShadows = true;
  });

  testWidgets('SuggestionArea bind offer Golden Test - Dark',
      (WidgetTester tester) async {
    await pumpBindOffer(tester, CoreTheme.dark());

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/suggestion_area_bind_dark.png'),
    );
    debugDisableShadows = true;
  });

  Future<void> pumpTwoRows(WidgetTester tester, ThemeData theme) async {
    final colors = theme.coreColors;

    debugDisableShadows = false;
    addTearDown(() => debugDisableShadows = true);

    // physicalSize is in physical pixels; logical size = physicalSize / DPR.
    // 1236x384 @ 3.0 => 412x128 logical: the primary row over the conversions
    // row, each 64 tall (48 chip + its own space2 vertical padding).
    tester.view.physicalSize = const Size(1236, 384);
    tester.view.devicePixelRatio = 3.0;
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
          body: testCoreSuggestionArea(
            layout: CoreSuggestionLayout.twoRows,
            aiSuggestions: [
              SuggestionData(
                label: 'Area:',
                value: '410.67',
                unit: 'ft²',
                kind: SuggestionKind.deterministic,
                onTap: () {},
              ),
              SuggestionData(
                label: 'Cost:',
                value: '\$84.25',
                kind: SuggestionKind.predictive,
                onTap: () {},
              ),
            ],
            conversionSuggestions: [
              SuggestionData(
                label: 'Conv:',
                value: '264',
                unit: 'in',
                kind: SuggestionKind.conversion,
                onTap: () {},
              ),
              SuggestionData(
                label: 'Conv:',
                value: '7.33',
                unit: 'yd',
                kind: SuggestionKind.conversion,
                onTap: () {},
              ),
              SuggestionData(
                label: 'Conv:',
                value: '6.71',
                unit: 'm',
                kind: SuggestionKind.conversion,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );

    await tester.pump();
  }

  testWidgets('SuggestionArea two rows Golden Test - Light',
      (WidgetTester tester) async {
    await pumpTwoRows(tester, CoreTheme.light());

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/suggestion_area_two_rows_light.png'),
    );
    debugDisableShadows = true;
  });

  testWidgets('SuggestionArea two rows Golden Test - Dark',
      (WidgetTester tester) async {
    await pumpTwoRows(tester, CoreTheme.dark());

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/suggestion_area_two_rows_dark.png'),
    );
    debugDisableShadows = true;
  });
}
