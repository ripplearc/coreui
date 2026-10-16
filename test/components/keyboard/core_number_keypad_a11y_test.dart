import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';

void main() {
  group('CoreNumberKeypad – accessibility', () {
    for (final isConfirmEnabled in [true, false]) {
      testWidgets(
          'meets tap target, label and contrast guidelines, '
          'confirm ${isConfirmEnabled ? 'enabled' : 'disabled'}',
          (tester) async {
        await setupA11yTest(tester, screenSize: const Size(412, 917));

        await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
          tester,
          (theme) => Align(
            alignment: Alignment.bottomCenter,
            child: CoreNumberKeypad(
              onDigitPressed: (_) {},
              onDecimalPressed: () {},
              onBackspacePressed: () {},
              onClearPressed: () {},
              onConfirmPressed: () {},
              clearLabel: 'Back to 10%',
              confirmLabel: 'Add to estimate',
              isConfirmEnabled: isConfirmEnabled,
            ),
          ),
          find.byType(CoreNumberKeypad),
        );
      });
    }
  });
}
