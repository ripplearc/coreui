import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

const CoreKeyboardLabels _french = CoreKeyboardLabels(
  viewAll: 'Tout afficher',
  functionKeys: 'Touches de fonction',
  groupHeader: _groupHeader,
  measurementSystem: 'Système de mesure',
  imperial: 'Impérial',
  metric: 'Métrique',
);

String _groupHeader(String groupLabel) => 'Groupe $groupLabel';

Widget _app(Widget child) => MaterialApp(
      theme: CoreTheme.light(),
      home: Scaffold(body: child),
    );

const GroupNameType _basic =
    GroupNameType(id: 'Basic Geometry', label: 'Basic Geometry');
const GroupNameType _materials =
    GroupNameType(id: 'Materials', label: 'Materials');

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
  FunctionGroup(
    name: _materials,
    keys: [
      KeyType(
        groupName: 'Materials',
        id: 'Wood',
        label: 'Wood',
        action: () {},
      ),
    ],
  ),
];

Widget _keyboard({
  CoreKeyboardLabels labels = CoreKeyboardLabels.english,
  UnitSystem currentUnitSystem = UnitSystem.imperial,
  ValueChanged<UnitSystem>? onUnitSystemChanged,
}) =>
    CoreKeyboard(
      currentGroup: _basic,
      allGroups: _groups,
      currentUnitSystem: currentUnitSystem,
      onDigitPressed: (_) {},
      onUnitSelected: (_) {},
      onOperatorPressed: (_) {},
      onControlAction: (_) {},
      onResultTapped: () {},
      onGroupSelected: (_) {},
      onKeyTapped: (_) {},
      onUnitSystemChanged: onUnitSystemChanged ?? (_) {},
      onGroupsReordered: (_, __) {},
      labels: labels,
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

  group('CoreKeyboardLabels.english', () {
    test('is the words the keyboard showed before 0.98.0', () {
      const english = CoreKeyboardLabels.english;
      expect(english.viewAll, 'View all');
      expect(english.functionKeys, 'Function keys');
      expect(english.groupHeader('Materials'), 'Materials group');
      expect(english.measurementSystem, 'Measurement System');
      expect(english.imperial, 'Imperial');
      expect(english.metric, 'Metric');
    });
  });

  group('CoreKeyboard shows the words it is given', () {
    testWidgets('the strip: View all and the group header', (tester) async {
      await _pumpKeyboard(tester, _keyboard(labels: _french));

      expect(find.text('Tout afficher'), findsOneWidget);
      expect(find.text('Groupe Basic Geometry'), findsOneWidget);
      expect(find.text('View all'), findsNothing);
      expect(find.text('Basic Geometry group'), findsNothing);
    });

    testWidgets(
        'the View all sheet: title, measurement system, the switch faces and '
        'every group header', (tester) async {
      await _pumpKeyboard(tester, _keyboard(labels: _french));

      await tester.tap(find.text('Tout afficher'));
      await tester.pumpAndSettle();

      expect(find.text('Touches de fonction'), findsOneWidget);
      expect(find.text('Système de mesure'), findsOneWidget);
      expect(find.text('Impérial'), findsOneWidget);
      expect(find.text('Métrique'), findsNothing);
      expect(find.text('Groupe Basic Geometry'), findsNWidgets(2));
      expect(find.text('Groupe Materials'), findsOneWidget);
      expect(find.text('Function keys'), findsNothing);
      expect(find.text('Measurement System'), findsNothing);
      expect(find.text('Imperial'), findsNothing);
    });

    testWidgets('the switch shows the metric face once switched',
        (tester) async {
      UnitSystem? changed;
      await _pumpKeyboard(
        tester,
        _keyboard(labels: _french, onUnitSystemChanged: (s) => changed = s),
      );
      await tester.tap(find.text('Tout afficher'));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(CoreSwitch));
      await tester.pumpAndSettle();

      expect(changed, UnitSystem.metric);
      expect(find.text('Métrique'), findsOneWidget);
      expect(find.text('Impérial'), findsNothing);
    });

    testWidgets('a keyboard built without a set keeps the English',
        (tester) async {
      await _pumpKeyboard(tester, _keyboard());

      expect(find.text('View all'), findsOneWidget);
      expect(find.text('Basic Geometry group'), findsOneWidget);

      await tester.tap(find.text('View all'));
      await tester.pumpAndSettle();

      expect(find.text('Function keys'), findsOneWidget);
      expect(find.text('Measurement System'), findsOneWidget);
      expect(find.text('Imperial'), findsOneWidget);
      expect(find.text('Materials group'), findsOneWidget);
    });
  });

  group('CoreFunctionKeyBottomSheet built on its own', () {
    testWidgets(
        'a long group header and measurement system label end in an ellipsis '
        'inside a narrow sheet', (tester) async {
      tester.view.physicalSize = const Size(320, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());
      addTearDown(() => tester.view.resetDevicePixelRatio());
      final colors = AppColorsExtension.create();
      const header = 'Groupe de touches de fonction Basic Geometry, '
          'à faire glisser pour le déplacer';
      const measurement = 'Système de mesure des longueurs, des surfaces et '
          'des volumes de ce calcul';
      await tester.pumpWidget(_app(CoreFunctionKeyBottomSheet(
        groups: _groups,
        groupAccentColors: {_basic: colors.orientMid},
        selectedGroup: _basic,
        onGroupSelected: (_) {},
        onKeyTapped: (_) {},
        onGroupsReordered: (_, __) {},
        onUnitSystemChanged: (_) {},
        labels: CoreKeyboardLabels(
          viewAll: 'Tout afficher',
          functionKeys: 'Touches de fonction',
          groupHeader: (_) => header,
          measurementSystem: measurement,
          imperial: 'Impérial',
          metric: 'Métrique',
        ),
      )));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      final sheet = tester.getRect(find.byType(CoreFunctionKeyBottomSheet));
      final headers = find.text(header);
      expect(headers, findsNWidgets(2));
      for (final rect in headers.evaluate().map((e) => tester.getRect(
          find.byElementPredicate((element) => identical(element, e))))) {
        expect(rect.right, lessThanOrEqualTo(sheet.right));
      }
      expect(
          tester.widget<Text>(headers.first).overflow, TextOverflow.ellipsis);

      final measurementRect = tester.getRect(find.text(measurement));
      final switchRect = tester.getRect(find.byType(CoreSwitch));
      expect(measurementRect.right, lessThanOrEqualTo(switchRect.left));
      expect(switchRect.right, lessThanOrEqualTo(sheet.right));
      expect(tester.widget<Text>(find.text(measurement)).overflow,
          TextOverflow.ellipsis);
    });

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
        onUnitSystemChanged: (_) {},
        currentUnitSystem: UnitSystem.metric,
        labels: _french,
      )));
      await tester.pumpAndSettle();

      expect(find.text('Touches de fonction'), findsOneWidget);
      expect(find.text('Système de mesure'), findsOneWidget);
      expect(find.text('Métrique'), findsOneWidget);
      expect(find.text('Groupe Basic Geometry'), findsOneWidget);
      expect(find.text('Groupe Materials'), findsOneWidget);
    });
  });

  group('CoreValueEditorSheet', () {
    testWidgets(
        'showSingleValue hands keyboardLabels to the keyboard it '
        'embeds', (tester) async {
      await _pumpSheetOf(
        tester,
        (context) => CoreValueEditorSheet.showSingleValue(
          context: context,
          title: 'Rate',
          label: 'Rate',
          resultLabel: 'Update',
          unitOptions: const ['m', 'cm'],
          unitGroupLabel: 'Unit',
          keyboardLabels: _french,
        ),
      );

      expect(find.text('Tout afficher'), findsOneWidget);
      expect(find.text('Groupe Unit'), findsOneWidget);
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
          unitOptions: const ['m', 'cm'],
          unitGroupLabel: 'Unit',
          keyboardLabels: _french,
        ),
      );

      expect(find.text('Tout afficher'), findsOneWidget);
      expect(find.text('Groupe Unit'), findsOneWidget);
    });
  });
}
