import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

ThemeData _createTestTheme() {
  return CoreTheme.light().copyWith(
    textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto'),
  );
}

class AlwaysFocusedNode extends FocusNode {
  @override
  bool get hasFocus => true;
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await loadFonts();
  });

  testWidgets('CoreChip Component Visual Regression Test',
      (WidgetTester tester) async {
    final colors = AppColorsExtension.create();
    final typography = AppTypographyExtension.create();
    debugDisableShadows = false;
    addTearDown(() => debugDisableShadows = true);
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final smallDefault = ValueNotifier<bool>(false);
    final smallPressed = ValueNotifier<bool>(false);
    final smallFocused = ValueNotifier<bool>(false);
    final smallSelected = ValueNotifier<bool>(true);

    final mediumDefault = ValueNotifier<bool>(false);
    final mediumPressed = ValueNotifier<bool>(false);
    final mediumFocused = ValueNotifier<bool>(false);
    final mediumSelected = ValueNotifier<bool>(true);

    final largeDefault = ValueNotifier<bool>(false);
    final largePressed = ValueNotifier<bool>(false);
    final largeFocused = ValueNotifier<bool>(false);
    final largeSelected = ValueNotifier<bool>(true);
    Widget stateLabel(String label) => SizedBox(
          width: 120,
          child: Text(label, style: typography.bodyMediumRegular),
        );
    Widget smallMediumRow(
      String label,
      ValueNotifier<bool> smallNotifier,
      ValueNotifier<bool> mediumNotifier, {
      Key? smallKey,
      Key? mediumKey,
      FocusNode? focusNode,
    }) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          stateLabel(label),
          const SizedBox(width: CoreSpacing.space8),
          CoreChip(
            key: smallKey,
            label: 'Chips',
            selected: smallNotifier,
            size: CoreChipSize.small,
            icon: CoreIcons.check,
            focusNode: focusNode,
            withCloseIcon: true,
            onRemove: () {},
          ),
          const SizedBox(width: CoreSpacing.space8),
          CoreChip(
            key: mediumKey,
            label: 'Chips',
            selected: mediumNotifier,
            size: CoreChipSize.medium,
            icon: CoreIcons.check,
            focusNode: focusNode,
            withCloseIcon: true,
            onRemove: () {},
          ),
        ],
      );
    }

    Widget largeRow(
      String label,
      ValueNotifier<bool> largeNotifier, {
      Key? key,
      FocusNode? focusNode,
    }) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          stateLabel(label),
          const SizedBox(width: CoreSpacing.space8),
          CoreChip(
            key: key,
            label: 'Chips',
            selected: largeNotifier,
            size: CoreChipSize.large,
            icon: CoreIcons.check,
            focusNode: focusNode,
            withCloseIcon: true,
            onRemove: () {},
          ),
        ],
      );
    }

    final clickSmallKey = UniqueKey();
    final clickMediumKey = UniqueKey();
    final clickLargeKey = UniqueKey();

    final widget = MaterialApp(
      theme: _createTestTheme(),
      home: Scaffold(
        backgroundColor: colors.pageBackground,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: CoreSpacing.space8,
              vertical: CoreSpacing.space8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                smallMediumRow('Default', smallDefault, mediumDefault),
                const SizedBox(height: CoreSpacing.space8),
                smallMediumRow(
                  'Focused',
                  smallFocused,
                  mediumFocused,
                  focusNode: AlwaysFocusedNode(),
                ),
                const SizedBox(height: CoreSpacing.space8),
                smallMediumRow(
                  'On Click',
                  smallPressed,
                  mediumPressed,
                  smallKey: clickSmallKey,
                  mediumKey: clickMediumKey,
                ),
                const SizedBox(height: CoreSpacing.space8),
                smallMediumRow('After click', smallSelected, mediumSelected),
                const SizedBox(height: CoreSpacing.space12),
                largeRow('Default', largeDefault),
                const SizedBox(height: CoreSpacing.space8),
                largeRow(
                  'Focused',
                  largeFocused,
                  focusNode: AlwaysFocusedNode(),
                ),
                const SizedBox(height: CoreSpacing.space8),
                largeRow(
                  'On Click',
                  largePressed,
                  key: clickLargeKey,
                ),
                const SizedBox(height: CoreSpacing.space8),
                largeRow('After click', largeSelected),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    final gesture1 =
        await tester.startGesture(tester.getCenter(find.byKey(clickSmallKey)));
    final gesture2 =
        await tester.startGesture(tester.getCenter(find.byKey(clickMediumKey)));
    final gesture3 =
        await tester.startGesture(tester.getCenter(find.byKey(clickLargeKey)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_chip_component.png'),
    );

    await gesture1.up();
    await gesture2.up();
    await gesture3.up();

    debugDisableShadows = true;
  });
}
