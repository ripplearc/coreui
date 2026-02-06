import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

void main() {
  setUpAll(() async {
    await loadFonts();
  });

  final colors = AppColorsExtension.create();

  testWidgets('CoreTooltip Golden Test - Top', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(300, 200));

    await tester.pumpWidget(
      MaterialApp(
        theme: CoreTheme.light().copyWith(
          textTheme: ThemeData().textTheme.apply(fontFamily: 'Roboto'),
        ),
        home: Scaffold(
          backgroundColor: colors.pageBackground,
          body: Center(
            child: CoreTooltip.top(
              message: 'Tooltip above',
              child: Container(
                padding: const EdgeInsets.all(CoreSpacing.space3),
                decoration: BoxDecoration(
                  color: colors.backgroundBlueLight,
                  borderRadius: BorderRadius.circular(CoreSpacing.space2),
                ),
                child: const Text('Top'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.text('Top'));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/tooltip_top.png'),
    );
  });

  testWidgets('CoreTooltip Golden Test - Bottom', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(300, 200));

    await tester.pumpWidget(
      MaterialApp(
        theme: CoreTheme.light().copyWith(
          textTheme: ThemeData().textTheme.apply(fontFamily: 'Roboto'),
        ),
        home: Scaffold(
          backgroundColor: colors.pageBackground,
          body: Center(
            child: CoreTooltip.bottom(
              message: 'Tooltip below',
              child: Container(
                padding: const EdgeInsets.all(CoreSpacing.space3),
                decoration: BoxDecoration(
                  color: colors.backgroundGreenLight,
                  borderRadius: BorderRadius.circular(CoreSpacing.space2),
                ),
                child: const Text('Bottom'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.text('Bottom'));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/tooltip_bottom.png'),
    );
  });

  testWidgets('CoreTooltip Golden Test - Left', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(300, 200));

    await tester.pumpWidget(
      MaterialApp(
        theme: CoreTheme.light().copyWith(
          textTheme: ThemeData().textTheme.apply(fontFamily: 'Roboto'),
        ),
        home: Scaffold(
          backgroundColor: colors.pageBackground,
          body: Center(
            child: CoreTooltip.left(
              message: 'Tooltip left',
              child: Container(
                padding: const EdgeInsets.all(CoreSpacing.space3),
                decoration: BoxDecoration(
                  color: colors.backgroundOrangeLight,
                  borderRadius: BorderRadius.circular(CoreSpacing.space2),
                ),
                child: const Text('Left'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.text('Left'));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/tooltip_left.png'),
    );
  });

  testWidgets('CoreTooltip Golden Test - Right', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(300, 200));

    await tester.pumpWidget(
      MaterialApp(
        theme: CoreTheme.light().copyWith(
          textTheme: ThemeData().textTheme.apply(fontFamily: 'Roboto'),
        ),
        home: Scaffold(
          backgroundColor: colors.pageBackground,
          body: Center(
            child: CoreTooltip.right(
              message: 'Tooltip right',
              child: Container(
                padding: const EdgeInsets.all(CoreSpacing.space3),
                decoration: BoxDecoration(
                  color: colors.backgroundRedLight,
                  borderRadius: BorderRadius.circular(CoreSpacing.space2),
                ),
                child: const Text('Right'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.text('Right'));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/tooltip_right.png'),
    );
  });

  testWidgets('CoreTooltip Golden Test - None', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(300, 200));

    await tester.pumpWidget(
      MaterialApp(
        theme: CoreTheme.light().copyWith(
          textTheme: ThemeData().textTheme.apply(fontFamily: 'Roboto'),
        ),
        home: Scaffold(
          backgroundColor: colors.pageBackground,
          body: Center(
            child: CoreTooltip.none(
              message: 'Tooltip without arrow',
              child: Container(
                padding: const EdgeInsets.all(CoreSpacing.space3),
                decoration: BoxDecoration(
                  color: colors.backgroundGrayMid,
                  borderRadius: BorderRadius.circular(CoreSpacing.space2),
                ),
                child: const Text('None'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.text('None'));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/tooltip_none.png'),
    );
  });
}
