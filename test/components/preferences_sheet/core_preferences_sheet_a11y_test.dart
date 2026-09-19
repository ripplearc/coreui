import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';

void main() {
  const sections = [
    CorePreferenceSection(
      rows: [
        CorePreferenceRow(
          key: 'system_of_units',
          label: 'System of units',
          value: CorePreferencePillValue('Imperial', isOn: true),
          selectedOptionId: 'imperial',
          options: [
            CorePreferenceOption(id: 'imperial', label: 'Imperial'),
            CorePreferenceOption(id: 'metric', label: 'Metric'),
          ],
        ),
      ],
    ),
    CorePreferenceSection(
      title: 'Display',
      rows: [
        CorePreferenceRow(
          key: 'fractional_resolution',
          label: 'Fractional resolution',
          value: CorePreferenceTextValue('1/16'),
          selectedOptionId: '1/16',
          options: [
            CorePreferenceOption(id: '1/8', label: '1/8'),
            CorePreferenceOption(id: '1/16', label: '1/16'),
          ],
        ),
      ],
    ),
  ];

  group('CorePreferencesSheet accessibility', () {
    testWidgets('rows meet tap target, label and contrast guidelines',
        (tester) async {
      await setupA11yTest(tester);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => CorePreferencesSheet(
          title: 'Preferences',
          sections: sections,
          onChanged: (_, __) {},
          optionUpdateLabel: 'Update',
          optionBackSemanticsLabel: 'Back to preferences',
          rowKeyOf: (key) => Key('row_$key'),
        ),
        find.byKey(const Key('row_fractional_resolution')),
      );
    });
  });
}
