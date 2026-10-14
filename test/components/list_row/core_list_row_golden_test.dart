import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

ThemeData _withRoboto(ThemeData base) {
  return base.copyWith(
    textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto'),
  );
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await loadFonts();
  });

  Future<void> pumpVariants(WidgetTester tester, ThemeData theme) async {
    // 824x1160 @ 2.0 => a 412 dp wide phone, tall enough for every row.
    tester.view.physicalSize = const Size(824, 1160);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: Scaffold(
          backgroundColor: theme.coreColors.pageBackground,
          body: Padding(
            // The storyboard's sheets start their content at 20 dp; the row
            // adds its own 8 dp, so the titles start at 28 dp.
            padding: const EdgeInsets.symmetric(horizontal: CoreSpacing.space5),
            child: Column(
              children: [
                const CoreListRow(
                  title: 'Scissor lift — 19ft',
                  subtitle: 'Used last week',
                  value: r'$120.00',
                  unit: '/day',
                ),
                const CoreListRow(
                  title: 'Dumpster — 30 yd',
                  value: r'$400.00',
                  unit: 'job',
                ),
                CoreListRow.action(
                  icon: CoreIcons.add,
                  title: 'New equipment cost',
                  onTap: () {},
                ),
                const CoreListRow.selectable(
                  title: 'Mini excavator — 1.5 ton',
                  subtitle: 'Compact, tight-access digging',
                  value: r'$145.00',
                  unit: '/day',
                  selected: true,
                ),
                const CoreListRow.selectable(
                  title: 'Skid steer — track',
                  subtitle: 'Loader attachment ready',
                  value: r'$165.00',
                  unit: '/day',
                  selected: false,
                ),
                const CoreListRow(
                  title: 'Compact track loader with a very long model name '
                      'that wraps',
                  value: r'$1,250.00',
                  unit: '/week',
                ),
                const CoreListRow.selectable(
                  title: 'Telehandler with a very long model name that '
                      'wraps',
                  value: r'$1,450.00',
                  unit: '/week',
                  selected: false,
                ),
                CoreListRow.action(
                  icon: CoreIcons.add,
                  title: 'New equipment cost for a very long model name '
                      'that wraps',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.pump();
  }

  testWidgets('CoreListRow Visual Regression - Light',
      (WidgetTester tester) async {
    await pumpVariants(tester, _withRoboto(CoreTheme.light()));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_list_row_light.png'),
    );
  });

  testWidgets('CoreListRow Visual Regression - Dark',
      (WidgetTester tester) async {
    await pumpVariants(tester, _withRoboto(CoreTheme.dark()));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_list_row_dark.png'),
    );
  });
}
