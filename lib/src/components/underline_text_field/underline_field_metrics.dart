import '../../theme/spacing.dart';
import 'core_underline_text_field_size.dart';

/// The measurements of a [CoreUnderlineTextField] at one size, in logical
/// pixels.
class UnderlineFieldMetrics {
  /// The minimum height of the row holding the label.
  final double labelRowHeight;

  /// The space either side of the label.
  final double labelInset;

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

  const UnderlineFieldMetrics._({
    required this.labelRowHeight,
    required this.labelInset,
    required this.labelGap,
    required this.valueRowHeight,
    required this.lineGap,
    required this.strokeWidth,
    required this.caretHeight,
  });

  /// The space either side of the value, so the caret is not clipped.
  static const double horizontalInset = 2;

  /// The width of the caret.
  static const double caretWidth = 2;

  static const UnderlineFieldMetrics _regular = UnderlineFieldMetrics._(
    labelRowHeight: CoreSpacing.space4,
    labelInset: horizontalInset,
    labelGap: 3,
    valueRowHeight: CoreSpacing.space6,
    lineGap: 10,
    strokeWidth: 1,
    caretHeight: 17,
  );

  static const UnderlineFieldMetrics _large = UnderlineFieldMetrics._(
    labelRowHeight: CoreSpacing.space5,
    labelInset: 0,
    labelGap: 6,
    valueRowHeight: CoreSpacing.space8,
    lineGap: 6,
    strokeWidth: 2,
    caretHeight: 24,
  );

  /// The measurements for [size].
  factory UnderlineFieldMetrics.of(CoreUnderlineTextFieldSize size) {
    switch (size) {
      case CoreUnderlineTextFieldSize.regular:
        return _regular;
      case CoreUnderlineTextFieldSize.large:
        return _large;
    }
  }
}
