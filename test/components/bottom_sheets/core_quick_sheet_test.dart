import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

void main() {
  group('CoreQuickSheet Widget Tests', () {
    testWidgets('renders child widget correctly', (WidgetTester tester) async {
      const testChild = Text('Test Content');

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  CoreQuickSheet.show(
                    context: context,
                    child: testChild,
                  );
                },
                child: const Text('Open Sheet'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      expect(find.text('Test Content'), findsOneWidget);
    });

    testWidgets('dismisses when tapping outside when isDismissible is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  CoreQuickSheet.show(
                    context: context,
                    isDismissible: true,
                    child: const Text('Content'),
                  );
                },
                child: const Text('Open Sheet'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      expect(find.text('Content'), findsOneWidget);

      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      expect(find.text('Content'), findsNothing);
    });

    testWidgets(
        'does not dismiss when tapping outside when isDismissible is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  CoreQuickSheet.show(
                    context: context,
                    isDismissible: false,
                    child: const Text('Content'),
                  );
                },
                child: const Text('Open Sheet'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      expect(find.text('Content'), findsOneWidget);

      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets('can be dragged to dismiss when enableDrag is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  CoreQuickSheet.show(
                    context: context,
                    enableDrag: true,
                    child: const SizedBox(
                      height: 200,
                      child: Text('Content'),
                    ),
                  );
                },
                child: const Text('Open Sheet'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      expect(find.text('Content'), findsOneWidget);

      await tester.drag(find.text('Content'), const Offset(0, 500));
      await tester.pumpAndSettle();

      expect(find.text('Content'), findsNothing);
    });

    testWidgets('respects SafeArea when useSafeArea is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  CoreQuickSheet.show(
                    context: context,
                    useSafeArea: true,
                    child: const Text('Content'),
                  );
                },
                child: const Text('Open Sheet'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      expect(find.byType(SafeArea), findsOneWidget);
    });

    testWidgets('does not use SafeArea when useSafeArea is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  CoreQuickSheet.show(
                    context: context,
                    useSafeArea: false,
                    child: const Text('Content'),
                  );
                },
                child: const Text('Open Sheet'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      expect(find.byType(SafeArea), findsNothing);
    });

    testWidgets('returns value when dismissed', (WidgetTester tester) async {
      String? result;

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await CoreQuickSheet.show<String>(
                    context: context,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop('Test Result');
                      },
                      child: const Text('Close'),
                    ),
                  );
                },
                child: const Text('Open Sheet'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      expect(result, 'Test Result');
    });

    testWidgets('handles large content with Flexible child',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  CoreQuickSheet.show(
                    context: context,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 50,
                      itemBuilder: (context, index) => ListTile(
                        title: Text('Item $index'),
                      ),
                    ),
                  );
                },
                child: const Text('Open Sheet'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      expect(find.text('Item 0'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
