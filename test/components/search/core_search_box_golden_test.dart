import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

const _hint = 'Search for Calculation and cost';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await loadFonts();
  });

  Future<void> pumpVariants(WidgetTester tester, ThemeData theme) async {
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);
    final scenarios = <Widget>[
      for (final type in CoreSearchBoxType.values) ...[
        _buildScenario(
          '${type.name} – Default',
          CoreSearchBox(type: type, hintText: _hint),
        ),
        _buildScenario(
          '${type.name} – Filled',
          CoreSearchBox(
            type: type,
            controller: TextEditingController(text: 'Mini excavator'),
            hintText: _hint,
          ),
        ),
        _buildScenario(
          '${type.name} – Disabled',
          CoreSearchBox(type: type, enabled: false, hintText: _hint),
        ),
      ],
      _buildScenario(
        'pill – Focus',
        CoreSearchBox(focusNode: focusNode, hintText: _hint),
      ),
    ];

    tester.view.physicalSize = const Size(400, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme.copyWith(
          textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto'),
        ),
        home: Scaffold(
          backgroundColor: theme.coreColors.pageBackground,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: scenarios,
          ),
        ),
      ),
    );
    focusNode.requestFocus();
    await tester.pump();
    // Lets the focus border finish its colour change.
    await tester.pump(const Duration(milliseconds: 300));
  }

  testWidgets('CoreSearchBox Golden Test - Light', (WidgetTester tester) async {
    await pumpVariants(tester, CoreTheme.light());

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/core_search_box_light.png'),
    );
  });

  testWidgets('CoreSearchBox Golden Test - Dark', (WidgetTester tester) async {
    await pumpVariants(tester, CoreTheme.dark());

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/core_search_box_dark.png'),
    );
  });
}

Widget _buildScenario(String title, Widget child) {
  final typography = AppTypographyExtension.create();
  return Padding(
    padding: const EdgeInsets.symmetric(
      vertical: CoreSpacing.space1,
      horizontal: CoreSpacing.space4,
    ),
    child: Builder(
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: typography.bodyMediumSemiBold.copyWith(
              color: Theme.of(context).coreColors.textHeadline,
            ),
          ),
          const SizedBox(height: CoreSpacing.space1),
          child,
        ],
      ),
    ),
  );
}
