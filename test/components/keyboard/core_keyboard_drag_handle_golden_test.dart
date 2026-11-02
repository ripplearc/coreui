import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../await_images_extension.dart';
import '../../load_fonts.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await loadFonts();
  });

  const basicGeometry =
      GroupNameType(id: "Basic Geometry", label: "Basic Geometry");
  Finder dragHandle() => find.bySemanticsLabel('Keyboard drag handle');

  Future<void> pumpKeyboard(WidgetTester tester, ThemeData theme) async {
    await tester.binding.setSurfaceSize(const Size(350, 550));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: theme.copyWith(
          textTheme: theme.textTheme.apply(fontFamily: 'Roboto'),
        ),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Column(
            children: [
              const Spacer(),
              CoreKeyboard(
                currentGroup: basicGeometry,
                allGroups: const [
                  FunctionGroup(name: basicGeometry, keys: []),
                ],
                onDigitPressed: (_) {},
                onUnitSelected: (_) {},
                onOperatorPressed: (_) {},
                onControlAction: (_) {},
                onResultTapped: () {},
                onGroupSelected: (_) {},
                onKeyTapped: (_) {},
                onUnitSystemChanged: (_) {},
                groupAccentColors: const {},
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.awaitImages();
  }

  final themes = {
    'light': CoreTheme.light(),
    'dark': CoreTheme.dark(),
  };

  for (final MapEntry(key: name, value: theme) in themes.entries) {
    testWidgets('CoreKeyboard drag handle pressed - $name', (tester) async {
      await pumpKeyboard(tester, theme);

      final gesture =
          await tester.startGesture(tester.getCenter(dragHandle()));
      addTearDown(gesture.removePointer);
      await tester.pump(kPressTimeout);
      await tester.pump(const Duration(milliseconds: 300));

      await expectLater(
        find.byType(CoreKeyboard),
        matchesGoldenFile(
          'goldens/core_keyboard_drag_handle_pressed_$name.png',
        ),
      );

      await gesture.up();
      await tester.pumpAndSettle();
    });

    testWidgets('CoreKeyboard drag handle focused - $name', (tester) async {
      await pumpKeyboard(tester, theme);

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();

      final semanticsHandle = tester.ensureSemantics();
      expect(
        tester.getSemantics(dragHandle()).flagsCollection.isFocused,
        ui.Tristate.isTrue,
      );
      semanticsHandle.dispose();
      await expectLater(
        find.byType(CoreKeyboard),
        matchesGoldenFile(
          'goldens/core_keyboard_drag_handle_focused_$name.png',
        ),
      );
    });
  }
}
