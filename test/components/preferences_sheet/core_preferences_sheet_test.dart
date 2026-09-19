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
  ///
  /// Each preference gets a section of its own on purpose. Grouping them
  /// under one heading renders the whole run as a single eager column, which
  /// hides whether the sheet can reach a row it has not built yet — the
  /// deep link's actual failure mode.
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
      for (var i = 0; i < rowCount; i++)
        CorePreferenceSection(
          title: 'Group $i',
          rows: [
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

  testWidgets('rows the caller drops stop being tracked', (tester) async {
    final recorder = _Recorder();
    var sections = buildSections();
    await tester.pumpWidget(
      MaterialApp(
        theme: CoreTheme.light(),
        home: StatefulBuilder(
          builder: (_, setState) => Scaffold(
            body: Column(
              children: [
                ElevatedButton(
                  onPressed: () =>
                      setState(() => sections = buildSections(rowCount: 3)),
                  child: const Text('shorten'),
                ),
                Expanded(
                  child: CorePreferencesSheet(
                    title: 'Preferences',
                    sections: sections,
                    optionUpdateLabel: 'Update',
                    optionBackSemanticsLabel: 'Back to preferences',
                    onChanged: (key, optionId) =>
                        recorder.changes.add((key, optionId)),
                    rowKeyOf: (key) => Key('row_$key'),
                    optionKeyOf: (id) => Key('option_$id'),
                    optionUpdateButtonKey: const Key('update_button'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('row_pref_19')), findsOneWidget);

    await tester.tap(find.text('shorten'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('row_pref_19')), findsNothing);

    await tester.tap(find.byKey(const Key('row_pref_0')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('option_b')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('update_button')));
    await tester.pumpAndSettle();

    expect(
      recorder.changes,
      [('pref_0', 'b')],
      reason: 'the anchors follow the rows the caller supplies, so a shorter '
          'list keeps working rather than dragging the dropped rows along',
    );
  });

  testWidgets('duplicate preference keys are caught here, not in the framework',
      (tester) async {
    const duplicated = CorePreferenceRow(
      key: 'length_format',
      label: 'Length display format',
      value: CorePreferenceTextValue('in'),
    );

    await pumpSheet(
      tester,
      sections: const [
        CorePreferenceSection(rows: [duplicated]),
        CorePreferenceSection(title: 'Display', rows: [duplicated]),
      ],
    );

    expect(
      tester.takeException(),
      isAssertionError,
      reason: 'each row owns a GlobalKey and a GlobalKey cannot be shared, '
          'so the duplicate has to surface where the mistake was made',
    );
  });

  testWidgets('a pill value renders its label', (tester) async {
    await pumpSheet(tester);

    expect(find.text('Imperial'), findsOneWidget);
  });
}
