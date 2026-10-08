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
    await loadFonts();
  });

  Future<void> pumpVariants(WidgetTester tester, ThemeData theme) async {
    // 412 x 520 logical at 2x: the three cards at Figma's 372 width with
    // the 20 px page margin of the cost sheets.
    tester.view.physicalSize = const Size(824, 1040);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: Scaffold(
          backgroundColor: theme.coreColors.pageBackground,
          body: const Padding(
            padding: EdgeInsets.all(CoreSpacing.space5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CoreEstimateSummaryCard(
                  title: 'Adds to this estimate',
                  lineTotal: r'$520.00',
                  estimateName: 'Bedroom 2',
                  totalBeforeSuffix: r' total  $2,993.62 →',
                  totalAfter: r'$3,513.62',
                ),
                SizedBox(height: CoreSpacing.space4),
                CoreEstimateSummaryCard(
                  title: 'Adds to this estimate',
                  lineTotal: r'$605.00',
                  extraCharge: CoreEstimateSummaryCharge(
                    label: 'incl. delivery',
                    amount: r'+$85.00',
                  ),
                  estimateName: 'Primary bedroom and walk-in closet suite',
                  totalBeforeSuffix: r' total  $2,993.62 →',
                  totalAfter: r'$3,598.62',
                ),
                SizedBox(height: CoreSpacing.space4),
                CoreEstimateSummaryCard.empty(
                  title: 'Adds to this estimate',
                  note: 'Needs a duration before it can total',
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('CoreEstimateSummaryCard Visual Regression - Light',
      (tester) async {
    await pumpVariants(tester, _withRoboto(CoreTheme.light()));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_estimate_summary_card_light.png'),
    );
  });

  testWidgets('CoreEstimateSummaryCard Visual Regression - Dark',
      (tester) async {
    await pumpVariants(tester, _withRoboto(CoreTheme.dark()));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_estimate_summary_card_dark.png'),
    );
  });
}
