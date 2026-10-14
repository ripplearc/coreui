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
    // 824x760 @ 2.0 => a 412 dp wide phone, tall enough for every row.
    tester.view.physicalSize = const Size(824, 760);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final colors = theme.coreColors;
    final typography = theme.coreTypography;

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: Scaffold(
          backgroundColor: colors.pageBackground,
          body: Padding(
            // The storyboard's sheets inset the row 20 dp.
            padding: const EdgeInsets.all(CoreSpacing.space5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CoreDetailsRow(
                  label: 'Delivery',
                  value: '—',
                  expanded: false,
                  onToggle: () {},
                  actionLabel: 'Add note',
                  onAction: () {},
                ),
                const SizedBox(height: CoreSpacing.space4),
                CoreDetailsRow(
                  label: 'Waste',
                  value: '10%',
                  expanded: false,
                  onToggle: () {},
                ),
                const SizedBox(height: CoreSpacing.space4),
                CoreDetailsRow(
                  label: 'Delivery',
                  value: r'$1,234,567,890.00 for the whole job, estimated',
                  expanded: false,
                  onToggle: () {},
                  actionLabel: 'Add note',
                  onAction: () {},
                ),
                const SizedBox(height: CoreSpacing.space4),
                CoreDetailsRow(
                  label: 'Delivery',
                  value: r'$150',
                  expanded: true,
                  onToggle: () {},
                  actionLabel: 'Add note',
                  onAction: () {},
                  child: Container(
                    height: CoreSpacing.space16,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Panel content',
                      style: typography.bodyLargeRegular.copyWith(
                        color: colors.textHeadline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.pump();
  }

  testWidgets('CoreDetailsRow Visual Regression - Light',
      (WidgetTester tester) async {
    await pumpVariants(tester, _withRoboto(CoreTheme.light()));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_details_row_light.png'),
    );
  });

  testWidgets('CoreDetailsRow Visual Regression - Dark',
      (WidgetTester tester) async {
    await pumpVariants(tester, _withRoboto(CoreTheme.dark()));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_details_row_dark.png'),
    );
  });
}
