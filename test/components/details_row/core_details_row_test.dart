import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/test_harness.dart';

void main() {
  const rowKey = Key('delivery_details_row');

  Widget buildRow({
    bool expanded = false,
    required VoidCallback onToggle,
    String? actionLabel,
    VoidCallback? onAction,
    String value = r'$150',
    String? semanticLabel,
  }) {
    return buildTestApp(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: CoreSpacing.space5),
        child: CoreDetailsRow(
          key: rowKey,
          label: 'Delivery',
          value: value,
          expanded: expanded,
          onToggle: onToggle,
          actionLabel: actionLabel,
          onAction: onAction,
          semanticLabel: semanticLabel,
          child: const Text('Delivery fee field'),
        ),
      ),
      theme: CoreTheme.light(),
    );
  }

  Finder chevron() => find.byType(CoreIconWidget);

  Offset chevronZone(WidgetTester tester) => Offset(
        tester.getTopRight(find.byKey(rowKey)).dx - 24,
        tester.getCenter(find.byKey(rowKey)).dy,
      );

  group('CoreDetailsRow', () {
    testWidgets('shows the label and the value in one line', (tester) async {
      await tester.pumpWidget(buildRow(onToggle: () {}));

      expect(find.text(r'Delivery $150', findRichText: true), findsOneWidget);
    });

    testWidgets('shows the action after a dot', (tester) async {
      await tester.pumpWidget(
        buildRow(onToggle: () {}, actionLabel: 'Add note', onAction: () {}),
      );

      expect(find.text('·'), findsOneWidget);
      expect(find.text('Add note'), findsOneWidget);
    });

    testWidgets('draws no dot without an action', (tester) async {
      await tester.pumpWidget(buildRow(onToggle: () {}));

      expect(find.text('·'), findsNothing);
    });

    testWidgets('a tap on the value calls onToggle', (tester) async {
      var toggles = 0;
      await tester.pumpWidget(buildRow(onToggle: () => toggles++));

      await tester.tap(find.text(r'Delivery $150', findRichText: true));

      expect(toggles, 1);
    });

    testWidgets('a tap on the chevron calls onToggle', (tester) async {
      var toggles = 0;
      await tester.pumpWidget(buildRow(onToggle: () => toggles++));

      await tester.tapAt(chevronZone(tester));

      expect(toggles, 1);
    });

    testWidgets('a tap on the action calls onAction and not onToggle',
        (tester) async {
      var toggles = 0;
      var actions = 0;
      await tester.pumpWidget(
        buildRow(
          onToggle: () => toggles++,
          actionLabel: 'Add note',
          onAction: () => actions++,
        ),
      );

      await tester.tap(find.text('Add note'));

      expect(actions, 1);
      expect(toggles, 0);
    });

    testWidgets('hides the panel while folded', (tester) async {
      await tester.pumpWidget(buildRow(onToggle: () {}));

      expect(find.text('Delivery fee field'), findsNothing);
    });

    testWidgets('shows the panel under the row while expanded', (tester) async {
      await tester.pumpWidget(buildRow(onToggle: () {}, expanded: true));

      final panel = find.text('Delivery fee field');
      expect(panel, findsOneWidget);
      expect(
        tester.getTopLeft(panel).dy,
        greaterThan(tester.getBottomLeft(chevron()).dy),
      );
    });

    testWidgets('the chevron points down while folded and up while expanded',
        (tester) async {
      await tester.pumpWidget(buildRow(onToggle: () {}));
      expect(
        tester.widget<AnimatedRotation>(find.byType(AnimatedRotation)).turns,
        0,
      );

      await tester.pumpWidget(buildRow(onToggle: () {}, expanded: true));
      expect(
        tester.widget<AnimatedRotation>(find.byType(AnimatedRotation)).turns,
        0.5,
      );
    });

    testWidgets('the folded row is 48 dp tall', (tester) async {
      await tester.pumpWidget(buildRow(onToggle: () {}));

      expect(tester.getSize(find.byType(CoreDetailsRow)).height, 48);
    });

    testWidgets('the chevron is centred 24 dp in from the right edge',
        (tester) async {
      await tester.pumpWidget(buildRow(onToggle: () {}));

      final rowRight = tester.getTopRight(find.byType(CoreDetailsRow)).dx;
      expect(rowRight - tester.getCenter(chevron()).dx, 24);
    });

    testWidgets('the label starts 16 dp in from the right edge in RTL',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          Directionality(
            textDirection: TextDirection.rtl,
            child: CoreDetailsRow(
              label: 'Delivery',
              value: r'$150',
              expanded: false,
              onToggle: () {},
            ),
          ),
          theme: CoreTheme.light(),
        ),
      );

      final summary = find.text(r'Delivery $150', findRichText: true);
      final rowRight = tester.getTopRight(find.byType(CoreDetailsRow)).dx;
      expect(rowRight - tester.getTopRight(summary).dx, 16);
    });

    testWidgets('a long value ends in an ellipsis rather than overflow',
        (tester) async {
      await tester.pumpWidget(
        buildRow(
          onToggle: () {},
          value: r'$1,234,567,890.00 for the whole job, estimated',
          actionLabel: 'Add note',
          onAction: () {},
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Add note'), findsOneWidget);
      expect(tester.getSize(find.byType(CoreDetailsRow)).height, 48);
    });

    test('an action label without onAction is refused', () {
      expect(
        () => CoreDetailsRow(
          label: 'Delivery',
          value: '—',
          expanded: false,
          onToggle: () {},
          actionLabel: 'Add note',
        ),
        throwsAssertionError,
      );
    });

    testWidgets('the toggle reads as a button with its expanded state',
        (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(buildRow(onToggle: () {}));

      expect(find.bySemanticsLabel(r'Delivery $150'), findsOneWidget);
      expect(
        tester.getSemantics(find.bySemanticsLabel(r'Delivery $150')),
        matchesSemantics(
          label: r'Delivery $150',
          isButton: true,
          hasExpandedState: true,
          isExpanded: false,
          hasTapAction: true,
        ),
      );

      await tester.pumpWidget(buildRow(onToggle: () {}, expanded: true));
      expect(
        tester.getSemantics(find.bySemanticsLabel(r'Delivery $150')),
        matchesSemantics(
          label: r'Delivery $150',
          isButton: true,
          hasExpandedState: true,
          isExpanded: true,
          hasTapAction: true,
        ),
      );
      handle.dispose();
    });

    testWidgets('semanticLabel replaces the toggle label', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        buildRow(onToggle: () {}, semanticLabel: 'Delivery, 150 dollars'),
      );

      expect(find.bySemanticsLabel('Delivery, 150 dollars'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('the action reads as its own button', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        buildRow(onToggle: () {}, actionLabel: 'Add note', onAction: () {}),
      );

      expect(
        tester.getSemantics(find.bySemanticsLabel('Add note')),
        matchesSemantics(
          label: 'Add note',
          isButton: true,
          hasTapAction: true,
        ),
      );
      handle.dispose();
    });
  });
}
