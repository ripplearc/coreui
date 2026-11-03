import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    // 640x560 @ 2.0 => 320x280 logical.
    tester.view.physicalSize = const Size(640, 560);
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
          body: Padding(
            padding: const EdgeInsets.all(CoreSpacing.space4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const CoreInlineErrorRow(message: 'Could not load your rates'),
                const SizedBox(height: CoreSpacing.space4),
                CoreInlineErrorRow(
                  message: 'Could not load your rates',
                  actionLabel: 'Try again',
                  onAction: () {},
                ),
                const SizedBox(height: CoreSpacing.space4),
                const CoreInlineErrorRow(
                  message: 'Could not add this line because the connection '
                      'dropped, so check it and add the line once more',
                ),
                const SizedBox(height: CoreSpacing.space4),
                CoreInlineErrorRow(
                  message: 'Could not load your rates because the connection '
                      'dropped, so check it and try once more',
                  actionLabel: 'Try again',
                  onAction: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.pump();
  }

  testWidgets('CoreInlineErrorRow Visual Regression - Light', (tester) async {
    await pumpVariants(tester, CoreTheme.light());

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_inline_error_row_light.png'),
    );
  });

  testWidgets('CoreInlineErrorRow Visual Regression - Dark', (tester) async {
    await pumpVariants(tester, CoreTheme.dark());

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_inline_error_row_dark.png'),
    );
  });

  Future<void> pumpFocused(WidgetTester tester, ThemeData theme) async {
    tester.view.physicalSize = const Size(640, 160);
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
          body: Padding(
            padding: const EdgeInsets.all(CoreSpacing.space4),
            child: CoreInlineErrorRow(
              message: 'Could not load your rates',
              actionLabel: 'Try again',
              onAction: () {},
            ),
          ),
        ),
      ),
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
  }

  testWidgets('CoreInlineErrorRow action focused - Light', (tester) async {
    await pumpFocused(tester, CoreTheme.light());

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_inline_error_row_focused_light.png'),
    );
  });

  testWidgets('CoreInlineErrorRow action focused - Dark', (tester) async {
    await pumpFocused(tester, CoreTheme.dark());

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_inline_error_row_focused_dark.png'),
    );
  });
}
