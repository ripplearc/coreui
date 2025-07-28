import 'package:core_ui/src/theme/shadows.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../load_fonts.dart';

void main() {
  setUpAll(() async {
    await loadFonts();
  });

  Widget buildShadowBox(String name, List<BoxShadow> shadows) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 24),
          child: Text(
            name.toLowerCase(),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontFamily: 'Roboto',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            width: 200,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: shadows,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildShadowGrid(List<MapEntry<String, List<BoxShadow>>> shadows) {
    return Container(
      color: const Color(0xFFF5F5F5),
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      child: Wrap(
        spacing: 40,
        runSpacing: 60,
        children: shadows.map((entry) {
          return SizedBox(
            width: 280,
            child: buildShadowBox(entry.key, entry.value),
          );
        }).toList(),
      ),
    );
  }

  testWidgets('Core Shadow Tokens Test', (tester) async {
    // Enable shadows
    debugDisableShadows = false;

    await tester.binding.setSurfaceSize(const Size(1200, 1600));

    final widget = MaterialApp(
      theme: ThemeData(fontFamily: 'Roboto'),
      home: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            color: const Color(0xFFF5F5F5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildShadowGrid([
                  MapEntry('xs', CoreShadows.extraSmall),
                  MapEntry('sm', CoreShadows.small),
                  MapEntry('md', CoreShadows.medium),
                  MapEntry('lg', CoreShadows.large),
                  MapEntry('xl', CoreShadows.extraLarge),
                  MapEntry('2xl', CoreShadows.doubleExtraLarge),
                  MapEntry('Sticky', CoreShadows.sticky),
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
      matchesGoldenFile('goldens/core_shadow_tokens.png'),
    );

    // Reset shadows to default value
    debugDisableShadows = true;
  });
}
