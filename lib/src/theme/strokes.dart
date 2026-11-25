/// Core stroke-width tokens for the lines the components draw.
///
/// A token is named by what the line is, not by its dp value, so a change to
/// the hairline is made once here and every rule, border and underline that
/// uses it follows.
class CoreStrokes {
  CoreStrokes._();

  /// One logical pixel: the rule of [CoreDivider], the date picker header
  /// and the sheet header, the border of a calculator chip, a [CoreChip], a
  /// chip-style [CoreButton], a status badge, a details row, an outlined
  /// icon button and the switch's off track, the outline of a text field
  /// and a search box and the rule beside a phone prefix, the ring round
  /// today in the date picker, and the underline of a regular or compact
  /// underline field. Not Flutter's `0` device-pixel hairline, so a
  /// high-DPR screen paints it several device pixels wide.
  static const double hairline = 1.0;
}
