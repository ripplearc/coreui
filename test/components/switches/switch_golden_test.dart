import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/core_ui.dart';

import '../../load_fonts.dart';

void main() {
  setUpAll(() async {
    await loadFonts();
  });

  testWidgets('CoreSwitch Golden Test - All Variants',
      (WidgetTester tester) async {
    final widget = MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CoreSwitch(
                type: CoreSwitchType.normal,
                value: false,
                onChanged: (_) {},
              ),
              const SizedBox(height: 16),
              CoreSwitch(
                type: CoreSwitchType.normal,
                value: true,
                onChanged: (_) {},
              ),
              const SizedBox(height: 16),
              CoreSwitch(
                type: CoreSwitchType.lock,
                value: false,
                onChanged: (_) {},
                activeLabel: 'Lock',
                inactiveLabel: 'Unlock',
              ),
              const SizedBox(height: 16),
              CoreSwitch(
                type: CoreSwitchType.lock,
                value: true,
                onChanged: (_) {},
                activeLabel: 'Lock',
                inactiveLabel: 'Unlock',
              ),
              const SizedBox(height: 16),
              CoreSwitch(
                type: CoreSwitchType.normal,
                value: false,
                onChanged: (_) {},
                activeLabel: 'Public',
                inactiveLabel: 'Private',
              ),
              const SizedBox(height: 16),
              CoreSwitch(
                type: CoreSwitchType.normal,
                value: true,
                onChanged: (_) {},
                activeLabel: 'Public',
                inactiveLabel: 'Private',
              ),
              const SizedBox(height: 16),
              CoreSwitch(
                type: CoreSwitchType.imperial,
                value: false,
                onChanged: (_) {},
                activeLabel: 'Metric',
                inactiveLabel: 'Imperial',
              ),
              const SizedBox(height: 16),
              CoreSwitch(
                type: CoreSwitchType.imperial,
                value: true,
                onChanged: (_) {},
                activeLabel: 'Metric',
                inactiveLabel: 'Imperial',
              ),
            ],
          ),
        ),
      ),
    );
    await tester.binding.setSurfaceSize(const Size(200, 400));

    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/switch_component.png'),
    );
  });
}
