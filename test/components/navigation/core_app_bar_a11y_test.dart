import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';
import '../../utils/a11y_guidelines.dart';

/// The contrast guideline samples rendered pixels, so the real font has to be
/// loaded and applied — otherwise it measures antialiasing on unrendered
/// glyphs rather than the token colors. Same idiom as the golden tests.
final List<ThemeData> _themes = [
  CoreTheme.light().copyWith(
    textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto'),
  ),
  CoreTheme.dark().copyWith(
    textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Roboto'),
  ),
];

Widget _buildBarApp(CoreAppBar appBar, ThemeData theme) {
  return MaterialApp(
    theme: theme,
    home: Scaffold(
      appBar: appBar,
      body: const SizedBox.shrink(),
    ),
  );
}

/// WCAG relative-luminance contrast ratio between two opaque colors.
double _contrastRatio(Color foreground, Color background) {
  double channel(double value) {
    return value <= 0.03928
        ? value / 12.92
        : math.pow((value + 0.055) / 1.055, 2.4).toDouble();
  }

  double luminance(Color color) {
    return 0.2126 * channel(color.r) +
        0.7152 * channel(color.g) +
        0.0722 * channel(color.b);
  }

  final a = luminance(foreground);
  final b = luminance(background);
  final lighter = a > b ? a : b;
  final darker = a > b ? b : a;
  return (lighter + 0.05) / (darker + 0.05);
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await loadFonts();
  });

  group('CoreAppBar accessibility', () {
    testWidgets('action tap targets meet the guideline in both themes',
        (tester) async {
      await setupA11yTest(tester);

      for (final theme in _themes) {
        await tester.pumpWidget(
          _buildBarApp(
            CoreAppBar(
              titleText: 'Projects',
              padding: const EdgeInsets.symmetric(
                horizontal: CoreSpacing.space4,
                vertical: CoreSpacing.space2,
              ),
              actions: [
                CoreIconWidget(
                  key: const Key('core_app_bar_search'),
                  icon: CoreIcons.search,
                  semanticLabel: 'Search',
                  onTap: () {},
                ),
              ],
            ),
            theme,
          ),
        );
        await tester.pump(const Duration(milliseconds: 100));

        await expectMeetsTapTargetAndLabelGuidelines(
          tester,
          find.byKey(const Key('core_app_bar_search')),
          // The pixel-sampling contrast guideline reads the AppBar title's
          // antialiased glyph edges rather than the token colors, so it reports
          // a ~50/50 blend of text and background. The title's real contrast is
          // asserted deterministically in the 'title contrast' group below.
          checkTextContrast: false,
        );
      }
    });

    testWidgets('leading tap target meets the guideline in both themes',
        (tester) async {
      await setupA11yTest(tester);

      for (final theme in _themes) {
        await tester.pumpWidget(
          _buildBarApp(
            CoreAppBar(
              titleText: 'Projects',
              leading: CoreIconWidget(
                key: const Key('core_app_bar_back'),
                icon: CoreIcons.arrowLeft,
                semanticLabel: 'Back',
                onTap: () {},
              ),
            ),
            theme,
          ),
        );
        await tester.pump(const Duration(milliseconds: 100));

        await expectMeetsTapTargetAndLabelGuidelines(
          tester,
          find.byKey(const Key('core_app_bar_back')),
          checkTextContrast: false,
        );
      }
    });

    testWidgets(
        'tap targets still meet the guideline at the minimum allowed height',
        (tester) async {
      await setupA11yTest(tester);

      // The floor the constructor asserts. Padding is additive, so even the
      // shortest permitted bar leaves a full 48 for the action to occupy.
      for (final theme in _themes) {
        await tester.pumpWidget(
          _buildBarApp(
            CoreAppBar(
              titleText: 'Projects',
              height: CoreSpacing.space12,
              padding: const EdgeInsets.symmetric(
                vertical: CoreSpacing.space2,
              ),
              actions: [
                CoreIconWidget(
                  key: const Key('core_app_bar_search'),
                  icon: CoreIcons.search,
                  semanticLabel: 'Search',
                  onTap: () {},
                ),
              ],
            ),
            theme,
          ),
        );
        await tester.pump(const Duration(milliseconds: 100));

        await expectMeetsTapTargetAndLabelGuidelines(
          tester,
          find.byKey(const Key('core_app_bar_search')),
          // The pixel-sampling contrast guideline reads the AppBar title's
          // antialiased glyph edges rather than the token colors, so it reports
          // a ~50/50 blend of text and background. The title's real contrast is
          // asserted deterministically in the 'title contrast' group below.
          checkTextContrast: false,
        );
      }
    });
  });

  group('CoreAppBar title contrast', () {
    // Measured from the tokens the bar actually resolves, so the result does
    // not depend on glyph antialiasing the way the pixel-sampling guideline
    // does. 4.5:1 is the WCAG AA threshold for normal-sized text.
    for (final entry in {
      'light': CoreTheme.light(),
      'dark': CoreTheme.dark(),
    }.entries) {
      test('titleText meets WCAG AA on pageBackground – ${entry.key}', () {
        final colors = entry.value.coreColors;
        final ratio = _contrastRatio(colors.textHeadline, colors.pageBackground);

        expect(
          ratio,
          greaterThanOrEqualTo(4.5),
          reason: '${entry.key}: textHeadline on pageBackground was $ratio:1',
        );
      });
    }
  });
}
