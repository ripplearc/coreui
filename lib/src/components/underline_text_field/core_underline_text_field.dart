import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_typography_extension.dart';
import '../../theme/theme_extensions.dart';
import 'core_underline_text_field_size.dart';
import 'underline_field_message.dart';
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
/// At rest the underline is `lineDarkOutline` (`lineMid` for the
/// [CoreUnderlineTextFieldSize.large] size). While the field has focus it
/// turns `outlineHover`, and the caret is `outlineFocus`. The weight does not
/// change with focus: it is 1px for [CoreUnderlineTextFieldSize.regular] and
/// 2px for [CoreUnderlineTextFieldSize.large].
///
/// ### Placeholder
/// While the field is empty, [hintText] shows in the value row in
/// `textDisable`.
///
/// ### Tap target
/// The label, the value row and the underline all focus the field when
/// tapped. The text field's own accessibility node is 48px tall, though the
/// value row is drawn 24px or 32px tall, so the field meets the minimum tap
/// target without changing the design's spacing.
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
///   keyboardType: TextInputType.number,
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

  /// Owns focus for the field. When omitted the field keeps its own.
  final FocusNode? focusNode;

  /// The size of the label and value. Defaults to
  /// [CoreUnderlineTextFieldSize.regular].
  final CoreUnderlineTextFieldSize size;

  /// Called whenever the text changes.
  final ValueChanged<String>? onChanged;

  /// Called when the user finishes editing with the keyboard's action key.
  final ValueChanged<String>? onSubmitted;

  /// The keyboard to show for this field.
  final TextInputType? keyboardType;

  /// The action key to show on the keyboard.
  final TextInputAction? textInputAction;

  /// Filters or reshapes what the user types.
  final List<TextInputFormatter>? inputFormatters;

  /// The most characters the field accepts, with no counter drawn. Unlimited
  /// when `null`.
  final int? maxLength;

  /// Whether the field takes focus when it is first built.
  final bool autofocus;

  /// A widget beside the label, such as a badge. It makes the label row 20px
  /// tall and takes that height back from the gap above the underline, so the
  /// field keeps its height.
  final Widget? labelTrailing;

  /// Fixed text drawn before the value, such as `$`. It is part of the field,
  /// not of the typed text, so it shows while the field is empty and backspace
  /// never deletes it.
  final String? prefixText;

  /// Fixed text drawn right after the value in the same size, such as `%`.
  final String? suffixText;

  /// Fixed text drawn right after the value in a smaller size, such as `days`
  /// or `/gal`. Pass it only once there is a value to put it beside.
  final String? unitText;

  /// A widget right after the value and unit, such as a unit chip. The row
  /// grows to fit it and centers the value against it.
  final Widget? inlineAccessory;

  /// A widget at the far end of the value row, such as a lookup button. The
  /// row grows to fit it and centers the value against it.
  final Widget? trailing;

  /// A line under the field with an info icon, for a hint about what to type.
  /// Replaced by [errorText] while there is one.
  final String? helperText;

  /// A line under the field with an error icon. While it is set, and not
  /// empty, the label,
  /// the underline and the line itself turn to the error colors, and the
  /// underline stays in the error color on focus. It pushes whatever sits
  /// below the field down by one line, and a screen reader announces it as it
  /// appears.
  ///
  /// The field never decides when a value is wrong. The caller sets this, for
  /// instance only once the user has left the field.
  final String? errorText;

  /// The key of the underline, for tests to read its color and weight.
  @visibleForTesting
  static const Key underlineKey = Key('core_underline_text_field_underline');

  const CoreUnderlineTextField({
    super.key,
    this.label,
    this.hintText,
    this.controller,
    this.initialValue,
    this.focusNode,
    this.size = CoreUnderlineTextFieldSize.regular,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.maxLength,
    this.autofocus = false,
    this.labelTrailing,
    this.prefixText,
    this.suffixText,
    this.unitText,
    this.inlineAccessory,
    this.trailing,
    this.helperText,
    this.errorText,
  });

  @override
  State<CoreUnderlineTextField> createState() => _CoreUnderlineTextFieldState();
}

class _CoreUnderlineTextFieldState extends State<CoreUnderlineTextField> {
  TextEditingController? _ownedController;
  FocusNode? _ownedFocusNode;

  TextEditingController get _controller =>
      widget.controller ??
      (_ownedController ??= TextEditingController(text: widget.initialValue));

  FocusNode get _focusNode =>
      widget.focusNode ?? (_ownedFocusNode ??= FocusNode());

  bool get _isLarge => widget.size == CoreUnderlineTextFieldSize.large;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(CoreUnderlineTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      (oldWidget.focusNode ?? _ownedFocusNode)?.removeListener(
        _onFocusChanged,
      );
      _focusNode.addListener(_onFocusChanged);
      _releaseOwnedFocusNode();
    }
  }

  void _releaseOwnedFocusNode() {
    final owned = _ownedFocusNode;
    if (owned == null || widget.focusNode == null) return;
    _ownedFocusNode = null;
    WidgetsBinding.instance.addPostFrameCallback((_) => owned.dispose());
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);
    _ownedFocusNode?.dispose();
    _ownedController?.dispose();
    super.dispose();
  }

  void _onFocusChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.coreColors;
    final typography = theme.coreTypography;
    final metrics = UnderlineFieldMetrics.of(widget.size);
    final errorText = widget.errorText;
    final hasError = errorText != null && errorText.isNotEmpty;
    final message = hasError ? errorText : widget.helperText;
    final restLineColor = _isLarge ? colors.lineMid : colors.lineDarkOutline;
    final lineColor = _focusNode.hasFocus ? colors.outlineHover : restLineColor;

    final hasLabelTrailing = widget.labelTrailing != null;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      excludeFromSemantics: true,
      onTap: _focusNode.requestFocus,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.label != null || hasLabelTrailing) ...[
            _buildLabel(metrics, typography, colors, hasError: hasError),
            SizedBox(height: metrics.labelGap),
          ],
          _buildValueRow(metrics, typography, colors),
          SizedBox(height: metrics.lineGapFor(hasTrailing: hasLabelTrailing)),
          Container(
            key: CoreUnderlineTextField.underlineKey,
            height: metrics.strokeWidth,
            color: hasError ? colors.statusError : lineColor,
          ),
          if (message != null)
            UnderlineFieldMessage(text: message, isError: hasError),
        ],
      ),
    );
  }

  Widget _buildLabel(
    UnderlineFieldMetrics metrics,
    AppTypographyExtension typography,
    AppColorsExtension colors, {
    required bool hasError,
  }) {
    final style =
        _isLarge ? typography.bodyMediumRegular : typography.bodySmallRegular;

    final labelTrailing = widget.labelTrailing;

    return Container(
      height: metrics.labelRowHeightFor(hasTrailing: labelTrailing != null),
      padding: EdgeInsets.symmetric(horizontal: metrics.labelInset),
      child: Row(
        children: [
          Flexible(
            child: ExcludeSemantics(
              child: Text(
                widget.label ?? '',
                style: style.copyWith(
                  color: hasError ? colors.textError : colors.textBody,
                ),
              ),
            ),
          ),
          if (labelTrailing != null) ...[
            const SizedBox(width: UnderlineFieldMetrics.labelTrailingGap),
            labelTrailing,
          ],
        ],
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

    final softStyle = style.copyWith(color: colors.textBody);
    final unitStyle =
        (_isLarge ? typography.bodyLargeRegular : typography.bodySmallRegular)
            .copyWith(color: colors.textBody);
    final prefixText = widget.prefixText;
    final suffixText = widget.suffixText;
    final unitText = widget.unitText;
    final inlineAccessory = widget.inlineAccessory;
    final trailing = widget.trailing;
    final input = _buildInput(metrics, style, colors);
    final hugsValue =
        suffixText != null || unitText != null || inlineAccessory != null;

    final valueGroup = Row(
      mainAxisSize: hugsValue ? MainAxisSize.min : MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        if (prefixText != null) ...[
          Text(prefixText, style: softStyle),
          const SizedBox(width: UnderlineFieldMetrics.prefixGap),
        ],
        if (hugsValue)
          Flexible(child: IntrinsicWidth(child: input))
        else
          Expanded(child: input),
        if (suffixText != null) Text(suffixText, style: softStyle),
        if (unitText != null) ...[
          SizedBox(width: metrics.unitGap),
          Text(unitText, style: unitStyle),
        ],
      ],
    );

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: metrics.valueRowHeight),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: UnderlineFieldMetrics.horizontalInset,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                children: [
                  if (hugsValue)
                    Flexible(child: valueGroup)
                  else
                    Expanded(child: valueGroup),
                  if (inlineAccessory != null) ...[
                    const SizedBox(
                      width: UnderlineFieldMetrics.inlineAccessoryGap,
                    ),
                    inlineAccessory,
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildInput(
    UnderlineFieldMetrics metrics,
    TextStyle style,
    AppColorsExtension colors,
  ) {
    return SizedBox(
      height: metrics.valueRowHeight,
      child: OverflowBox(
        maxHeight: kMinInteractiveDimension,
        child: Semantics(
          label: widget.label,
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            onChanged: widget.onChanged,
            onSubmitted: widget.onSubmitted,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            autofocus: widget.autofocus,
            inputFormatters: [
              ...?widget.inputFormatters,
              if (widget.maxLength != null)
                LengthLimitingTextInputFormatter(widget.maxLength),
            ],
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
