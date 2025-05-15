import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:core_ui/src/theme/color_tokens.dart';

void main() {
  setUpAll(() async {
    // Initialize golden testing
    await loadAppFonts();
  });

  testGoldens('Core Text Colors Golden Test', (tester) async {
    // Build a simple widget that displays color swatches
    final builder = GoldenBuilder.column()
      ..addScenario(
        'Core Text Colors',
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildColorSwatch('headline', CoreTextColors.headline),
              _buildColorSwatch('dark', CoreTextColors.dark),
              _buildColorSwatch('body', CoreTextColors.body),
              _buildColorSwatch('disable', CoreTextColors.disable),
              _buildColorSwatch('inverse', CoreTextColors.inverse),
              _buildColorSwatch('link', CoreTextColors.link),
              _buildColorSwatch('info', CoreTextColors.info),
              _buildColorSwatch('warning', CoreTextColors.warning),
              _buildColorSwatch('error', CoreTextColors.error),
              _buildColorSwatch('success', CoreTextColors.success),
            ],
          ),
        ),
      );

    await tester.pumpWidgetBuilder(
      builder.build(),
      surfaceSize: const Size(800, 200),
    );

    await screenMatchesGolden(tester, 'core_text_colors');
  });
}

Widget _buildColorSwatch(String label, Color color) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      const SizedBox(height: 4),
      Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
    ],
  );
} 