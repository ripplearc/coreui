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
    // 720x960 @ 2.0 => 360x480 logical, tall enough to stack all rows.
    tester.view.physicalSize = const Size(720, 960);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: Scaffold(
          // A sheet is white in the light theme; the pressed fill is gray50,
          // which is also pageBackground and would not show against it.
          backgroundColor: theme.brightness == Brightness.light
              ? Colors.white
              : colors.pageBackground,
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CoreCheckRowItem(
                key: Key('default'),
                title: 'Judy Smith',
                subtitle: 'Homeowner · judy@acme.com',
                selected: false,
                onChanged: _noop,
              ),
              const CoreCheckRowItem(
                title: 'John Doe',
                subtitle: 'Owner · john.doe@gmail.com',
                selected: true,
                onChanged: _noop,
              ),
              const CoreCheckRowItem(
                key: Key('pressed'),
                title: 'Floyd Miles',
                subtitle: 'Foreman · floyd@acme.com',
                selected: false,
                onChanged: _noop,
              ),
              const CoreCheckRowItem(
                title: 'Esther Howard',
                subtitle: 'Estimator · esther@acme.com',
                selected: false,
                enabled: false,
                onChanged: _noop,
              ),
              CoreCheckRowItem(
                title: 'Marvin McKinney',
                selected: false,
                showDivider: false,
                onChanged: _noop,
                avatarBackgroundColor: colors.backgroundGreenLight,
                avatarTextColor: colors.textSuccess,
              ),
            ],
          ),
        ),
      ),
    );

    // Hold a pointer down on the third row so it paints its pressed fill.
    final gesture = await tester.startGesture(
      tester.getCenter(find.byKey(const Key('pressed'))),
    );
    addTearDown(gesture.up);
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 400));
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
