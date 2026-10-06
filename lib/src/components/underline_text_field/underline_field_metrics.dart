import 'dart:math' as math;

import '../../theme/spacing.dart';
import 'core_underline_text_field_size.dart';

class UnderlineFieldMetrics {
  final double labelRowHeight;
  final double labelInset;
  final double labelGap;
  final double valueRowHeight;
  final double lineGap;
  final double strokeWidth;
  final double caretHeight;
  final double unitGap;

  const UnderlineFieldMetrics._({
    required this.labelRowHeight,
    required this.labelInset,
    required this.labelGap,
    required this.valueRowHeight,
    required this.lineGap,
    required this.strokeWidth,
    required this.caretHeight,
    required this.unitGap,
  });

  static const double horizontalInset = 2;
  static const double caretWidth = 2;
  static const double labelTrailingGap = 5;
  static const double inlineAccessoryGap = 12;
  static const double prefixGap = 2;

  static const UnderlineFieldMetrics _regular = UnderlineFieldMetrics._(
    labelRowHeight: CoreSpacing.space4,
    labelInset: horizontalInset,
    labelGap: 3,
    valueRowHeight: CoreSpacing.space6,
    lineGap: 10,
    strokeWidth: 1,
    caretHeight: 17,
    unitGap: 5,
  );

  static const UnderlineFieldMetrics _large = UnderlineFieldMetrics._(
    labelRowHeight: CoreSpacing.space5,
    labelInset: 0,
    labelGap: 6,
    valueRowHeight: CoreSpacing.space8,
    lineGap: 6,
    strokeWidth: 2,
    caretHeight: 24,
    unitGap: 8,
  );

  double labelRowHeightFor({required bool hasTrailing}) => hasTrailing
      ? math.max(labelRowHeight, CoreSpacing.space5)
      : labelRowHeight;

  double lineGapFor({required bool hasTrailing}) =>
      lineGap - (labelRowHeightFor(hasTrailing: hasTrailing) - labelRowHeight);

  factory UnderlineFieldMetrics.of(CoreUnderlineTextFieldSize size) {
    switch (size) {
      case CoreUnderlineTextFieldSize.regular:
        return _regular;
      case CoreUnderlineTextFieldSize.large:
        return _large;
    }
  }
}
