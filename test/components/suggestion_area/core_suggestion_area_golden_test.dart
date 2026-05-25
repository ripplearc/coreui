import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

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
        body: const Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Suggestion Area - empty state'),
            SizedBox(height: CoreSpacing.space8),
            CoreSuggestionArea(),
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
            CoreSuggestionArea(
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
            CoreSuggestionArea(
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
    await tester.tap(find.bySemanticsLabel('Toggle suggestion mode'));
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
            CoreSuggestionArea(
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
}
