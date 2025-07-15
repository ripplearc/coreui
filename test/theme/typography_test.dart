import 'package:core_ui/src/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  Widget buildTypographyRow(String name, String fontFamily, String weight,
      String size, TextStyle style) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 250,
            child: Text(name, style: style),
          ),
          SizedBox(
            width: 360,
            child: Text(fontFamily, style: style),
          ),
          SizedBox(
            width: 150,
            child: Text(weight, style: style),
          ),
          SizedBox(
            width: 100,
            child: Text(size, style: style),
          ),
        ],
      ),
    );
  }

  Widget buildTypographySection(String title, List<Widget> rows) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        ...rows,
        const SizedBox(height: 16),
      ],
    );
  }

  testGoldens('Core Typography Tokens Test', (tester) async {
    final builder = GoldenBuilder.column()
      ..addScenario(
        'Typography Variations',
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
                child: const Text('Android_Typography',
                    style: TextStyle(fontSize: 14)),
              ),
              const SizedBox(height: 16),

              // Headline Large
              buildTypographySection(
                'Headline Large',
                [
                  buildTypographyRow(
                    'Headline Large',
                    'IBM Plex Sans Hebrew',
                    'Regular',
                    '32/40',
                    CoreTypography.headlineLargeRegular(),
                  ),
                  buildTypographyRow(
                    'Headline Large',
                    'IBM Plex Sans Hebrew',
                    'Semibold',
                    '32/40',
                    CoreTypography.headlineLargeSemiBold(),
                  ),
                ],
              ),

              // Headline Medium
              buildTypographySection(
                'Headline Medium',
                [
                  buildTypographyRow(
                    'Headline Medium',
                    'IBM Plex Sans Hebrew',
                    'Regular',
                    '24/32',
                    CoreTypography.headlineMediumRegular(),
                  ),
                  buildTypographyRow(
                    'Headline Medium',
                    'IBM Plex Sans Hebrew',
                    'Semibold',
                    '24/32',
                    CoreTypography.headlineMediumSemiBold(),
                  ),
                ],
              ),

              // Title Large
              buildTypographySection(
                'Title Large',
                [
                  buildTypographyRow(
                    'Title Large',
                    'IBM Plex Sans Hebrew',
                    'Regular',
                    '20/28',
                    CoreTypography.titleLargeRegular(),
                  ),
                  buildTypographyRow(
                    'Title Large',
                    'IBM Plex Sans Hebrew',
                    'Medium',
                    '20/28',
                    CoreTypography.titleLargeMedium(),
                  ),
                  buildTypographyRow(
                    'Title Large',
                    'IBM Plex Sans Hebrew',
                    'Semibold',
                    '20/28',
                    CoreTypography.titleLargeSemiBold(),
                  ),
                ],
              ),

              // Title Medium
              buildTypographySection(
                'Title Medium',
                [
                  buildTypographyRow(
                    'Title Medium',
                    'IBM Plex Sans Hebrew',
                    'Regular',
                    '18/26',
                    CoreTypography.titleMediumRegular(),
                  ),
                  buildTypographyRow(
                    'Title Medium',
                    'IBM Plex Sans Hebrew',
                    'Medium',
                    '18/26',
                    CoreTypography.titleMediumMedium(),
                  ),
                  buildTypographyRow(
                    'Title Medium',
                    'IBM Plex Sans Hebrew',
                    'Semibold',
                    '18/26',
                    CoreTypography.titleMediumSemiBold(),
                  ),
                ],
              ),

              // Body Large
              buildTypographySection(
                'Body Large',
                [
                  buildTypographyRow(
                    'Body Large',
                    'IBM Plex Sans Hebrew',
                    'Regular',
                    '16/24',
                    CoreTypography.bodyLargeRegular(),
                  ),
                  buildTypographyRow(
                    'Body Large',
                    'IBM Plex Sans Hebrew',
                    'Medium',
                    '16/24',
                    CoreTypography.bodyLargeMedium(),
                  ),
                  buildTypographyRow(
                    'Body Large',
                    'IBM Plex Sans Hebrew',
                    'Semibold',
                    '16/24',
                    CoreTypography.bodyLargeSemiBold(),
                  ),
                ],
              ),

              // Body Medium
              buildTypographySection(
                'Body Medium',
                [
                  buildTypographyRow(
                    'Body Medium',
                    'IBM Plex Sans Hebrew',
                    'Regular',
                    '14/20',
                    CoreTypography.bodyMediumRegular(),
                  ),
                  buildTypographyRow(
                    'Body Medium',
                    'IBM Plex Sans Hebrew',
                    'Medium',
                    '14/20',
                    CoreTypography.bodyMediumMedium(),
                  ),
                  buildTypographyRow(
                    'Body Medium',
                    'IBM Plex Sans Hebrew',
                    'Semibold',
                    '14/20',
                    CoreTypography.bodyMediumSemiBold(),
                  ),
                ],
              ),

              // Body Small
              buildTypographySection(
                'Body Small',
                [
                  buildTypographyRow(
                    'Body Small',
                    'IBM Plex Sans Hebrew',
                    'Regular',
                    '12/16',
                    CoreTypography.bodySmallRegular(),
                  ),
                  buildTypographyRow(
                    'Body Small',
                    'IBM Plex Sans Hebrew',
                    'Medium',
                    '12/16',
                    CoreTypography.bodySmallMedium(),
                  ),
                  buildTypographyRow(
                    'Body Small',
                    'IBM Plex Sans Hebrew',
                    'Semibold',
                    '12/16',
                    CoreTypography.bodySmallSemiBold(),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

    await tester.pumpWidgetBuilder(
      builder.build(),
      surfaceSize: const Size(1310, 1600),
    );

    await screenMatchesGolden(tester, 'core_typography_tokens');
  });
}
