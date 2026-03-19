import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';

void main() {
  group('CoreQuickSheet accessibility', () {
    testWidgets('respects semantics of child widgets', (tester) async {
      await setupA11yTest(tester);

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  CoreQuickSheet.show(
                    context: context,
                    child: Semantics(
                      label: 'Custom semantic label for sheet content',
                      child: const Text('Visual Content'),
                    ),
                  );
                },
                child: const Text('Open Sheet'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      final semanticsHandle = tester.ensureSemantics();

      final semanticsNode = tester.getSemantics(find.text('Visual Content'));
      expect(
        semanticsNode.label,
        contains('Custom semantic label for sheet content'),
      );

      semanticsHandle.dispose();
    });
  });
}
