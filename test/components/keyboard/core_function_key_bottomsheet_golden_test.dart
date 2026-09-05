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
  final colors = AppColorsExtension.create();
  testWidgets('CoreFunctionKeyBottomSheet Golden Test', (tester) async {
    final testGroups = [
      FunctionGroup(
        name: const GroupNameType(id: 'Trigonomety', label: 'Trigonomety'),
        keys: [
          KeyType(groupName: 'Trigonomety', id: 'sin', label: 'sin', action: () {}),
          KeyType(groupName: 'Trigonomety', id: 'cos', label: 'cos', action: () {}),
          KeyType(groupName: 'Trigonomety', id: 'tan', label: 'tan', action: () {}),
          KeyType(groupName: 'Trigonomety', id: 'csc', label: 'csc', action: () {}),
          KeyType(groupName: 'Trigonomety', id: 'sec', label: 'sec', action: () {}),
        ],
      ),
      FunctionGroup(
        name: const GroupNameType(id: 'Materials', label: 'Materials'),
        keys: [
          KeyType(groupName: 'Materials', id: 'Wood', label: 'Wood', action: () {}),
          KeyType(groupName: 'Materials', id: 'Steel', label: 'Steel', action: () {}),
          KeyType(groupName: 'Materials', id: 'Concrete', label: 'Concrete', action: () {}),
          KeyType(groupName: 'Materials', id: 'Brick', label: 'Brick', action: () {}),
          KeyType(groupName: 'Materials', id: 'Glass', label: 'Glass', action: () {}),
        ],
      ),
    ];

    final testAccentColors = {
      const GroupNameType(id: 'Trigonomety', label: 'Trigonomety'):
          colors.backgroundDarkGray,
      const GroupNameType(id: 'Materials', label: 'Materials'):
          colors.orientMid,
    };

    final widget = MaterialApp(
      theme: _createTestTheme(),
      home: Scaffold(
        backgroundColor: colors.pageBackground,
        body: Center(
          child: CoreFunctionKeyBottomSheet(
            groups: testGroups,
            groupAccentColors: testAccentColors,
            selectedGroup: const GroupNameType(id: 'Trigonomety', label: 'Trigonomety'),
            onGroupSelected: (_) {},
            onKeyTapped: (_) {},
            showUnitToggle: true,
            currentUnitSystem: UnitSystem.imperial,
            onUnitSystemChanged: (_) {},
          ),
        ),
      ),
    );

    await tester.binding.setSurfaceSize(const Size(500, 500));
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();
    await tester.awaitImages();

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/core_function_key_bottomsheet.png'),
    );
  });
}
