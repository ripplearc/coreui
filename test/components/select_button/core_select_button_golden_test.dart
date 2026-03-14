import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await loadFonts();
  });
  final colors = AppColorsExtension.create();
  final typography = AppTypographyExtension.create();
  testWidgets('CoreSelectButton - Golden Test', (tester) async {
    debugDisableShadows = false;
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
    ];

    await tester.binding.setSurfaceSize(const Size(600, 450));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          extensions: [colors, typography],
        ),
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 600,
              height: 450,
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
}
