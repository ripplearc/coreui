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

  const options = [
    CorePreferenceOption(id: '0.0', label: '0.0'),
    CorePreferenceOption(id: '0.00', label: '0.00'),
    CorePreferenceOption(id: '0.000', label: '0.000'),
  ];

  /// Sizes the surface and pumps [child] under [theme]. The sheet body is
  /// rendered directly rather than through CoreQuickSheet, so the golden
  /// frames the component and not the scrim behind it.
  Future<void> pumpBody(
    WidgetTester tester,
    ThemeData theme,
    Widget child,
  ) async {
    tester.view.physicalSize = const Size(780, 800);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: Scaffold(
          backgroundColor: theme.coreColors.pageBackground,
          body: Center(child: child),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Widget buildOptionSheet({bool withInfo = false}) =>
      CorePreferenceOptionSheet(
        title: 'Meter length display',
        options: options,
        selectedOptionId: '0.0',
        updateLabel: 'Update',
        backSemanticsLabel: 'Back to preferences',
        info: withInfo
            ? const CorePreferenceInfo(
                title: 'Meter length display',
                description:
                    'Changes the number of decimal places meter values are '
                    'displayed',
                semanticsLabel: 'About this preference',
                closeLabel: 'Close',
              )
            : null,
        infoButtonKey: const Key('info_button'),
        onUpdate: (_) {},
      );

  for (final (name, theme) in [
    ('light', _withRoboto(CoreTheme.light())),
    ('dark', _withRoboto(CoreTheme.dark())),
  ]) {
    testWidgets('CorePreferenceOptionSheet Visual Regression - $name',
        (tester) async {
      await pumpBody(tester, theme, buildOptionSheet());

      await expectLater(
        find.byType(CorePreferenceOptionSheet),
        matchesGoldenFile('goldens/core_preference_option_sheet_$name.png'),
      );
    });

    testWidgets('CorePreferenceOptionSheet Visual Regression - info - $name',
        (tester) async {
      await pumpBody(tester, theme, buildOptionSheet(withInfo: true));
      await tester.tap(find.byKey(const Key('info_button')));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(CorePreferenceOptionSheet),
        matchesGoldenFile('goldens/core_preference_option_sheet_info_$name.png'),
      );
    });
  }
}
