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

    for (final dark in [false, true]) {
      final suffix = dark ? '_dark' : '';
      final theme = dark ? ' in dark theme' : '';
      testWidgets('renders pressed chip correctly$theme', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = ratio;
        addTearDown(() => tester.view.resetPhysicalSize());

        await pumpFilterChip(
          tester: tester,
          label: 'Tags',
          onTap: () {},
          dark: dark,
        );
        final gesture = await tester.startGesture(
          tester.getCenter(find.byKey(CoreFilterChip.pillKey)),
        );
        await tester.pump();

        await expectLater(
          find.byType(CoreFilterChip),
          matchesGoldenFile('goldens/core_filter_chip_pressed$suffix.png'),
        );
        await gesture.up();
      });
    }

    testWidgets('renders chip at 200% text correctly', (tester) async {
      tester.view.physicalSize = const Size(390, 72);
      tester.view.devicePixelRatio = ratio;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        MaterialApp(
          theme: _createTestTheme(),
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(2),
            ),
            child: child!,
          ),
          home: Material(
            child: Center(child: CoreFilterChip(label: 'Tags', onTap: () {})),
          ),
        ),
      );

      await expectLater(
        find.byType(CoreFilterChip),
        matchesGoldenFile('goldens/core_filter_chip_text_200.png'),
      );
    });
  });
}
