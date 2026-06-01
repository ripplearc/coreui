import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';
import '../../utils/a11y_guidelines.dart';

void main() {
  setUpAll(() async {
    await loadFonts();
  });

  group('CoreKeyboard – accessibility', () {
    final testGroups = [
      FunctionGroup(
        name: const GroupNameType(label: "Basic Geometry"),
        keys: [
          KeyType(groupName: 'Basic Geometry', label: 'Area', action: () {}),
          KeyType(
              groupName: 'Basic Geometry', label: 'Perimeter', action: () {}),
        ],
      ),
    ];

    Widget buildTestKeyboard() {
      return CoreKeyboard(
        currentGroup: const GroupNameType(label: "Basic Geometry"),
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
      testWidgets('${entry.key} keys meet tap target and label guidelines',
          (tester) async {
        await setupA11yTest(tester, screenSize: const Size(1100, 1600));

        await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
          tester,
          (_) => buildTestKeyboard(),
          find.byType(entry.value).first,
        );
      });
    }
  });
}
