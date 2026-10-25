import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

ThemeData _createTestTheme({bool dark = false}) {
  return (dark ? CoreTheme.dark() : CoreTheme.light()).copyWith(
    textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto'),
  );
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await loadFonts();
  });

  group('CoreFilterChip Screenshot Tests', () {
    const size = Size(390, 56);
    const ratio = 1.0;

    Future<void> pumpFilterChip({
      required WidgetTester tester,
      required String label,
      VoidCallback? onTap,
      bool dark = false,
      bool focused = false,
      Color? parentColor,
    }) async {
      final chip = Center(
        child: CoreFilterChip(
          label: label,
          onTap: onTap,
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: _createTestTheme(dark: dark),
          home: Material(
            child: parentColor == null
                ? chip
                : ColoredBox(color: parentColor, child: chip),
          ),
        ),
      );
      if (focused) await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
    }

    testWidgets('renders chip correctly', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = ratio;
      addTearDown(() => tester.view.resetPhysicalSize());

      await pumpFilterChip(
        tester: tester,
        label: 'Tags',
        onTap: () {},
      );

      await expectLater(
        find.byType(CoreFilterChip),
        matchesGoldenFile('goldens/core_filter_chip_default.png'),
      );
    });

    testWidgets('renders chip correctly in dark theme', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = ratio;
      addTearDown(() => tester.view.resetPhysicalSize());

      await pumpFilterChip(
        tester: tester,
        label: 'Tags',
        onTap: () {},
        dark: true,
      );

      await expectLater(
        find.byType(CoreFilterChip),
        matchesGoldenFile('goldens/core_filter_chip_default_dark.png'),
      );
    });

    testWidgets('renders chip with long label correctly', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = ratio;
      addTearDown(() => tester.view.resetPhysicalSize());

      await pumpFilterChip(
        tester: tester,
        label: 'Recently Modified',
        onTap: () {},
      );

      await expectLater(
        find.byType(CoreFilterChip),
        matchesGoldenFile('goldens/core_filter_chip_long_label.png'),
      );
    });

    testWidgets('renders disabled chip correctly', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = ratio;
      addTearDown(() => tester.view.resetPhysicalSize());

      await pumpFilterChip(
        tester: tester,
        label: 'Tags',
      );

      await expectLater(
        find.byType(CoreFilterChip),
        matchesGoldenFile('goldens/core_filter_chip_disabled.png'),
      );
    });

    testWidgets('renders focused chip correctly', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = ratio;
      addTearDown(() => tester.view.resetPhysicalSize());

      await pumpFilterChip(
        tester: tester,
        label: 'Tags',
        onTap: () {},
        focused: true,
      );

      await expectLater(
        find.byType(CoreFilterChip),
        matchesGoldenFile('goldens/core_filter_chip_focused.png'),
      );
    });

    testWidgets('renders focused chip correctly in dark theme', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = ratio;
      addTearDown(() => tester.view.resetPhysicalSize());

      await pumpFilterChip(
        tester: tester,
        label: 'Tags',
        onTap: () {},
        dark: true,
        focused: true,
      );

      await expectLater(
        find.byType(CoreFilterChip),
        matchesGoldenFile('goldens/core_filter_chip_focused_dark.png'),
      );
    });

    testWidgets('renders chip on a coloured parent correctly', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = ratio;
      addTearDown(() => tester.view.resetPhysicalSize());

      await pumpFilterChip(
        tester: tester,
        label: 'Tags',
        onTap: () {},
        parentColor: AppColorsExtension.create().backgroundGrayMid,
      );

      await expectLater(
        find.byType(CoreFilterChip),
        matchesGoldenFile('goldens/core_filter_chip_coloured_parent.png'),
      );
    });
  });
}
