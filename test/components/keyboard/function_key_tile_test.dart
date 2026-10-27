import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';
import '../../utils/a11y_guidelines.dart';

void main() {
  setUpAll(() async {
    await loadFonts();
  });

  _announcementTests();

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

Widget _tileIn(ThemeData theme, KeyType keyType) => MaterialApp(
      theme: theme,
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

const KeyType _footing = KeyType(
  groupName: 'materials',
  id: 'Footing',
  label: 'Footng',
  semanticLabel: 'Footing',
);

const KeyType _length = KeyType(
  groupName: 'basic',
  id: 'Length',
  label: 'Length',
);

void _announcementTests() {
  group('FunctionKeyTile announcement', () {
    testWidgets('a key with semanticLabel is announced by it', (tester) async {
      await tester.pumpWidget(_tileIn(CoreTheme.light(), _footing));

      final semantics =
          tester.getSemantics(find.byKey(const ValueKey('calc_key_Footing')));
      expect(semantics.label, startsWith('Footing'));
      expect(semantics.label, isNot(contains('function key')));
      expect(semantics.hint, isEmpty);
    });

    testWidgets('a key without semanticLabel is announced by its face',
        (tester) async {
      await tester.pumpWidget(_tileIn(CoreTheme.light(), _length));

      final semantics =
          tester.getSemantics(find.byKey(const ValueKey('calc_key_Length')));
      expect(semantics.label, startsWith('Length'));
      expect(semantics.label, isNot(contains('Function key')));
      expect(semantics.hint, isEmpty);
    });

    testWidgets('a key with an empty semanticLabel is announced by its face',
        (tester) async {
      await tester.pumpWidget(_tileIn(
        CoreTheme.light(),
        const KeyType(
          groupName: 'test',
          id: 'Length',
          label: 'Length',
          semanticLabel: '',
        ),
      ));

      final semantics =
          tester.getSemantics(find.byKey(const ValueKey('calc_key_Length')));
      expect(semantics.label, startsWith('Length'));
    });

    testWidgets('the hint is the caller\'s words or nothing', (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: CoreTheme.light(),
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: CoreSpacing.space40,
              height: CoreSpacing.space12,
              child: FunctionKeyTile(
                keyType: _footing,
                onTap: () {},
                customHint: 'Ajoute une semelle',
              ),
            ),
          ),
        ),
      ));

      final semantics =
          tester.getSemantics(find.byKey(const ValueKey('calc_key_Footing')));
      expect(semantics.hint, 'Ajoute une semelle');
    });

    for (final (name, keyType) in [
      ('a named key', _footing),
      ('a bare key', _length)
    ]) {
      testWidgets('$name meets the tap target and label guidelines',
          (tester) async {
        await setupA11yTest(tester);

        await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
          tester,
          (theme) => _tileIn(theme, keyType),
          find.byKey(keyType.resolvedTestKey),
        );
      });
    }
  });

  group('FunctionKeyTile announcement on the keyboard', () {
    const basic = GroupNameType(id: 'basic', label: 'Basic Geometry');
    final groups = [
      const FunctionGroup(name: basic, keys: [_length, _footing]),
    ];

    Widget keyboard() => MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreKeyboard(
              currentGroup: basic,
              allGroups: groups,
              onDigitPressed: (_) {},
              onUnitSelected: (_) {},
              onOperatorPressed: (_) {},
              onControlAction: (_) {},
              onResultTapped: () {},
              onGroupSelected: (_) {},
              onKeyTapped: (_) {},
              onUnitSystemChanged: (_) {},
            ),
          ),
        );

    testWidgets('the strip and the View all sheet announce the same names',
        (tester) async {
      tester.view.physicalSize = const Size(1100, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());
      addTearDown(() => tester.view.resetDevicePixelRatio());
      await tester.pumpWidget(keyboard());
      await tester.pumpAndSettle();

      final strip = find.descendant(
        of: find.byType(CoreKeyboard),
        matching: find.byKey(const ValueKey('calc_key_Footing')),
      );
      expect(tester.getSemantics(strip).label, startsWith('Footing'));

      await tester.tap(find.text('View all'));
      await tester.pumpAndSettle();

      final inSheet = find.descendant(
        of: find.byType(CoreFunctionKeyBottomSheet),
        matching: find.byKey(const ValueKey('calc_key_Footing')),
      );
      expect(tester.getSemantics(inSheet).label, startsWith('Footing'));
      expect(
        tester
            .getSemantics(find.descendant(
              of: find.byType(CoreFunctionKeyBottomSheet),
              matching: find.byKey(const ValueKey('calc_key_Length')),
            ))
            .label,
        startsWith('Length'),
      );
    });
  });
}
