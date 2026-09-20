import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';
import 'package:ripplearc_coreui/src/components/preferences_sheet/preference_option_tile.dart';

void main() {
  const option = CorePreferenceOption(id: '1/16', label: '1/16');

  Future<void> pumpTile(
    WidgetTester tester, {
    required bool isSelected,
    VoidCallback? onTap,
  }) {
    return tester.pumpWidget(
      MaterialApp(
        theme: CoreTheme.light(),
        home: Scaffold(
          body: PreferenceOptionTile(
            option: option,
            isSelected: isSelected,
            onTap: onTap ?? () {},
          ),
        ),
      ),
    );
  }

  testWidgets('the label is rendered', (tester) async {
    await pumpTile(tester, isSelected: false);

    expect(find.text('1/16'), findsOneWidget);
  });

  final tick = find.byWidgetPredicate(
    (widget) => widget is CoreIconWidget && widget.icon == CoreIcons.checkMark,
  );

  testWidgets('the tick marks the picked choice and nothing else',
      (tester) async {
    await pumpTile(tester, isSelected: true);
    expect(tick, findsOneWidget);

    await pumpTile(tester, isSelected: false);
    expect(tick, findsNothing);
  });

  testWidgets('the picked choice is announced as selected', (tester) async {
    final semanticsHandle = tester.ensureSemantics();

    await pumpTile(tester, isSelected: true);
    expect(
      tester.getSemantics(find.byType(PreferenceOptionTile)),
      isSemantics(label: '1/16', isSelected: true),
    );

    await pumpTile(tester, isSelected: false);
    expect(
      tester.getSemantics(find.byType(PreferenceOptionTile)),
      isSemantics(label: '1/16', isSelected: false),
    );

    semanticsHandle.dispose();
  });

  testWidgets('the tile announces itself as a button', (tester) async {
    final semanticsHandle = tester.ensureSemantics();

    await pumpTile(tester, isSelected: false);
    expect(
      tester.getSemantics(find.byType(PreferenceOptionTile)),
      isSemantics(isButton: true),
      reason: 'a screen reader should announce the row as something to '
          'activate, the way the sibling CoreCheckRowItem does',
    );

    semanticsHandle.dispose();
  });

  testWidgets('tapping the tile reports the pick', (tester) async {
    var taps = 0;
    await pumpTile(tester, isSelected: false, onTap: () => taps++);

    await tester.tap(find.byType(PreferenceOptionTile));
    await tester.pump();

    expect(taps, 1);
  });
}
