import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

const CoreKeyboardSemantics _french = CoreKeyboardSemantics(
  digitLabel: _digit,
  operatorLabel: _operator,
  unitLabel: _unit,
  controlLabel: _control,
  controlHint: _controlHint,
  resultLabel: _result,
  resultHint: 'Calcule le résultat',
  dragHandle: 'Poignée du clavier',
  viewAllLabel: 'Toutes les touches de fonction',
  viewAllHint: 'Ouvre la feuille des groupes',
  unitSystemSwitch: 'Système de mesure',
  groupHeader: _groupHeader,
  reorderHandle: _reorderHandle,
);

String _digit(DigitType digit) => 'Chiffre ${digit.label}';

String _operator(OperatorType operatorType) =>
    'Opérateur ${operatorType.symbol}';

String _unit(UnitType unit) => 'Unité ${unit.label}';

String _control(ControlAction action) => 'Commande ${action.name}';

String _controlHint(ControlAction action) => 'Indice ${action.name}';

String _result(String face) => 'Résultat $face';

String _groupHeader(String groupLabel) => 'En-tête $groupLabel';

String _reorderHandle(String groupLabel) => 'Déplacer $groupLabel';

Widget _app(Widget child) => MaterialApp(
      theme: CoreTheme.light(),
      home: Scaffold(body: child),
    );

void main() {
  setUpAll(() async {
    await loadFonts();
  });

  group('CoreKeyboardSemantics.english', () {
    test('builds the strings the keyboard announced before 0.61.0', () {
      const english = CoreKeyboardSemantics.english;
      expect(english.digitLabel(DigitType.seven), '7 button');
      expect(english.digitLabel(DigitType.decimal), '. button');
      expect(english.operatorLabel(OperatorType.add), '+ operator button');
      expect(english.unitLabel(UnitType.feet), 'Feet unit button');
      expect(english.unitLabel(UnitType.divideSymbol), '/ unit button');
      expect(english.controlLabel(ControlAction.delete), 'Delete button');
      expect(english.controlLabel(ControlAction.clearAll), 'Clear all button');
      expect(english.controlLabel(ControlAction.paren), 'Bracket button');
      expect(
        english.controlHint(ControlAction.delete),
        'Deletes the last entered character',
      );
      expect(english.controlHint(ControlAction.clearAll), 'Clears all input');
      expect(
        english.controlHint(ControlAction.paren),
        'Opens a bracket; the next press closes it',
      );
      expect(english.resultLabel('='), '= button');
      expect(english.resultHint, 'Calculates and displays the result');
      expect(english.dragHandle, 'Keyboard drag handle');
      expect(english.viewAllLabel, 'View all function keys');
      expect(
        english.viewAllHint,
        'Opens a bottom sheet with all available function keys',
      );
      expect(english.unitSystemSwitch, 'Unit system switch');
      expect(
        english.groupHeader('Materials'),
        'Function group header for Materials',
      );
      expect(
        english.reorderHandle('Materials'),
        'Drag indicator for Materials group',
      );
    });
  });

  group('each key announces the caller-supplied label', () {
    testWidgets('digit key', (tester) async {
      await tester.pumpWidget(_app(CoreDigitInput(
        digit: DigitType.seven,
        onDigitPressed: (_) {},
        semantics: _french,
        width: 56,
        height: 56,
      )));

      final semantics =
          tester.getSemantics(find.byKey(DigitType.seven.testKey));
      expect(semantics.label, contains('Chiffre 7'));
    });

    testWidgets('operator key', (tester) async {
      await tester.pumpWidget(_app(CoreOperatorButton(
        operatorType: OperatorType.multiply,
        onOperatorPressed: (_) {},
        semantics: _french,
        width: 56,
        height: 56,
      )));

      final semantics =
          tester.getSemantics(find.byKey(OperatorType.multiply.testKey));
      expect(semantics.label, contains('Opérateur ×'));
    });

    testWidgets('unit key', (tester) async {
      await tester.pumpWidget(_app(CoreUnitButton(
        unit: UnitType.inch,
        onUnitSelected: (_) {},
        semantics: _french,
        width: 56,
        height: 56,
      )));

      final semantics = tester.getSemantics(find.byKey(UnitType.inch.testKey));
      expect(semantics.label, contains('Unité Inch'));
    });

    testWidgets('control key, label and hint', (tester) async {
      await tester.pumpWidget(_app(CoreControlButton(
        action: ControlAction.clearAll,
        onControlAction: (_) {},
        semantics: _french,
        width: 56,
        height: 56,
      )));

      final semantics =
          tester.getSemantics(find.byKey(ControlAction.clearAll.testKey));
      expect(semantics.label, contains('Commande clearAll'));
      expect(semantics.hint, 'Indice clearAll');
    });

    testWidgets('a label passed for one control key wins over the set',
        (tester) async {
      await tester.pumpWidget(_app(CoreControlButton(
        action: ControlAction.paren,
        onControlAction: (_) {},
        semantics: _french,
        semanticLabel: 'Touche parenthèse',
        width: 56,
        height: 56,
      )));

      final semantics =
          tester.getSemantics(find.byKey(ControlAction.paren.testKey));
      expect(semantics.label, contains('Touche parenthèse'));
      expect(semantics.hint, 'Indice paren');
    });

    testWidgets('a hint passed for one control key wins over the set',
        (tester) async {
      await tester.pumpWidget(_app(CoreControlButton(
        action: ControlAction.paren,
        onControlAction: (_) {},
        semantics: _french,
        semanticHint: 'Ouvre une parenthèse',
        width: 56,
        height: 56,
      )));

      final semantics =
          tester.getSemantics(find.byKey(ControlAction.paren.testKey));
      expect(semantics.label, contains('Commande paren'));
      expect(semantics.hint, 'Ouvre une parenthèse');
    });

    testWidgets('result key, label from its face and the hint', (tester) async {
      await tester.pumpWidget(_app(CoreResultButton(
        resultType: const ResultType(label: '='),
        onTap: () {},
        semantics: _french,
        width: 120,
        height: 56,
      )));

      final semantics =
          tester.getSemantics(find.byKey(CoreResultButton.testKey));
      expect(semantics.label, contains('Résultat ='));
      expect(semantics.hint, 'Calcule le résultat');
    });

    testWidgets('a result key with a caller-supplied face gets no hint',
        (tester) async {
      await tester.pumpWidget(_app(CoreResultButton(
        resultType: const ResultType(label: '='),
        customLabel: 'Mettre à jour',
        onTap: () {},
        semantics: _french,
        width: 120,
        height: 56,
      )));

      final semantics =
          tester.getSemantics(find.byKey(CoreResultButton.testKey));
      expect(semantics.label, contains('Résultat Mettre à jour'));
      expect(semantics.hint, isEmpty);
    });
  });

  group('CoreNumberKeypad', () {
    testWidgets('digit and backspace keys announce the caller-supplied label',
        (tester) async {
      tester.view.physicalSize = const Size(412, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());
      addTearDown(() => tester.view.resetDevicePixelRatio());
      await tester.pumpWidget(_app(Align(
        alignment: Alignment.bottomCenter,
        child: CoreNumberKeypad(
          onDigitPressed: (_) {},
          onDecimalPressed: () {},
          onBackspacePressed: () {},
          onClearPressed: () {},
          onConfirmPressed: () {},
          clearLabel: 'Clear',
          confirmLabel: 'Add',
          semantics: _french,
        ),
      )));

      expect(
        tester.getSemantics(find.byKey(DigitType.nine.testKey)).label,
        contains('Chiffre 9'),
      );
      expect(
        tester.getSemantics(find.byKey(DigitType.decimal.testKey)).label,
        contains('Chiffre .'),
      );
      expect(
        tester.getSemantics(find.byKey(ControlAction.delete.testKey)).label,
        contains('Commande delete'),
      );
    });
  });
}
