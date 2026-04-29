import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

void main() {
  setUpAll(() async {
    await loadFonts();
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  final colors = AppColorsExtension.create();

  testWidgets('CoreSearchBox Golden Test', (WidgetTester tester) async {
    final scenarios = <Widget>[
      _buildScenario(
        'Default',
        const CoreSearchBox(
          hintText: 'Search for Calculation and cost',
        ),
      ),
      _buildScenario(
        'Active',
        CoreSearchBox(
          controller: TextEditingController(text: 'Roof cost'),
          hintText: 'Search for Calculation and cost',
        ),
      ),
      _buildScenario(
        'Disabled',
        const CoreSearchBox(
          enabled: false,
          hintText: 'Search for Calculation and cost',
        ),
      ),
      _buildScenario(
        'Disabled Active',
        CoreSearchBox(
          enabled: false,
          controller: TextEditingController(text: 'Roof cost'),
          hintText: 'Search for Calculation and cost',
        ),
      ),
    ];

    final widget = MaterialApp(
      home: Scaffold(
        backgroundColor: colors.pageBackground,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: scenarios,
        ),
      ),
    );

    await tester.binding.setSurfaceSize(const Size(400, 600));
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/core_search_box.png'),
    );
  });
}

Widget _buildScenario(String title, Widget child) {
  final typography = AppTypographyExtension.create();
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: typography.bodyMediumSemiBold),
        const SizedBox(height: 4),
        child,
      ],
    ),
  );
}
