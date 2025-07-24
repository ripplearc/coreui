import 'package:core_ui/src/theme/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  Widget buildSpacingRow(
      String name, String remValue, String pixelValue, double size) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: Text(
              remValue,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          SizedBox(
            width: 80,
            child: Text(
              pixelValue,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Container(
            height: 24,
            width: size,
            decoration: BoxDecoration(
              color: Colors.blue.shade200,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  testGoldens('Core Spacing Tokens Test', (tester) async {
    final builder = GoldenBuilder.column()
      ..addScenario(
        'Spacing Variations',
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                color: Colors.grey.shade200,
                child: const Text(
                  'Spacing System',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Our spacing system is based on a 4px grid (0.25rem with 16px base).',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 24),

              // Header row
              const Padding(
                padding:  EdgeInsets.only(bottom: 16),
                child: Row(
                  children:  [
                    SizedBox(
                      width: 60,
                      child: Text(
                        'Token',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: Text(
                        'rem',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      child: Text(
                        'pixels',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Example',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Spacing rows
              buildSpacingRow('space1', '0.25rem', '4px', CoreSpacing.space1),
              buildSpacingRow('space2', '0.5rem', '8px', CoreSpacing.space2),
              buildSpacingRow('space3', '0.75rem', '12px', CoreSpacing.space3),
              buildSpacingRow('space4', '1rem', '16px', CoreSpacing.space4),
              buildSpacingRow('space5', '1.25rem', '20px', CoreSpacing.space5),
              buildSpacingRow('space6', '1.5rem', '24px', CoreSpacing.space6),
              buildSpacingRow('space8', '2rem', '32px', CoreSpacing.space8),
              buildSpacingRow(
                  'space10', '2.5rem', '40px', CoreSpacing.space10),
              buildSpacingRow('space12', '3rem', '48px', CoreSpacing.space12),
              buildSpacingRow('space16', '4rem', '64px', CoreSpacing.space16),
              buildSpacingRow('space20', '5rem', '80px', CoreSpacing.space20),
              buildSpacingRow('space24', '6rem', '96px', CoreSpacing.space24),
              buildSpacingRow('space32', '8rem', '128px', CoreSpacing.space32),
              buildSpacingRow(
                  'space40', '10rem', '160px', CoreSpacing.space40),
              buildSpacingRow(
                  'space48', '12rem', '192px', CoreSpacing.space48),
              buildSpacingRow(
                  'space56', '14rem', '224px', CoreSpacing.space56),
              buildSpacingRow(
                  'space64', '16rem', '256px', CoreSpacing.space64),
            ],
          ),
        ),
      );

    await tester.pumpWidgetBuilder(
      builder.build(),
      surfaceSize: const Size(800, 950),
    );

    await screenMatchesGolden(tester, 'core_spacing_tokens');
  });
}
