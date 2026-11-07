/// The sizes of a [CoreUnderlineTextField].
enum CoreUnderlineTextFieldSize {
  /// A 12px label over a 16px value, for forms that ask several questions
  /// at once. Every field on such a form uses the same size.
  regular,

  /// Drawn the same as [regular], for the fields of an open editor panel
  /// (waste, burden, delivery, note). The design's 6px underline gap is kept
  /// at 8px on the 4px grid.
  compact,

  /// A 14px label over a 24px semibold value, for a form that asks a single
  /// question and so enlarges its one number.
  large,
}
