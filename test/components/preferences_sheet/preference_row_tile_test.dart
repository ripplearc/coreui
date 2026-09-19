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

  late AppColorsExtension colors;

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
                anchorKey: const Key('anchor'),
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

    expect(find.byKey(const Key('anchor')), findsOneWidget);
  });
}
