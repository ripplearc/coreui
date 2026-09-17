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
        // The row's label and value are the accessible text; the row itself
        // carries no semantics label of its own.
        checkLabeledTapTarget: false,
      );
    });
  });

  group('CorePreferenceOptionSheet accessibility', () {
    testWidgets('the back button is labelled and reachable', (tester) async {
      await setupA11yTest(tester);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => CorePreferenceOptionSheet(
          title: 'Fractional resolution',
          options: const [
            CorePreferenceOption(id: '1/8', label: '1/8'),
            CorePreferenceOption(id: '1/16', label: '1/16'),
          ],
          selectedOptionId: '1/16',
          updateLabel: 'Update',
          backSemanticsLabel: 'Back to preferences',
          onUpdate: (_) {},
        ),
        find.bySemanticsLabel('Back to preferences'),
      );
    });

    testWidgets('the info button, option rows and Update meet guidelines',
        (tester) async {
      await setupA11yTest(tester);

      Widget build(ThemeData theme) => CorePreferenceOptionSheet(
            title: 'Meter length display',
            options: const [
              CorePreferenceOption(id: '0.0', label: '0.0'),
              CorePreferenceOption(id: '0.00', label: '0.00'),
            ],
            selectedOptionId: '0.0',
            updateLabel: 'Update',
            backSemanticsLabel: 'Back to preferences',
            info: const CorePreferenceInfo(
              title: 'Meter length display',
              description: 'Changes the number of decimal places shown',
              semanticsLabel: 'About this preference',
              closeLabel: 'Close',
            ),
            onUpdate: (_) {},
            optionKeyOf: (id) => Key('option_$id'),
            updateButtonKey: const Key('update_button'),
            infoButtonKey: const Key('info_button'),
          );

      for (final target in [
        find.byKey(const Key('info_button')),
        find.byKey(const Key('option_0.00')),
        find.byKey(const Key('update_button')),
      ]) {
        await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
          tester,
          build,
          target,
        );
      }
    });

    testWidgets('the selected option is announced as selected',
        (tester) async {
      await setupA11yTest(tester);
      final semanticsHandle = tester.ensureSemantics();

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CorePreferenceOptionSheet(
              title: 'Fractional resolution',
              options: const [
                CorePreferenceOption(id: '1/8', label: '1/8'),
                CorePreferenceOption(id: '1/16', label: '1/16'),
              ],
              selectedOptionId: '1/16',
              updateLabel: 'Update',
              backSemanticsLabel: 'Back to preferences',
              onUpdate: (_) {},
              optionKeyOf: (id) => Key('option_$id'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        tester.getSemantics(find.byKey(const Key('option_1/16'))),
        isSemantics(label: '1/16', isSelected: true),
      );
      expect(
        tester.getSemantics(find.byKey(const Key('option_1/8'))),
        isSemantics(label: '1/8', isSelected: false),
      );

      semanticsHandle.dispose();
    });
  });
}
