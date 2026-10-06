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

  // TODO: [CA-1238] https://ripplearc.youtrack.cloud/issue/CA-1238
  // CoreSpacing has no 2, 3, 5, 6 or 10 step. Replace these with tokens once
  // they exist.
  static const double _px2 = 2;
  static const double _px3 = 3;
  static const double _px5 = 5;
  static const double _px6 = 6;
  static const double _px10 = 10;

  static const double horizontalInset = _px2;
  static const double caretWidth = _px2;
  static const double caretGap = _px2;
  static const double labelTrailingGap = _px5;
  static const double inlineAccessoryGap = CoreSpacing.space3;
  static const double prefixGap = _px2;
  static const double messageTopGap = CoreSpacing.space2;

  static const UnderlineFieldMetrics _regular = UnderlineFieldMetrics._(
    labelRowHeight: CoreSpacing.space4,
    labelInset: horizontalInset,
    labelGap: _px3,
    valueRowHeight: CoreSpacing.space6,
    lineGap: _px10,
    strokeWidth: 1,
    caretHeight: 17,
    unitGap: _px5,
  );

  static const UnderlineFieldMetrics _compact = UnderlineFieldMetrics._(
    labelRowHeight: CoreSpacing.space4,
    labelInset: horizontalInset,
    labelGap: _px3,
    valueRowHeight: CoreSpacing.space6,
    lineGap: CoreSpacing.space2,
    strokeWidth: 1,
    caretHeight: 17,
    unitGap: _px5,
  );

  static const UnderlineFieldMetrics _large = UnderlineFieldMetrics._(
    labelRowHeight: CoreSpacing.space5,
    labelInset: 0,
    labelGap: _px6,
    valueRowHeight: CoreSpacing.space8,
    lineGap: _px6,
    strokeWidth: 2,
    caretHeight: CoreSpacing.space6,
    unitGap: CoreSpacing.space2,
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
      case CoreUnderlineTextFieldSize.compact:
        return _compact;
      case CoreUnderlineTextFieldSize.large:
        return _large;
    }
  }
}
