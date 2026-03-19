import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

ThemeData _createTestTheme() {
  return CoreTheme.light().copyWith(
    textTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'Roboto',
        ),
  );
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await loadFonts();
  });

  final typography = AppTypographyExtension.create();
  final colors = AppColorsExtension.create();

  testWidgets('CoreTabs Golden Test - All Variants',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1100));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final widget = MaterialApp(
      theme: _createTestTheme(),
      home: Scaffold(
        backgroundColor: colors.pageBackground,
        body: Padding(
          padding: EdgeInsets.all(CoreSpacing.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tabs Test',
                style: typography.bodyLargeSemiBold
                    .copyWith(color: colors.textDark),
              ),
              CoreTabs(tabs: ['Tab 1', 'Tab 2'], selectedIndex: 0),
              SizedBox(height: CoreSpacing.space6),
              CoreTabs(tabs: ['Tab 1', 'Tab 2'], selectedIndex: 1),
              SizedBox(height: CoreSpacing.space6),
              CoreTabs(tabs: ['Tab 1', 'Tab 2', 'Tab 3'], selectedIndex: 0),
              SizedBox(height: CoreSpacing.space6),
              CoreTabs(tabs: ['Tab 1', 'Tab 2', 'Tab 3'], selectedIndex: 1),
              SizedBox(height: CoreSpacing.space6),
              CoreTabs(tabs: ['Tab 1', 'Tab 2', 'Tab 3'], selectedIndex: 2),
              SizedBox(height: CoreSpacing.space6),
              CoreTabs(
                  tabs: ['Tab 1', 'Tab 2', 'Tab 3', 'Tab 4'], selectedIndex: 0),
              SizedBox(height: CoreSpacing.space6),
              CoreTabs(
                  tabs: ['Tab 1', 'Tab 2', 'Tab 3', 'Tab 4'], selectedIndex: 1),
              SizedBox(height: CoreSpacing.space6),
              CoreTabs(
                  tabs: ['Tab 1', 'Tab 2', 'Tab 3', 'Tab 4'], selectedIndex: 2),
              SizedBox(height: CoreSpacing.space6),
              CoreTabs(
                  tabs: ['Tab 1', 'Tab 2', 'Tab 3', 'Tab 4'], selectedIndex: 3),
              SizedBox(height: CoreSpacing.space6),
              CoreTabs(
                  tabs: ['Tab 1', 'Tab 2', 'Tab 3', 'Tab 4', 'Tab 5'],
                  selectedIndex: 0),
              SizedBox(height: CoreSpacing.space6),
              CoreTabs(
                  tabs: ['Tab 1', 'Tab 2', 'Tab 3', 'Tab 4', 'Tab 5'],
                  selectedIndex: 1),
              SizedBox(height: CoreSpacing.space6),
              CoreTabs(
                  tabs: ['Tab 1', 'Tab 2', 'Tab 3', 'Tab 4', 'Tab 5'],
                  selectedIndex: 2),
              SizedBox(height: CoreSpacing.space6),
              CoreTabs(
                  tabs: ['Tab 1', 'Tab 2', 'Tab 3', 'Tab 4', 'Tab 5'],
                  selectedIndex: 3),
              SizedBox(height: CoreSpacing.space6),
              CoreTabs(
                  tabs: ['Tab 1', 'Tab 2', 'Tab 3', 'Tab 4', 'Tab 5'],
                  selectedIndex: 4),
            ],
          ),
        ),
      ),
    );

    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_tabs_component.png'),
    );
  });
}
