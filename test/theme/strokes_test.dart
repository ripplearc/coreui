import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';
import 'package:ripplearc_coreui/src/components/calculator_chips/core_calculator_chip_theme.dart';
import 'package:ripplearc_coreui/src/components/chips/core_chip_theme.dart';
import 'package:ripplearc_coreui/src/components/underline_text_field/underline_field_metrics.dart';

/// The public constants that are [CoreStrokes.hairline] (CA-1490). The other
/// parts pass the token inline or through a private constant, at the value
/// they drew before, so their unchanged goldens are what checks them.
void main() {
  test('the hairline is one logical pixel', () {
    expect(CoreStrokes.hairline, 1.0);
  });

  test(
      'the divider, the chip-style button and the calculator chip draw '
      'their 1 px edge from the token', () {
    expect(CoreDivider.thickness, CoreStrokes.hairline);
    expect(CoreButton.hairlineBorderWidth, CoreStrokes.hairline);
    expect(CoreCalculatorChipTheme.borderWidth, CoreStrokes.hairline);
  });

  test(
      'a chip draws the token at rest and twice the token when it is '
      'focused or highlighted', () {
    expect(CoreChipTheme.borderWidth, CoreStrokes.hairline);
    expect(
      CoreChipTheme.borderWidthFor(isFocused: false),
      CoreStrokes.hairline,
    );
    expect(
      CoreChipTheme.borderWidthFor(isFocused: true),
      2 * CoreStrokes.hairline,
    );
    expect(
      CoreChipTheme.borderWidthFor(
        isFocused: false,
        outline: CoreChipOutline.highlight,
      ),
      2 * CoreStrokes.hairline,
    );
  });

  test(
      'the regular and compact underline fields draw the token, and the '
      'large one keeps its 2 px stroke', () {
    expect(
        UnderlineFieldMetrics.of(CoreUnderlineTextFieldSize.regular)
            .strokeWidth,
        CoreStrokes.hairline);
    expect(
        UnderlineFieldMetrics.of(CoreUnderlineTextFieldSize.compact)
            .strokeWidth,
        CoreStrokes.hairline);
    expect(
        UnderlineFieldMetrics.of(CoreUnderlineTextFieldSize.large).strokeWidth,
        2.0);
  });
}
