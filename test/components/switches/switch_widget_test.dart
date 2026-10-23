import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';
import '../../utils/test_harness.dart';

void main() {
  group('CoreSwitch Widget Tests', () {
    testWidgets('renders normal switch correctly', (WidgetTester tester) async {
      bool switchValue = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoreSwitch(
              type: CoreSwitchType.normal,
              value: switchValue,
              onChanged: (value) {
                switchValue = value;
              },
            ),
          ),
        ),
      );

      final switchFinder = find.byType(CoreSwitch);
      expect(switchFinder, findsOneWidget);

      final gestureDetectorFinder = find.byType(GestureDetector);
      expect(gestureDetectorFinder, findsOneWidget);
    });

    testWidgets('renders lock switch with labels correctly',
        (WidgetTester tester) async {
      bool switchValue = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoreSwitch(
              type: CoreSwitchType.lock,
              value: switchValue,
              onChanged: (value) {
                switchValue = value;
              },
              activeLabel: 'Lock',
              inactiveLabel: 'Unlock',
            ),
          ),
        ),
      );

      final switchFinder = find.byType(CoreSwitch);
      expect(switchFinder, findsOneWidget);

      final unlockTextFinder = find.text('Unlock');
      expect(unlockTextFinder, findsOneWidget);

      // Lock text should not be visible when switch is off
      final lockTextFinder = find.text('Lock');
      expect(lockTextFinder, findsNothing);
    });

    testWidgets('renders imperial switch with labels correctly',
        (WidgetTester tester) async {
      bool switchValue = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoreSwitch(
              type: CoreSwitchType.imperial,
              value: switchValue,
              onChanged: (value) {
                switchValue = value;
              },
              activeLabel: 'Imperial',
              inactiveLabel: 'Metric',
            ),
          ),
        ),
      );

      final switchFinder = find.byType(CoreSwitch);
      expect(switchFinder, findsOneWidget);

      final metricTextFinder = find.text('Metric');
      expect(metricTextFinder, findsOneWidget);

      // Imperial text should not be visible when switch is off
      final imperialTextFinder = find.text('Imperial');
      expect(imperialTextFinder, findsNothing);
    });

    testWidgets('switch toggles value when tapped',
        (WidgetTester tester) async {
      bool switchValue = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return CoreSwitch(
                  type: CoreSwitchType.normal,
                  value: switchValue,
                  onChanged: (value) {
                    setState(() {
                      switchValue = value;
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      expect(switchValue, isFalse);

      await tester.tap(find.byType(CoreSwitch));
      await tester.pumpAndSettle();

      expect(switchValue, isTrue);

      await tester.tap(find.byType(CoreSwitch));
      await tester.pumpAndSettle();

      expect(switchValue, isFalse);
    });

    testWidgets('switch with labels shows correct label based on state',
        (WidgetTester tester) async {
      bool switchValue = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return CoreSwitch(
                  type: CoreSwitchType.normal,
                  value: switchValue,
                  onChanged: (value) {
                    setState(() {
                      switchValue = value;
                    });
                  },
                  activeLabel: 'Public',
                  inactiveLabel: 'Private',
                );
              },
            ),
          ),
        ),
      );

      // Initially should show inactive label
      expect(find.text('Private'), findsOneWidget);
      expect(find.text('Public'), findsNothing);

      await tester.tap(find.byType(CoreSwitch));
      await tester.pumpAndSettle();

      // Should now show active label
      expect(find.text('Public'), findsOneWidget);
      expect(find.text('Private'), findsNothing);
    });

    Color offKnobColor(WidgetTester tester) {
      final knob = tester.widget<Container>(
        find.byWidgetPredicate(
          (w) =>
              w is Container &&
              w.decoration is BoxDecoration &&
              (w.decoration! as BoxDecoration).shape == BoxShape.circle,
        ),
      );
      return (knob.decoration! as BoxDecoration).color!;
    }

    Color offBorderColor(WidgetTester tester) {
      final track = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      final border = (track.decoration! as BoxDecoration).border! as Border;
      return border.top.color;
    }

    // Each type's expected (knob, border) colours when off.
    final offColors = <CoreSwitchType,
        (
          Color Function(AppColorsExtension),
          Color Function(AppColorsExtension),
        )>{
      CoreSwitchType.normal: ((c) => c.lineDarkOutline, (c) => c.iconGrayMid),
      CoreSwitchType.lock: ((c) => c.statusError, (c) => c.iconRed),
      CoreSwitchType.imperial: ((c) => c.iconGreen, (c) => c.iconGreen),
    };

    offColors.forEach((type, expected) {
      testWidgets('${type.name} off knob and border use their own colours',
          (WidgetTester tester) async {
        final colors = CoreTheme.light().coreColors;
        final (knob, border) = expected;

        await tester.pumpWidget(
          MaterialApp(
            theme: CoreTheme.light(),
            home: Scaffold(
              body: CoreSwitch(type: type, value: false, onChanged: (_) {}),
            ),
          ),
        );

        expect(offKnobColor(tester), knob(colors));
        expect(offBorderColor(tester), border(colors));
      });
    });

    Future<void> pumpSwitch(
      WidgetTester tester, {
      required CoreSwitchType type,
      required bool value,
      ValueChanged<bool>? onChanged,
      String? activeLabel,
      String? inactiveLabel,
      String? semanticLabel,
    }) {
      return tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreSwitch(
              type: type,
              value: value,
              onChanged: onChanged,
              activeLabel: activeLabel,
              inactiveLabel: inactiveLabel,
              semanticLabel: semanticLabel,
            ),
          ),
        ),
      );
    }

    testWidgets('show hide label names the current state',
        (WidgetTester tester) async {
      var value = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) => CoreSwitch(
                type: CoreSwitchType.showHide,
                value: value,
                onChanged: (v) => setState(() => value = v),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Hide'), findsOneWidget);
      expect(find.text('Show'), findsNothing);

      await tester.tap(find.byType(CoreSwitch));
      await tester.pumpAndSettle();

      expect(find.text('Show'), findsOneWidget);
      expect(find.text('Hide'), findsNothing);
    });

    testWidgets('show hide is 72 x 32', (WidgetTester tester) async {
      await pumpSwitch(
        tester,
        type: CoreSwitchType.showHide,
        value: false,
        onChanged: (_) {},
      );

      expect(tester.getSize(find.byType(AnimatedContainer)),
          const Size(72, 32));
    });

    testWidgets('show hide uses the Figma colours when enabled',
        (WidgetTester tester) async {
      final colors = CoreTheme.light().coreColors;

      await pumpSwitch(
        tester,
        type: CoreSwitchType.showHide,
        value: false,
        onChanged: (_) {},
      );
      expect(offKnobColor(tester), colors.iconGrayLight);
      expect(offBorderColor(tester), colors.lineMid);
      expect(tester.widget<Text>(find.text('Hide')).style!.color,
          colors.textDark);

      await pumpSwitch(
        tester,
        type: CoreSwitchType.showHide,
        value: true,
        onChanged: (_) {},
      );
      await tester.pumpAndSettle();
      final track = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      final decoration = track.decoration! as BoxDecoration;
      expect(decoration.color, colors.buttonSurface);
      expect(decoration.border, isNull);
      expect(offKnobColor(tester), colors.iconWhite);
      expect(tester.widget<Text>(find.text('Show')).style!.color,
          colors.textInverse);
    });

    for (final type in CoreSwitchType.values) {
      for (final value in [false, true]) {
        testWidgets('disabled ${type.name} ${value ? 'on' : 'off'} uses the '
            'disabled colours', (WidgetTester tester) async {
          final colors = CoreTheme.light().coreColors;
          final labelled = type != CoreSwitchType.normal;

          await pumpSwitch(
            tester,
            type: type,
            value: value,
            activeLabel: labelled ? 'On' : null,
            inactiveLabel: labelled ? 'Off' : null,
          );
          await tester.pumpAndSettle();

          final track = tester.widget<AnimatedContainer>(
            find.byType(AnimatedContainer),
          );
          final decoration = track.decoration! as BoxDecoration;
          expect(decoration.color, colors.pageBackground);
          expect(offBorderColor(tester), colors.lineMid);
          expect(offKnobColor(tester), colors.iconGrayLight);
          if (labelled) {
            expect(
              tester.widget<Text>(find.text(value ? 'On' : 'Off')).style!.color,
              colors.textDisable,
            );
          }
        });
      }
    }

    testWidgets('disabled thumb keeps the side of its value',
        (WidgetTester tester) async {
      Future<double> thumbLeft(bool value) async {
        await pumpSwitch(
          tester,
          type: CoreSwitchType.showHide,
          value: value,
        );
        await tester.pumpAndSettle();
        return tester
            .getTopLeft(find.byWidgetPredicate((w) =>
                w is Container &&
                w.decoration is BoxDecoration &&
                (w.decoration! as BoxDecoration).shape == BoxShape.circle))
            .dx;
      }

      final off = await thumbLeft(false);
      final on = await thumbLeft(true);
      expect(on, greaterThan(off));
    });

    testWidgets('disabled switch ignores taps', (WidgetTester tester) async {
      await pumpSwitch(
        tester,
        type: CoreSwitchType.showHide,
        value: false,
      );

      await tester.tap(find.byType(CoreSwitch));
      await tester.pumpAndSettle();

      expect(find.text('Hide'), findsOneWidget);
      expect(find.text('Show'), findsNothing);
    });

    testWidgets('enabled switch calls onChanged with the toggled value',
        (WidgetTester tester) async {
      bool? received;
      await pumpSwitch(
        tester,
        type: CoreSwitchType.showHide,
        value: false,
        onChanged: (v) => received = v,
      );

      await tester.tap(find.byType(CoreSwitch));

      expect(received, isTrue);
    });

    testWidgets('screen reader reads a disabled switch as disabled',
        (WidgetTester tester) async {
      final handle = tester.ensureSemantics();
      await pumpSwitch(
        tester,
        type: CoreSwitchType.showHide,
        value: false,
        semanticLabel: 'Markup to client',
      );

      expect(
        tester.getSemantics(find.byType(CoreSwitch)),
        isSemantics(
          label: 'Markup to client',
          hasEnabledState: true,
          isEnabled: false,
          hasToggledState: true,
          isToggled: false,
          hasTapAction: false,
        ),
      );
      handle.dispose();
    });

    testWidgets('screen reader reads an enabled switch as enabled and on',
        (WidgetTester tester) async {
      final handle = tester.ensureSemantics();
      await pumpSwitch(
        tester,
        type: CoreSwitchType.showHide,
        value: true,
        onChanged: (_) {},
        semanticLabel: 'Markup to client',
      );

      expect(
        tester.getSemantics(find.byType(CoreSwitch)),
        isSemantics(
          hasEnabledState: true,
          isEnabled: true,
          hasToggledState: true,
          isToggled: true,
          hasTapAction: true,
        ),
      );
      handle.dispose();
    });

    testWidgets('screen reader reads the current label when none is given',
        (WidgetTester tester) async {
      final handle = tester.ensureSemantics();
      await pumpSwitch(
        tester,
        type: CoreSwitchType.showHide,
        value: true,
        onChanged: (_) {},
      );

      expect(
        tester.getSemantics(find.byType(CoreSwitch)),
        isSemantics(label: 'Show'),
      );
      handle.dispose();
    });

    testWidgets('switch respects custom inactive color',
        (WidgetTester tester) async {
      final colors = AppColorsExtension.create();
      final customColor = colors.iconBlue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoreSwitch(
              type: CoreSwitchType.normal,
              value: false,
              onChanged: (_) {},
              inactiveColor: customColor,
            ),
          ),
        ),
      );

      final switchFinder = find.byType(CoreSwitch);
      expect(switchFinder, findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('meets a11y guidelines (label, contrast; tap size skipped)',
        (WidgetTester tester) async {
      await setupA11yTest(tester);

      for (final theme in kA11yTestThemes) {
        await tester.pumpWidget(
          buildTestApp(
            CoreSwitch(
              type: CoreSwitchType.normal,
              value: false,
              onChanged: (_) {},
              activeLabel: 'On',
              inactiveLabel: 'Off',
            ),
            theme: theme,
          ),
        );

        await tester.pumpAndSettle();

        await expectMeetsTapTargetAndLabelGuidelines(
          tester,
          find.byType(CoreSwitch),
        );

        await tester.tap(find.byType(CoreSwitch));
        await tester.pumpAndSettle();

        await expectMeetsTapTargetAndLabelGuidelines(
          tester,
          find.byType(CoreSwitch),
        );
      }
    });
  });
}

