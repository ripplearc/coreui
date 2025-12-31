import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../await_images_extension.dart';
import '../../load_fonts.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await loadFonts();
  });

  testWidgets('CoreKeyboard Full UI Golden Test - Multiple Function Groups',
      (tester) async {
    final testGroups = [
      FunctionGroup(
        name: const GroupNameType(label: "Basic Geometry"),
        keys: [
          KeyType(groupName: 'Basic Geometry', label: 'Area', action: () {}),
          KeyType(groupName: 'Basic Geometry', label: 'Volume', action: () {}),
          KeyType(
              groupName: 'Basic Geometry', label: 'Perimeter', action: () {}),
        ],
      ),
      FunctionGroup(
        name: const GroupNameType(label: "Materials"),
        keys: [
          KeyType(groupName: 'Materials', label: 'Wood', action: () {}),
          KeyType(groupName: 'Materials', label: 'Steel', action: () {}),
          KeyType(groupName: 'Materials', label: 'Concrete', action: () {}),
        ],
      ),
      FunctionGroup(
        name: const GroupNameType(label: "Trigonometry"),
        keys: [
          KeyType(groupName: 'Trigonometry', label: 'sin', action: () {}),
          KeyType(groupName: 'Trigonometry', label: 'cos', action: () {}),
          KeyType(groupName: 'Trigonometry', label: 'tan', action: () {}),
        ],
      ),
    ];

    final testAccentColors = {
      const GroupNameType(label: "Basic Geometry"):
          CoreKeyboardColors.functions,
      const GroupNameType(label: "Materials"): CoreKeyboardColors.actions,
      const GroupNameType(label: "Trigonometry"): CoreKeyboardColors.functions,
    };

    final widget = MaterialApp(
      theme: CoreTheme.light().copyWith(
        textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto'),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: CoreBackgroundColors.pageBackground,
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: CoreKeyboard(
            currentGroup: const GroupNameType(label: "Basic Geometry"),
            allGroups: testGroups,
            onDigitPressed: (_) {},
            onUnitSelected: (_) {},
            onOperatorPressed: (_) {},
            onControlAction: (_) {},
            onResultTapped: () {},
            onGroupSelected: (_) {},
            onKeyTapped: (_) {},
            onUnitSystemChanged: (_) {},
            groupAccentColors: testAccentColors,
          ),
        ),
      ),
    );

    await tester.binding.setSurfaceSize(const Size(350, 430));

    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();
    await tester.awaitImages();

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/core_keyboard_full_ui.png'),
    );
  });
}
