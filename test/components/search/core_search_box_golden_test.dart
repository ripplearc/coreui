import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        'pill – Disabled with text',
        CoreSearchBox(
          enabled: false,
          controller: TextEditingController(text: 'Mini excavator'),
          hintText: _hint,
        ),
      ),
      _buildScenario(
        'pill – Focus',
        CoreSearchBox(focusNode: focusNode, hintText: _hint),
      ),
    ];

    tester.view.physicalSize = const Size(400, 720);
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

  Future<void> pumpOne(
    WidgetTester tester,
    ThemeData theme,
    CoreSearchBox box,
  ) async {
    tester.view.physicalSize = const Size(400, 80);
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
          body: Padding(
            padding: const EdgeInsets.all(CoreSpacing.space4),
            child: box,
          ),
        ),
      ),
    );
  }

  final themes = {'light': CoreTheme.light(), 'dark': CoreTheme.dark()};
  final clear = find.byKey(CoreSearchBox.clearButtonKey);

  themes.forEach((name, theme) {
    testWidgets('CoreSearchBox sheet focus golden ($name)', (tester) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      await pumpOne(
        tester,
        theme,
        CoreSearchBox(
          type: CoreSearchBoxType.sheet,
          focusNode: focusNode,
          controller: TextEditingController(text: 'Mini excavator'),
          hintText: _hint,
        ),
      );
      focusNode.requestFocus();
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/core_search_box_sheet_focus_$name.png'),
      );
    });

    testWidgets('CoreSearchBox clear pressed golden ($name)', (tester) async {
      await pumpOne(
        tester,
        theme,
        CoreSearchBox(
          controller: TextEditingController(text: 'Mini excavator'),
          hintText: _hint,
        ),
      );
      final gesture = await tester.startGesture(tester.getCenter(clear));
      await tester.pump(kPressTimeout);

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/core_search_box_clear_pressed_$name.png'),
      );
      await gesture.cancel();
    });

    testWidgets('CoreSearchBox clear focused golden ($name)', (tester) async {
      await pumpOne(
        tester,
        theme,
        CoreSearchBox(
          controller: TextEditingController(text: 'Mini excavator'),
          hintText: _hint,
        ),
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/core_search_box_clear_focused_$name.png'),
      );
    });
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
