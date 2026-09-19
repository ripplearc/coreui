import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';
import 'package:ripplearc_coreui/src/components/preferences_sheet/preference_value_view.dart';

void main() {
  late AppColorsExtension colors;

  Future<void> pumpValue(WidgetTester tester, CorePreferenceValue value) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: CoreTheme.light(),
        home: Builder(
          builder: (context) {
            colors = AppColorsExtension.of(context);
            return Scaffold(body: PreferenceValueView(value: value));
          },
        ),
      ),
    );
  }

  Color colorOf(WidgetTester tester, String text) {
    return tester.widget<Text>(find.text(text)).style!.color!;
  }

  group('text values', () {
    testWidgets('an actionable value reads as a link', (tester) async {
      await pumpValue(tester, const CorePreferenceTextValue('1/16'));

      expect(find.text('1/16'), findsOneWidget);
      expect(colorOf(tester, '1/16'), colors.textLink);
    });

    testWidgets('a value the app cannot act on yet reads as disabled',
        (tester) async {
      await pumpValue(
        tester,
        const CorePreferenceTextValue('std', isMuted: true),
      );

      expect(colorOf(tester, 'std'), colors.textDisable);
    });
  });

  group('pill values', () {
    /// The dot and the outline share one accent, so reading the border back
    /// is enough to know which state the pill is drawn in.
    Color accentOf(WidgetTester tester) {
      final decoration = tester
          .widget<Container>(find.ancestor(
            of: find.byType(Row),
            matching: find.byType(Container),
          ).first)
          .decoration! as BoxDecoration;
      return decoration.border!.top.color;
    }

    testWidgets('an on pill takes the green accent', (tester) async {
      await pumpValue(
        tester,
        const CorePreferencePillValue('Imperial', isOn: true),
      );

      expect(find.text('Imperial'), findsOneWidget);
      expect(accentOf(tester), colors.iconGreen);
      expect(colorOf(tester, 'Imperial'), colors.textSuccess);
    });

    testWidgets('an off pill takes the grey accent', (tester) async {
      await pumpValue(
        tester,
        const CorePreferencePillValue('Off', isOn: false),
      );

      expect(accentOf(tester), colors.iconGrayMid);
      expect(colorOf(tester, 'Off'), colors.textBody);
    });
  });
}
