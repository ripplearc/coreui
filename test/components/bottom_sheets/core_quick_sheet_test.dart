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

  group('CoreQuickSheet fixed height', () {
    const maxHeightRatio = 0.9;
    const footerHeight = 48.0;

    double screenHeight(WidgetTester tester) =>
        tester.view.physicalSize.height / tester.view.devicePixelRatio;

    Future<void> openSheet(
      WidgetTester tester, {
      required Widget child,
      bool isFixedHeight = true,
    }) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => CoreQuickSheet.show(
                  context: context,
                  isFixedHeight: isFixedHeight,
                  child: child,
                ),
                child: const Text('Open Sheet'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();
    }

    double contentHeight(WidgetTester tester) =>
        tester.getSize(find.byKey(const Key('content'))).height;

    testWidgets('is 90% of the screen for short content',
        (WidgetTester tester) async {
      await openSheet(
        tester,
        child: const Column(
          children: [Expanded(child: SizedBox(key: Key('content')))],
        ),
      );

      expect(
        contentHeight(tester),
        lessThan(screenHeight(tester) * maxHeightRatio),
      );
      expect(
        tester.getRect(find.byType(BottomSheet)).height,
        closeTo(screenHeight(tester) * maxHeightRatio, 0.01),
      );
    });

    testWidgets('keeps its height when the content changes',
        (WidgetTester tester) async {
      final showMore = ValueNotifier<bool>(false);
      await openSheet(
        tester,
        child: ValueListenableBuilder<bool>(
          valueListenable: showMore,
          builder: (context, more, _) => Column(
            children: [
              if (more) const SizedBox(height: 200, child: Text('More')),
              const Expanded(child: SizedBox(key: Key('content'))),
              const Text('Footer'),
            ],
          ),
        ),
      );

      final before = tester.getRect(find.byType(BottomSheet));
      showMore.value = true;
      await tester.pumpAndSettle();

      expect(find.text('More'), findsOneWidget);
      expect(tester.getRect(find.byType(BottomSheet)), before);
    });

    testWidgets('a filling part grows and the footer stays at the bottom',
        (WidgetTester tester) async {
      await openSheet(
        tester,
        child: const Column(
          children: [
            Expanded(child: SizedBox(key: Key('content'))),
            SizedBox(height: footerHeight, child: Text('Footer')),
          ],
        ),
      );

      final sheet = tester.getRect(find.byType(BottomSheet));
      expect(tester.getRect(find.text('Footer')).bottom,
          lessThanOrEqualTo(sheet.bottom));
      expect(tester.getRect(find.byKey(const Key('content'))).bottom,
          closeTo(sheet.bottom - footerHeight, 0.01));
      expect(contentHeight(tester), greaterThan(300));
    });

    testWidgets('long content scrolls inside the sheet',
        (WidgetTester tester) async {
      await openSheet(
        tester,
        child: ListView.builder(
          key: const Key('long_list'),
          itemCount: 100,
          itemBuilder: (context, index) => SizedBox(
            height: 56,
            child: Text('Item $index'),
          ),
        ),
      );

      final sheetBefore = tester.getRect(find.byType(BottomSheet));
      expect(find.text('Item 60'), findsNothing);

      await tester.drag(find.byKey(const Key('long_list')), const Offset(0, -2000));
      await tester.pumpAndSettle();

      expect(find.text('Item 0'), findsNothing);
      expect(tester.getRect(find.byType(BottomSheet)), sheetBefore);
      expect(tester.takeException(), isNull);
    });

    testWidgets('without the option the sheet still wraps its content',
        (WidgetTester tester) async {
      await openSheet(
        tester,
        isFixedHeight: false,
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [SizedBox(key: Key('content'), height: 100)],
        ),
      );

      expect(
        tester.getRect(find.byType(BottomSheet)).height,
        lessThan(screenHeight(tester) * maxHeightRatio / 2),
      );
    });
  });
}
