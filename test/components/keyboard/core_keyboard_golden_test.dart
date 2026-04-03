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

  final colors = AppColorsExtension.create();

  const basicGeometry = GroupNameType(label: "Basic Geometry");
  const materials = GroupNameType(label: "Materials");
  const trigonometry = GroupNameType(label: "Trigonometry");

  testWidgets('CoreKeyboard Full UI Golden Test - Multiple Function Groups',
      (tester) async {
    final testGroups = [
      FunctionGroup(
        name: basicGeometry,
        keys: [
          KeyType(groupName: 'Basic Geometry', label: 'Area', action: () {}),
          KeyType(groupName: 'Basic Geometry', label: 'Volume', action: () {}),
          KeyType(
            groupName: 'Basic Geometry',
            label: 'Perimeter',
            action: () {},
          ),
        ],
      ),
      FunctionGroup(
        name: materials,
        keys: [
          KeyType(groupName: 'Materials', label: 'Wood', action: () {}),
          KeyType(groupName: 'Materials', label: 'Steel', action: () {}),
          KeyType(groupName: 'Materials', label: 'Concrete', action: () {}),
        ],
      ),
      FunctionGroup(
        name: trigonometry,
        keys: [
          KeyType(groupName: 'Trigonometry', label: 'sin', action: () {}),
          KeyType(groupName: 'Trigonometry', label: 'cos', action: () {}),
          KeyType(groupName: 'Trigonometry', label: 'tan', action: () {}),
        ],
      ),
    ];

    final testAccentColors = {
      basicGeometry: colors.keyboardFunctions,
      materials: colors.keyboardActions,
      trigonometry: colors.keyboardFunctions,
    };

    final widget = MaterialApp(
      theme: CoreTheme.light().copyWith(
        textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto'),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: colors.pageBackground,
        body: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: CoreKeyboard(
            currentGroup: basicGeometry,
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
    await tester.binding.setSurfaceSize(const Size(350, 550));
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();
    await tester.awaitImages();
    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/core_keyboard_full_ui_small.png'),
    );
    await tester.binding.setSurfaceSize(const Size(800, 650));
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();
    await tester.awaitImages();
    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/core_keyboard_full_ui_large.png'),
    );
  });
}
