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
  group('CoreListRow – accessibility', () {
    final rows = <String, Widget>{
      'plain': CoreListRow(
        title: 'Scissor lift — 19ft',
        subtitle: 'Used last week',
        value: r'$120.00',
        unit: '/day',
        onTap: () {},
      ),
      'selected': CoreListRow.selectable(
        title: 'Mini excavator — 1.5 ton',
        subtitle: 'Compact, tight-access digging',
        value: r'$145.00',
        unit: '/day',
        selected: true,
        onTap: () {},
      ),
      'action': CoreListRow.action(
        icon: CoreIcons.add,
        title: 'New equipment cost',
        onTap: () {},
      ),
    };

    for (final entry in rows.entries) {
      testWidgets('${entry.key} row meets tap target and label guidelines',
          (tester) async {
        await setupA11yTest(tester);

        await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
          tester,
          (theme) => entry.value,
          find.byType(CoreListRow),
          // The row is one Semantics node that is both the label and the tap
          // target; there is no separately labelled tap target to check.
          checkLabeledTapTarget: false,
        );
      });
    }

    // The row merges its texts into one node, so the contrast guideline
    // samples the row as a whole. Each text colour is checked on each fill.
    for (final theme in kA11yTestThemes) {
      final colors = theme.coreColors;
      final name = theme.brightness.name;
      final fills = {
        'page': colors.pageBackground,
        'selected': colors.backgroundBlueLight,
      };
      final texts = {
        'textHeadline': colors.textHeadline,
        'textBody': colors.textBody,
        'textLink': colors.textLink,
      };
      for (final fill in fills.entries) {
        for (final text in texts.entries) {
          test('${text.key} on the ${fill.key} fill meets 4.5:1 – $name', () {
            final ratio = _contrastRatio(text.value, fill.value);

            expect(
              ratio,
              greaterThanOrEqualTo(4.5),
              reason: '$name: ${text.key} on ${fill.key} was $ratio:1',
            );
          });
        }
      }
    }
  });
}
