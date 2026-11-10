import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';
import '../../utils/a11y_guidelines.dart';
import '../../utils/test_harness.dart';

const CoreKeyboardSemantics _callerSemantics = CoreKeyboardSemantics(
  digitLabel: _digitLabel,
  operatorLabel: _operatorLabel,
  unitLabel: _unitLabel,
  controlLabel: _controlLabel,
  controlHint: _controlHint,
  resultLabel: _resultLabel,
  resultHint: 'Calcule le résultat',
  dragHandle: 'Poignée du clavier',
  viewAllLabel: 'Toutes les touches',
  viewAllHint: 'Ouvre la feuille des groupes',
  unitSystemSwitch: 'Système de mesure',
  groupHeader: _groupHeader,
  reorderHandle: _reorderHandle,
);

String _digitLabel(DigitType digit) => 'Touche ${digit.label}';

String _operatorLabel(OperatorType operatorType) =>
    'Touche ${operatorType.symbol}';

String _unitLabel(UnitType unit) => 'Touche ${unit.label}';

String _controlLabel(ControlAction action) => 'Touche ${action.name}';

String _controlHint(ControlAction action) => 'Indice ${action.name}';

String _resultLabel(String face) => 'Touche $face';

String _groupHeader(String groupLabel) => 'En-tête $groupLabel';

String _reorderHandle(String groupLabel) => 'Déplacer $groupLabel';

const CoreKeyboardLabels _callerLabels = CoreKeyboardLabels(
  viewAll: 'Tout afficher',
  functionKeys: 'Touches de fonction',
  groupHeader: _groupHeaderText,
  measurementSystem: 'Système de mesure des unités',
  imperial: 'Impérial',
  metric: 'Métrique',
);

String _groupHeaderText(String groupLabel) => 'Groupe $groupLabel';

void _expectTapTarget(WidgetTester tester, Finder finder) {
  final size = tester.getSemantics(finder).rect.size;
  expect(size.width, greaterThanOrEqualTo(kMinInteractiveDimension));
  expect(size.height, greaterThanOrEqualTo(kMinInteractiveDimension));
}

void main() {
  setUpAll(() async {
    await loadFonts();
  });

  group('CoreKeyboard – accessibility', () {
    final testGroups = [
      FunctionGroup(
        name:
            const GroupNameType(id: "Basic Geometry", label: "Basic Geometry"),
        keys: [
          KeyType(
              groupName: 'Basic Geometry',
              id: 'Area',
              label: 'Area',
              action: () {}),
          KeyType(
            groupName: 'Basic Geometry',
            id: 'Perimeter',
            label: 'Perimeter',
            action: () {},
          ),
        ],
      ),
    ];

    Widget buildTestKeyboard({
      bool parenEnabled = true,
      String? parenSemanticLabel,
      CoreKeyboardSemantics semantics = CoreKeyboardSemantics.english,
      CoreKeyboardLabels labels = CoreKeyboardLabels.english,
    }) {
      return CoreKeyboard(
        labels: labels,
        currentGroup:
            const GroupNameType(id: "Basic Geometry", label: "Basic Geometry"),
        allGroups: testGroups,
        onDigitPressed: (_) {},
        onUnitSelected: (_) {},
        onOperatorPressed: (_) {},
        onControlAction: (_) {},
        onResultTapped: () {},
        onGroupSelected: (_) {},
        onKeyTapped: (_) {},
        onUnitSystemChanged: (_) {},
        parenEnabled: parenEnabled,
        parenSemanticLabel: parenSemanticLabel,
        semantics: semantics,
      );
    }

    final keyTypesToTest = [
      (kind: 'digit', key: DigitType.five.testKey, label: 'Touche 5'),
      (kind: 'operator', key: OperatorType.add.testKey, label: 'Touche +'),
      (kind: 'unit', key: UnitType.feet.testKey, label: 'Touche Feet'),
      (
        kind: 'control',
        key: ControlAction.delete.testKey,
        label: 'Touche delete',
      ),
      (kind: 'result', key: CoreResultButton.testKey, label: 'Touche ='),
    ];

    for (final keyType in keyTypesToTest) {
      testWidgets(
        '${keyType.kind} keys meet tap target and label guidelines',
        (tester) async {
          await setupA11yTest(
            tester,
            screenSize: const Size(1100, 1600),
          );

          await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
            tester,
            (_) => buildTestKeyboard(),
            find.byKey(keyType.key),
          );
          _expectTapTarget(tester, find.byKey(keyType.key));
        },
      );
    }

    for (final keyType in keyTypesToTest) {
      testWidgets(
        '${keyType.kind} keys labelled by the caller meet the guidelines',
        (tester) async {
          await setupA11yTest(
            tester,
            screenSize: const Size(1100, 1600),
          );

          await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
            tester,
            (_) => buildTestKeyboard(semantics: _callerSemantics),
            find.byKey(keyType.key),
          );
          _expectTapTarget(tester, find.byKey(keyType.key));

          final semantics = tester.getSemantics(find.byKey(keyType.key));
          expect(semantics.label, keyType.label);
        },
      );
    }

    testWidgets(
      'View all labelled by the caller meets the guidelines and is at least '
      '48 dp',
      (tester) async {
        await setupA11yTest(
          tester,
          screenSize: const Size(1100, 1600),
        );

        await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
          tester,
          (_) => buildTestKeyboard(semantics: _callerSemantics),
          find.bySemanticsLabel('Toutes les touches'),
        );
        _expectTapTarget(tester, find.bySemanticsLabel('Toutes les touches'));
      },
    );

    testWidgets(
      'the drag handle announces the caller\'s label in both themes',
      (tester) async {
        await setupA11yTest(
          tester,
          screenSize: const Size(1100, 1600),
        );

        for (final theme in kA11yTestThemes) {
          await tester.pumpWidget(buildTestApp(
            buildTestKeyboard(semantics: _callerSemantics),
            theme: theme,
          ));
          await tester.pumpAndSettle();

          expect(find.bySemanticsLabel('Poignée du clavier'), findsOneWidget);
          expect(find.bySemanticsLabel('Keyboard drag handle'), findsNothing);
        }
      },
    );

    testWidgets(
      'the bracket key meets tap target and label guidelines',
      (tester) async {
        await setupA11yTest(
          tester,
          screenSize: const Size(1100, 1600),
        );

        await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
          tester,
          (_) => buildTestKeyboard(),
          find.byKey(ControlAction.paren.testKey),
        );
      },
    );

    testWidgets(
      'a bracket key labelled by the caller meets the guidelines',
      (tester) async {
        await setupA11yTest(
          tester,
          screenSize: const Size(1100, 1600),
        );

        await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
          tester,
          (_) => buildTestKeyboard(parenSemanticLabel: 'Touche parenthèse'),
          find.byKey(ControlAction.paren.testKey),
        );
        _expectTapTarget(tester, find.byKey(ControlAction.paren.testKey));

        final semantics =
            tester.getSemantics(find.byKey(ControlAction.paren.testKey));
        expect(semantics.label, 'Touche parenthèse');
      },
    );

    testWidgets(
      'a disabled bracket key keeps the keyboard within guidelines',
      (tester) async {
        await setupA11yTest(
          tester,
          screenSize: const Size(1100, 1600),
        );

        await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
          tester,
          (_) => buildTestKeyboard(parenEnabled: false),
          find.byKey(ControlAction.paren.testKey),
        );

        final semantics =
            tester.getSemantics(find.byKey(ControlAction.paren.testKey));
        expect(semantics.flagsCollection.isEnabled, ui.Tristate.isFalse);
      },
    );

    testWidgets(
      'drag handle meets tap target and label guidelines',
      (tester) async {
        await setupA11yTest(
          tester,
          screenSize: const Size(1100, 1600),
        );

        await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
          tester,
          (_) => buildTestKeyboard(),
          find.bySemanticsLabel('Keyboard drag handle'),
        );
      },
    );

    testWidgets(
      'collapsed drag handle meets tap target and label guidelines',
      (tester) async {
        await setupA11yTest(
          tester,
          screenSize: const Size(1100, 1600),
        );

        for (final theme in kA11yTestThemes) {
          await tester.pumpWidget(
            buildTestApp(
              buildTestKeyboard(),
              theme: theme,
            ),
          );
          await tester.pumpAndSettle();

          await tester.tap(find.bySemanticsLabel('Keyboard drag handle'));
          await tester.pumpAndSettle();

          await expectMeetsTapTargetAndLabelGuidelines(
            tester,
            find.bySemanticsLabel('Keyboard drag handle'),
          );
        }
      },
    );

    testWidgets(
      'View all sheet drag handles are announced with the reorder label',
      (tester) async {
        await setupA11yTest(tester, screenSize: const Size(600, 1000));

        for (final theme in kA11yTestThemes) {
          await tester.pumpWidget(
            buildTestApp(
              CoreKeyboard(
                currentGroup: const GroupNameType(
                    id: "Basic Geometry", label: "Basic Geometry"),
                allGroups: testGroups,
                onDigitPressed: (_) {},
                onUnitSelected: (_) {},
                onOperatorPressed: (_) {},
                onControlAction: (_) {},
                onResultTapped: () {},
                onGroupSelected: (_) {},
                onKeyTapped: (_) {},
                onUnitSystemChanged: (_) {},
                onGroupsReordered: (_, __) {},
                reorderSemanticsLabelBuilder: (label) => 'Reorder $label group',
              ),
              theme: theme,
            ),
          );
          await tester.pumpAndSettle();

          await tester.tap(find.text('View all'));
          await tester.pumpAndSettle();

          expect(
            find.bySemanticsLabel(RegExp('Reorder Basic Geometry group')),
            findsOneWidget,
          );
          await expectMeetsTapTargetAndLabelGuidelines(
            tester,
            find.byType(CoreFunctionKeyBottomSheet),
            checkTapTargetSize: false,
            checkLabeledTapTarget: true,
            checkTextContrast: false,
          );

          await tester.tap(find.descendant(
            of: find.byType(CoreFunctionKeyBottomSheet),
            matching: find.text('Basic Geometry group'),
          ));
          await tester.pumpAndSettle();
        }
      },
    );

    testWidgets(
      'with a label set, View all and the sheet meet the label guideline in '
      'both themes and no node on the sheet reads an English literal',
      (tester) async {
        await setupA11yTest(tester, screenSize: const Size(1100, 1600));

        await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
          tester,
          (_) => buildTestKeyboard(
            semantics: _callerSemantics,
            labels: _callerLabels,
          ),
          find.bySemanticsLabel('Toutes les touches'),
        );
        _expectTapTarget(tester, find.bySemanticsLabel('Toutes les touches'));

        await setupA11yTest(tester, screenSize: const Size(600, 1000));
        for (final theme in kA11yTestThemes) {
          await tester.pumpWidget(buildTestApp(
            buildTestKeyboard(
              semantics: _callerSemantics,
              labels: _callerLabels,
            ),
            theme: theme,
          ));
          await tester.pumpAndSettle();

          await tester.tap(find.text('Tout afficher'));
          await tester.pumpAndSettle();

          await expectMeetsTapTargetAndLabelGuidelines(
            tester,
            find.byType(CoreFunctionKeyBottomSheet),
            checkTapTargetSize: false,
            checkLabeledTapTarget: true,
            checkTextContrast: false,
          );
          expect(find.bySemanticsLabel('Touches de fonction'), findsOneWidget);
          expect(find.bySemanticsLabel('Système de mesure des unités'),
              findsOneWidget);
          expect(find.bySemanticsLabel(RegExp('Groupe Basic Geometry')),
              findsWidgets);
          for (final english in [
            'Function keys',
            'Measurement System',
            'Imperial',
            'Metric',
            'View all',
            'Basic Geometry group',
          ]) {
            expect(find.bySemanticsLabel(RegExp(RegExp.escape(english))),
                findsNothing,
                reason: '"$english" is an English literal from coreui');
          }

          await tester.tap(find.descendant(
            of: find.byType(CoreFunctionKeyBottomSheet),
            matching: find.text('Groupe Basic Geometry'),
          ));
          await tester.pumpAndSettle();
        }
      },
    );
  });
}
