import 'package:flutter/material.dart';

import '../../theme/app_typography_extension.dart';
import '../../theme/theme_extensions.dart';
import 'core_underline_text_field_size.dart';
import 'underline_field_metrics.dart';

/// A text field drawn as a label over a value with a single rule beneath it,
/// for dense stacked forms such as the "New material, labor or equipment cost"
/// family of screens.
///
/// It is a sibling of [CoreTextField], not a replacement: [CoreTextField]
/// draws an outlined box, this field draws no border at all. The only line is
/// the underline, which is the field's whole focus affordance.
///
/// ### Underline
/// The underline is `lineDarkOutline` (`lineMid` for the
/// [CoreUnderlineTextFieldSize.large] size) and the caret is `outlineFocus`.
/// It is 1px for [CoreUnderlineTextFieldSize.regular] and 2px for
/// [CoreUnderlineTextFieldSize.large].
///
/// ### Placeholder
/// While the field is empty, [hintText] shows in the value row in
/// `textDisable`.
///
/// ### Tap target
/// The text field's accessibility node is 48px tall, though the value row is
/// drawn 24px or 32px tall, so the field meets the minimum tap target without
/// changing the design's spacing.
///
/// ### Strings
/// This field owns no user-facing strings. Every label and hint is passed in
/// by the caller, who localises it.
///
/// ---
/// ## Examples
///
/// ### 1) A form field with a placeholder
/// ```dart
/// CoreUnderlineTextField(
///   label: 'Equipment',
///   hintText: 'Name the equipment',
///   onChanged: (value) => bloc.add(NameChanged(value)),
/// )
/// ```
///
/// ### 2) A single-question form
/// ```dart
/// CoreUnderlineTextField(
///   size: CoreUnderlineTextFieldSize.large,
///   label: 'Amount',
/// )
/// ```
class CoreUnderlineTextField extends StatefulWidget {
  /// The small caption above the value.
  final String? label;

  /// The dimmed text shown in the value row while the field is empty.
  final String? hintText;

  /// Controls the text. When omitted the field keeps its own, seeded with
  /// [initialValue].
  final TextEditingController? controller;

  /// The text the field starts with. Ignored when [controller] is given.
  final String? initialValue;

  /// The size of the label and value. Defaults to
  /// [CoreUnderlineTextFieldSize.regular].
  final CoreUnderlineTextFieldSize size;

  /// Called whenever the text changes.
  final ValueChanged<String>? onChanged;

  /// The key of the underline, for tests to read its color and weight.
  @visibleForTesting
  static const Key underlineKey = Key('core_underline_text_field_underline');

  const CoreUnderlineTextField({
    super.key,
    this.label,
    this.hintText,
    this.controller,
    this.initialValue,
    this.size = CoreUnderlineTextFieldSize.regular,
    this.onChanged,
  });

  @override
  State<CoreUnderlineTextField> createState() => _CoreUnderlineTextFieldState();
}

class _CoreUnderlineTextFieldState extends State<CoreUnderlineTextField> {
  TextEditingController? _ownedController;

  TextEditingController get _controller =>
      widget.controller ??
      (_ownedController ??= TextEditingController(text: widget.initialValue));

  bool get _isLarge => widget.size == CoreUnderlineTextFieldSize.large;

  @override
  void dispose() {
    _ownedController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.coreColors;
    final typography = theme.coreTypography;
    final metrics = UnderlineFieldMetrics.of(widget.size);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          _buildLabel(metrics, typography, colors),
          SizedBox(height: metrics.labelGap),
        ],
        _buildValueRow(metrics, typography, colors),
        SizedBox(height: metrics.lineGap),
        Container(
          key: CoreUnderlineTextField.underlineKey,
          height: metrics.strokeWidth,
          color: _isLarge ? colors.lineMid : colors.lineDarkOutline,
        ),
      ],
    );
  }

  Widget _buildLabel(
    UnderlineFieldMetrics metrics,
    AppTypographyExtension typography,
    AppColorsExtension colors,
  ) {
    final style =
        _isLarge ? typography.bodyMediumRegular : typography.bodySmallRegular;

    return Container(
      height: metrics.labelRowHeight,
      padding: EdgeInsets.symmetric(horizontal: metrics.labelInset),
      child: ExcludeSemantics(
        child: Text(
          widget.label ?? '',
          style: style.copyWith(color: colors.textBody),
        ),
      ),
    );
  }

  Widget _buildValueRow(
    UnderlineFieldMetrics metrics,
    AppTypographyExtension typography,
    AppColorsExtension colors,
  ) {
    final style = _isLarge
        ? typography.headlineMediumSemiBold
        : typography.bodyLargeRegular;

    return Container(
      height: metrics.valueRowHeight,
      padding: const EdgeInsets.symmetric(
        horizontal: UnderlineFieldMetrics.horizontalInset,
      ),
      child: OverflowBox(
        maxHeight: kMinInteractiveDimension,
        child: Semantics(
          label: widget.label,
          child: TextField(
            controller: _controller,
            onChanged: widget.onChanged,
            style: style.copyWith(color: colors.textHeadline),
            cursorColor: colors.outlineFocus,
            cursorWidth: UnderlineFieldMetrics.caretWidth,
            cursorHeight: metrics.caretHeight,
            decoration: InputDecoration(
              isCollapsed: true,
              contentPadding: EdgeInsets.symmetric(
                vertical:
                    (kMinInteractiveDimension - metrics.valueRowHeight) / 2,
              ),
              hintText: widget.hintText,
              hintStyle: style.copyWith(color: colors.textDisable),
              filled: false,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
