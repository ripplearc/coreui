import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';

void main() {
  group('CoreInputChip – accessibility', () {
    testWidgets('remove button meets tap target and label guidelines in both themes', (
      tester,
    ) async {
      await setupA11yTest(tester);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => CoreInputChip(
          label: 'alice@example.com',
          onRemove: () {},
        ),
        find.byKey(CoreInputChip.removeButtonKey),
      );
    });
  });
}
