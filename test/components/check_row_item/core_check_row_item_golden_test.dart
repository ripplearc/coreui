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
    final colors = theme.coreColors;

    // physicalSize is in physical pixels; logical size = physicalSize / DPR.
    // 720x720 @ 2.0 => 360x360 logical, tall enough to stack all rows.
    tester.view.physicalSize = const Size(720, 720);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: Scaffold(
          backgroundColor: colors.pageBackground,
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CoreCheckRowItem(
                title: 'John Doe',
                selected: true,
                onChanged: _noop,
              ),
              const CoreCheckRowItem(
                title: 'Floyd Miles',
                selected: false,
                onChanged: _noop,
              ),
              const CoreCheckRowItem(
                title: 'Esther Howard',
                subtitle: 'esther@acme.com',
                selected: false,
                onChanged: _noop,
              ),
              CoreCheckRowItem(
                title: 'Marvin McKinney',
                selected: false,
                onChanged: _noop,
                avatarBackgroundColor: colors.backgroundGreenLight,
                avatarTextColor: colors.iconGreen,
              ),
            ],
          ),
        ),
      ),
    );

    await tester.pump();
  }

  testWidgets('CoreCheckRowItem Visual Regression - Light',
      (WidgetTester tester) async {
    await pumpVariants(tester, _withRoboto(CoreTheme.light()));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_check_row_item_light.png'),
    );
  });

  testWidgets('CoreCheckRowItem Visual Regression - Dark',
      (WidgetTester tester) async {
    await pumpVariants(tester, _withRoboto(CoreTheme.dark()));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_check_row_item_dark.png'),
    );
  });
}

void _noop(bool _) {}
