import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:core_ui/core_ui.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  group('Toast Golden Tests', () {
    testGoldens('Toast Component Visual Regression Test', (tester) async {
      final builder = GoldenBuilder.grid(
        columns: 2,
        widthToHeightRatio: 1,
      )
        // Basic variants with title and description
        ..addScenario(
          'Error Toast',
          Container(
            padding: const EdgeInsets.all(8),
            child: Toast.error(
              title: 'Error Title',
              description: 'This is an error message that needs attention',
              onClose: () {},
            ),
          ),
        )
        ..addScenario(
          'Warning Toast',
          Container(
            padding: const EdgeInsets.all(8),
            child: Toast.warning(
              title: 'Warning Title',
              description: 'This is a warning message to be careful about',
              onClose: () {},
            ),
          ),
        )
        ..addScenario(
          'Info Toast',
          Container(
            padding: const EdgeInsets.all(8),
            child: Toast.info(
              title: 'Info Title',
              description: 'This is an informational message for you',
              onClose: () {},
            ),
          ),
        )
        ..addScenario(
          'Success Toast',
          Container(
            padding: const EdgeInsets.all(8),
            child: Toast.success(
              title: 'Success Title',
              description: 'This is a success message, well done!',
              onClose: () {},
            ),
          ),
        )
        // Variants without description
        ..addScenario(
          'Title Only',
          Container(
            padding: const EdgeInsets.all(8),
            child: Toast.info(
              title: 'Toast with Title Only',
              onClose: () {},
            ),
          ),
        )
        // Variant without close button
        ..addScenario(
          'No Close Button',
          Container(
            padding: const EdgeInsets.all(8),
            child: Toast.warning(
              title: 'No Close Button',
              description: 'This toast cannot be dismissed manually',
            ),
          ),
        )
        // Long content handling
        ..addScenario(
          'Long Content',
          Container(
            padding: const EdgeInsets.all(8),
            child: Toast.error(
              title: 'This is a very long title that should wrap to multiple lines gracefully',
              description: 'This is an equally long description that demonstrates how the toast handles extended content without breaking the layout',
              onClose: () {},
            ),
          ),
        )
        // Minimal variant
        ..addScenario(
          'Minimal',
          Container(
            padding: const EdgeInsets.all(8),
            child: Toast.success(
              title: 'Simple Success',
            ),
          ),
        );

      await tester.pumpWidgetBuilder(
        Container(
          color: Colors.white,
          child: builder.build(),
        ),
        surfaceSize: const Size(800, 800),
      );

      await screenMatchesGolden(tester, 'toast_component');
    });
  });
} 