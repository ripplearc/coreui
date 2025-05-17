import 'package:core_ui/src/theme/shadows.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  Widget _buildShadowBox(String name, List<BoxShadow> shadows) {
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

  Widget _buildShadowGrid(List<MapEntry<String, List<BoxShadow>>> shadows) {
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
            child: _buildShadowBox(entry.key, entry.value),
          );
        }).toList(),
      ),
    );
  }

  testGoldens('Core Shadow Tokens Test', (tester) async {
    // Enable shadows for this test
    debugDisableShadows = false;

    final builder = GoldenBuilder.column()
      ..addScenario(
        'Shadow Variations',
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Container(
            color: const Color(0xFFF5F5F5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildShadowGrid([
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
      );

    await tester.pumpWidgetBuilder(
      builder.build(),
      surfaceSize: const Size(1200, 1600),
    );

    await screenMatchesGolden(tester, 'core_shadow_tokens');

    // Reset shadows to default value
    debugDisableShadows = true;
  });
}
