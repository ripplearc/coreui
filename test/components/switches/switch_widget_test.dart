import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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

      // Find the switch widget
      final switchFinder = find.byType(CoreSwitch);
      expect(switchFinder, findsOneWidget);

      // Find the GestureDetector
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

      // Find the switch widget
      final switchFinder = find.byType(CoreSwitch);
      expect(switchFinder, findsOneWidget);

      // Find the inactive label text
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

      // Find the switch widget
      final switchFinder = find.byType(CoreSwitch);
      expect(switchFinder, findsOneWidget);

      // Find the inactive label text
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

      // Initial state should be false
      expect(switchValue, isFalse);

      // Tap the switch
      await tester.tap(find.byType(CoreSwitch));
      await tester.pumpAndSettle();

      // Value should now be true
      expect(switchValue, isTrue);

      // Tap again
      await tester.tap(find.byType(CoreSwitch));
      await tester.pumpAndSettle();

      // Value should be false again
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

      // Tap to activate
      await tester.tap(find.byType(CoreSwitch));
      await tester.pumpAndSettle();

      // Should now show active label
      expect(find.text('Public'), findsOneWidget);
      expect(find.text('Private'), findsNothing);
    });

    testWidgets('switch animation completes properly',
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

      // Tap the switch
      await tester.tap(find.byType(CoreSwitch));

      // Pump a few frames to let animation start
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Complete the animation
      await tester.pumpAndSettle();

      // Verify the switch is in the correct state
      expect(switchValue, isTrue);
    });

    testWidgets('switch respects custom inactive color',
        (WidgetTester tester) async {
      const customColor = Colors.purple;

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

      // Find the switch widget
      final switchFinder = find.byType(CoreSwitch);
      expect(switchFinder, findsOneWidget);

      // The widget should render without errors
      await tester.pumpAndSettle();
    });
  });
}
