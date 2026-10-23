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
    testWidgets('CoreUnderlineTextField with several lines - $name',
        (tester) async {
      await pumpScenarios(tester, theme, const Size(404, 540), [
        (
          'Several lines, short text',
          const CoreUnderlineTextField(
            label: 'Scope of work',
            maxLines: 4,
            initialValue: 'Demolition of the existing kitchen.',
          ),
        ),
        (
          'Several lines, long text (scrolls past four)',
          const CoreUnderlineTextField(
            label: 'Scope of work',
            maxLines: 4,
            initialValue: 'Demolition of the existing kitchen, removal of all '
                'cabinets and appliances, new subfloor, new tile flooring, '
                'new cabinets, new countertops, paint, new lighting, new '
                'plumbing fixtures and a final clean of the whole room.',
          ),
        ),
        (
          'Several lines, hint',
          const CoreUnderlineTextField(
            label: 'Terms',
            maxLines: 4,
            initialValue: 'Net 30 from the date of invoice.',
            helperText: 'Shown on the estimate the client receives.',
          ),
        ),
        (
          'Several lines, error',
          const CoreUnderlineTextField(
            label: 'Scope of work',
            maxLines: 4,
            initialValue: 'Kitchen',
            errorText: 'Describe the work in at least two sentences.',
          ),
        ),
      ]);

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile(
          'goldens/core_underline_text_field_multiline_$name.png',
        ),
      );
    });
  }
}
