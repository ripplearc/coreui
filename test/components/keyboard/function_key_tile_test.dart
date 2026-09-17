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
                width: CoreSpacing.space40,
                height: CoreSpacing.space12,
                child: FunctionKeyTile(
                  keyType: const KeyType(
                    groupName: 'test',
                    id: 'Test',
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

  group('FunctionKeyTile test key', () {
    Widget tile(KeyType keyType) => MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: CoreSpacing.space40,
                height: CoreSpacing.space12,
                child: FunctionKeyTile(keyType: keyType, onTap: () {}),
              ),
            ),
          ),
        );

    testWidgets('carries calc_key_<id> unless testKey is set', (tester) async {
      await tester.pumpWidget(tile(
          const KeyType(groupName: 'basic', id: 'Length', label: 'Length')));
      expect(find.byKey(const ValueKey('calc_key_Length')), findsOneWidget);

      await tester.pumpWidget(tile(const KeyType(
        groupName: 'basic',
        id: 'Length',
        label: 'Length',
        testKey: ValueKey('calc_key_length'),
      )));
      expect(find.byKey(const ValueKey('calc_key_length')), findsOneWidget);
      expect(find.byKey(const ValueKey('calc_key_Length')), findsNothing);
    });
  });
}
