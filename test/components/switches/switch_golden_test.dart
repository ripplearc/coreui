import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  group('Switch Golden Tests', () {
    testGoldens('Switch Component Visual Regression Test', (tester) async {
      final builder = GoldenBuilder.grid(
          columns: 1, widthToHeightRatio: 2, bgColor: Colors.white)
        // Normal switches - compact (no labels)
        ..addScenario(
          'Normal Off',
          CoreSwitch(
            type: CoreSwitchType.normal,
            value: false,
            onChanged: (_) {},
          ),
        )
        ..addScenario(
          'Normal On',
          CoreSwitch(
            type: CoreSwitchType.normal,
            value: true,
            onChanged: (_) {},
          ),
        )

        // Lock switches with labels
        ..addScenario(
          'Lock Off',
          CoreSwitch(
            type: CoreSwitchType.lock,
            value: false,
            onChanged: (_) {},
            activeLabel: 'Lock',
            inactiveLabel: 'Unlock',
          ),
        )
        ..addScenario(
          'Lock On',
          CoreSwitch(
            type: CoreSwitchType.lock,
            value: true,
            onChanged: (_) {},
            activeLabel: 'Lock',
            inactiveLabel: 'Unlock',
          ),
        )

        // Normal switches with labels (Private/Public)
        ..addScenario(
          'Private Off',
          CoreSwitch(
            type: CoreSwitchType.normal,
            value: false,
            onChanged: (_) {},
            activeLabel: 'Public',
            inactiveLabel: 'Private',
          ),
        )
        ..addScenario(
          'Public On',
          CoreSwitch(
            type: CoreSwitchType.normal,
            value: true,
            onChanged: (_) {},
            activeLabel: 'Public',
            inactiveLabel: 'Private',
          ),
        )
        // Imperial switches with labels
        ..addScenario(
          'Imperial',
          CoreSwitch(
            type: CoreSwitchType.imperial,
            value: false,
            onChanged: (_) {},
            activeLabel: 'Metric',
            inactiveLabel: 'Imperial',
          ),
        )
        ..addScenario(
          'Metric',
          CoreSwitch(
            type: CoreSwitchType.imperial,
            value: true,
            onChanged: (_) {},
            activeLabel: 'Metric',
            inactiveLabel: 'Imperial',
          ),
        );

      await tester.pumpWidgetBuilder(
        Container(
          color: Colors.white,
          child: builder.build(),
        ),
        surfaceSize: const Size(200, 600),
      );

      await screenMatchesGolden(tester, 'switch_component');
    });
  });
}
