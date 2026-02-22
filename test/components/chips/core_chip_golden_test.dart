import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../golden_test_typography.dart';
import '../../load_fonts.dart';

void main() {
  setUpAll(() async {
    await loadFonts();
    TestWidgetsFlutterBinding.ensureInitialized();
  });
  final colors = AppColorsExtension.create();
  final typography = createGoldenTestTypography();
  testWidgets('CoreChip Component Visual Regression Test',
          (WidgetTester tester) async {
        final isCI = Platform.environment.containsKey('CI') ||
            Platform.environment.containsKey('GITHUB_ACTIONS');
        if (isCI) return;
        await tester.binding.setSurfaceSize(const Size(1200, 900));

        final mediumDefault1 = ValueNotifier<bool>(false);
        final mediumHighlight1 = ValueNotifier<bool>(false);
        final mediumPressed1 = ValueNotifier<bool>(false);
        final mediumSelected1 = ValueNotifier<bool>(true);

        final largeDefault1 = ValueNotifier<bool>(false);
        final largeHighlight1 = ValueNotifier<bool>(false);
        final largePressed1 = ValueNotifier<bool>(false);
        final largeSelected1 = ValueNotifier<bool>(true);

        final mediumDefault2 = ValueNotifier<bool>(false);
        final mediumHighlight2 = ValueNotifier<bool>(false);
        final mediumPressed2 = ValueNotifier<bool>(false);
        final mediumSelected2 = ValueNotifier<bool>(true);

        final largeDefault2 = ValueNotifier<bool>(false);
        final largeHighlight2 = ValueNotifier<bool>(false);
        final largePressed2 = ValueNotifier<bool>(false);
        final largeSelected2 = ValueNotifier<bool>(true);

        Widget buildStateRow(
            String label,
            ValueNotifier<bool> mediumNotifier,
            ValueNotifier<bool> largeNotifier,
            ) {
          return Row(
            children: [
              SizedBox(
                width: 140,
                child: Text(label, style: typography.bodyMediumRegular),
              ),
              const SizedBox(width: CoreSpacing.space8),
              CoreChip(
                label: 'Chips',
                selected: mediumNotifier,
                size: CoreChipSize.medium,
                icon: CoreIcons.check,
              ),
              const SizedBox(width: CoreSpacing.space56),
              CoreChip(
                label: 'Chips',
                selected: largeNotifier,
                size: CoreChipSize.large,
                icon: CoreIcons.check,
              ),
            ],
          );
        }

        final widget = MaterialApp(
          theme: ThemeData(
            extensions: [colors, typography],
          ),
          home: Scaffold(
            backgroundColor: colors.pageBackground,
            body: Center(
              child: Padding(

                padding: const EdgeInsets.symmetric(horizontal: CoreSpacing.space8, vertical: CoreSpacing.space8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildStateRow('Default', mediumDefault1, largeDefault1),
                    const SizedBox(height: CoreSpacing.space8),
                    buildStateRow('Highlight', mediumHighlight1, largeHighlight1),
                    const SizedBox(height: CoreSpacing.space8),
                    buildStateRow('On Click', mediumPressed1, largePressed1),
                    const SizedBox(height: CoreSpacing.space8),
                    buildStateRow('After click', mediumSelected1, largeSelected1),

                    const SizedBox(height: CoreSpacing.space8),

                    buildStateRow('Default', mediumDefault2, largeDefault2),
                    const SizedBox(height: CoreSpacing.space8),
                    buildStateRow('Highlight', mediumHighlight2, largeHighlight2),
                    const SizedBox(height: CoreSpacing.space8),
                    buildStateRow('On Click', mediumPressed2, largePressed2),
                    const SizedBox(height: CoreSpacing.space8),
                    buildStateRow('After click', mediumSelected2, largeSelected2),
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
      });
}