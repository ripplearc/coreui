import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../await_images_extension.dart';
import '../../load_fonts.dart';

ThemeData _createThemeWithFonts() {
  final baseTheme = CoreTheme.light();
  final typography = baseTheme.extension<TypographyExtension>()!;

  final testTypography = TypographyExtension(
    headlineLargeRegular:
        typography.headlineLargeRegular.copyWith(fontFamily: 'Roboto'),
    headlineLargeSemiBold:
        typography.headlineLargeSemiBold.copyWith(fontFamily: 'Roboto'),
    headlineMediumRegular:
        typography.headlineMediumRegular.copyWith(fontFamily: 'Roboto'),
    headlineMediumSemiBold:
        typography.headlineMediumSemiBold.copyWith(fontFamily: 'Roboto'),
    titleLargeRegular:
        typography.titleLargeRegular.copyWith(fontFamily: 'Roboto'),
    titleLargeMedium:
        typography.titleLargeMedium.copyWith(fontFamily: 'Roboto'),
    titleLargeSemiBold:
        typography.titleLargeSemiBold.copyWith(fontFamily: 'Roboto'),
    titleMediumRegular:
        typography.titleMediumRegular.copyWith(fontFamily: 'Roboto'),
    titleMediumMedium:
        typography.titleMediumMedium.copyWith(fontFamily: 'Roboto'),
    titleMediumSemiBold:
        typography.titleMediumSemiBold.copyWith(fontFamily: 'Roboto'),
    bodyLargeRegular:
        typography.bodyLargeRegular.copyWith(fontFamily: 'Roboto'),
    bodyLargeMedium: typography.bodyLargeMedium.copyWith(fontFamily: 'Roboto'),
    bodyLargeSemiBold:
        typography.bodyLargeSemiBold.copyWith(fontFamily: 'Roboto'),
    bodyMediumRegular:
        typography.bodyMediumRegular.copyWith(fontFamily: 'Roboto'),
    bodyMediumMedium:
        typography.bodyMediumMedium.copyWith(fontFamily: 'Roboto'),
    bodyMediumSemiBold:
        typography.bodyMediumSemiBold.copyWith(fontFamily: 'Roboto'),
    bodySmallRegular:
        typography.bodySmallRegular.copyWith(fontFamily: 'Roboto'),
    bodySmallMedium: typography.bodySmallMedium.copyWith(fontFamily: 'Roboto'),
    bodySmallSemiBold:
        typography.bodySmallSemiBold.copyWith(fontFamily: 'Roboto'),
  );

  return ThemeData(
    fontFamily: 'Roboto',
    materialTapTargetSize: baseTheme.materialTapTargetSize,
    primaryColor: baseTheme.primaryColor,
    colorScheme: baseTheme.colorScheme,
    useMaterial3: baseTheme.useMaterial3,
    iconTheme: baseTheme.iconTheme.copyWith(),
    extensions: [
      baseTheme.extension<AppColorsExtension>()!,
      testTypography,
    ],
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
          CoreTheme.light().colorScheme.primary,
      const GroupNameType(label: 'Materials'):
          CoreTheme.light().colorScheme.secondary,
    };

    final widget = MaterialApp(
      theme: _createThemeWithFonts(),
      home: Scaffold(
        backgroundColor: CoreTheme.light().colorScheme.surface,
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
