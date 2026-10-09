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

  Opacity leadingOpacityOf(WidgetTester tester) {
    return tester.widget<Opacity>(
      find.ancestor(
        of: find.byType(CoreIconWidget),
        matching: find.byType(Opacity),
      ),
    );
  }

  Color textColorOf(WidgetTester tester, String text) {
    return tester.widget<Text>(find.text(text)).style!.color!;
  }

  double titleLeftOf(WidgetTester tester, String title) {
    return tester.getTopLeft(find.text(title)).dx;
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
  });

  group('CoreListRow.selectable', () {
    testWidgets('keeps an invisible check slot when unselected',
        (tester) async {
      await pumpRow(
        tester,
        const CoreListRow.selectable(
          title: 'Skid steer — track',
          selected: false,
        ),
      );

      expect(leadingOpacityOf(tester).opacity, 0);
      expect(fillOf(tester), CoreTheme.light().coreColors.transparent);
    });

    testWidgets('shows the check and the light blue fill when selected',
        (tester) async {
      await pumpRow(
        tester,
        const CoreListRow.selectable(
          title: 'Mini excavator — 1.5 ton',
          selected: true,
        ),
      );

      final colors = CoreTheme.light().coreColors;
      final icon = tester.widget<CoreIconWidget>(find.byType(CoreIconWidget));
      expect(leadingOpacityOf(tester).opacity, 1);
      expect(icon.icon, CoreIcons.checkMark);
      expect(fillOf(tester), colors.backgroundBlueLight);
      expect(textColorOf(tester, 'Mini excavator — 1.5 ton'), colors.textLink);
    });

    testWidgets('puts the title at the same x selected or not',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CoreListRow.selectable(title: 'Picked', selected: true),
              CoreListRow.selectable(title: 'Not picked', selected: false),
            ],
          ),
          theme: CoreTheme.light(),
        ),
      );

      expect(titleLeftOf(tester, 'Picked'), titleLeftOf(tester, 'Not picked'));
    });

    testWidgets('reports its selected state', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpRow(
        tester,
        CoreListRow.selectable(
          title: 'Mini excavator — 1.5 ton',
          selected: true,
          onTap: () {},
        ),
      );

      expect(
        tester.getSemantics(find.byType(CoreListRow)),
        matchesSemantics(
          label: 'Mini excavator — 1.5 ton',
          isButton: true,
          hasSelectedState: true,
          isSelected: true,
          hasEnabledState: true,
          isEnabled: true,
          hasTapAction: true,
          isFocusable: true,
          hasFocusAction: true,
        ),
      );
      handle.dispose();
    });
  });

  group('CoreListRow.action', () {
    testWidgets('shows the icon and the title in the link colour',
        (tester) async {
      await pumpRow(
        tester,
        CoreListRow.action(
          icon: CoreIcons.add,
          title: 'New equipment cost',
          onTap: () {},
        ),
      );

      final colors = CoreTheme.light().coreColors;
      final icon = tester.widget<CoreIconWidget>(find.byType(CoreIconWidget));
      expect(leadingOpacityOf(tester).opacity, 1);
      expect(icon.icon, CoreIcons.add);
      expect(icon.color, colors.textLink);
      expect(textColorOf(tester, 'New equipment cost'), colors.textLink);
    });

    testWidgets('lines its title up with a selectable row', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CoreListRow.selectable(title: 'Picked', selected: false),
              CoreListRow.action(
                icon: CoreIcons.add,
                title: 'New equipment cost',
                onTap: () {},
              ),
            ],
          ),
          theme: CoreTheme.light(),
        ),
      );

      expect(
        titleLeftOf(tester, 'New equipment cost'),
        titleLeftOf(tester, 'Picked'),
      );
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var taps = 0;
      await pumpRow(
        tester,
        CoreListRow.action(
          icon: CoreIcons.add,
          title: 'New equipment cost',
          onTap: () => taps++,
        ),
      );

      await tester.tap(find.text('New equipment cost'));

      expect(taps, 1);
    });
  });
}
