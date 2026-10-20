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
    // 824x352 @ 2.0 => 412x176 logical: Figma's 412 dp sheet width, a 72 dp
    // header with a subtitle, a 52 dp one without and a long title cut short,
    // 52 dp, stacked with no gaps.
    tester.view.physicalSize = const Size(824, 352);
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
