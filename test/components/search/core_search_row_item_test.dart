import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/test_harness.dart';

void main() {
  group('CoreSearchRowItem – general', () {
    testWidgets('renders custom label widget', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CoreSearchRowItem(
            leadingIcon: CoreIcons.history,
            label: const Text('My Label'),
            onTap: () {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      expect(find.text('My Label'), findsOneWidget);
      expect(find.byType(CoreSearchRowItem), findsOneWidget);
    });

    testWidgets('trailing icon is rendered by default', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CoreSearchRowItem(
            leadingIcon: CoreIcons.history,
            label: const Text('Item'),
            onTap: () {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      expect(find.byKey(const Key('trailing_icon')), findsOneWidget);
    });

    testWidgets('trailing icon is hidden when showTrailingIcon is false',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CoreSearchRowItem(
            leadingIcon: CoreIcons.history,
            label: const Text('Item'),
            onTap: () {},
            showTrailingIcon: false,
          ),
          theme: CoreTheme.light(),
        ),
      );

      expect(find.byKey(const Key('trailing_icon')), findsNothing);
    });

    testWidgets('onTap fires when row body is tapped', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        buildTestApp(
          CoreSearchRowItem(
            leadingIcon: CoreIcons.history,
            label: const Text('Row'),
            onTap: () => tapped = true,
          ),
          theme: CoreTheme.light(),
        ),
      );

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('onTrailingTap fires when trailing icon tapped; onTap does not',
        (tester) async {
      var rowTapped = false;
      var trailingTapped = false;

      await tester.pumpWidget(
        buildTestApp(
          CoreSearchRowItem(
            leadingIcon: CoreIcons.history,
            label: const Text('Row'),
            onTap: () => rowTapped = true,
            onTrailingTap: () => trailingTapped = true,
          ),
          theme: CoreTheme.light(),
        ),
      );

      await tester.tap(find.byKey(const Key('trailing_icon')));
      await tester.pumpAndSettle();

      expect(trailingTapped, isTrue);
      expect(rowTapped, isFalse);
    });
  });

  group('CoreSearchRowItem.recentSearch', () {
    testWidgets('renders label text', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CoreSearchRowItem.recentSearch(
            text: '#Carpentry',
            onTap: () {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      expect(find.text('#Carpentry'), findsOneWidget);
    });

    testWidgets('uses history leading icon', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CoreSearchRowItem.recentSearch(
            text: 'Roof cost',
            onTap: () {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      final icon = tester.widget<CoreIconWidget>(
        find.byType(CoreIconWidget).first,
      );
      expect(icon.icon, CoreIcons.history);
    });

    testWidgets('onTap fires on row tap', (tester) async {
      var called = false;

      await tester.pumpWidget(
        buildTestApp(
          CoreSearchRowItem.recentSearch(
            text: 'Wall cost',
            onTap: () => called = true,
          ),
          theme: CoreTheme.light(),
        ),
      );

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      expect(called, isTrue);
    });

    testWidgets('onTrailingTap fires; onTap does not', (tester) async {
      var rowTapped = false;
      var trailingTapped = false;

      await tester.pumpWidget(
        buildTestApp(
          CoreSearchRowItem.recentSearch(
            text: '#Roof',
            onTap: () => rowTapped = true,
            onTrailingTap: () => trailingTapped = true,
          ),
          theme: CoreTheme.light(),
        ),
      );

      await tester.tap(find.byKey(const Key('trailing_icon')));
      await tester.pumpAndSettle();

      expect(trailingTapped, isTrue);
      expect(rowTapped, isFalse);
    });

    testWidgets('row has semantic label matching text', (tester) async {
      const label = '#Roof';

      await tester.pumpWidget(
        buildTestApp(
          CoreSearchRowItem.recentSearch(
            text: label,
            onTap: () {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      final semantics = tester.getSemantics(find.byType(CoreSearchRowItem));
      expect(semantics.label, label);
    });

    testWidgets('trailing icon has semantic label', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CoreSearchRowItem.recentSearch(
            text: '#Roof',
            onTap: () {},
            onTrailingTap: () {},
            trailingSemanticLabel: 'Fill search with #Roof',
          ),
          theme: CoreTheme.light(),
        ),
      );

      final semantics = tester
          .getSemantics(find.byKey(const Key('trailing_icon')));
      expect(semantics.label, contains('#Roof'));
    });
  });

  group('CoreSearchRowItem.suggestion', () {
    testWidgets('renders full label text', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CoreSearchRowItem.suggestion(
            text: '#Carpentry',
            query: 'Car',
            onTap: () {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      expect(find.byType(RichText), findsWidgets);
    });

    testWidgets('uses search leading icon', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CoreSearchRowItem.suggestion(
            text: '#Carpentry',
            query: 'Car',
            onTap: () {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      final icon = tester.widget<CoreIconWidget>(
        find.byType(CoreIconWidget).first,
      );
      expect(icon.icon, CoreIcons.search);
    });

    testWidgets('bold span covers exactly the query prefix', (tester) async {
      // 'Carpentry' starts with 'Car', so the first 3 chars are bold.
      await tester.pumpWidget(
        buildTestApp(
          CoreSearchRowItem.suggestion(
            text: 'Carpentry',
            query: 'Car',
            onTap: () {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      // Find the RichText whose top-level TextSpan has child spans.
      final richTextFinder = find.byWidgetPredicate((widget) {
        if (widget is RichText) {
          final span = widget.text;
          return span is TextSpan &&
              span.children != null &&
              span.children!.isNotEmpty;
        }
        return false;
      });

      expect(richTextFinder, findsOneWidget);

      final richText = tester.widget<RichText>(richTextFinder);
      final root = richText.text as TextSpan;
      // Text.rich wraps our span in an outer TextSpan, so descend one level.
      final innerSpan = root.children!.first as TextSpan;
      final children = innerSpan.children!.cast<TextSpan>();

      // Verify the text content of each child span.
      expect(children[0].text, 'Car');
      expect(children[1].text, 'pentry');

      // Bold span must use semiBold weight (w600).
      expect(children[0].style!.fontWeight, FontWeight.w600);
      // Regular span must use regular weight (w400).
      expect(children[1].style!.fontWeight, FontWeight.w400);
    });

    testWidgets('falls back to plain Text when query is empty', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CoreSearchRowItem.suggestion(
            text: '#Carpentry',
            query: '',
            onTap: () {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      expect(find.text('#Carpentry'), findsOneWidget);
    });

    testWidgets('falls back to plain Text when query is longer than text',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CoreSearchRowItem.suggestion(
            text: 'Hi',
            query: 'Hello World',
            onTap: () {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      expect(find.text('Hi'), findsOneWidget);
    });

    testWidgets('falls back to plain Text when query does not match prefix',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CoreSearchRowItem.suggestion(
            text: '#Carpentry',
            query: 'xyz',
            onTap: () {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      expect(find.text('#Carpentry'), findsOneWidget);
    });

    testWidgets('onTap fires on row tap', (tester) async {
      var called = false;

      await tester.pumpWidget(
        buildTestApp(
          CoreSearchRowItem.suggestion(
            text: '#Carpentry',
            query: 'Car',
            onTap: () => called = true,
          ),
          theme: CoreTheme.light(),
        ),
      );

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      expect(called, isTrue);
    });

    testWidgets('onTrailingTap fires; onTap does not', (tester) async {
      var rowTapped = false;
      var trailingTapped = false;

      await tester.pumpWidget(
        buildTestApp(
          CoreSearchRowItem.suggestion(
            text: 'Carparking cost',
            query: 'Car',
            onTap: () => rowTapped = true,
            onTrailingTap: () => trailingTapped = true,
          ),
          theme: CoreTheme.light(),
        ),
      );

      await tester.tap(find.byKey(const Key('trailing_icon')));
      await tester.pumpAndSettle();

      expect(trailingTapped, isTrue);
      expect(rowTapped, isFalse);
    });
  });
}
