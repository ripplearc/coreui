import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../load_fonts.dart';

void main() {
  setUpAll(() async {
    await loadFonts();
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('Toast Component Visual Regression Test',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1050, 550));

    final toasts = <Widget>[
      Toast.error(
        title: 'Error Title',
        description: 'This is an error message that needs attention',
        closeLabel: 'Close',
        onClose: () {},
      ),
      Toast.warning(
        title: 'Warning Title',
        description: 'This is a warning message to be careful about',
        closeLabel: 'Close',
        onClose: () {},
      ),
      Toast.info(
        title: 'Info Title',
        description: 'This is an informational message for you',
        closeLabel: 'Close',
        onClose: () {},
      ),
      Toast.success(
        title: 'Success Title',
        description: 'This is a success message, well done!',
        closeLabel: 'Close',
        onClose: () {},
      ),
      Toast.error(
        description: 'This is an error message without a title',
        closeLabel: 'Close',
        onClose: () {},
      ),
      Toast.warning(
        description: 'This is a warning message without a title',
        closeLabel: 'Close',
        onClose: () {},
      ),
      Toast.info(
        description: 'This is an info message without a title',
        closeLabel: 'Close',
        onClose: () {},
      ),
      Toast.success(
        description: 'This is a success message without a title',
        closeLabel: 'Close',
        onClose: () {},
      ),
      Toast.error(
        title:
            'This is a very long title that should wrap to multiple lines gracefully',
        description:
            'This is an equally long description that demonstrates how the toast handles extended content without breaking the layout',
        closeLabel: 'Close',
        onClose: () {},
      ),
    ];

    final widget = MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: toasts
                .map((toast) => SizedBox(width: 500, child: toast))
                .toList(),
          ),
        ),
      ),
    );

    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/toast_component.png'),
    );
  });
}
