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
  group('CoreValueEditorSheet a11y', () {
    testWidgets('meets basic accessibility guidelines',
        (WidgetTester tester) async {
      await setTestViewport(tester);

      await setupA11yTest(tester);
      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => MaterialApp(
          theme: theme,
          home: const Scaffold(
            body: CoreValueEditorSheet(
              titles: ['Title 1', 'Title 2'],
              addSizeTitle: 'Add size',
              editSizeTitle: 'Edit size',
              resultLabel: 'Add',
              unitOptions: ['m', 'cm', 'mm'],
              unitGroupLabel: 'Unit',
            ),
          ),
        ),
        find.byType(CoreValueEditorSheet),
        checkTapTargetSize: _skipKeyboardDragHandleTapTarget,
      );
    });

    testWidgets('single-value mode meets basic accessibility guidelines',
        (WidgetTester tester) async {
      await setTestViewport(tester);

      await setupA11yTest(tester);
      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => MaterialApp(
          theme: theme,
          home: Scaffold(
            body: CoreValueEditorSheet.singleValue(
              title: 'Rate',
              label: 'Rate',
              resultLabel: 'Update',
              initialValue: '12.3',
            ),
          ),
        ),
        find.byType(CoreValueEditorSheet),
        checkTapTargetSize: _skipKeyboardDragHandleTapTarget,
      );
    });
  });
}
