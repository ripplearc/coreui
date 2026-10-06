/// The sizes of a [CoreUnderlineTextField].
enum CoreUnderlineTextFieldSize {
  /// A 12px label over a 16px value, for forms that ask several questions
  /// at once. Every field on such a form uses the same size.
  regular,

  /// The regular label and value with the underline 2px closer to the value,
  /// for the fields of an open editor panel (waste, burden, delivery, note).
  compact,

  /// A 14px label over a 24px semibold value, for a form that asks a single
  /// question and so enlarges its one number.
  large,
}
