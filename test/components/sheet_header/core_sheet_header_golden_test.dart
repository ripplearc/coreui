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

  Future<void> pumpHeaders(WidgetTester tester, ThemeData theme) async {
    // physicalSize is in physical pixels; logical size = physicalSize / DPR.
    // 824x660 @ 2.0 => 412x330 logical: Figma's 412 dp sheet width. Back=On
    // with and without a subtitle and with a long title, then Back=Off, the
    // meta line and a header with its bottom line, stacked with no gaps.
    tester.view.physicalSize = const Size(824, 660);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: _withRoboto(theme),
        home: Scaffold(
          backgroundColor: theme.coreColors.pageBackground,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CoreSheetHeader(
                title: 'Excavator',
                subtitle: 'Metered rate',
                backSemanticLabel: 'Back',
                onBack: () {},
              ),
              CoreSheetHeader(
                title: 'Excavator',
                backSemanticLabel: 'Back',
                onBack: () {},
              ),
              CoreSheetHeader(
                title: 'Hydraulic crawler excavator with a long reach boom',
                backSemanticLabel: 'Back',
                onBack: () {},
              ),
              const CoreSheetHeader(
                title: 'Add a cost',
                subtitle: 'Pick a category. It sets where the cost appears',
              ),
              const CoreSheetHeader(
                title: 'Logs',
                subtitle: 'Bedroom 2 — flooring & drywall · newest first',
                style: CoreSheetHeaderStyle.metaLine,
              ),
              CoreSheetHeader(
                title: 'Excavator',
                backSemanticLabel: 'Back',
                onBack: () {},
                showBottomLine: true,
              ),
            ],
          ),
        ),
      ),
    );

    await tester.pump();
  }

  testWidgets('CoreSheetHeader Visual Regression - Light', (tester) async {
    await pumpHeaders(tester, CoreTheme.light());

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_sheet_header_light.png'),
    );
  });

  testWidgets('CoreSheetHeader Visual Regression - Dark', (tester) async {
    await pumpHeaders(tester, CoreTheme.dark());

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_sheet_header_dark.png'),
    );
  });
}
