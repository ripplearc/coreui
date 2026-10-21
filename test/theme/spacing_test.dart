import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/src/theme/spacing.dart';

import '../load_fonts.dart';

void main() {
  setUpAll(() async {
    await loadFonts();
  });

  Widget buildSpacingRow(
    String name,
    String remValue,
    String pixelValue,
    double size,
  ) {
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
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: Text(
              remValue,
              style: const TextStyle(fontFamily: 'Roboto', fontSize: 14),
            ),
          ),
          SizedBox(
            width: 80,
            child: Text(
              pixelValue,
              style: const TextStyle(fontFamily: 'Roboto', fontSize: 14),
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

  test('px tokens are named in logical pixels', () {
    expect(CoreSpacing.px2, 2);
    expect(CoreSpacing.px3, 3);
    expect(CoreSpacing.px5, 5);
    expect(CoreSpacing.px6, 6);
    expect(CoreSpacing.px10, 10);
    expect(CoreSpacing.px11, 11);
    expect(CoreSpacing.px15, 15);
    expect(CoreSpacing.px17, 17);
  });

  testWidgets('Core Spacing Tokens Test', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));

    final widget = MaterialApp(
      theme: ThemeData(
        fontFamily: 'Roboto',
        textTheme: const TextTheme().apply(fontFamily: 'Roboto'),
      ),
      home: Scaffold(
        body: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  color: Colors.grey.shade200,
                  child: const Text(
                    'Spacing System',
                    style: TextStyle(fontSize: 14, fontFamily: 'Roboto'),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Our spacing system is based on a 4px grid (0.25rem with 16px base).',
                  style: TextStyle(fontSize: 14, fontFamily: 'Roboto'),
                ),
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 60,
                        child: Text(
                          'Token',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontFamily: 'Roboto',
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
                            fontFamily: 'Roboto',
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
                            fontFamily: 'Roboto',
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
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                buildSpacingRow('space1', '0.25rem', '4px', CoreSpacing.space1),
                buildSpacingRow('space2', '0.5rem', '8px', CoreSpacing.space2),
                buildSpacingRow(
                    'space3', '0.75rem', '12px', CoreSpacing.space3),
                buildSpacingRow('space4', '1rem', '16px', CoreSpacing.space4),
                buildSpacingRow(
                    'space5', '1.25rem', '20px', CoreSpacing.space5),
                buildSpacingRow('space6', '1.5rem', '24px', CoreSpacing.space6),
                buildSpacingRow('space8', '2rem', '32px', CoreSpacing.space8),
                buildSpacingRow(
                    'space10', '2.5rem', '40px', CoreSpacing.space10),
                buildSpacingRow('space12', '3rem', '48px', CoreSpacing.space12),
                buildSpacingRow('space16', '4rem', '64px', CoreSpacing.space16),
                buildSpacingRow('space20', '5rem', '80px', CoreSpacing.space20),
                buildSpacingRow('space24', '6rem', '96px', CoreSpacing.space24),
                buildSpacingRow(
                    'space32', '8rem', '128px', CoreSpacing.space32),
                buildSpacingRow(
                    'space40', '10rem', '160px', CoreSpacing.space40),
                buildSpacingRow(
                    'space48', '12rem', '192px', CoreSpacing.space48),
                buildSpacingRow(
                    'space56', '14rem', '224px', CoreSpacing.space56),
                buildSpacingRow(
                    'space64', '16rem', '256px', CoreSpacing.space64),
                buildSpacingRow('px2', '0.125rem', '2px', CoreSpacing.px2),
                buildSpacingRow('px3', '0.1875rem', '3px', CoreSpacing.px3),
                buildSpacingRow('px5', '0.3125rem', '5px', CoreSpacing.px5),
                buildSpacingRow('px6', '0.375rem', '6px', CoreSpacing.px6),
                buildSpacingRow('px10', '0.625rem', '10px', CoreSpacing.px10),
                buildSpacingRow('px11', '0.6875rem', '11px', CoreSpacing.px11),
                buildSpacingRow('px15', '0.9375rem', '15px', CoreSpacing.px15),
                buildSpacingRow('px17', '1.0625rem', '17px', CoreSpacing.px17),
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
      matchesGoldenFile('goldens/core_spacing_tokens.png'),
    );
  });
}
