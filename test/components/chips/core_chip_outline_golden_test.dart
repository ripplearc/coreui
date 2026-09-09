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

  Future<void> pumpOutlines(WidgetTester tester, ThemeData theme) async {
    final colors = theme.coreColors;
    final unselected = ValueNotifier<bool>(false);
    addTearDown(unselected.dispose);

    debugDisableShadows = false;
    addTearDown(() => debugDisableShadows = true);

    // physicalSize is in physical pixels; logical size = physicalSize / DPR.
    // 720x192 @ 2.0 => 360x96 logical: one row of a solid large, a dashed
    // large and a dashed medium chip (64 tall including the chip's own space2
    // vertical padding) with space4 padding and no dead space.
    tester.view.physicalSize = const Size(720, 192);
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
          backgroundColor: colors.pageBackground,
          body: Padding(
            padding: const EdgeInsets.all(CoreSpacing.space4),
            child: Row(
              children: [
                CoreChip(
                  label: 'Area:',
                  value: '220',
                  unit: 'ft²',
                  selected: unselected,
                  size: CoreChipSize.large,
                ),
                const SizedBox(width: CoreSpacing.space3),
                CoreChip(
                  label: 'Height:',
                  value: '8ft ?',
                  selected: unselected,
                  size: CoreChipSize.large,
                  outline: CoreChipOutline.dashed,
                ),
                const SizedBox(width: CoreSpacing.space3),
                CoreChip(
                  label: 'Offer',
                  selected: unselected,
                  size: CoreChipSize.medium,
                  outline: CoreChipOutline.dashed,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 100));
  }

  testWidgets('CoreChip outline Visual Regression - Light',
      (WidgetTester tester) async {
    await pumpOutlines(tester, _withRoboto(CoreTheme.light()));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_chip_outline_light.png'),
    );
    debugDisableShadows = true;
  });

  testWidgets('CoreChip outline Visual Regression - Dark',
      (WidgetTester tester) async {
    await pumpOutlines(tester, _withRoboto(CoreTheme.dark()));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_chip_outline_dark.png'),
    );
    debugDisableShadows = true;
  });
}
