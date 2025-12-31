import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../helper/core_test_theme_helper.dart';
import '../../load_fonts.dart';

ThemeData _createTestTheme() {
  return coreTestTheme().copyWith(
    textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto'),
  );
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await loadFonts();
  });

  testWidgets('CoreSelectButton - Golden Test', (tester) async {
    const pressedKey = Key('pressed_tab');

    Widget scenario(String title, Widget button) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
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
          initialIndex: 0,
          onChanged: (_) {},
        ),
      ),
      scenario(
        'Tab 2 Selected',
        CoreSelectButton(
          tabs: const ['Tab 1', 'Tab 2', 'Tab 3'],
          initialIndex: 1,
          onChanged: (_) {},
        ),
      ),
      scenario(
        'Tab 3 Selected',
        CoreSelectButton(
          tabs: const ['Tab 1', 'Tab 2', 'Tab 3'],
          initialIndex: 2,
          onChanged: (_) {},
        ),
      ),
      scenario(
        'Many Tabs',
        CoreSelectButton(
          key: pressedKey,
          tabs: const [
            'Short',
            'Medium Tab',
            'Very Long Tab Name',
            'Tab',
            'Another'
          ],
          initialIndex: 0,
          onChanged: (_) {},
        ),
      ),
    ];

    await tester.binding.setSurfaceSize(const Size(600, 800));

    await tester.pumpWidget(
      MaterialApp(
        theme: _createTestTheme(),
        home: Scaffold(
          backgroundColor: CoreBackgroundColors.pageBackground,
          body: Center(
            child: SizedBox(
              width: 600,
              height: 800,
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

    // Simulate pressed state
    final gesture =
        await tester.startGesture(tester.getCenter(find.byKey(pressedKey)));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_select_button.png'),
    );

    await gesture.up();
  });
}
