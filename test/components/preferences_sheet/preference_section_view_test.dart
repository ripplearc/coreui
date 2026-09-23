import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';
import 'package:ripplearc_coreui/src/components/preferences_sheet/preference_anchors.dart';
import 'package:ripplearc_coreui/src/components/preferences_sheet/preference_row_tile.dart';
import 'package:ripplearc_coreui/src/components/preferences_sheet/preference_section_view.dart';
import 'package:ripplearc_coreui/src/components/preferences_sheet/preference_sheet_title.dart';

void main() {
  const choices = [
    CorePreferenceOption(id: 'a', label: 'Option A'),
    CorePreferenceOption(id: 'b', label: 'Option B'),
  ];

  const section = CorePreferenceSection(
    title: 'Display',
    rows: [
      CorePreferenceRow(
        key: 'fractional_resolution',
        label: 'Fractional resolution',
        value: CorePreferenceTextValue('1/16'),
        options: choices,
      ),
      CorePreferenceRow(
        key: 'fractional_mode',
        label: 'Fractional mode',
        value: CorePreferenceTextValue('std', isMuted: true),
        options: [CorePreferenceOption(id: 'std', label: 'std')],
      ),
    ],
  );

  late PreferenceAnchors anchors;

  setUp(() => anchors = PreferenceAnchors());

  Future<List<String>> pumpSection(
    WidgetTester tester, {
    CorePreferenceSection group = section,
    String? emphasisKey,
    bool withRowKeys = true,
  }) async {
    final tapped = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        theme: CoreTheme.light(),
        home: Scaffold(
          body: PreferenceSectionView(
            section: group,
            emphasisKey: emphasisKey,
            emphasisDuration: const Duration(milliseconds: 400),
            rowKeyOf: withRowKeys ? (key) => Key('row_$key') : null,
            anchorOf: (key) => anchors[key],
            onRowTap: (row) => tapped.add(row.key),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return tapped;
  }

  testWidgets('a titled group renders its heading', (tester) async {
    await pumpSection(tester);

    expect(find.text('Display'), findsOneWidget);
  });

  testWidgets('an untitled group renders its rows without a heading',
      (tester) async {
    await pumpSection(
      tester,
      group: const CorePreferenceSection(
        rows: [
          CorePreferenceRow(
            key: 'system_of_units',
            label: 'System of units',
            value: CorePreferencePillValue('Imperial', isOn: true),
            options: choices,
          ),
        ],
      ),
    );

    expect(find.text('System of units'), findsOneWidget);
    expect(find.byType(Text), findsNWidgets(2), reason: 'label and value only');
  });

  testWidgets('one tile per row', (tester) async {
    await pumpSection(tester);

    expect(find.byType(PreferenceRowTile), findsNWidgets(2));
    expect(find.byKey(const Key('row_fractional_resolution')), findsOneWidget);
  });

  testWidgets('only a row offering a choice reports its tap', (tester) async {
    final tapped = await pumpSection(tester);

    await tester.tap(find.byKey(const Key('row_fractional_mode')));
    await tester.pump();
    expect(tapped, isEmpty, reason: 'that row offers a single option');

    await tester.tap(find.byKey(const Key('row_fractional_resolution')));
    await tester.pump();
    expect(tapped, ['fractional_resolution']);
  });

  testWidgets('the deep-link mark lands on the named row alone',
      (tester) async {
    await pumpSection(tester, emphasisKey: 'fractional_mode');

    PreferenceRowTile tileAt(String key) =>
        tester.widget<PreferenceRowTile>(find.byKey(Key('row_$key')));

    expect(tileAt('fractional_mode').isEmphasised, isTrue);
    expect(tileAt('fractional_resolution').isEmphasised, isFalse);
  });

  testWidgets('every row carries the anchor the sheet scrolls to',
      (tester) async {
    await pumpSection(tester);

    expect(
      anchors.contextOf('fractional_resolution'),
      isNotNull,
      reason: 'the sheet scrolls to a row through the registry it owns, so '
          'the anchor the registry holds must be the one the row was built '
          'with',
    );
    expect(anchors.contextOf('fractional_mode'), isNotNull);
  });

  testWidgets('a section renders when the caller leaves out rowKeyOf',
      (tester) async {
    await pumpSection(tester, withRowKeys: false);

    expect(find.text('Display'), findsOneWidget);
    expect(find.byType(PreferenceRowTile), findsNWidgets(2));
    expect(anchors.contextOf('fractional_resolution'), isNotNull);
  });

  testWidgets('PreferenceSheetTitle renders the sheet heading',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: CoreTheme.light(),
        home: const Scaffold(body: PreferenceSheetTitle(title: 'Preferences')),
      ),
    );

    expect(find.text('Preferences'), findsOneWidget);
  });
}
