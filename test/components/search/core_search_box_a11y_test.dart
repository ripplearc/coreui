import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';

void main() {
  group('CoreSearchBox – accessibility tests', () {
    testWidgets('CoreSearchBox meets tap target and label guidelines',
        (tester) async {
      await setupA11yTest(tester);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (_) => const Padding(
          padding: EdgeInsets.all(CoreSpacing.space4),
          child: CoreSearchBox(
            hintText: 'Search for Calculation and cost',
          ),
        ),
        find.byType(CoreSearchBox),
        checkLabeledTapTarget: false,
      );
    });
  });
}
