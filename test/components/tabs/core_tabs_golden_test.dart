import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

void main() {
  setUpAll(() async {
    await loadFonts();
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('CoreTabs Golden Test - All Variants',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));

    final widget = const MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 2 Tabs - Tab 1 selected
                CoreTabs(
                  tabs: ['Tab 1', 'Tab 2'],
                  initialIndex: 0,
                ),
                SizedBox(height: 24),

                // 2 Tabs - Tab 2 selected
                CoreTabs(
                  tabs: ['Tab 1', 'Tab 2'],
                  initialIndex: 1,
                ),
                SizedBox(height: 24),

                // 3 Tabs - Tab 1 selected
                CoreTabs(
                  tabs: ['Tab 1', 'Tab 2', 'Tab 3'],
                  initialIndex: 0,
                ),
                SizedBox(height: 24),

                // 3 Tabs - Tab 2 selected
                CoreTabs(
                  tabs: ['Tab 1', 'Tab 2', 'Tab 3'],
                  initialIndex: 1,
                ),
                SizedBox(height: 24),

                // 3 Tabs - Tab 3 selected
                CoreTabs(
                  tabs: ['Tab 1', 'Tab 2', 'Tab 3'],
                  initialIndex: 2,
                ),
                SizedBox(height: 24),

                // 4 Tabs - Tab 1 selected
                CoreTabs(
                  tabs: ['Tab 1', 'Tab 2', 'Tab 3', 'Tab 4'],
                  initialIndex: 0,
                ),
                SizedBox(height: 24),

                // 4 Tabs - Tab 2 selected
                CoreTabs(
                  tabs: ['Tab 1', 'Tab 2', 'Tab 3', 'Tab 4'],
                  initialIndex: 1,
                ),
                SizedBox(height: 24),

                // 4 Tabs - Tab 3 selected
                CoreTabs(
                  tabs: ['Tab 1', 'Tab 2', 'Tab 3', 'Tab 4'],
                  initialIndex: 2,
                ),
                SizedBox(height: 24),

                // 4 Tabs - Tab 4 selected
                CoreTabs(
                  tabs: ['Tab 1', 'Tab 2', 'Tab 3', 'Tab 4'],
                  initialIndex: 3,
                ),
                SizedBox(height: 24),

                // 5 Tabs - Tab 1 selected
                CoreTabs(
                  tabs: ['Tab 1', 'Tab 2', 'Tab 3', 'Tab 4', 'Tab 5'],
                  initialIndex: 0,
                ),
                SizedBox(height: 24),

                // 5 Tabs - Tab 2 selected
                CoreTabs(
                  tabs: ['Tab 1', 'Tab 2', 'Tab 3', 'Tab 4', 'Tab 5'],
                  initialIndex: 1,
                ),
                SizedBox(height: 24),

                // 5 Tabs - Tab 3 selected
                CoreTabs(
                  tabs: ['Tab 1', 'Tab 2', 'Tab 3', 'Tab 4', 'Tab 5'],
                  initialIndex: 2,
                ),
                SizedBox(height: 24),

                // 5 Tabs - Tab 4 selected
                CoreTabs(
                  tabs: ['Tab 1', 'Tab 2', 'Tab 3', 'Tab 4', 'Tab 5'],
                  initialIndex: 3,
                ),
                SizedBox(height: 24),

                // 5 Tabs - Tab 5 selected
                CoreTabs(
                  tabs: ['Tab 1', 'Tab 2', 'Tab 3', 'Tab 4', 'Tab 5'],
                  initialIndex: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // await tester.binding.setSurfaceSize(const Size(800, 1800));

    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_tabs_component.png'),
    );
  });
}
