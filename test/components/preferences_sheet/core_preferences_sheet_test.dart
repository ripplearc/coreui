import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

/// Captures the sheet's callback across the separate `pump` calls a test
/// body makes.
class _Recorder {
  final List<(String, String)> changes = [];
}

void main() {
  /// A list long enough that its last rows start below the viewport, so the
  /// deep-link test has somewhere to scroll to.
  List<CorePreferenceSection> buildSections({int rowCount = 20}) {
    return [
      const CorePreferenceSection(
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
          for (var i = 0; i < rowCount; i++)
            CorePreferenceRow(
              key: 'pref_$i',
              label: 'Preference $i',
              value: CorePreferenceTextValue('value $i'),
              selectedOptionId: 'a',
              options: const [
                CorePreferenceOption(id: 'a', label: 'Option A'),
                CorePreferenceOption(id: 'b', label: 'Option B'),
              ],
            ),
        ],
      ),
    ];
  }

  Future<_Recorder> pumpSheet(
    WidgetTester tester, {
    String? initialKey,
    List<CorePreferenceSection>? sections,
  }) async {
    final recorder = _Recorder();
    tester.view.physicalSize = const Size(780, 1200);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: CoreTheme.light(),
        home: Scaffold(
          body: CorePreferencesSheet(
            title: 'Preferences',
            sections: sections ?? buildSections(),
            initialKey: initialKey,
            optionUpdateLabel: 'Update',
            optionBackSemanticsLabel: 'Back to preferences',
            onChanged: (key, optionId) =>
                recorder.changes.add((key, optionId)),
            rowKeyOf: (key) => Key('row_$key'),
            optionKeyOf: (id) => Key('option_$id'),
            optionUpdateButtonKey: const Key('update_button'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return recorder;
  }

  testWidgets('without a deep link the sheet opens at the top', (tester) async {
    await pumpSheet(tester);

    final viewport = tester.view.physicalSize.height /
        tester.view.devicePixelRatio;
    final lastRow = tester.getRect(find.byKey(const Key('row_pref_19')));

    expect(
      lastRow.top,
      greaterThan(viewport),
      reason: 'the fixture must start with the target row off-screen, '
          'or the deep-link test proves nothing',
    );
  });

  testWidgets('initialKey lands on its row without the user scrolling',
      (tester) async {
    await pumpSheet(tester, initialKey: 'pref_19');

    final viewport = tester.view.physicalSize.height /
        tester.view.devicePixelRatio;
    final target = tester.getRect(find.byKey(const Key('row_pref_19')));

    expect(target.top, lessThan(viewport));
    expect(target.bottom, greaterThan(0));
  });

  testWidgets('an unknown initialKey opens the list rather than failing',
      (tester) async {
    await pumpSheet(tester, initialKey: 'no_such_preference');

    expect(find.text('Preferences'), findsOneWidget);
  });

  testWidgets('committing a choice reports the row key and the option id',
      (tester) async {
    final recorder = await pumpSheet(tester);

    await tester.tap(find.byKey(const Key('row_pref_0')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('option_b')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('update_button')));
    await tester.pumpAndSettle();

    expect(recorder.changes, [('pref_0', 'b')]);
  });

  testWidgets('the sheet does not update its own rows', (tester) async {
    final sections = buildSections();
    await pumpSheet(tester, sections: sections);

    await tester.tap(find.byKey(const Key('row_pref_0')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('option_b')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('update_button')));
    await tester.pumpAndSettle();

    expect(
      sections[1].rows.first.selectedOptionId,
      'a',
      reason: 'the sheet holds no persistent state: the caller re-supplies '
          'sections with the new value',
    );
    expect(find.text('value 0'), findsOneWidget);
  });

  testWidgets('a row with a single option opens nothing', (tester) async {
    final recorder = await pumpSheet(
      tester,
      sections: const [
        CorePreferenceSection(
          rows: [
            CorePreferenceRow(
              key: 'fractional_mode',
              label: 'Fractional mode',
              value: CorePreferenceTextValue('std', isMuted: true),
              options: [
                CorePreferenceOption(id: 'std', label: 'std'),
              ],
            ),
          ],
        ),
      ],
    );

    await tester.tap(find.byKey(const Key('row_fractional_mode')));
    await tester.pumpAndSettle();

    expect(find.text('Update'), findsNothing);
    expect(recorder.changes, isEmpty);
  });

  testWidgets('a pill value renders its label', (tester) async {
    await pumpSheet(tester);

    expect(find.text('Imperial'), findsOneWidget);
  });
}
