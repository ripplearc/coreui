import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  group('Toast Golden Tests', () {
    testGoldens('Toast Component Visual Regression Test', (tester) async {
      final builder = GoldenBuilder.grid(
          columns: 2, widthToHeightRatio: 2.5, bgColor: Colors.white)
        // Toasts with title and description
        ..addScenario(
          'Error Toast with Title',
          Toast.error(
            title: 'Error Title',
            description: 'This is an error message that needs attention',
            closeLabel: 'Close',
            onClose: () {},
          ),
        )
        ..addScenario(
          'Warning Toast with Title',
          Toast.warning(
            title: 'Warning Title',
            description: 'This is a warning message to be careful about',
            closeLabel: 'Close',
            onClose: () {},
          ),
        )
        ..addScenario(
          'Info Toast with Title',
          Toast.info(
            title: 'Info Title',
            description: 'This is an informational message for you',
            closeLabel: 'Close',
            onClose: () {},
          ),
        )
        ..addScenario(
          'Success Toast with Title',
          Toast.success(
            title: 'Success Title',
            description: 'This is a success message, well done!',
            closeLabel: 'Close',
            onClose: () {},
          ),
        )
        // Toasts without title (description only)
        ..addScenario(
          'Error Toast without Title',
          Toast.error(
            description: 'This is an error message without a title',
            closeLabel: 'Close',
            onClose: () {},
          ),
        )
        ..addScenario(
          'Warning Toast without Title',
          Toast.warning(
            description: 'This is a warning message without a title',
            closeLabel: 'Close',
            onClose: () {},
          ),
        )
        ..addScenario(
          'Info Toast without Title',
          Toast.info(
            description: 'This is an info message without a title',
            closeLabel: 'Close',
            onClose: () {},
          ),
        )
        ..addScenario(
          'Success Toast without Title',
          Toast.success(
            description: 'This is a success message without a title',
            closeLabel: 'Close',
            onClose: () {},
          ),
        )
        // Long content handling
        ..addScenario(
          'Long Content',
          Toast.error(
            title:
                'This is a very long title that should wrap to multiple lines gracefully',
            description:
                'This is an equally long description that demonstrates how the toast handles extended content without breaking the layout',
            closeLabel: 'Close',
            onClose: () {},
          ),
        );

      await tester.pumpWidgetBuilder(
        Container(
          color: Colors.white,
          child: builder.build(),
        ),
        surfaceSize: const Size(1050, 1050),
      );

      await screenMatchesGolden(tester, 'toast_component');
    });
  });
}
