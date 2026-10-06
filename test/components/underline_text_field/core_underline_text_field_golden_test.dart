import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

ThemeData _withRoboto(ThemeData base) {
  return base.copyWith(
    textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto'),
  );
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await loadFonts();
  });

  final themes = [
    ('light', _withRoboto(CoreTheme.light())),
    ('dark', _withRoboto(CoreTheme.dark())),
  ];

  Future<void> pumpScenarios(
    WidgetTester tester,
    ThemeData theme,
    Size logicalSize,
    List<(String, Widget)> scenarios,
  ) async {
    tester.view.physicalSize = logicalSize * 2;
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final typography = theme.coreTypography;
    final colors = theme.coreColors;

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: Scaffold(
          backgroundColor: colors.pageBackground,
          body: Padding(
            padding: const EdgeInsets.all(CoreSpacing.space4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final (caption, field) in scenarios) ...[
                  Text(
                    caption,
                    style: typography.bodySmallSemiBold.copyWith(
                      color: colors.textBody,
                    ),
                  ),
                  const SizedBox(height: CoreSpacing.space2),
                  SizedBox(width: 372, child: field),
                  const SizedBox(height: CoreSpacing.space5),
                ],
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  for (final (name, theme) in themes) {
    testWidgets('CoreUnderlineTextField at rest - $name', (tester) async {
      await pumpScenarios(tester, theme, const Size(404, 540), [
        (
          'Regular, empty with placeholder',
          const CoreUnderlineTextField(
            label: 'Equipment',
            hintText: 'Name the equipment',
          ),
        ),
        (
          'Regular, filled',
          const CoreUnderlineTextField(
            label: 'Equipment',
            initialValue: 'Mini excavator - 1.5 ton',
          ),
        ),
        (
          'Large, empty with placeholder',
          const CoreUnderlineTextField(
            size: CoreUnderlineTextFieldSize.large,
            label: 'How many days?',
            hintText: '0',
          ),
        ),
        (
          'Large, filled',
          const CoreUnderlineTextField(
            size: CoreUnderlineTextFieldSize.large,
            label: 'How many days?',
            initialValue: '3',
          ),
        ),
      ]);

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/core_underline_text_field_rest_$name.png'),
      );
    });

    final focusedCases = <(String, String, Widget Function(FocusNode))>[
      (
        'regular_empty',
        'Regular, focused, empty with placeholder',
        (focusNode) => CoreUnderlineTextField(
              focusNode: focusNode,
              label: 'Equipment',
              hintText: 'Name the equipment',
            ),
      ),
      (
        'regular_filled',
        'Regular, focused, filled',
        (focusNode) => CoreUnderlineTextField(
              focusNode: focusNode,
              label: 'Equipment',
              initialValue: 'Mini excavator - 1.5 ton',
            ),
      ),
      (
        'large_filled',
        'Large, focused, filled',
        (focusNode) => CoreUnderlineTextField(
              focusNode: focusNode,
              size: CoreUnderlineTextFieldSize.large,
              label: 'How many days?',
              initialValue: '3',
            ),
      ),
    ];

    for (final (id, caption, build) in focusedCases) {
      testWidgets('CoreUnderlineTextField $id focused - $name', (tester) async {
        final focusNode = FocusNode();
        addTearDown(focusNode.dispose);

        await pumpScenarios(tester, theme, const Size(404, 152), [
          (caption, build(focusNode)),
        ]);
        focusNode.requestFocus();
        await tester.pump();
        await tester.pump();

        await expectLater(
          find.byType(Scaffold),
          matchesGoldenFile(
            'goldens/core_underline_text_field_focused_${id}_$name.png',
          ),
        );
      });
    }
  }
}
