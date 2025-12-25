import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../await_images_extension.dart';
import '../../load_fonts.dart';

ThemeData _createTestTheme() {
  return CoreTheme.light().copyWith(
    textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto'),
  );
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await loadFonts();
  });

  testWidgets('CoreFunctionKeyBottomSheet Golden Test', (tester) async {
    final testGroups = [
      FunctionGroup(
        name: const GroupNameType(label: 'Trigonomety'),
        keys: [
          KeyType(groupName: 'Trigonomety', label: 'sin', action: () {}),
          KeyType(groupName: 'Trigonomety', label: 'cos', action: () {}),
          KeyType(groupName: 'Trigonomety', label: 'tan', action: () {}),
        ],
      ),
      FunctionGroup(
        name: const GroupNameType(label: 'Materials'),
        keys: [
          KeyType(groupName: 'Materials', label: 'Wood', action: () {}),
          KeyType(groupName: 'Materials', label: 'Steel', action: () {}),
          KeyType(groupName: 'Materials', label: 'Concrete', action: () {}),
        ],
      ),
    ];

    final testAccentColors = {
      const GroupNameType(label: 'Trigonomety'):
          CoreBackgroundColors.backgroundDarkGray,
      const GroupNameType(label: 'Materials'):
          CoreBackgroundColors.backgroundOrientMid,
    };

    final widget = MaterialApp(
      theme: _createTestTheme(),
      home: Scaffold(
        backgroundColor: CoreBackgroundColors.pageBackground,
        body: Center(
          child: CoreFunctionKeyBottomSheet(
            groups: testGroups,
            groupAccentColors: testAccentColors,
            selectedGroup: const GroupNameType(label: 'Trigonomety'),
            onGroupSelected: (_) {},
            onKeyTapped: (_) {},
            showUnitToggle: true,
            currentUnitSystem: UnitSystem.imperial,
            onUnitSystemChanged: (_) {},
          ),
        ),
      ),
    );

    await tester.binding.setSurfaceSize(const Size(500, 800));
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.awaitImages();

    await expectLater(
      find.byType(CoreFunctionKeyBottomSheet),
      matchesGoldenFile('goldens/core_function_key_bottomsheet.png'),
    );
  });
}
