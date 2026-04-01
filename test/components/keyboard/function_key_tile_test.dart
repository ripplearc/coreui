import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

void main() {
  setUpAll(() async {
    await loadFonts();
  });

  group('FunctionKeyTile', () {
    testWidgets('onTap is called exactly once per tap', (tester) async {
      var callCount = 0;
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 160,
                height: 48,
                child: FunctionKeyTile(
                  keyType: const KeyType(
                    groupName: 'test',
                    label: 'Test',
                    semanticLabel: 'Test key',
                  ),
                  onTap: () => callCount++,
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(FunctionKeyTile));
      await tester.pumpAndSettle();
      expect(callCount, 1);

      await tester.tap(find.byType(FunctionKeyTile));
      await tester.pumpAndSettle();
      expect(callCount, 2);
    });
  });
}
