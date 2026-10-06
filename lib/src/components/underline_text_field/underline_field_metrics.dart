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

  const UnderlineFieldMetrics._({
    required this.labelRowHeight,
    required this.labelInset,
    required this.labelGap,
    required this.valueRowHeight,
    required this.lineGap,
    required this.strokeWidth,
    required this.caretHeight,
  });

  static const double horizontalInset = 2;
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

  factory UnderlineFieldMetrics.of(CoreUnderlineTextFieldSize size) {
    switch (size) {
      case CoreUnderlineTextFieldSize.regular:
        return _regular;
      case CoreUnderlineTextFieldSize.large:
        return _large;
    }
  }
}
