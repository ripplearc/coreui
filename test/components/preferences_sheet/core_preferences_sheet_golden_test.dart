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

  const sections = [
    CorePreferenceSection(
      rows: [
        CorePreferenceRow(
          key: 'system_of_units',
          label: 'System of units',
          value: CorePreferencePillValue('Imperial', isOn: true),
          selectedOptionId: 'imperial',
          options: [
            CorePreferenceOption(id: 'imperial', label: 'Imperial'),
            CorePreferenceOption(id: 'metric', label: 'Metric'),
          ],
        ),
      ],
    ),
    CorePreferenceSection(
      title: 'Display',
      rows: [
        CorePreferenceRow(
          key: 'fractional_resolution',
          label: 'Fractional resolution',
          value: CorePreferenceTextValue('1/16'),
        ),
        CorePreferenceRow(
          key: 'fractional_mode',
          label: 'Fractional mode',
          value: CorePreferenceTextValue('std: nearest fraction',
              isMuted: true),
        ),
        CorePreferenceRow(
          key: 'length_format',
          label: 'Length display format',
          value: CorePreferenceTextValue('in'),
        ),
        CorePreferenceRow(
          key: 'pounds_per_ton',
          label: 'Pounds per ton',
          value: CorePreferenceTextValue('2,000 lb (US short ton)'),
        ),
        CorePreferenceRow(
          key: 'thousands_separator',
          label: 'Thousands separator',
          value: CorePreferencePillValue('Off', isOn: false),
        ),
      ],
    ),
  ];

  /// Sizes the surface and pumps [child] under [theme]. The sheet body is
  /// rendered directly rather than through CoreQuickSheet, so the golden
  /// frames the component and not the scrim behind it.
  Future<void> pumpBody(
    WidgetTester tester,
    ThemeData theme,
    Widget child,
  ) async {
    tester.view.physicalSize = const Size(780, 1400);
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

  Widget buildList() => CorePreferencesSheet(
        title: 'Preferences',
        sections: sections,
        onChanged: (_, __) {},
        optionUpdateLabel: 'Update',
        optionBackSemanticsLabel: 'Back to preferences',
      );

  for (final (name, theme) in [
    ('light', _withRoboto(CoreTheme.light())),
    ('dark', _withRoboto(CoreTheme.dark())),
  ]) {
    testWidgets('CorePreferencesSheet Visual Regression - $name',
        (tester) async {
      await pumpBody(tester, theme, buildList());

      await expectLater(
        find.byType(CorePreferencesSheet),
        matchesGoldenFile('goldens/core_preferences_sheet_$name.png'),
      );
    });

  }
}
