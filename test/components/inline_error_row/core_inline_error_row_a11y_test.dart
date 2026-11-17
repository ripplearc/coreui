import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';

void main() {
  testWidgets('the action meets tap target, label and contrast guidelines',
      (tester) async {
    await setupA11yTest(tester);
    await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
      tester,
      (theme) => CoreInlineErrorRow(
        message: 'Could not load your rates',
        actionLabel: 'Try again',
        onAction: () {},
      ),
      find.text('Try again'),
    );
  });

  testWidgets('the message meets the text contrast guideline', (tester) async {
    await setupA11yTest(tester);
    await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
      tester,
      (theme) => const CoreInlineErrorRow(message: 'Could not load your rates'),
      find.byType(CoreInlineErrorRow),
      checkTapTargetSize: false,
    );
  });
}
