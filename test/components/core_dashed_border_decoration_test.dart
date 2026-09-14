import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';
import 'package:ripplearc_coreui/src/components/calculator_chips/core_calculator_chip_theme.dart';

void main() {
  group('CoreDashedBorderDecoration', () {
    final colors = AppColorsExtension.create();

    CoreDashedBorderDecoration decoration({
      required Color color,
      double strokeWidth = CoreCalculatorChipTheme.borderWidth,
    }) {
      return CoreDashedBorderDecoration(
        color: color,
        strokeWidth: strokeWidth,
        radius: CoreSpacing.space6,
        dashLength: CoreSpacing.space1,
        gapLength: CoreSpacing.space1,
      );
    }

    test('equal configurations compare equal', () {
      expect(
        decoration(color: colors.outlineFocus),
        decoration(color: colors.outlineFocus),
      );
      expect(
        decoration(color: colors.outlineFocus).hashCode,
        decoration(color: colors.outlineFocus).hashCode,
      );
      expect(
        decoration(color: colors.outlineFocus),
        isNot(decoration(color: colors.lineMid)),
      );
      expect(
        decoration(color: colors.outlineFocus),
        isNot(decoration(
          color: colors.outlineFocus,
          strokeWidth: CoreCalculatorChipTheme.borderWidth * 2,
        )),
      );
    });

    test('interpolates by stepping instead of throwing', () {
      final a = decoration(color: colors.outlineFocus);
      final b = decoration(color: colors.lineMid);
      expect(Decoration.lerp(a, b, 0.25), a);
      expect(Decoration.lerp(a, b, 0.75), b);
      expect(Decoration.lerp(null, b, 0.5), b);
    });

    testWidgets('paints as a foreground decoration without error',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: Center(
              child: Container(
                width: CoreSpacing.space24,
                height: CoreSpacing.space7,
                foregroundDecoration: decoration(color: colors.outlineFocus),
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });
  });
}
