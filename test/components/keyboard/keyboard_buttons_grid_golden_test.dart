import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../await_images_extension.dart';
import '../../load_fonts.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await loadFonts();
  });

  Widget buildButtonGrid(List<Widget> buttons) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 5,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.0,
      children: buttons,
    );
  }

  List<Widget> getButtons({String? keyPrefix}) {
    return [
      CoreDigitInput(
        key: keyPrefix != null ? Key('${keyPrefix}_digit_7') : null,
        digit: DigitType.seven,
        onDigitPressed: (_) {},
        height: 80.0,
        width: 80.0,
      ),
      CoreDigitInput(
        key: keyPrefix != null ? Key('${keyPrefix}_digit_8') : null,
        digit: DigitType.eight,
        onDigitPressed: (_) {},
        height: 80.0,
        width: 80.0,
      ),
      CoreDigitInput(
        key: keyPrefix != null ? Key('${keyPrefix}_digit_9') : null,
        digit: DigitType.nine,
        onDigitPressed: (_) {},
        height: 80.0,
        width: 80.0,
      ),
      CoreOperatorButton(
        key: keyPrefix != null ? Key('${keyPrefix}_op_divide') : null,
        operatorType: OperatorType.divide,
        onOperatorPressed: (_) {},
        height: 80.0,
        width: 80.0,
      ),
      CoreControlButton(
        key: keyPrefix != null ? Key('${keyPrefix}_ctrl_delete') : null,
        action: ControlAction.delete,
        onControlAction: (_) {},
        height: 80.0,
        width: 80.0,
      ),
      CoreDigitInput(
        key: keyPrefix != null ? Key('${keyPrefix}_digit_4') : null,
        digit: DigitType.four,
        onDigitPressed: (_) {},
        height: 80.0,
        width: 80.0,
      ),
      CoreDigitInput(
        key: keyPrefix != null ? Key('${keyPrefix}_digit_5') : null,
        digit: DigitType.five,
        onDigitPressed: (_) {},
        height: 80.0,
        width: 80.0,
      ),
      CoreDigitInput(
        key: keyPrefix != null ? Key('${keyPrefix}_digit_6') : null,
        digit: DigitType.six,
        onDigitPressed: (_) {},
        height: 80.0,
        width: 80.0,
      ),
      CoreOperatorButton(
        key: keyPrefix != null ? Key('${keyPrefix}_op_multiply') : null,
        operatorType: OperatorType.multiply,
        onOperatorPressed: (_) {},
        height: 80.0,
        width: 80.0,
      ),
      CoreControlButton(
        key: keyPrefix != null ? Key('${keyPrefix}_ctrl_clear') : null,
        action: ControlAction.clearAll,
        onControlAction: (_) {},
        height: 80.0,
        width: 80.0,
      ),
      CoreDigitInput(
        key: keyPrefix != null ? Key('${keyPrefix}_digit_1') : null,
        digit: DigitType.one,
        onDigitPressed: (_) {},
        height: 80.0,
        width: 80.0,
      ),
      CoreDigitInput(
        key: keyPrefix != null ? Key('${keyPrefix}_digit_2') : null,
        digit: DigitType.two,
        onDigitPressed: (_) {},
        height: 80.0,
        width: 80.0,
      ),
      CoreDigitInput(
        key: keyPrefix != null ? Key('${keyPrefix}_digit_3') : null,
        digit: DigitType.three,
        onDigitPressed: (_) {},
        height: 80.0,
        width: 80.0,
      ),
      CoreOperatorButton(
        key: keyPrefix != null ? Key('${keyPrefix}_op_subtract') : null,
        operatorType: OperatorType.subtract,
        onOperatorPressed: (_) {},
        height: 80.0,
        width: 80.0,
      ),
      CoreUnitButton(
        key: keyPrefix != null ? Key('${keyPrefix}_unit_feet') : null,
        unit: UnitType.feet,
        onUnitSelected: (_) {},
        height: 80.0,
        width: 80.0,
      ),
      CoreDigitInput(
        key: keyPrefix != null ? Key('${keyPrefix}_digit_0') : null,
        digit: DigitType.zero,
        onDigitPressed: (_) {},
        height: 80.0,
        width: 80.0,
      ),
      CoreDigitInput(
        key: keyPrefix != null ? Key('${keyPrefix}_digit_decimal') : null,
        digit: DigitType.decimal,
        onDigitPressed: (_) {},
        height: 80.0,
        width: 80.0,
      ),
      CoreOperatorButton(
        key: keyPrefix != null ? Key('${keyPrefix}_op_add') : null,
        operatorType: OperatorType.add,
        onOperatorPressed: (_) {},
        height: 80.0,
        width: 80.0,
      ),
      CoreOperatorButton(
        key: keyPrefix != null ? Key('${keyPrefix}_op_percent') : null,
        operatorType: OperatorType.percent,
        onOperatorPressed: (_) {},
        height: 80.0,
        width: 80.0,
      ),
      CoreControlButton(
        key: keyPrefix != null ? Key('${keyPrefix}_ctrl_more_options') : null,
        action: ControlAction.moreOptions,
        onControlAction: (_) {},
        height: 80.0,
        width: 80.0,
      ),
    ];
  }

  testWidgets('Keyboard Buttons Grid View Golden Test', (tester) async {
    final normalButtons = getButtons(keyPrefix: 'normal');
    final pressedButtons = getButtons(keyPrefix: 'pressed');
    final colors = AppColorsExtension.create();

    final widget = MaterialApp(
      theme: CoreTheme.light().copyWith(
        textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto'),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: colors.pageBackground,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Normal States',
              ),
              const SizedBox(height: 16),
              buildButtonGrid(normalButtons),
              const SizedBox(height: 16),
              CoreResultButton(
                key: const Key('normal_result_button'),
                resultType: const ResultType(label: '='),
                onTap: () {},
                height: 80.0,
                width: 160.0,
              ),
              const SizedBox(height: 32),
              const Text(
                'Pressed States',
              ),
              const SizedBox(height: 16),
              buildButtonGrid(pressedButtons),
              const SizedBox(height: 16),
              CoreResultButton(
                key: const Key('pressed_result_button'),
                resultType: const ResultType(label: '='),
                onTap: () {},
                height: 80.0,
                width: 160.0,
              ),
            ],
          ),
        ),
      ),
    );

    await tester.binding.setSurfaceSize(const Size(600, 1250));
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    // Simulate pressed state for the second grid buttons
    for (final button in pressedButtons) {
      final finder = find.byKey((button.key as Key));
      if (finder.evaluate().isNotEmpty) {
        await tester.startGesture(tester.getCenter(finder));
        await tester.pump(const Duration(milliseconds: 200));
      }
    }

    // Simulate pressed state for the result button
    final finder = find.byKey(const Key('pressed_result_button'));
    if (finder.evaluate().isNotEmpty) {
      await tester.startGesture(tester.getCenter(finder));
      await tester.pump(const Duration(milliseconds: 200));
    }
    await tester.pump(const Duration(milliseconds: 200));
    await tester.awaitImages();

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/keyboard_buttons_grid_view.png'),
    );
  });
}
