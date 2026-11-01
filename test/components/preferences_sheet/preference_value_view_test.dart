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

    testWidgets('a read-only value reads as body text, not disabled',
        (tester) async {
      await pumpValue(
        tester,
        const CorePreferenceTextValue('std', isMuted: true),
      );

      expect(colorOf(tester, 'std'), colors.textBody);
    });

    testWidgets('a text value is Body Medium Semibold', (tester) async {
      await pumpValue(tester, const CorePreferenceTextValue('1/16'));

      final style = tester.widget<Text>(find.text('1/16')).style!;
      final expected = AppTypographyExtension.create().bodyMediumSemiBold;
      expect(style.fontSize, expected.fontSize);
      expect(style.fontWeight, expected.fontWeight);
    });
  });

  group('pill values', () {
    /// The dot and the outline share one accent, so reading the border back
    /// is enough to know which state the pill is drawn in.
    Color accentOf(WidgetTester tester) {
      final decoration = tester
          .widget<Container>(find.byKey(PreferenceValueView.pillKey))
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

    testWidgets('pill text is Body Small Regular, as the library draws it',
        (tester) async {
      await pumpValue(
        tester,
        const CorePreferencePillValue('Imperial', isOn: true),
      );

      final style = tester.widget<Text>(find.text('Imperial')).style!;
      final expected = AppTypographyExtension.create().bodySmallRegular;
      expect(style.fontSize, expected.fontSize);
      expect(style.fontWeight, expected.fontWeight);
    });

    // Library Setting List, Switch row (Figma 66778:196399): a 14 dp dot
    // 5 dp from the pill's outer edge and 4 dp before the text, in a pill
    // 24 dp high.
    testWidgets('the dot, its gap and the pill height match the library',
        (tester) async {
      await pumpValue(
        tester,
        const CorePreferencePillValue('Imperial', isOn: true),
      );

      final pill = tester.getRect(find.byKey(PreferenceValueView.pillKey));
      final dot = tester.getRect(find.byKey(PreferenceValueView.dotKey));
      final text = tester.getRect(find.text('Imperial'));

      expect(dot.size, const Size(14, 14));
      expect(dot.left - pill.left, 5);
      expect(text.left - dot.right, 4);
      expect(pill.height, 24);
    });

    testWidgets('the pill grows with 2.0 text, so the label is not cut',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(2.0)),
            child: Scaffold(
              body: PreferenceValueView(
                value: CorePreferencePillValue('Imperial', isOn: true),
              ),
            ),
          ),
        ),
      );

      final pill = tester.getRect(find.byKey(PreferenceValueView.pillKey));
      final text = tester.getRect(find.text('Imperial'));

      expect(text.height, greaterThan(24));
      expect(pill.top, lessThan(text.top));
      expect(pill.bottom, greaterThan(text.bottom));
    });
  });
}
