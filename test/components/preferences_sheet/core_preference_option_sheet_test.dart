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
          body: CorePreferenceOptionSheet(
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

  testWidgets('the back button leaves the preference untouched',
      (tester) async {
    final recorder = await pumpSheet(tester);

    await tester.tap(find.byKey(const Key('option_0.000')));
    await tester.pump();
    await tester.tap(find.bySemanticsLabel('Back to preferences'));
    await tester.pump();

    expect(recorder.updateCount, 0);
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
