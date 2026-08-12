import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

Widget _buildVariants() {
  return const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CoreSwitch(
        type: CoreSwitchType.normal,
        value: false,
        onChanged: _noop,
      ),
      SizedBox(height: 10),
      CoreSwitch(
        type: CoreSwitchType.normal,
        value: true,
        onChanged: _noop,
      ),
      SizedBox(height: 10),
      CoreSwitch(
        type: CoreSwitchType.lock,
        value: false,
        onChanged: _noop,
        activeLabel: 'Lock',
        inactiveLabel: 'Unlock',
      ),
      SizedBox(height: 10),
      CoreSwitch(
        type: CoreSwitchType.lock,
        value: true,
        onChanged: _noop,
        activeLabel: 'Lock',
        inactiveLabel: 'Unlock',
      ),
      SizedBox(height: 10),
      CoreSwitch(
        type: CoreSwitchType.normal,
        value: false,
        onChanged: _noop,
        activeLabel: 'Public',
        inactiveLabel: 'Private',
      ),
      SizedBox(height: 10),
      CoreSwitch(
        type: CoreSwitchType.normal,
        value: true,
        onChanged: _noop,
        activeLabel: 'Public',
        inactiveLabel: 'Private',
      ),
      SizedBox(height: 10),
      CoreSwitch(
        type: CoreSwitchType.imperial,
        value: false,
        onChanged: _noop,
        activeLabel: 'Metric',
        inactiveLabel: 'Imperial',
      ),
      SizedBox(height: 10),
      CoreSwitch(
        type: CoreSwitchType.imperial,
        value: true,
        onChanged: _noop,
        activeLabel: 'Metric',
        inactiveLabel: 'Imperial',
      ),
    ],
  );
}

void _noop(bool _) {}

void main() {
  setUpAll(() async {
    await loadFonts();
  });

  Future<void> pumpVariants(WidgetTester tester, ThemeData theme) async {
    final colors = theme.coreColors;
    final widget = MaterialApp(
      theme: theme,
      home: Scaffold(
        backgroundColor: colors.pageBackground,
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: _buildVariants(),
        ),
      ),
    );
    await tester.binding.setSurfaceSize(const Size(200, 500));

    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();
  }

  testWidgets('CoreSwitch Golden Test - All Variants',
      (WidgetTester tester) async {
    await pumpVariants(tester, CoreTheme.light());

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/switch_component.png'),
    );
  });

  testWidgets('CoreSwitch Golden Test - All Variants - Dark',
      (WidgetTester tester) async {
    await pumpVariants(tester, CoreTheme.dark());

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/switch_component_dark.png'),
    );
  });
}
