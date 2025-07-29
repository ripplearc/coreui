import 'package:core_ui/src/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../load_fonts.dart';

void main() {
  setUpAll(() async {
    await loadFonts();
  });

  Widget buildTypographyRow(
      String name, String weight, String size, TextStyle style) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(name, style: style)),
          Expanded(flex: 2, child: Text(weight, style: style)),
          Expanded(flex: 1, child: Text(size, style: style)),
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

  testWidgets('Core Typography Tokens Test', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1310, 1600));

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
                    'Roboto Typography (Golden Test)',
                    style: TextStyle(fontSize: 14, fontFamily: 'Roboto'),
                  ),
                ),
                const SizedBox(height: 16),
                buildTypographySection('Headline Large', [
                  buildTypographyRow('Headline Large', 'Regular', '32/40',
                      CoreTypography.headlineLargeRegular()),
                  buildTypographyRow('Headline Large', 'Bold', '32/40',
                      CoreTypography.headlineLargeSemiBold()),
                ]),
                buildTypographySection('Headline Medium', [
                  buildTypographyRow('Headline Medium', 'Regular', '24/32',
                      CoreTypography.headlineMediumRegular()),
                  buildTypographyRow('Headline Medium', 'Bold', '24/32',
                      CoreTypography.headlineMediumSemiBold()),
                ]),
                buildTypographySection('Title Large', [
                  buildTypographyRow('Title Large', 'Regular', '20/28',
                      CoreTypography.titleLargeRegular()),
                  buildTypographyRow('Title Large', 'Medium', '20/28',
                      CoreTypography.titleLargeMedium()),
                  buildTypographyRow('Title Large', 'Bold', '20/28',
                      CoreTypography.titleLargeSemiBold()),
                ]),
                buildTypographySection('Title Medium', [
                  buildTypographyRow('Title Medium', 'Regular', '18/26',
                      CoreTypography.titleMediumRegular()),
                  buildTypographyRow('Title Medium', 'Medium', '18/26',
                      CoreTypography.titleMediumMedium()),
                  buildTypographyRow('Title Medium', 'Bold', '18/26',
                      CoreTypography.titleMediumSemiBold()),
                ]),
                buildTypographySection('Body Large', [
                  buildTypographyRow('Body Large', 'Regular', '16/24',
                      CoreTypography.bodyLargeRegular()),
                  buildTypographyRow('Body Large', 'Medium', '16/24',
                      CoreTypography.bodyLargeMedium()),
                  buildTypographyRow('Body Large', 'Bold', '16/24',
                      CoreTypography.bodyLargeSemiBold()),
                ]),
                buildTypographySection('Body Medium', [
                  buildTypographyRow('Body Medium', 'Regular', '14/20',
                      CoreTypography.bodyMediumRegular()),
                  buildTypographyRow('Body Medium', 'Medium', '14/20',
                      CoreTypography.bodyMediumMedium()),
                  buildTypographyRow('Body Medium', 'Bold', '14/20',
                      CoreTypography.bodyMediumSemiBold()),
                ]),
                buildTypographySection('Body Small', [
                  buildTypographyRow('Body Small', 'Regular', '12/16',
                      CoreTypography.bodySmallRegular()),
                  buildTypographyRow('Body Small', 'Medium', '12/16',
                      CoreTypography.bodySmallMedium()),
                  buildTypographyRow('Body Small', 'Bold', '12/16',
                      CoreTypography.bodySmallSemiBold()),
                ]),
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
      matchesGoldenFile('goldens/core_typography_tokens.png'),
    );
  });
}
