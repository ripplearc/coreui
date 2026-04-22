import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await loadFonts();
  });

  const List<CoreCalculatorChip> mockChips = [
    CoreCalculatorChip(
      label: 'Length',
      value: '16ft 14in',
      type: CoreCalculatorChipType.editable,
    ),
    CoreCalculatorChip(
      label: 'Length',
      value: '16ft 14in',
      type: CoreCalculatorChipType.active,
    ),
    CoreCalculatorChip(
      label: 'Length',
      value: '16ft 14in',
      type: CoreCalculatorChipType.disabled,
    ),
    CoreCalculatorChip(
      label: 'Width',
      value: '10ft',
      type: CoreCalculatorChipType.editable,
    ),
    CoreCalculatorChip(
      label: 'Height',
      value: '8ft',
      type: CoreCalculatorChipType.active,
    ),
    CoreCalculatorChip(
      label: 'Weight',
      value: '20lbs',
      type: CoreCalculatorChipType.disabled,
    ),
    CoreCalculatorChip(
      label: 'Volume',
      value: '100gal',
      type: CoreCalculatorChipType.editable,
    ),
    CoreCalculatorChip(
      label: 'Width',
      value: '10ft',
      type: CoreCalculatorChipType.editable,
    ),
    CoreCalculatorChip(
      label: 'Width',
      value: '10ft',
      type: CoreCalculatorChipType.editable,
    ),
  ];

  final List<CoreHistorySessionData> mockPreviousSessions = [
    const CoreHistorySessionData(
      dateLabel: 'May 27, 2025',
      value: '2700ft³',
      chipsList: mockChips,
    ),
    const CoreHistorySessionData(
      dateLabel: 'May 26, 2025',
      value: '1500ft³',
      chipsList: [
        CoreCalculatorChip(
          label: 'Width',
          value: '10ft',
          type: CoreCalculatorChipType.editable,
        ),
      ],
    ),
  ];

  Widget buildTestWidget({void Function(DisplayAreaStage)? onStageChanged}) {
    final colors = AppColorsExtension.create();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: CoreTheme.light().copyWith(
        textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto'),
      ),
      home: Scaffold(
        backgroundColor: colors.buttonInverse,
        body: MediaQuery(
          data: const MediaQueryData(
            size: Size(412, 892),
            padding: EdgeInsets.zero,
            viewPadding: EdgeInsets.zero,
            viewInsets: EdgeInsets.zero,
          ),
          child: CoreDisplayArea(
            label: 'Length',
            value: '16ft 14in',
            isTyping: false,
            dependentKeyLabel: 'O.C',
            dependentKeyValue: '16in',
            onPressedDependentKey: () {},
            chipsList: mockChips,
            previousSessions: mockPreviousSessions,
            onStageChanged: onStageChanged,
          ),
        ),
      ),
    );
  }

  testWidgets('CoreDisplayArea Expansion Stages Golden Test',
      (WidgetTester tester) async {
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() => tester.view.resetDevicePixelRatio());
    await tester.binding.setSurfaceSize(const Size(412, 892));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    await tester.fling(
        find.byType(CoreDisplayArea), const Offset(0, 300), 1000);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(CoreDisplayArea),
      matchesGoldenFile('goldens/core_display_area_stage_1_current.png'),
    );

    await tester.fling(
        find.byType(CoreDisplayArea), const Offset(0, 300), 1000);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(CoreDisplayArea),
      matchesGoldenFile('goldens/core_display_area_stage_2_previous.png'),
    );

    await tester.fling(
        find.byType(CoreDisplayArea), const Offset(0, 300), 1000);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(CoreDisplayArea),
      matchesGoldenFile('goldens/core_display_area_stage_3_fullscreen.png'),
    );
  });

  testWidgets('CoreDisplayArea 2-Stage Expansion Path Golden Test',
      (WidgetTester tester) async {
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() => tester.view.resetDevicePixelRatio());
    await tester.binding.setSurfaceSize(const Size(412, 892));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    // ≤ 5 chips triggers the 2-stage path
    const List<CoreCalculatorChip> fewChips = [
      CoreCalculatorChip(
        label: 'Volume',
        value: '100gal',
        type: CoreCalculatorChipType.editable,
      ),
      CoreCalculatorChip(
        label: 'Width',
        value: '10ft',
        type: CoreCalculatorChipType.editable,
      ),
      CoreCalculatorChip(
        label: 'Width',
        value: '10ft',
        type: CoreCalculatorChipType.editable,
      ),
    ];

    await tester.pumpWidget(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: CoreTheme.light().copyWith(
        textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto'),
      ),
      home: Scaffold(
        body: CoreDisplayArea(
          label: 'Length',
          value: '16ft 14in',
          isTyping: false,
          dependentKeyLabel: 'O.C',
          dependentKeyValue: '16in',
          onPressedDependentKey: () {},
          chipsList: fewChips,
          previousSessions: mockPreviousSessions,
        ),
      ),
    ));
    await tester.pumpAndSettle();

    // 1st Swipe -> expandedPrevious
    await tester.fling(
        find.byType(CoreDisplayArea), const Offset(0, 300), 1000);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(CoreDisplayArea),
      matchesGoldenFile('goldens/core_display_area_2stage_1_previous.png'),
    );

    // 2nd Swipe -> fullScreen
    await tester.fling(
        find.byType(CoreDisplayArea), const Offset(0, 300), 1000);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(CoreDisplayArea),
      matchesGoldenFile('goldens/core_display_area_2stage_2_fullscreen.png'),
    );
  });
}
