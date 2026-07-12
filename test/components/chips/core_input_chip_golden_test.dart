import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

ThemeData _createTestTheme() {
  return CoreTheme.light().copyWith(
    textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto'),
  );
}

ThemeData _createDarkTestTheme() {
  return CoreTheme.dark().copyWith(
    textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Roboto'),
  );
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await loadFonts();
  });

  group('CoreInputChip Screenshot Tests', () {
    const size = Size(390, 56);
    const ratio = 1.0;

    Future<void> pumpChip({
      required WidgetTester tester,
      required String label,
      ThemeData? theme,
    }) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = ratio;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        MaterialApp(
          theme: theme ?? _createTestTheme(),
          home: Material(
            child: Center(
              child: CoreInputChip(
                label: label,
                onRemove: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('renders chip with short label', (tester) async {
      await pumpChip(tester: tester, label: 'Tag');

      await expectLater(
        find.byType(CoreInputChip),
        matchesGoldenFile('goldens/core_input_chip_short_label.png'),
      );
    });

    testWidgets('renders chip with email label', (tester) async {
      await pumpChip(tester: tester, label: 'alice@example.com');

      await expectLater(
        find.byType(CoreInputChip),
        matchesGoldenFile('goldens/core_input_chip_email_label.png'),
      );
    });

    testWidgets('renders chip with short label – dark theme', (tester) async {
      await pumpChip(
        tester: tester,
        label: 'Tag',
        theme: _createDarkTestTheme(),
      );

      await expectLater(
        find.byType(CoreInputChip),
        matchesGoldenFile('goldens/core_input_chip_short_label_dark.png'),
      );
    });

    testWidgets('renders chip with email label – dark theme', (tester) async {
      await pumpChip(
        tester: tester,
        label: 'alice@example.com',
        theme: _createDarkTestTheme(),
      );

      await expectLater(
        find.byType(CoreInputChip),
        matchesGoldenFile('goldens/core_input_chip_email_label_dark.png'),
      );
    });
  });
}
