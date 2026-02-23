import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

void main() {
  setUpAll(() async {
    await loadFonts();
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  final colors = AppColorsExtension.create();
  final typography = AppTypographyExtension.create();

  testWidgets('CoreChip Component Visual Regression Test',
      (WidgetTester tester) async {
    debugDisableShadows = false;
    await tester.binding.setSurfaceSize(const Size(1200, 900));

    // ── Small & Medium notifiers ─────────────────────────────────────────────
    final smallDefault = ValueNotifier<bool>(false);
    final smallPressed = ValueNotifier<bool>(false);
    final smallSelected = ValueNotifier<bool>(true);

    final mediumDefault = ValueNotifier<bool>(false);
    final mediumPressed = ValueNotifier<bool>(false);
    final mediumSelected = ValueNotifier<bool>(true);

    // ── Large notifiers ──────────────────────────────────────────────────────
    final largeDefault = ValueNotifier<bool>(false);
    final largePressed = ValueNotifier<bool>(false);
    final largeSelected = ValueNotifier<bool>(true);

    // ── Helpers ──────────────────────────────────────────────────────────────

    Widget stateLabel(String label) => SizedBox(
          width: 120,
          child: Text(label, style: typography.bodyMediumRegular),
        );

    /// One row: label | small chip | medium chip
    Widget smallMediumRow(
      String label,
      ValueNotifier<bool> smallNotifier,
      ValueNotifier<bool> mediumNotifier,
    ) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          stateLabel(label),
          const SizedBox(width: CoreSpacing.space8),
          CoreChip(
            label: 'Chips',
            selected: smallNotifier,
            size: CoreChipSize.small,
            icon: CoreIcons.check,
          ),
          const SizedBox(width: CoreSpacing.space8),
          CoreChip(
            label: 'Chips',
            selected: mediumNotifier,
            size: CoreChipSize.medium,
            icon: CoreIcons.check,
          ),
        ],
      );
    }

    /// One row: label | large chip
    Widget largeRow(
      String label,
      ValueNotifier<bool> largeNotifier,
    ) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          stateLabel(label),
          const SizedBox(width: CoreSpacing.space8),
          CoreChip(
            label: 'Chips',
            selected: largeNotifier,
            size: CoreChipSize.large,
            icon: CoreIcons.check,
          ),
        ],
      );
    }

    // ── Widget ───────────────────────────────────────────────────────────────

    final widget = MaterialApp(
      theme: ThemeData(extensions: [colors, typography]),
      home: Scaffold(
        backgroundColor: colors.pageBackground,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: CoreSpacing.space8,
              vertical: CoreSpacing.space8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Section 1: Small & Medium ──────────────────────────────
                smallMediumRow('Default', smallDefault, mediumDefault),
                const SizedBox(height: CoreSpacing.space8),
                smallMediumRow('On Click', smallPressed, mediumPressed),
                const SizedBox(height: CoreSpacing.space8),
                smallMediumRow('After click', smallSelected, mediumSelected),

                const SizedBox(height: CoreSpacing.space12),

                // ── Section 2: Large ───────────────────────────────────────
                largeRow('Default', largeDefault),
                const SizedBox(height: CoreSpacing.space8),
                largeRow('On Click', largePressed),
                const SizedBox(height: CoreSpacing.space8),
                largeRow('After click', largeSelected),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_chip_component.png'),
    );
    debugDisableShadows = true;
  });
}
