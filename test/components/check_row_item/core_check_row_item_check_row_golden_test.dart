import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

ThemeData _withRoboto(ThemeData base) {
  return base.copyWith(
    textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto'),
  );
}

void _noop(bool _) {}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await loadFonts();
  });

  final themes = {
    'light': _withRoboto(CoreTheme.light()),
    'dark': _withRoboto(CoreTheme.dark()),
  };

  Future<void> pumpRows(
    WidgetTester tester,
    ThemeData theme,
    Size size,
    List<Widget> rows,
  ) async {
    tester.view.physicalSize = size * 2;
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: Scaffold(
          backgroundColor: theme.coreColors.pageBackground,
          body: Column(mainAxisSize: MainAxisSize.min, children: rows),
        ),
      ),
    );
    await tester.pump();
  }

  for (final MapEntry(key: mode, value: theme) in themes.entries) {
    testWidgets('Check row states and disabled Dropdown cell - $mode',
        (tester) async {
      await pumpRows(tester, theme, const Size(360, 440), const [
        CoreCheckRowItem.checkRow(
          title: 'John Doe',
          subtitle: 'john@acme.com',
          selected: false,
          onChanged: _noop,
        ),
        CoreCheckRowItem.checkRow(
          title: 'Floyd Miles',
          subtitle: 'floyd@acme.com',
          selected: true,
          onChanged: _noop,
        ),
        CoreCheckRowItem.checkRow(
          title: 'Esther Howard',
          subtitle: 'esther@acme.com',
          selected: false,
          enabled: false,
          onChanged: _noop,
        ),
        CoreCheckRowItem.checkRow(
          title: 'Marvin McKinney',
          subtitle: 'Last row, no divider',
          selected: true,
          enabled: false,
          showDivider: false,
          onChanged: _noop,
        ),
        CoreCheckRowItem(
          title: 'Dropdown cell disabled',
          selected: false,
          enabled: false,
          onChanged: _noop,
        ),
        CoreCheckRowItem(
          title: 'Dropdown cell disabled, selected',
          selected: true,
          enabled: false,
          onChanged: _noop,
        ),
      ]);

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/core_check_row_item_check_row_$mode.png'),
      );
    });

    testWidgets('Check row pressed - $mode', (tester) async {
      await pumpRows(tester, theme, const Size(360, 68), const [
        CoreCheckRowItem.checkRow(
          title: 'John Doe',
          subtitle: 'john@acme.com',
          selected: false,
          showDivider: false,
          onChanged: _noop,
        ),
      ]);
      final gesture =
          await tester.startGesture(tester.getCenter(find.text('John Doe')));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile(
          'goldens/core_check_row_item_check_row_pressed_$mode.png',
        ),
      );
      await gesture.up();
    });

    testWidgets('both looks focused - $mode', (tester) async {
      await pumpRows(tester, theme, const Size(360, 116), const [
        CoreCheckRowItem.checkRow(
          title: 'Check row, focused',
          subtitle: 'john@acme.com',
          selected: false,
          onChanged: _noop,
        ),
        CoreCheckRowItem(
          title: 'Dropdown cell, focused',
          selected: true,
          onChanged: _noop,
        ),
      ]);
      // Tab once to the Check row, picture it; Tab again to the Dropdown cell.
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile(
          'goldens/core_check_row_item_check_row_focused_$mode.png',
        ),
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile(
          'goldens/core_check_row_item_dropdown_cell_focused_$mode.png',
        ),
      );
    });
  }
}
