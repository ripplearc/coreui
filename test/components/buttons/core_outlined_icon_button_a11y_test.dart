import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';

double _contrastRatio(Color foreground, Color background) {
  final a = foreground.computeLuminance();
  final b = background.computeLuminance();
  return (a > b ? a + 0.05 : b + 0.05) / (a > b ? b + 0.05 : a + 0.05);
}

void main() {
  group('CoreOutlinedIconButton – accessibility', () {
    testWidgets('meets tap target and label guidelines', (tester) async {
      await setupA11yTest(tester);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => CoreOutlinedIconButton(
          icon: CoreIcons.search,
          onTap: () {},
          semanticLabel: 'Look up a rate',
        ),
        find.byType(CoreOutlinedIconButton),
      );
    });

    // WCAG 1.4.11: the icon is the only sign of what the button does, so it
    // holds 3:1 on the page in both themes.
    for (final theme in kA11yTestThemes) {
      final colors = theme.coreColors;
      final name = theme.brightness.name;
      test('the icon holds 3:1 on the page – $name', () {
        final ratio = _contrastRatio(colors.iconGrayMid, colors.pageBackground);

        expect(ratio, greaterThanOrEqualTo(3), reason: '$name: $ratio:1');
      });
    }
  });
}
