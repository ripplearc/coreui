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
  group('CoreDetailsRow – accessibility', () {
    for (final expanded in [false, true]) {
      testWidgets(
          '${expanded ? 'expanded' : 'folded'} row meets tap target, label '
          'and contrast guidelines', (tester) async {
        await setupA11yTest(tester);

        await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
          tester,
          (theme) => CoreDetailsRow(
            label: 'Delivery',
            value: r'$150',
            expanded: expanded,
            onToggle: () {},
            actionLabel: 'Add note',
            onAction: () {},
            child: const SizedBox(height: CoreSpacing.space12),
          ),
          find.byType(CoreDetailsRow),
        );
      });
    }

    for (final theme in kA11yTestThemes) {
      final colors = theme.coreColors;
      final name = theme.brightness.name;
      final texts = {
        'textBody': colors.textBody,
        'textHeadline': colors.textHeadline,
        'textLink': colors.textLink,
      };
      for (final text in texts.entries) {
        test('${text.key} on backgroundGrayLight meets 4.5:1 – $name', () {
          final ratio = _contrastRatio(text.value, colors.backgroundGrayLight);

          expect(ratio, greaterThanOrEqualTo(4.5), reason: '$ratio:1');
        });
      }

      // WCAG 1.4.11: the chevron is the only sign the row opens.
      test('the chevron holds 3:1 on backgroundGrayLight – $name', () {
        final ratio =
            _contrastRatio(colors.iconGrayMid, colors.backgroundGrayLight);

        expect(ratio, greaterThanOrEqualTo(3), reason: '$ratio:1');
      });
    }
  });
}
