import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';
import '../../utils/a11y_guidelines.dart';
import '../../utils/test_harness.dart';

void main() {
  setUpAll(() async {
    await loadFonts();
  });

  group('CoreKeyboard – accessibility', () {
    final testGroups = [
      FunctionGroup(
        name:
            const GroupNameType(id: "Basic Geometry", label: "Basic Geometry"),
        keys: [
          KeyType(
              groupName: 'Basic Geometry',
              id: 'Area',
              label: 'Area',
              action: () {}),
          KeyType(
            groupName: 'Basic Geometry',
            id: 'Perimeter',
            label: 'Perimeter',
            action: () {},
          ),
        ],
      ),
    ];

    Widget buildTestKeyboard() {
      return CoreKeyboard(
        currentGroup:
            const GroupNameType(id: "Basic Geometry", label: "Basic Geometry"),
        allGroups: testGroups,
        onDigitPressed: (_) {},
        onUnitSelected: (_) {},
        onOperatorPressed: (_) {},
        onControlAction: (_) {},
        onResultTapped: () {},
        onGroupSelected: (_) {},
        onKeyTapped: (_) {},
        onUnitSystemChanged: (_) {},
      );
    }

    final keyTypesToTest = {
      'digit': CoreDigitInput,
      'operator': CoreOperatorButton,
      'unit': CoreUnitButton,
      'control': CoreControlButton,
      'result': CoreResultButton,
    };

    for (final entry in keyTypesToTest.entries) {
      testWidgets(
        '${entry.key} keys meet tap target and label guidelines',
        (tester) async {
          await setupA11yTest(
            tester,
            screenSize: const Size(1100, 1600),
          );

          await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
            tester,
            (_) => buildTestKeyboard(),
            find.byType(entry.value).first,
          );
        },
      );
    }

    testWidgets(
      'drag handle meets tap target and label guidelines',
      (tester) async {
        await setupA11yTest(
          tester,
          screenSize: const Size(1100, 1600),
        );

        await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
          tester,
          (_) => buildTestKeyboard(),
          find.bySemanticsLabel('Keyboard drag handle'),
        );
      },
    );

    testWidgets(
      'collapsed drag handle meets tap target and label guidelines',
      (tester) async {
        await setupA11yTest(
          tester,
          screenSize: const Size(1100, 1600),
        );

        for (final theme in kA11yTestThemes) {
          await tester.pumpWidget(
            buildTestApp(
              buildTestKeyboard(),
              theme: theme,
            ),
          );
          await tester.pumpAndSettle();

          await tester.tap(find.bySemanticsLabel('Keyboard drag handle'));
          await tester.pumpAndSettle();

          await expectMeetsTapTargetAndLabelGuidelines(
            tester,
            find.bySemanticsLabel('Keyboard drag handle'),
          );
        }
      },
    );

    testWidgets(
      'View all sheet drag handles are announced with the reorder label',
      (tester) async {
        await setupA11yTest(tester, screenSize: const Size(600, 1000));

        for (final theme in kA11yTestThemes) {
          await tester.pumpWidget(
            buildTestApp(
              CoreKeyboard(
                currentGroup: const GroupNameType(
                    id: "Basic Geometry", label: "Basic Geometry"),
                allGroups: testGroups,
                onDigitPressed: (_) {},
                onUnitSelected: (_) {},
                onOperatorPressed: (_) {},
                onControlAction: (_) {},
                onResultTapped: () {},
                onGroupSelected: (_) {},
                onKeyTapped: (_) {},
                onUnitSystemChanged: (_) {},
                onGroupsReordered: (_, __) {},
                reorderSemanticsLabelBuilder: (label) => 'Reorder $label group',
              ),
              theme: theme,
            ),
          );
          await tester.pumpAndSettle();

          await tester.tap(find.text('View all'));
          await tester.pumpAndSettle();

          expect(
            find.bySemanticsLabel(RegExp('Reorder Basic Geometry group')),
            findsOneWidget,
          );
          await expectMeetsTapTargetAndLabelGuidelines(
            tester,
            find.byType(CoreFunctionKeyBottomSheet),
            checkTapTargetSize: false,
            checkLabeledTapTarget: true,
            checkTextContrast: false,
          );

          await tester.tap(find.descendant(
            of: find.byType(CoreFunctionKeyBottomSheet),
            matching: find.text('Basic Geometry group'),
          ));
          await tester.pumpAndSettle();
        }
      },
    );
  });
}
