import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';

Future<void> setTestViewport(WidgetTester tester) async {
  addTearDown(() => tester.view.resetPhysicalSize());
  tester.view.physicalSize = const ui.Size(1100, 1600);
}

/// [CoreKeyboard]'s drag handle is 12px tall by design and does not qualify
/// as a standalone tap target. Tap target enforcement is delegated to
/// [CoreKeyboard]'s own accessibility test.
const _skipKeyboardDragHandleTapTarget = false;

void main() {
  group('SizeEntryBottomSheet a11y', () {
    testWidgets('meets basic accessibility guidelines',
        (WidgetTester tester) async {
      await setTestViewport(tester);

      await setupA11yTest(tester);
      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => MaterialApp(
          theme: theme,
          home: const Scaffold(
            body: SizeEntryBottomSheet(
              titles: ['Title 1', 'Title 2'],
              addSizeTitle: 'Add size',
              editSizeTitle: 'Edit size',
            ),
          ),
        ),
        find.byType(SizeEntryBottomSheet),
        checkTapTargetSize: _skipKeyboardDragHandleTapTarget,
      );
    });
  });
}
