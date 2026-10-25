import 'dart:math' as math;

import '../../theme/spacing.dart';
import 'core_underline_text_field_size.dart';

/// The measurements of a [CoreUnderlineTextField] at one size, in logical
/// pixels.
class UnderlineFieldMetrics {
  /// The minimum height of the row holding the label.
  final double labelRowHeight;

  /// The space between the label row and the value row.
  final double labelGap;

  /// The minimum height of the row holding the value.
  final double valueRowHeight;

  /// The space between the value row and the underline.
  final double lineGap;

  /// The thickness of the underline.
  final double strokeWidth;

  /// The height of the caret.
  final double caretHeight;

  /// The space between the value and the unit text.
  final double unitGap;

  const UnderlineFieldMetrics._({
    required this.labelRowHeight,
    required this.labelGap,
    required this.valueRowHeight,
    required this.lineGap,
    required this.strokeWidth,
    required this.caretHeight,
    required this.unitGap,
  });

  // TODO: [CA-1238] use CoreSpacing.px2/px5/px6/px17 when they exist
  static const double _px2 = 2;
  static const double _px5 = 5;
  static const double _px6 = 6;
  static const double _px17 = 17;

  /// The width of the caret.
  static const double caretWidth = _px2;

  /// The space between the label and the widget after it.
  static const double labelTrailingGap = _px5;

  /// The space between the value and the inline accessory.
  static const double inlineAccessoryGap = CoreSpacing.space3;

  /// The space between the underline and the helper or error line.
  static const double messageTopGap = CoreSpacing.space2;

  static const UnderlineFieldMetrics _regular = UnderlineFieldMetrics._(
    labelRowHeight: CoreSpacing.space4,
    labelGap: CoreSpacing.space1,
    valueRowHeight: CoreSpacing.space6,
    lineGap: CoreSpacing.space2,
    strokeWidth: 1,
    caretHeight: _px17,
    unitGap: CoreSpacing.space1,
  );

  static const UnderlineFieldMetrics _compact = UnderlineFieldMetrics._(
    labelRowHeight: CoreSpacing.space4,
    labelGap: CoreSpacing.space1,
    valueRowHeight: CoreSpacing.space6,
    lineGap: _px6,
    strokeWidth: 1,
    caretHeight: _px17,
    unitGap: CoreSpacing.space1,
  );

  static const UnderlineFieldMetrics _large = UnderlineFieldMetrics._(
    labelRowHeight: CoreSpacing.space5,
    labelGap: CoreSpacing.space1,
    valueRowHeight: CoreSpacing.space8,
    lineGap: CoreSpacing.space2,
    strokeWidth: 2,
    caretHeight: CoreSpacing.space6,
    unitGap: CoreSpacing.space2,
  );

  /// The minimum height of the label row, taller when a widget follows the
  /// label.
  double labelRowHeightFor({required bool hasTrailing}) => hasTrailing
      ? math.max(labelRowHeight, CoreSpacing.space5)
      : labelRowHeight;

  /// The space above the underline, reduced by the height a trailing label
  /// widget added to the label row.
  double lineGapFor({required bool hasTrailing}) =>
      lineGap - (labelRowHeightFor(hasTrailing: hasTrailing) - labelRowHeight);

  /// The measurements for [size].
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
