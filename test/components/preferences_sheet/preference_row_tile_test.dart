import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';
import 'package:ripplearc_coreui/src/components/preferences_sheet/preference_row_tile.dart';

void main() {
  const row = CorePreferenceRow(
    key: 'fractional_resolution',
    label: 'Fractional resolution',
    value: CorePreferenceTextValue('1/16'),
    options: [
      CorePreferenceOption(id: '1/8', label: '1/8'),
      CorePreferenceOption(id: '1/16', label: '1/16'),
    ],
  );

  late GlobalKey anchor;
  late AppColorsExtension colors;

  setUp(() => anchor = GlobalKey());

  Future<void> pumpTile(
    WidgetTester tester, {
    bool isEmphasised = false,
    VoidCallback? onTap,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: CoreTheme.light(),
        home: Builder(
          builder: (context) {
            colors = AppColorsExtension.of(context);
            return Scaffold(
              body: PreferenceRowTile(
                row: row,
                isEmphasised: isEmphasised,
                emphasisDuration: const Duration(milliseconds: 400),
                anchorKey: anchor,
                onTap: onTap,
              ),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Color backgroundOf(WidgetTester tester) {
    final container = tester.widget<AnimatedContainer>(
      find.byType(AnimatedContainer),
    );
    return (container.decoration! as BoxDecoration).color!;
  }

  testWidgets('a row is 48 dp high with a Line Light bottom line inside it',
      (tester) async {
    await pumpTile(tester);

    final container = tester.widget<AnimatedContainer>(
      find.byType(AnimatedContainer),
    );
    expect(tester.getSize(find.byType(AnimatedContainer)).height, 48);
    final border = (container.decoration! as BoxDecoration).border! as Border;
    expect(border.bottom, BorderSide(color: colors.lineLight));
    expect(border.top, BorderSide.none);
  });

  testWidgets('the value sits 12 dp after the label', (tester) async {
    await pumpTile(tester);

    final label = tester.getRect(find.ancestor(
      of: find.text('Fractional resolution'),
      matching: find.byType(Expanded),
    ));
    final value = tester.getRect(find.text('1/16'));
    expect(value.left - label.right, CoreSpacing.space3);
  });

  testWidgets('the ink sits inside the fill, with a Blue Light highlight',
      (tester) async {
    await pumpTile(tester, onTap: () {});

    final inkWell = find.byType(InkWell);
    final inkMaterial = find
        .ancestor(of: inkWell, matching: find.byType(Material))
        .first;
    expect(
      find.ancestor(
        of: inkMaterial,
        matching: find.byType(AnimatedContainer),
      ),
      findsOneWidget,
    );
    expect(
      tester.widget<InkWell>(inkWell).highlightColor,
      colors.backgroundBlueLight,
    );
  });

  testWidgets('a disabled row draws its label and value in Text Disable',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: CoreTheme.light(),
        home: Builder(
          builder: (context) {
            colors = AppColorsExtension.of(context);
            return Scaffold(
              body: PreferenceRowTile(
                row: const CorePreferenceRow(
                  key: 'units',
                  label: 'Units',
                  value: CorePreferenceTextValue('Imperial'),
                  isDisabled: true,
                ),
                isEmphasised: false,
                emphasisDuration: const Duration(milliseconds: 400),
                anchorKey: anchor,
              ),
            );
          },
        ),
      ),
    );

    expect(
      tester.widget<Text>(find.text('Units')).style!.color,
      colors.textDisable,
    );
    expect(
      tester.widget<Text>(find.text('Imperial')).style!.color,
      colors.textDisable,
    );
  });

  testWidgets('the label is Text Dark', (tester) async {
    await pumpTile(tester);

    expect(
      tester.widget<Text>(find.text('Fractional resolution')).style!.color,
      colors.textDark,
    );
  });

  testWidgets('the label and the current value are both rendered',
      (tester) async {
    await pumpTile(tester);

    expect(find.text('Fractional resolution'), findsOneWidget);
    expect(find.text('1/16'), findsOneWidget);
  });

  testWidgets('a row with nowhere to go does not respond to a tap',
      (tester) async {
    await pumpTile(tester);

    await tester.tap(find.byType(PreferenceRowTile));
    await tester.pump();

    expect(
      tester.widget<InkWell>(find.byType(InkWell)).onTap,
      isNull,
      reason: 'a preference with nothing to choose between must read as '
          'inert rather than open an empty sub-sheet',
    );
  });

  testWidgets('a tappable row reports its tap', (tester) async {
    var taps = 0;
    await pumpTile(tester, onTap: () => taps++);

    await tester.tap(find.byType(PreferenceRowTile));
    await tester.pump();

    expect(taps, 1);
  });

  testWidgets('the deep-link mark is a background of its own', (tester) async {
    await pumpTile(tester);
    expect(backgroundOf(tester), colors.backgroundGrayMid);

    await pumpTile(tester, isEmphasised: true);
    expect(backgroundOf(tester), colors.backgroundBlueLight);
  });

  testWidgets('the anchor is exposed so the sheet can scroll to the row',
      (tester) async {
    await pumpTile(tester);

    expect(find.byKey(anchor), findsOneWidget);
    expect(
      anchor.currentContext,
      isNotNull,
      reason: 'the sheet scrolls by reading the anchor\'s context, so an '
          'anchor that resolves to nothing would leave the deep link '
          'silently doing nothing',
    );
  });
}
