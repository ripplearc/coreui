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

  Future<void> pumpRemovableChips(WidgetTester tester, ThemeData theme) async {
    final unselected = ValueNotifier<bool>(false);
    addTearDown(unselected.dispose);

    tester.view.physicalSize = const Size(640, 160);
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
          body: Padding(
            padding: const EdgeInsets.all(CoreSpacing.space4),
            child: Row(
              children: [
                for (final size in [CoreChipSize.small, CoreChipSize.medium])
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      end: CoreSpacing.space3,
                    ),
                    child: CoreChip(
                      label: 'Chips',
                      selected: unselected,
                      size: size,
                      withCloseIcon: true,
                      onRemove: () {},
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  for (final (name, theme) in [
    ('light', CoreTheme.light()),
    ('dark', CoreTheme.dark()),
  ]) {
    testWidgets('CoreChip close focused - $name', (tester) async {
      await pumpRemovableChips(tester, _withRoboto(theme));

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/core_chip_close_focused_$name.png'),
      );
    });

    testWidgets('CoreChip close pressed - $name', (tester) async {
      await pumpRemovableChips(tester, _withRoboto(theme));

      final gesture = await tester.startGesture(
        tester.getCenter(find.byKey(const Key('close_icon')).first),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/core_chip_close_pressed_$name.png'),
      );
      await gesture.up();
    });
  }
}
