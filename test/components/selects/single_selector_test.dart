import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';
import '../../utils/test_harness.dart';

void main() {
  group('SingleItemSelector', () {
    testWidgets('renders label and hint', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleItemSelector<String>(
              labelText: 'Role',
              hintText: 'Select your role',
              modalTitle: 'Select Role',
              items: ['Engineer', 'Designer'],
              selectedItem: null,
              onItemSelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Role'), findsOneWidget);
      // Find the InputDecorator
      final decoratorFinder = find.byType(InputDecorator);
      expect(decoratorFinder, findsOneWidget);

      // Grab the widget and inspect its decoration
      final decorator = tester.widget<InputDecorator>(decoratorFinder);
      final decoration = decorator.decoration;

      expect(decoration.hintText, equals('Select your role'));
    });

    testWidgets('opens modal and selects item', (tester) async {
      String? selected;
      final items = ['Engineer', 'Designer'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleItemSelector<String>(
              labelText: 'Role',
              hintText: 'Select your role',
              modalTitle: 'Select Role',
              items: items,
              selectedItem: null,
              onItemSelected: (val) => selected = val,
            ),
          ),
        ),
      );

      // Tap to open modal
      await tester.tap(find.byType(SingleItemSelector<String>));
      await tester.pumpAndSettle();

      // Verify modal and list is shown
      expect(find.text('Select Role'), findsOneWidget);
      expect(find.byKey(const Key('professional_role_list')), findsOneWidget);
      expect(find.text('Engineer'), findsOneWidget);
      expect(find.text('Designer'), findsOneWidget);

      // Tap item
      await tester.tap(find.text('Engineer'));
      await tester.pumpAndSettle();

      // Check if selected was updated
      expect(selected, 'Engineer');
    });

    testWidgets('opens selected item bottom sheet without framework errors',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleItemSelector<String>(
              labelText: 'Role',
              hintText: 'Select your role',
              modalTitle: 'Select Role',
              items: const ['Engineer', 'Designer'],
              selectedItem: 'Designer',
              onItemSelected: (_) {},
            ),
          ),
        ),
      );

      await tester.tap(find.byType(SingleItemSelector<String>));
      await tester.pumpAndSettle();

      expect(find.text('Select Role'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('displays selected item when default is passed', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleItemSelector<String>(
              labelText: 'Role',
              hintText: 'Select your role',
              modalTitle: 'Select Role',
              items: ['Engineer', 'Designer'],
              selectedItem: 'Engineer',
              onItemSelected: (_) {},
            ),
          ),
        ),
      );
      expect(find.text('Engineer'), findsOneWidget);
    });

    testWidgets('onOpen callback is triggered', (tester) async {
      bool opened = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleItemSelector<String>(
              labelText: 'Role',
              hintText: 'Select your role',
              modalTitle: 'Select Role',
              items: ['Engineer', 'Designer'],
              selectedItem: null,
              onItemSelected: (_) {},
              onOpen: () => opened = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(SingleItemSelector<String>));
      await tester.pumpAndSettle();

      expect(opened, isTrue);
    });

    testWidgets('does not open when disabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleItemSelector<String>(
              labelText: 'Role',
              hintText: 'Select your role',
              modalTitle: 'Select Role',
              items: ['Engineer', 'Designer'],
              selectedItem: null,
              isDisabled: true,
              onItemSelected: (_) {},
            ),
          ),
        ),
      );

      await tester.tap(find.byType(SingleItemSelector<String>));
      await tester.pumpAndSettle();

      // Modal should not open
      expect(find.text('Select Role'), findsNothing);
    });

    testWidgets('draws the field focus look when Tab reaches it', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          SingleItemSelector<String>(
            labelText: 'Role',
            modalTitle: 'Select Role',
            items: const ['Engineer', 'Designer'],
            selectedItem: 'Designer',
            onItemSelected: (_) {},
          ),
          theme: CoreTheme.light(),
        ),
      );
      InputDecoration decoration() =>
          tester.widget<TextField>(find.byType(TextField)).decoration
              as InputDecoration;
      final colors = AppColorsExtension.of(
        tester.element(find.byType(TextField)),
      );
      final restingBorder = decoration().enabledBorder as OutlineInputBorder;
      expect(restingBorder.borderSide.color, colors.lineDarkOutline);

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();

      final focusedBorder = decoration().enabledBorder as OutlineInputBorder;
      expect(focusedBorder.borderSide.color, colors.textDark);
      final labelStyle = decoration().labelStyle as TextStyle;
      expect(labelStyle.color, colors.outlineFocus);
    });

    testWidgets('opens the sheet with Enter after Tab', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          SingleItemSelector<String>(
            labelText: 'Role',
            modalTitle: 'Select Role',
            items: const ['Engineer', 'Designer'],
            onItemSelected: (_) {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(find.text('Select Role'), findsOneWidget);
    });

    Widget roleSelector({bool isDisabled = false}) => buildTestApp(
          SingleItemSelector<String>(
            labelText: 'Role',
            hintText: 'Select your role',
            modalTitle: 'Select Role',
            items: const ['Engineer', 'Designer'],
            isDisabled: isDisabled,
            onItemSelected: (_) {},
          ),
          theme: CoreTheme.light(),
        );

    testWidgets('draws the tap ripple on top of the field', (tester) async {
      await tester.pumpWidget(roleSelector());
      final selector = find.byType(SingleItemSelector<String>);
      final inkLayer = find
          .descendant(of: selector, matching: find.byType(Material))
          .last;

      final gesture = await tester.startGesture(tester.getCenter(selector));
      await tester.pump(kPressTimeout);

      expect(inkLayer, paints..clipPath()..rect());
      await gesture.cancel();
    });

    testWidgets('shows the hint in an empty field', (tester) async {
      await tester.pumpWidget(roleSelector());

      final hintOpacity = tester.widget<AnimatedOpacity>(
        find
            .ancestor(
              of: find.text('Select your role'),
              matching: find.byType(AnimatedOpacity),
            )
            .first,
      );
      expect(hintOpacity.opacity, 1);
    });

    testWidgets('a disabled selector dims its chevron and reads as disabled',
        (tester) async {
      await tester.pumpWidget(roleSelector(isDisabled: true));

      final chevron = tester.widget<CoreIconWidget>(
        find.byWidgetPredicate(
          (w) => w is CoreIconWidget && w.icon == CoreIcons.arrowDown,
        ),
      );
      expect(chevron.color, CoreTheme.light().coreColors.iconGrayLight);
      expect(
        tester.getSemantics(find.byType(SingleItemSelector<String>)),
        isSemantics(hasEnabledState: true, isEnabled: false),
      );
    });

    testWidgets('meets a11y guidelines for closed field and option list', (tester) async {
      await setupA11yTest(tester);

      final selector = SingleItemSelector<String>(
        labelText: 'Role',
        hintText: 'Select your role',
        modalTitle: 'Select Role',
        items: <String>['Engineer', 'Designer'],
        selectedItem: null,
        onItemSelected: (_) {},
      );

      for (final theme in kA11yTestThemes) {
        await tester.pumpWidget(buildTestApp(selector, theme: theme));
        await tester.pumpAndSettle();
        await expectMeetsTapTargetAndLabelGuidelines(
          tester,
          find.byType(SingleItemSelector<String>),
        );
        await tester.tap(find.byType(SingleItemSelector<String>));
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('professional_role_list')), findsOneWidget);
        await expectMeetsTapTargetAndLabelGuidelines(
          tester,
          find.byKey(const Key('professional_role_list')),
        );
        await tester.tapAt(const Offset(10, 10));
        await tester.pumpAndSettle();
      }
    });
  });
}
