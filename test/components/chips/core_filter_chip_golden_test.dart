import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

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

  group('CoreFilterChip Screenshot Tests', () {
    const size = Size(390, 56);
    const ratio = 1.0;

    Future<void> pumpFilterChip({
      required WidgetTester tester,
      required String label,
      VoidCallback? onTap,
    }) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: _createTestTheme(),
          home: Material(
            child: Center(
              child: CoreFilterChip(
                label: label,
                onTap: onTap,
              ),
            ),
          ),
        ),
      );
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
  });
}
