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

const GroupNameType _basic =
    GroupNameType(id: 'Basic Geometry', label: 'Basic Geometry');

final List<FunctionGroup> _groups = [
  FunctionGroup(
    name: _basic,
    keys: [
      KeyType(
        groupName: 'Basic Geometry',
        id: 'Area',
        label: 'Area',
        action: () {},
      ),
    ],
  ),
];

Widget _keyboard({
  CoreKeyboardSemantics semantics = CoreKeyboardSemantics.english,
  String? parenSemanticLabel,
  String? parenSemanticHint,
  String Function(String groupLabel)? reorderSemanticsLabelBuilder,
}) =>
    CoreKeyboard(
      currentGroup: _basic,
      allGroups: _groups,
      onDigitPressed: (_) {},
      onUnitSelected: (_) {},
      onOperatorPressed: (_) {},
      onControlAction: (_) {},
      onResultTapped: () {},
      onGroupSelected: (_) {},
      onKeyTapped: (_) {},
      onUnitSystemChanged: (_) {},
      onGroupsReordered: (_, __) {},
      semantics: semantics,
      parenSemanticLabel: parenSemanticLabel,
      parenSemanticHint: parenSemanticHint,
      reorderSemanticsLabelBuilder: reorderSemanticsLabelBuilder,
    );

Future<void> _pumpKeyboard(WidgetTester tester, Widget keyboard) async {
  tester.view.physicalSize = const Size(1100, 1600);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() => tester.view.resetPhysicalSize());
  addTearDown(() => tester.view.resetDevicePixelRatio());
  await tester.pumpWidget(_app(keyboard));
  await tester.pumpAndSettle();
}

Future<void> _pumpSheetOf(
  WidgetTester tester,
  Future<void> Function(BuildContext context) show,
) async {
  tester.view.physicalSize = const Size(600, 1400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() => tester.view.resetPhysicalSize());
  addTearDown(() => tester.view.resetDevicePixelRatio());
  await tester.pumpWidget(_app(Builder(
    builder: (context) => ElevatedButton(
      onPressed: () => show(context),
      child: const Text('Show'),
    ),
  )));
  await tester.tap(find.text('Show'));
  await tester.pumpAndSettle();
}

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

  group('CoreKeyboard passes the set to everything it renders', () {
    testWidgets('keys, drag handle and View all', (tester) async {
      await _pumpKeyboard(tester, _keyboard(semantics: _french));

      expect(
        tester.getSemantics(find.byKey(DigitType.five.testKey)).label,
        contains('Chiffre 5'),
      );
      expect(
        tester.getSemantics(find.byKey(OperatorType.add.testKey)).label,
        contains('Opérateur +'),
      );
      expect(
        tester.getSemantics(find.byKey(UnitType.feet.testKey)).label,
        contains('Unité Feet'),
      );
      expect(
        tester.getSemantics(find.byKey(ControlAction.delete.testKey)).label,
        contains('Commande delete'),
      );
      expect(
        tester.getSemantics(find.byKey(ControlAction.paren.testKey)).hint,
        'Indice paren',
      );
      expect(
        tester.getSemantics(find.byKey(CoreResultButton.testKey)).label,
        contains('Résultat ='),
      );
      expect(find.bySemanticsLabel('Poignée du clavier'), findsOneWidget);
      expect(find.bySemanticsLabel('Keyboard drag handle'), findsNothing);
    });

    testWidgets(
        'the View all button is one node that carries the label and '
        'the hint a screen reader lands on', (tester) async {
      await _pumpKeyboard(tester, _keyboard(semantics: _french));

      final viewAll = tester.getSemantics(find.text('View all'));
      expect(viewAll.label, 'Toutes les touches de fonction');
      expect(viewAll.hint, 'Ouvre la feuille des groupes');
      expect(viewAll.flagsCollection.isButton, isTrue);
      expect(find.bySemanticsLabel('View all'), findsNothing);

      await tester.tap(find.text('View all'));
      await tester.pumpAndSettle();
      expect(find.byType(CoreFunctionKeyBottomSheet), findsOneWidget);
    });

    testWidgets('the View all sheet: switch, group header and drag handle',
        (tester) async {
      await _pumpKeyboard(tester, _keyboard(semantics: _french));

      await tester.tap(find.text('View all'));
      await tester.pumpAndSettle();

      expect(
          find.bySemanticsLabel(RegExp('Système de mesure')), findsOneWidget);
      expect(find.bySemanticsLabel(RegExp('En-tête Basic Geometry')),
          findsOneWidget);
      expect(
        find.bySemanticsLabel(RegExp('Déplacer Basic Geometry')),
        findsOneWidget,
      );
      expect(find.bySemanticsLabel(RegExp('Unit system switch')), findsNothing);
    });

    testWidgets(
        'the paren label, the paren hint and the reorder builder win '
        'over the set', (tester) async {
      await _pumpKeyboard(
        tester,
        _keyboard(
          semantics: _french,
          parenSemanticLabel: 'Touche parenthèse',
          parenSemanticHint: 'Ouvre une parenthèse',
          reorderSemanticsLabelBuilder: (label) => 'Réordonner $label',
        ),
      );

      final paren =
          tester.getSemantics(find.byKey(ControlAction.paren.testKey));
      expect(paren.label, contains('Touche parenthèse'));
      expect(paren.hint, 'Ouvre une parenthèse');

      await tester.tap(find.text('View all'));
      await tester.pumpAndSettle();

      expect(
        find.bySemanticsLabel(RegExp('Réordonner Basic Geometry')),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel(RegExp('Déplacer Basic Geometry')),
        findsNothing,
      );
    });

    testWidgets('a keyboard built without a set keeps the English',
        (tester) async {
      await _pumpKeyboard(tester, _keyboard());

      expect(
        tester.getSemantics(find.byKey(DigitType.five.testKey)).label,
        contains('5 button'),
      );
      expect(find.bySemanticsLabel('Keyboard drag handle'), findsOneWidget);
      final viewAll = tester.getSemantics(find.text('View all'));
      expect(viewAll.label, 'View all function keys');
      expect(
        viewAll.hint,
        'Opens a bottom sheet with all available function keys',
      );
    });
  });

  group('CoreFunctionKeyBottomSheet built on its own', () {
    testWidgets('follows the set it is given', (tester) async {
      tester.view.physicalSize = const Size(600, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());
      addTearDown(() => tester.view.resetDevicePixelRatio());
      final colors = AppColorsExtension.create();
      await tester.pumpWidget(_app(CoreFunctionKeyBottomSheet(
        groups: _groups,
        groupAccentColors: {_basic: colors.orientMid},
        selectedGroup: _basic,
        onGroupSelected: (_) {},
        onKeyTapped: (_) {},
        onGroupsReordered: (_, __) {},
        onUnitSystemChanged: (_) {},
        semantics: _french,
      )));
      await tester.pumpAndSettle();

      expect(
          find.bySemanticsLabel(RegExp('Système de mesure')), findsOneWidget);
      expect(find.bySemanticsLabel(RegExp('En-tête Basic Geometry')),
          findsOneWidget);
      expect(
        find.bySemanticsLabel(RegExp('Déplacer Basic Geometry')),
        findsOneWidget,
      );
    });
  });

  group('CoreValueEditorSheet', () {
    testWidgets(
        'showSingleValue hands keyboardSemantics to the keyboard it '
        'embeds', (tester) async {
      await _pumpSheetOf(
        tester,
        (context) => CoreValueEditorSheet.showSingleValue(
          context: context,
          title: 'Rate',
          label: 'Rate',
          resultLabel: 'Update',
          keyboardSemantics: _french,
        ),
      );

      expect(
        tester.getSemantics(find.byKey(ControlAction.clearAll.testKey)).label,
        contains('Commande clearAll'),
      );
      expect(
        tester.getSemantics(find.byKey(CoreResultButton.testKey)).label,
        contains('Résultat Update'),
      );
    });

    testWidgets('show, the multi-column editor, hands it on too',
        (tester) async {
      await _pumpSheetOf(
        tester,
        (context) => CoreValueEditorSheet.show(
          context: context,
          titles: const ['Width', 'Height'],
          addSizeTitle: 'Add size',
          editSizeTitle: 'Edit size',
          resultLabel: 'Add',
          keyboardSemantics: _french,
        ),
      );

      expect(
        tester.getSemantics(find.byKey(ControlAction.clearAll.testKey)).label,
        contains('Commande clearAll'),
      );
      expect(
        tester.getSemantics(find.byKey(DigitType.seven.testKey)).label,
        contains('Chiffre 7'),
      );
    });
  });
}
