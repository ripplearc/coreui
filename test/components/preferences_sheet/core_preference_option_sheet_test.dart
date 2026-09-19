import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

/// Captures the sheet's callback across the separate `pump` calls a test
/// body makes.
class _Recorder {
  String? updatedId;
  int updateCount = 0;
}

void main() {
  const options = [
    CorePreferenceOption(id: '0.0', label: '0.0'),
    CorePreferenceOption(id: '0.00', label: '0.00'),
    CorePreferenceOption(id: '0.000', label: '0.000'),
  ];

  CorePreferenceOptionSheet buildSheet(
    _Recorder recorder, {
    String? selectedOptionId = '0.00',
    CorePreferenceInfo? info,
  }) {
    return CorePreferenceOptionSheet(
      title: 'Meter length display',
      options: options,
      selectedOptionId: selectedOptionId,
      updateLabel: 'Update',
      backSemanticsLabel: 'Back to preferences',
      info: info,
      onUpdate: (id) {
        recorder.updatedId = id;
        recorder.updateCount++;
      },
      optionKeyOf: (id) => Key('option_$id'),
      updateButtonKey: const Key('update_button'),
      infoButtonKey: const Key('info_button'),
    );
  }

  Future<_Recorder> pumpSheet(
    WidgetTester tester, {
    String? selectedOptionId = '0.00',
    CorePreferenceInfo? info,
  }) async {
    final recorder = _Recorder();
    await tester.pumpWidget(
      MaterialApp(
        theme: CoreTheme.light(),
        home: Scaffold(
          body: buildSheet(
            recorder,
            selectedOptionId: selectedOptionId,
            info: info,
          ),
        ),
      ),
    );
    return recorder;
  }

  testWidgets('picking an option reports nothing until Update commits it',
      (tester) async {
    final recorder = await pumpSheet(tester);

    await tester.tap(find.byKey(const Key('option_0.000')));
    await tester.pump();

    expect(
      recorder.updateCount,
      0,
      reason: 'browsing the choices must not change the stored preference',
    );

    await tester.tap(find.byKey(const Key('update_button')));
    await tester.pump();

    expect(recorder.updatedId, '0.000');
    expect(recorder.updateCount, 1);
  });

  testWidgets('the back button dismisses the sheet, preference untouched',
      (tester) async {
    final recorder = _Recorder();
    // Pushed over a home route rather than pumped as one: with nothing to pop
    // back to, the back button cannot dismiss anything and the test would
    // only prove that onUpdate stayed quiet.
    await tester.pumpWidget(
      MaterialApp(
        theme: CoreTheme.light(),
        home: Builder(
          builder: (context) => Scaffold(
            body: ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => Scaffold(body: buildSheet(recorder)),
                ),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.byType(CorePreferenceOptionSheet), findsOneWidget);

    await tester.tap(find.byKey(const Key('option_0.000')));
    await tester.pump();
    await tester.tap(find.bySemanticsLabel('Back to preferences'));
    await tester.pumpAndSettle();

    expect(find.byType(CorePreferenceOptionSheet), findsNothing);
    expect(recorder.updateCount, 0);
  });

  testWidgets('a preference changed elsewhere moves an untouched pick',
      (tester) async {
    final recorder = _Recorder();
    var selected = '0.00';
    await tester.pumpWidget(
      MaterialApp(
        theme: CoreTheme.light(),
        home: StatefulBuilder(
          builder: (_, setState) => Scaffold(
            body: Column(
              children: [
                ElevatedButton(
                  onPressed: () => setState(() => selected = '0.000'),
                  child: const Text('store elsewhere'),
                ),
                Expanded(child: buildSheet(recorder, selectedOptionId: selected)),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('store elsewhere'));
    await tester.pump();
    await tester.tap(find.byKey(const Key('update_button')));
    await tester.pump();

    expect(
      recorder.updatedId,
      '0.000',
      reason: 'the caller owns what is stored, so an untouched pick has to '
          'follow it rather than commit the value the sheet opened with',
    );
  });

  testWidgets('the info button swaps Update for the explanation',
      (tester) async {
    await pumpSheet(
      tester,
      info: const CorePreferenceInfo(
        title: 'Meter length display',
        description: 'Changes the number of decimal places shown',
        semanticsLabel: 'About this preference',
        closeLabel: 'Close',
      ),
    );

    expect(find.byKey(const Key('update_button')), findsOneWidget);

    await tester.tap(find.byKey(const Key('info_button')));
    await tester.pump();

    expect(find.text('Changes the number of decimal places shown'),
        findsOneWidget);
    expect(
      find.byKey(const Key('update_button')),
      findsNothing,
      reason: 'the explanation takes the commit button\'s slot, '
          'so the sheet keeps its height',
    );
  });

  testWidgets('no info button when the preference has no explanation',
      (tester) async {
    await pumpSheet(tester);

    expect(find.byKey(const Key('info_button')), findsNothing);
  });

  testWidgets('Update is disabled until something is selected',
      (tester) async {
    await pumpSheet(tester, selectedOptionId: null);

    final button = tester.widget<CoreButton>(
      find.byKey(const Key('update_button')),
    );
    expect(button.onPressed, isNull);
  });
}
