import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';
import 'package:ripplearc_coreui/src/components/keyboard/core_keyboard.dart';
import 'package:ripplearc_coreui/src/theme/typography_extension.dart';

import '../../load_fonts.dart';
import '../../await_images_extension.dart';

/// Helper to create theme with proper Roboto and MaterialIcons fonts for golden tests
ThemeData _createThemeWithFonts() {
  final baseTheme = CoreTheme.light();
  final typography = baseTheme.extension<TypographyExtension>()!;

  // Create typography with Roboto font family applied to all styles
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
    textTheme: baseTheme.textTheme.apply(fontFamily: 'Roboto'),
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

  testWidgets('CoreKeyboard Full UI Golden Test', (tester) async {
    final testGroups = [
      FunctionGroup(
        name: const GroupNameType(label: "Basic Geometry"),
        keys: [
          KeyType(groupName: 'Basic Geometry', label: 'Area', action: () {}),
          KeyType(groupName: 'Basic Geometry', label: 'Volume', action: () {}),
        ],
      ),
      FunctionGroup(
        name: const GroupNameType(label: "Advanced"),
        keys: [
          KeyType(groupName: 'Advanced', label: 'sin', action: () {}),
          KeyType(groupName: 'Advanced', label: 'cos', action: () {}),
          KeyType(groupName: 'Advanced', label: 'tan', action: () {}),
        ],
      ),
    ];

    final testAccentColors = {
      const GroupNameType(label: "Basic Geometry"):
          CoreTheme.light().colorScheme.primary,
      const GroupNameType(label: "Advanced"):
          CoreTheme.light().colorScheme.secondary,
    };

    final widget = MaterialApp(
      theme: _createThemeWithFonts(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: CoreTheme.light().scaffoldBackgroundColor,
        body: CoreKeyboard(
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
    );

    await tester.binding.setSurfaceSize(const Size(600, 1000));
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    // Wait for fonts to be fully loaded and applied
    await tester.pump(const Duration(milliseconds: 100));
    await tester.awaitImages();

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/core_keyboard_full_ui.png'),
    );
  });
}
