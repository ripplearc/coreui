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

  /// Pumps the sheet under a caller that can change the stored preference
  /// while the sheet is still open — the `didUpdateWidget` path. Tapping
  /// "store elsewhere" moves the caller's value to `0.000`.
  Future<_Recorder> pumpSheetOverStore(WidgetTester tester) async {
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
                Expanded(
                  child: buildSheet(recorder, selectedOptionId: selected),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    return recorder;
  }

  /// The tick a row shows once it is the pick in force.
  final tick = find.byWidgetPredicate(
    (widget) => widget is CoreIconWidget && widget.icon == CoreIcons.checkMark,
  );

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

  /// Pushes the sheet over a home route rather than pumping it as one: with
  /// nothing to pop back to, a sheet that fails to dismiss itself looks
  /// exactly like one that dismissed correctly.
  Future<_Recorder> pumpSheetOverHome(WidgetTester tester) async {
    final recorder = _Recorder();
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
    return recorder;
  }

  testWidgets('the back button dismisses the sheet, preference untouched',
      (tester) async {
    final recorder = await pumpSheetOverHome(tester);

    await tester.tap(find.byKey(const Key('option_0.000')));
    await tester.pump();
    await tester.tap(find.bySemanticsLabel('Back to preferences'));
    await tester.pumpAndSettle();

    expect(find.byType(CorePreferenceOptionSheet), findsNothing);
    expect(recorder.updateCount, 0);
  });

  testWidgets('Update commits the pick and dismisses the sheet',
      (tester) async {
    final recorder = await pumpSheetOverHome(tester);

    await tester.tap(find.byKey(const Key('option_0.000')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('update_button')));
    await tester.pumpAndSettle();

    expect(recorder.updatedId, '0.000');
    expect(
      find.byType(CorePreferenceOptionSheet),
      findsNothing,
      reason: 'committing closes the sheet, so the user is returned to what '
          'they opened it from rather than left on the choices they just made',
    );
  });

  testWidgets('a preference changed elsewhere moves an untouched pick',
      (tester) async {
    final recorder = await pumpSheetOverStore(tester);

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

  testWidgets("a preference changed elsewhere leaves the user's own pick alone",
      (tester) async {
    final recorder = await pumpSheetOverStore(tester);

    await tester.tap(find.byKey(const Key('option_0.0')));
    await tester.pump();
    await tester.tap(find.text('store elsewhere'));
    await tester.pump();
    await tester.tap(find.byKey(const Key('update_button')));
    await tester.pump();

    expect(
      recorder.updatedId,
      '0.0',
      reason: 'once the user has picked for themselves, a change made '
          'elsewhere must not silently replace what Update will store',
    );
  });

  testWidgets('a pick that lands back on the opening value still counts',
      (tester) async {
    final recorder = await pumpSheetOverStore(tester);

    // The sheet opened on 0.00; the user changes their mind and lands back on
    // it. Comparing the pick against the opening value cannot tell this apart
    // from never having touched a row — hence the explicit touched flag.
    await tester.tap(find.byKey(const Key('option_0.000')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('option_0.00')));
    await tester.pump();

    await tester.tap(find.text('store elsewhere'));
    await tester.pump();
    await tester.tap(find.byKey(const Key('update_button')));
    await tester.pump();

    expect(
      recorder.updatedId,
      '0.00',
      reason: 'the user settled on 0.00 deliberately, so a change made '
          'elsewhere must not overwrite it just because it happens to equal '
          'the value the sheet opened with',
    );
  });

  testWidgets('the info button swaps Update for the explanation, '
      'leaving the sheet the same height', (tester) async {
    await pumpSheet(
      tester,
      info: const CorePreferenceInfo(
        title: 'Meter length display',
        description: 'Changes the number of decimal places shown',
        semanticsLabel: 'About this preference',
        closeLabel: 'Close',
      ),
    );

    final sheet = find.byType(CorePreferenceOptionSheet);
    final updateButton = find.byKey(const Key('update_button'));
    expect(updateButton.hitTestable(), findsOneWidget);
    final heightShowingUpdate = tester.getSize(sheet).height;

    await tester.tap(find.byKey(const Key('info_button')));
    await tester.pump();

    expect(find.text('Changes the number of decimal places shown'),
        findsOneWidget);
    expect(
      updateButton.hitTestable(),
      findsNothing,
      reason: 'the explanation takes the commit button\'s slot, so Update '
          'cannot be tapped from behind it',
    );
    expect(
      tester.getSize(sheet).height,
      heightShowingUpdate,
      reason: 'the explanation is taller than the button it replaces, so the '
          'footer holds the taller of the two in both states — the sheet must '
          'not grow under the thumb that just opened it',
    );
  });

  testWidgets('the explanation takes Update out of the focus traversal',
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

    /// The Update button's focus nodes that keyboard traversal can still
    /// reach. The button stays laid out behind the explanation, so being in
    /// the tree says nothing about whether a Tab can land on it.
    int reachableUpdateNodes() {
      final scope = FocusScope.of(
        tester.element(find.byType(CorePreferenceOptionSheet)),
      );
      final button = find.byKey(const Key('update_button')).evaluate().toSet();
      return scope.traversalDescendants.where((node) {
        final context = node.context;
        if (context == null) return false;
        var underButton = false;
        context.visitAncestorElements((element) {
          if (button.contains(element)) {
            underButton = true;
            return false;
          }
          return true;
        });
        return underButton;
      }).length;
    }

    expect(reachableUpdateNodes(), 1);

    await tester.tap(find.byKey(const Key('info_button')));
    await tester.pump();

    expect(
      reachableUpdateNodes(),
      0,
      reason: 'a Tab must not land on a button the explanation is covering, '
          'which would move focus out of what the user can see',
    );
  });

  testWidgets('the reserved explanation height sits above Update, not below it',
      (tester) async {
    Future<double> gapUnderUpdate({required CorePreferenceInfo? info}) async {
      await pumpSheet(tester, info: info);
      final sheetBottom =
          tester.getRect(find.byType(CorePreferenceOptionSheet)).bottom;
      final buttonBottom =
          tester.getRect(find.byKey(const Key('update_button'))).bottom;
      return sheetBottom - buttonBottom;
    }

    final withoutInfo = await gapUnderUpdate(info: null);
    final withInfo = await gapUnderUpdate(
      info: const CorePreferenceInfo(
        title: 'Meter length display',
        description: 'Changes the number of decimal places shown',
        semanticsLabel: 'About this preference',
        closeLabel: 'Close',
      ),
    );

    expect(
      withInfo,
      withoutInfo,
      reason: 'the height a row with an explanation reserves belongs between '
          'the options and Update, not beneath it — Update is the sheet\'s '
          'only call to action and stays against the bottom padding, as it '
          'does in both Figma frames',
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

  testWidgets('an option set that drops the pick disables Update',
      (tester) async {
    await pumpSheet(tester, selectedOptionId: '0.00');
    expect(
      tick,
      findsOneWidget,
      reason: 'a matched id ticks its row — without this the findsNothing '
          'below would also pass if the tile stopped drawing a tick at all',
    );

    await pumpSheet(tester, selectedOptionId: 'gone');

    expect(
      tick,
      findsNothing,
      reason: 'no row can show a pick the option list no longer offers',
    );

    final button = tester.widget<CoreButton>(
      find.byKey(const Key('update_button')),
    );
    expect(
      button.onPressed,
      isNull,
      reason: 'a stale id left over after the options changed must not be '
          'handed back to the caller as a choice the user never saw made',
    );
  });

  testWidgets('a sheet opened on an id matching no option cannot commit it',
      (tester) async {
    // The test above reaches the unmatched id through didUpdateWidget, since
    // Flutter keeps the state across two pumps of the same tree. A fresh mount
    // is the initState path, and a caller opening a sheet on a stale stored
    // value takes it.
    await pumpSheet(tester, selectedOptionId: 'gone');

    expect(
      tick,
      findsNothing,
      reason: 'no row can show a pick the option list does not offer',
    );

    final button = tester.widget<CoreButton>(
      find.byKey(const Key('update_button')),
    );
    expect(
      button.onPressed,
      isNull,
      reason: 'a sheet that opens on a stale id must wait for the user to '
          'choose rather than offer to commit an id no row ever ticked',
    );
  });
}
