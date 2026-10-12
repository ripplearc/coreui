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
    // 824x880 @ 2.0 => a 412 dp wide phone, tall enough for every row.
    tester.view.physicalSize = const Size(824, 880);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: Scaffold(
          backgroundColor: theme.coreColors.pageBackground,
          body: const Padding(
            // The storyboard's sheets inset their lists by 12 dp.
            padding: EdgeInsets.all(CoreSpacing.space3),
            child: Column(
              children: [
                CoreListRow(
                  title: 'Scissor lift — 19ft',
                  subtitle: 'Used last week',
                  value: r'$120.00',
                  unit: '/day',
                ),
                CoreListRow(
                  title: 'Dumpster — 30 yd',
                  value: r'$400.00',
                  unit: 'job',
                ),
                CoreListRow(
                  title: 'Compact track loader with a very long model name '
                      'that wraps',
                  value: r'$1,250.00',
                  unit: '/week',
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
