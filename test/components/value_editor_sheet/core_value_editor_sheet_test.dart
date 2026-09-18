import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

void _setTestViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}

Widget _buildShowTrigger({
  CoreSizeCardData? initialData,
  int? initialIndex,
  String resultLabel = 'Add',
  List<String>? unitOptions,
  String? unitGroupLabel,
  String? Function(String value)? validator,
  void Function(SizeEntryResult)? onResult,
}) {
  return MaterialApp(
    theme: CoreTheme.light(),
    home: Scaffold(
      body: Builder(
        builder: (context) {
          return ElevatedButton(
            onPressed: () {
              CoreValueEditorSheet.show(
                context: context,
                titles: const ['Rail', 'O.C.'],
                addSizeTitle: 'Add size',
                editSizeTitle: 'Edit size',
                initialData: initialData,
                initialIndex: initialIndex,
                resultLabel: resultLabel,
                unitOptions: unitOptions,
                unitGroupLabel: unitGroupLabel,
                validator: validator,
              ).then((result) {
                if (result != null) onResult?.call(result);
              });
            },
            child: const Text('Show'),
          );
        },
      ),
    ),
  );
}

Widget _buildSingleValueTrigger({
  String title = 'Rate (\$ per ft²)',
  String label = 'Rate',
  String resultLabel = 'Update',
  String? initialValue,
  List<String>? unitOptions,
  String? unit,
  String? unitGroupLabel,
  String? Function(String value)? validator,
  void Function(String value, String? unit)? onSaved,
}) {
  return MaterialApp(
    theme: CoreTheme.light(),
    home: Scaffold(
      body: Builder(
        builder: (context) {
          return ElevatedButton(
            onPressed: () {
              CoreValueEditorSheet.showSingleValue(
                context: context,
                title: title,
                label: label,
                resultLabel: resultLabel,
                initialValue: initialValue,
                unitOptions: unitOptions,
                unit: unit,
                unitGroupLabel: unitGroupLabel,
                validator: validator,
                onSaved: onSaved,
              );
            },
            child: const Text('Show'),
          );
        },
      ),
    ),
  );
}

// Spelled out rather than using `?? 0`: optional operators are banned inside
// test blocks, and a non-numeric value deserves its own message anyway.
String? _positiveValidator(String value) {
  final parsed = double.tryParse(value);
  if (parsed == null) return 'Enter a number';
  return parsed > 0 ? null : 'Must be positive';
}

Future<void> _open(WidgetTester tester, Widget app) async {
  await tester.pumpWidget(app);
  await tester.tap(find.text('Show'));
  await tester.pumpAndSettle();
}

void main() {
  group('CoreValueEditorSheet multi-column', () {
    testWidgets('renders Add mode with correct title and field labels',
        (tester) async {
      _setTestViewport(tester);
      await _open(tester, _buildShowTrigger());

      expect(find.byType(CoreValueEditorSheet), findsOneWidget);
      expect(find.text('Add size'), findsOneWidget);
      expect(find.text('Rail*'), findsOneWidget);
      expect(find.text('O.C.*'), findsOneWidget);
    });

    testWidgets('renders Edit mode with correct title and pre-filled values',
        (tester) async {
      _setTestViewport(tester);
      await _open(
        tester,
        _buildShowTrigger(
          initialData: const CoreSizeCardData(id: '1', values: ['5', '8ft']),
          initialIndex: 0,
          resultLabel: 'Update',
        ),
      );

      expect(find.byType(CoreValueEditorSheet), findsOneWidget);
      expect(find.text('Edit size'), findsOneWidget);
      expect(find.text('5'), findsWidgets);
      expect(find.text('8ft'), findsWidgets);
    });

    testWidgets('renders the caller-supplied unit row', (tester) async {
      _setTestViewport(tester);
      await _open(
        tester,
        _buildShowTrigger(
          unitOptions: const ['m', 'cm', 'mm'],
          unitGroupLabel: 'Unit',
        ),
      );

      expect(find.byType(FunctionKeyTile), findsNWidgets(3));
      expect(find.text('m'), findsOneWidget);
      expect(find.text('cm'), findsOneWidget);
      expect(find.text('mm'), findsOneWidget);
    });

    testWidgets('a failing validator keeps the sheet open and shows the message',
        (tester) async {
      _setTestViewport(tester);
      await _open(
        tester,
        _buildShowTrigger(
          validator: (value) => value.isEmpty ? 'Required' : null,
        ),
      );

      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      expect(find.byType(CoreValueEditorSheet), findsOneWidget);
      expect(find.text('Required'), findsWidgets);
    });
  });

  group('CoreValueEditorSheet single value', () {
    testWidgets('renders one field under the caller-supplied title',
        (tester) async {
      _setTestViewport(tester);
      await _open(tester, _buildSingleValueTrigger(initialValue: '12.3'));

      expect(find.byType(CoreValueEditorSheet), findsOneWidget);
      expect(find.text('Rate (\$ per ft²)'), findsOneWidget);
      expect(find.text('Rate*'), findsOneWidget);
      expect(find.byType(CoreTextField), findsOneWidget);
      expect(find.text('12.3'), findsWidgets);
    });

    testWidgets('renders no unit row when the caller supplies none',
        (tester) async {
      _setTestViewport(tester);
      await _open(tester, _buildSingleValueTrigger());

      expect(find.byType(FunctionKeyTile), findsNothing);
    });

    testWidgets('digits reach the single field', (tester) async {
      _setTestViewport(tester);
      await _open(tester, _buildSingleValueTrigger());

      await tester.tap(find.text('4'));
      await tester.tap(find.text('2'));
      await tester.pumpAndSettle();

      expect(find.text('42'), findsWidgets);
    });

    testWidgets('clear-all empties the single field', (tester) async {
      _setTestViewport(tester);
      await _open(tester, _buildSingleValueTrigger(initialValue: '99'));

      await tester.tap(find.bySemanticsLabel('Clear all button'));
      await tester.pumpAndSettle();

      expect(find.text('99'), findsNothing);
    });

    testWidgets('onSaved reports the value and the selected unit',
        (tester) async {
      _setTestViewport(tester);
      String? savedValue;
      String? savedUnit;

      await _open(
        tester,
        _buildSingleValueTrigger(
          initialValue: '12.3',
          unitOptions: const ['m', 'cm', 'mm'],
          unitGroupLabel: 'Unit',
          onSaved: (value, unit) {
            savedValue = value;
            savedUnit = unit;
          },
        ),
      );

      await tester.tap(find.text('cm'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Update'));
      await tester.pumpAndSettle();

      // The unit is its own field, so it must not also be spelled into the
      // value — a round-trip through initialValue would compound it.
      expect(savedValue, '12.3');
      expect(savedUnit, 'cm');
    });

    testWidgets('commits the same value shape whether or not a unit is tapped',
        (tester) async {
      _setTestViewport(tester);
      final commits = <(String, String?)>[];

      Widget trigger() => _buildSingleValueTrigger(
            initialValue: '12.3',
            unitOptions: const ['m', 'cm', 'mm'],
            unitGroupLabel: 'Unit',
            unit: 'cm',
            onSaved: (value, unit) => commits.add((value, unit)),
          );

      await _open(tester, trigger());
      await tester.tap(find.text('Update'));
      await tester.pumpAndSettle();

      await _open(tester, trigger());
      await tester.tap(find.text('mm'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Update'));
      await tester.pumpAndSettle();

      expect(commits, [('12.3', 'cm'), ('12.3', 'mm')]);
    });

    testWidgets('onSaved reports a null unit when there is no unit row',
        (tester) async {
      _setTestViewport(tester);
      String? savedUnit = 'untouched';

      await _open(
        tester,
        _buildSingleValueTrigger(
          initialValue: '12.3',
          onSaved: (value, unit) => savedUnit = unit,
        ),
      );

      await tester.tap(find.text('Update'));
      await tester.pumpAndSettle();

      expect(savedUnit, isNull);
    });

    testWidgets('a failing validator blocks the commit', (tester) async {
      _setTestViewport(tester);
      var saved = false;

      await _open(
        tester,
        _buildSingleValueTrigger(
          initialValue: '0',
          validator: _positiveValidator,
          onSaved: (_, __) => saved = true,
        ),
      );

      await tester.tap(find.text('Update'));
      await tester.pumpAndSettle();

      expect(saved, isFalse);
      expect(find.byType(CoreValueEditorSheet), findsOneWidget);
      expect(find.text('Must be positive'), findsWidgets);
    });
  });

  group('CoreValueEditorSheet rebuilds', () {
    Widget sheet(List<String> titles) => MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreValueEditorSheet(
              titles: titles,
              addSizeTitle: 'Add size',
              editSizeTitle: 'Edit size',
              resultLabel: 'Add',
            ),
          ),
        );

    // The widget is public now, so it can be held in a tree and rebuilt with a
    // different column count rather than only ever built by showModalBottomSheet.
    testWidgets('survives being rebuilt with more titles', (tester) async {
      _setTestViewport(tester);
      await tester.pumpWidget(sheet(const ['A', 'B']));
      expect(find.byType(CoreTextField), findsNWidgets(2));

      await tester.pumpWidget(sheet(const ['A', 'B', 'C', 'D']));
      await tester.pumpAndSettle();

      expect(find.byType(CoreTextField), findsNWidgets(4));
      expect(find.text('D*'), findsOneWidget);
    });

    testWidgets('survives being rebuilt with fewer titles', (tester) async {
      _setTestViewport(tester);
      await tester.pumpWidget(sheet(const ['A', 'B', 'C', 'D']));
      await tester.pumpWidget(sheet(const ['A']));
      await tester.pumpAndSettle();

      expect(find.byType(CoreTextField), findsOneWidget);
      expect(find.text('D*'), findsNothing);
    });
  });

  group('CoreValueEditorSheet unit row per mode', () {
    // Multi-column deliberately diverges from single-value: SizeEntryResult
    // carries no unit, so the unit is spelled into the value as `47.24in` is.
    testWidgets('multi-column types the unit into the active field',
        (tester) async {
      _setTestViewport(tester);
      SizeEntryResult? result;
      await _open(
        tester,
        _buildShowTrigger(
          unitOptions: const ['m', 'cm', 'mm'],
          unitGroupLabel: 'Unit',
          onResult: (r) => result = r,
        ),
      );

      await tester.tap(find.text('4'));
      await tester.tap(find.text('cm'));
      await tester.pumpAndSettle();
      expect(find.text('4cm'), findsWidgets);

      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      expect(result, isNotNull);
      expect(result!.values.first, '4cm');
    });
  });

  group('SizeEntryBottomSheet deprecated alias', () {
    // Removed in the next release; until then it must still resolve and build.
    testWidgets('still builds the promoted widget', (tester) async {
      _setTestViewport(tester);
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            // ignore: deprecated_member_use_from_same_package
            body: SizeEntryBottomSheet(
              titles: ['Rail'],
              addSizeTitle: 'Add size',
              editSizeTitle: 'Edit size',
              resultLabel: 'Add',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CoreValueEditorSheet), findsOneWidget);
      expect(find.text('Rail*'), findsOneWidget);
    });
  });

  group('CoreValueEditorSheet validation', () {
    testWidgets('multi-column clears only the edited field\'s message',
        (tester) async {
      _setTestViewport(tester);
      await _open(tester, _buildShowTrigger(validator: _positiveValidator));

      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();
      expect(find.text('Enter a number'), findsNWidgets(2));

      await tester.tap(find.text('5'));
      await tester.pumpAndSettle();

      // Only the edited field clears; the untouched one keeps its message.
      expect(find.text('Enter a number'), findsOneWidget);
    });

    testWidgets('editing a rejected field clears its message', (tester) async {
      _setTestViewport(tester);
      await _open(
        tester,
        _buildSingleValueTrigger(
          initialValue: '0',
          validator: _positiveValidator,
        ),
      );

      await tester.tap(find.text('Update'));
      await tester.pumpAndSettle();
      expect(find.text('Must be positive'), findsWidgets);

      await tester.tap(find.text('5'));
      await tester.pumpAndSettle();

      expect(find.text('Must be positive'), findsNothing);
    });
  });

  group('CoreValueEditorSheet result label', () {
    testWidgets('multi-column mode wears the caller-supplied label',
        (tester) async {
      _setTestViewport(tester);
      await _open(tester, _buildShowTrigger(resultLabel: 'Commit'));

      expect(find.text('Commit'), findsOneWidget);
      expect(find.text('Add'), findsNothing);
      expect(find.text('Update'), findsNothing);
    });

    testWidgets('single-value mode wears the caller-supplied label',
        (tester) async {
      _setTestViewport(tester);
      await _open(tester, _buildSingleValueTrigger(resultLabel: 'Apply'));

      expect(find.text('Apply'), findsOneWidget);
      expect(find.text('Add'), findsNothing);
      expect(find.text('Update'), findsNothing);
    });
  });
}
