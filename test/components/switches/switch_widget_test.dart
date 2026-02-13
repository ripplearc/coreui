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

