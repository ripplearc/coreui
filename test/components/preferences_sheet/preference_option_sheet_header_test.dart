import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';
import 'package:ripplearc_coreui/src/components/preferences_sheet/preference_option_sheet_header.dart';

void main() {
  const info = CorePreferenceInfo(
    title: 'Meter length display',
    description: 'Changes the number of decimal places shown',
    semanticsLabel: 'About this preference',
    closeLabel: 'Close',
  );

  Future<void> pumpHeader(
    WidgetTester tester, {
    CorePreferenceInfo? withInfo,
    VoidCallback? onBack,
    VoidCallback? onInfoTap,
  }) {
    return tester.pumpWidget(
      MaterialApp(
        theme: CoreTheme.light(),
        home: Scaffold(
          body: PreferenceOptionSheetHeader(
            title: 'Meter length display',
            backSemanticsLabel: 'Back to preferences',
            onBack: onBack ?? () {},
            info: withInfo,
            onInfoTap: onInfoTap,
            infoButtonKey: const Key('info_button'),
          ),
        ),
      ),
    );
  }

  testWidgets('the preference name is rendered', (tester) async {
    await pumpHeader(tester);

    expect(find.text('Meter length display'), findsOneWidget);
  });

  testWidgets('the info button appears only with an explanation to show',
      (tester) async {
    await pumpHeader(tester);
    expect(find.byKey(const Key('info_button')), findsNothing);

    await pumpHeader(tester, withInfo: info);
    expect(find.byKey(const Key('info_button')), findsOneWidget);
  });

  testWidgets('both controls report their taps', (tester) async {
    var backs = 0;
    var infos = 0;
    await pumpHeader(
      tester,
      withInfo: info,
      onBack: () => backs++,
      onInfoTap: () => infos++,
    );

    await tester.tap(find.bySemanticsLabel('Back to preferences'));
    await tester.tap(find.byKey(const Key('info_button')));
    await tester.pump();

    expect(backs, 1);
    expect(infos, 1);
  });

  testWidgets('the info button is labelled from the explanation',
      (tester) async {
    await pumpHeader(tester, withInfo: info);

    expect(
      find.bySemanticsLabel('About this preference'),
      findsOneWidget,
      reason: 'an interactive control with no label is invisible to a '
          'screen reader',
    );
  });
}
