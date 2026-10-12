import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/test_harness.dart';

void main() {
  Future<void> pumpRow(WidgetTester tester, Widget row) {
    return tester.pumpWidget(buildTestApp(row, theme: CoreTheme.light()));
  }

  Color fillOf(WidgetTester tester) {
    final material = tester.widget<Material>(
      find.descendant(
        of: find.byType(CoreListRow),
        matching: find.byType(Material),
      ),
    );
    return material.color!;
  }

  group('CoreListRow', () {
    testWidgets('shows the title, subtitle, value and unit', (tester) async {
      await pumpRow(
        tester,
        const CoreListRow(
          title: 'Scissor lift — 19ft',
          subtitle: 'Used last week',
          value: r'$120.00',
          unit: '/day',
        ),
      );

      expect(find.text('Scissor lift — 19ft'), findsOneWidget);
      expect(find.text('Used last week'), findsOneWidget);
      expect(find.text(r'$120.00 /day', findRichText: true), findsOneWidget);
    });

    testWidgets('has no leading slot and no fill', (tester) async {
      await pumpRow(tester, const CoreListRow(title: 'Dumpster — 30 yd'));

      expect(find.byType(CoreIconWidget), findsNothing);
      expect(fillOf(tester), CoreTheme.light().coreColors.transparent);
    });

    testWidgets('ignores a unit without a value', (tester) async {
      await pumpRow(
        tester,
        const CoreListRow(title: 'Dumpster — 30 yd', unit: '/day'),
      );

      expect(find.textContaining('/day', findRichText: true), findsNothing);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var taps = 0;
      await pumpRow(
        tester,
        CoreListRow(title: 'Dumpster — 30 yd', onTap: () => taps++),
      );

      await tester.tap(find.text('Dumpster — 30 yd'));

      expect(taps, 1);
    });

    testWidgets('is at least 48 dp tall with a single line', (tester) async {
      await pumpRow(tester, const CoreListRow(title: 'Dumpster — 30 yd'));

      expect(
        tester.getSize(find.byType(CoreListRow)).height,
        greaterThanOrEqualTo(CoreSpacing.space12),
      );
    });

    testWidgets('reads its visible texts in order by default', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpRow(
        tester,
        CoreListRow(
          title: 'Scissor lift — 19ft',
          subtitle: 'Used last week',
          value: r'$120.00',
          unit: '/day',
          onTap: () {},
        ),
      );

      expect(
        tester.getSemantics(find.byType(CoreListRow)),
        matchesSemantics(
          label: r'Scissor lift — 19ft. Used last week. $120.00 /day',
          isButton: true,
          hasEnabledState: true,
          isEnabled: true,
          hasTapAction: true,
          isFocusable: true,
          hasFocusAction: true,
        ),
      );
      handle.dispose();
    });

    testWidgets('announces the semanticLabel in place of the texts',
        (tester) async {
      final handle = tester.ensureSemantics();
      await pumpRow(
        tester,
        const CoreListRow(
          title: 'Scissor lift — 19ft',
          value: r'$120.00',
          unit: '/day',
          semanticLabel: 'Scissor lift, 120 dollars a day',
        ),
      );

      expect(
        tester.getSemantics(find.byType(CoreListRow)),
        matchesSemantics(
          label: 'Scissor lift, 120 dollars a day',
          isButton: true,
          hasEnabledState: true,
        ),
      );
      handle.dispose();
    });

    testWidgets('shrinks a wide value instead of overflowing at 200 % text',
        (tester) async {
      await pumpRow(
        tester,
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: SizedBox(
            width: 320,
            child: CoreListRow(
              title: 'Scissor lift — 19ft',
              value: r'$12,450.00',
              unit: '/week',
              onTap: () {},
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(
        tester.getSize(find.byType(FittedBox)).width,
        lessThanOrEqualTo(tester.getSize(find.byType(CoreListRow)).width / 2),
      );
    });
  });
}
