import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

void main() {
  setUpAll(() async {
    await loadFonts();
  });

  testWidgets('Keyboard Buttons - All Variants', (tester) async {
    Widget scenario(String title, Widget button) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          button,
        ],
      );
    }

    final widget = Container(
      color: CoreBackgroundColors.pageBackground,
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          // Digit Input Buttons
          scenario(
            'Digit Input - Zero',
            CoreDigitInput(
              digit: DigitType.zero,
              onDigitPressed: (_) {},
            ),
          ),
          scenario(
            'Digit Input - Five',
            CoreDigitInput(
              digit: DigitType.five,
              onDigitPressed: (_) {},
            ),
          ),
          scenario(
            'Digit Input - Decimal',
            CoreDigitInput(
              digit: DigitType.decimal,
              onDigitPressed: (_) {},
            ),
          ),
          scenario(
            'Digit Input - Emphasized',
            CoreDigitInput(
              digit: DigitType.nine,
              onDigitPressed: (_) {},
              isEmphasized: true,
            ),
          ),

          // Operator Buttons
          scenario(
            'Operator - Add',
            CoreOperatorButton(
              operatorType: OperatorType.add,
              onOperatorPressed: (_) {},
            ),
          ),
          scenario(
            'Operator - Multiply',
            CoreOperatorButton(
              operatorType: OperatorType.multiply,
              onOperatorPressed: (_) {},
            ),
          ),
          scenario(
            'Operator - Divide',
            CoreOperatorButton(
              operatorType: OperatorType.divide,
              onOperatorPressed: (_) {},
            ),
          ),

          // Unit Buttons
          scenario(
            'Unit - Yards',
            CoreUnitButton(
              unit: UnitType.yards,
              onUnitSelected: (_) {},
            ),
          ),
          scenario(
            'Unit - Feet',
            CoreUnitButton(
              unit: UnitType.feet,
              onUnitSelected: (_) {},
            ),
          ),
          scenario(
            'Unit - Inches',
            CoreUnitButton(
              unit: UnitType.inch,
              onUnitSelected: (_) {},
            ),
          ),
          scenario(
            'Unit - Meters',
            CoreUnitButton(
              unit: UnitType.meter,
              onUnitSelected: (_) {},
            ),
          ),

          // Control Buttons
          scenario(
            'Control - Delete',
            CoreControlButton(
              action: ControlAction.delete,
              onControlAction: (_) {},
            ),
          ),
          scenario(
            'Control - Clear All',
            CoreControlButton(
              action: ControlAction.clearAll,
              onControlAction: (_) {},
            ),
          ),
          scenario(
            'Control - More Options',
            CoreControlButton(
              action: ControlAction.moreOptions,
              onControlAction: (_) {},
            ),
          ),

          // Result Buttons
          scenario(
            'Result - Equals',
            CoreResultButton(
              resultType: ResultType.equals,
              onTap: () {},
            ),
          ),
          scenario(
            'Result - Area',
            CoreResultButton(
              resultType: ResultType.area,
              onTap: () {},
            ),
          ),
          scenario(
            'Result - Volume',
            CoreResultButton(
              resultType: ResultType.volume,
              onTap: () {},
            ),
          ),
          scenario(
            'Result - Custom',
            CoreResultButton(
              resultType: ResultType.custom,
              customLabel: 'Calculate',
              onTap: () {},
            ),
          ),
        ],
      ),
    );

    await tester.binding.setSurfaceSize(const Size(800, 1200));

    await tester.pumpWidget(
      MaterialApp(
        theme: CoreTheme.light(),
        home: Scaffold(
          body: SingleChildScrollView(
            child: widget,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/keyboard_buttons.png'),
    );
  });
}

