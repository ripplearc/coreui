import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await loadFonts();
  });

  testWidgets('CoreSelectButton - Golden Test', (tester) async {
    final colors = AppColorsExtension.create();
    final typography = AppTypographyExtension.create();
    debugDisableShadows = false;
    addTearDown(() => debugDisableShadows = true);
    Widget scenario(String title, Widget button) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: typography.bodyMediumSemiBold,
          ),
          const SizedBox(height: 8),
          button,
        ],
      );
    }

    final buttons = [
      scenario(
        'Default - Tab 1 Selected',
        CoreSelectButton(
          tabs: const ['Tab 1', 'Tab 2', 'Tab 3'],
          selectedIndex: 0,
          onChanged: (_) {},
        ),
      ),
      scenario(
        'Tab 2 Selected',
        CoreSelectButton(
          tabs: const ['Tab 1', 'Tab 2', 'Tab 3'],
          selectedIndex: 1,
          onChanged: (_) {},
        ),
      ),
      scenario(
        'Tab 3 Selected',
        CoreSelectButton(
          tabs: const ['Tab 1', 'Tab 2', 'Tab 3'],
          selectedIndex: 2,
          onChanged: (_) {},
        ),
      ),
      scenario(
        'Many Tabs - Tab 1 Selected',
        CoreSelectButton(
          tabs: const ['Overview', 'Details', 'Settings', 'History', 'Analytics', 'Reports'],
          selectedIndex: 0,
          onChanged: (_) {},
        ),
      ),
    ];

    await tester.binding.setSurfaceSize(const Size(700, 600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          extensions: [colors, typography],
        ),
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 700,
              height: 600,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ...buttons.map((button) => Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: button,
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_select_button.png'),
    );

    debugDisableShadows = true;
  });

  Future<void> pumpSingle(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 80));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          extensions: [
            AppColorsExtension.create(),
            AppTypographyExtension.create(),
          ],
        ),
        home: Scaffold(
          body: Center(
            child: CoreSelectButton(
              tabs: const ['Tab 1', 'Tab 2', 'Tab 3'],
              selectedIndex: 0,
              onChanged: (_) {},
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('CoreSelectButton - Golden Test, Tab 2 focused', (tester) async {
    await pumpSingle(tester);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_select_button_focused.png'),
    );
  });

  testWidgets('CoreSelectButton - Golden Test, Tab 2 pressed', (tester) async {
    await pumpSingle(tester);
    final gesture = await tester.press(find.text('Tab 2'));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_select_button_pressed.png'),
    );
    await gesture.cancel();
  });
}
