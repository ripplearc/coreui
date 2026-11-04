import 'package:flutter/material.dart';

import '../../theme/app_typography_extension.dart';
import '../../theme/icons/core_icons.dart';
import '../../theme/spacing.dart';
import '../../theme/theme_extensions.dart';
import '../core_icon.dart';

/// A custom text field widget with optional label, helper text, and error text
class CoreTextField extends StatelessWidget {
  /// Label inside the empty field that floats above it on focus or text.
  final String? label;

  /// Text under the field after an info icon. Hidden when null.
  final String? helperText;

  /// Grey text inside the field while it is empty.
  final String? hintText;

  /// Error lines under the field, each after a red error icon; the border
  /// turns red. Don't pass it with [errorWidgetList]: the build throws.
  final List<String>? errorTextList;

  /// Like [errorTextList], with your own widget after each icon.
  final List<Widget>? errorWidgetList;

  /// Hides the text as dots and shows an eye icon unless [suffix] is set.
  /// The icon does not toggle the text. Defaults to false.
  final bool obscureText;

  /// Makes this a phone field: a `+1` style prefix button replaces
  /// [prefix] and the phone keyboard opens. Defaults to false.
  final bool isPhoneNumber;

  /// Controller for the text. Don't pass it with [initialValue].
  final TextEditingController? controller;

  /// Called with the new text on every edit.
  final void Function(String)? onChanged;

  /// Keyboard to open. Ignored when [isPhoneNumber] is true.
  final TextInputType? keyboardType;

  /// When false the field draws its disabled look and takes no input.
  /// Defaults to true.
  final bool enabled;

  /// Checks the text when the enclosing [Form] validates; return an error
  /// message or null.
  final String? Function(String?)? validator;

  /// Focus node for the field.
  final FocusNode? focusNode;

  /// Text the field starts with when no [controller] is set.
  final String? initialValue;

  /// Shows the text without letting it be edited, in the disabled colours.
  /// Defaults to false.
  final bool readOnly;

  /// Draws the focused border and label without taking focus, for a field
  /// that only shows a choice whose tap target holds the focus, such as
  /// [SingleItemSelector]. Defaults to false.
  final bool showsFocus;

  /// Keeps the label above the field, so an empty field that never takes
  /// focus, such as [SingleItemSelector], shows its [hintText]. Defaults to
  /// false.
  final bool floatsLabel;

  /// Widget before the text. Replaced by the prefix button when
  /// [isPhoneNumber] is true.
  final Widget? prefix;

  /// Widget after the text.
  final Widget? suffix;

  /// Prefix shown on the phone prefix button. Defaults to `+1`.
  final String? phonePrefix;

  /// Called with the prefix picked in the prefix sheet. The caller passes
  /// it back as [phonePrefix].
  final void Function(String?)? onPhonePrefixChanged;

  /// Prefixes listed in the sheet the prefix button opens. When null the
  /// sheet lists none.
  final List<String>? phonePrefixes;

  /// Heading of the prefix sheet. Defaults to the English "Select Country
  /// Code".
  final String? countryCodePickerTitle;

  /// Creates an outlined text field.
  const CoreTextField({
    super.key,
    this.label,
    this.helperText,
    this.hintText,
    this.errorTextList,
    this.errorWidgetList,
    this.obscureText = false,
    this.controller,
    this.onChanged,
    this.keyboardType,
    this.enabled = true,
    this.validator,
    this.focusNode,
    this.initialValue,
    this.readOnly = false,
    this.showsFocus = false,
    this.floatsLabel = false,
    this.prefix,
    this.suffix,
    this.isPhoneNumber = false,
    this.phonePrefix = '+1',
    this.onPhonePrefixChanged,
    this.phonePrefixes,
    this.countryCodePickerTitle,
  });

  @override
  Widget build(BuildContext context) {
    Widget? prefixWidget = prefix;

    if (isPhoneNumber) {
      prefixWidget = _buildPhonePrefixButton(context);
    }

    final bool isDisabled = !enabled || readOnly;
    final bool hasError = errorTextList != null || errorWidgetList != null;
    final typography = Theme.of(context).coreTypography;
    final colors = Theme.of(context).coreColors;
    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(color: colors.outlineHover),
    );

    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      focusNode: focusNode,
      enabled: enabled,
      readOnly: readOnly,
      obscureText: obscureText,
      onChanged: onChanged,
      validator: validator,
      cursorColor: isDisabled ? colors.transparent : colors.outlineFocus,
      keyboardType: isPhoneNumber ? TextInputType.phone : keyboardType,
      style: typography.bodyLargeRegular.copyWith(
        color: isDisabled ? colors.textDisable : colors.textDark,
      ),
      decoration: InputDecoration(
        floatingLabelStyle: typography.bodySmallRegular.copyWith(
          color: isDisabled
              ? colors.textDisable
              : (hasError ? colors.textError : colors.textDark),
        ),
        hoverColor: isDisabled
            ? colors.backgroundGrayMid
            : colors.pageBackground,
        fillColor: isDisabled
            ? colors.backgroundGrayMid
            : colors.pageBackground,
        filled: true,
        labelText: label,
        floatingLabelBehavior:
            floatsLabel ? FloatingLabelBehavior.always : null,
        labelStyle: typography.bodyLargeRegular.copyWith(
          color: isDisabled
              ? colors.textDisable
              : showsFocus
                  ? colors.textDark
                  : colors.textHeadline,
        ),
        prefixIcon: prefixWidget,
        hintText: hintText,
        hintStyle: typography.bodyLargeRegular.copyWith(
          color: colors.textDisable,
        ),
        suffixIcon: (obscureText
            ? suffix ?? const Icon(Icons.visibility)
            : suffix),
        error: !hasError
            ? null
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    _buildErrorWidgetList(
                      context,
                      errorTextList,
                      errorWidgetList,
                    ) ??
                    [],
              ),
        helper: helperText == null
            ? null
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CoreIconWidget(
                    icon: CoreIcons.info,
                    size: 16,
                    color: colors.iconGrayMid,
                  ),
                  const SizedBox(width: CoreSpacing.space1),
                  Flexible(
                    child: Text(
                      helperText ?? "",
                      style: typography.bodySmallRegular.copyWith(
                        color: isDisabled
                            ? colors.textDisable
                            : colors.textHeadline,
                      ),
                    ),
                  ),
                ],
              ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(
            color: isDisabled ? colors.lineMid : colors.lineDarkOutline,
          ),
        ),
        enabledBorder: showsFocus
            ? focusedBorder
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(
                  color: isDisabled ? colors.lineMid : colors.lineDarkOutline,
                ),
              ),
        focusedBorder: focusedBorder,
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: colors.statusError),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: colors.statusError),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: colors.lineMid),
        ),
      ),
    );
  }

  List<Widget>? _buildErrorWidgetList(
    BuildContext context,
    List<String>? errorTextList,
    List<Widget>? errorWidgetList,
  ) {
    if (errorTextList == null && errorWidgetList == null) return null;
    if (errorTextList != null && errorWidgetList != null) {
      throw ArgumentError(
        'errorTextList and errorWidgetList cannot be provided together',
      );
    }
    if (errorTextList != null) {
      return errorTextList
          .map((errorText) => _buildErrorWidget(context, errorText: errorText))
          .toList();
    }
    if (errorWidgetList != null) {
      return errorWidgetList
          .map(
            (errorWidget) =>
                _buildErrorWidget(context, errorWidget: errorWidget),
          )
          .toList();
    }
    return null;
  }

  Widget _buildErrorWidget(
    BuildContext context, {
    String? errorText,
    Widget? errorWidget,
  }) {
    final typography = Theme.of(context).coreTypography;
    final colors = Theme.of(context).coreColors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CoreIconWidget(icon: CoreIcons.error, size: 16, color: colors.iconRed),
        const SizedBox(width: CoreSpacing.space1),
        if (errorWidget != null)
          Expanded(child: errorWidget)
        else if (errorText != null)
          Expanded(
            child: Text(
              errorText,
              style: typography.bodySmallRegular.copyWith(
                color: colors.textError,
              ),
            ),
          ),
      ],
    );
  }

  Widget? _buildPhonePrefixButton(BuildContext context) {
    final typography = Theme.of(context).coreTypography;
    final colors = Theme.of(context).coreColors;

    return IntrinsicWidth(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: CoreSpacing.space3),
        child: Row(
          children: [
            TextButton(
              onPressed: enabled && !readOnly && isPhoneNumber
                  ? () => _showPhonePrefixBottomSheet(context)
                  : null,
              child: Row(
                children: [
                  Text(
                    phonePrefix ?? '+1',
                    style: typography.bodyLargeRegular.copyWith(
                      color: colors.textHeadline,
                    ),
                  ),
                  const SizedBox(width: CoreSpacing.space1),
                  CoreIconWidget(
                    icon: CoreIcons.arrowDropDown,
                    color: colors.textHeadline,
                    size: 18,
                  ),
                ],
              ),
            ),
            const SizedBox(width: CoreSpacing.space3),
            Container(height: 20, width: 1, color: colors.lineMid),
          ],
        ),
      ),
    );
  }

  //todo need to be updated
  void _showPhonePrefixBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        final typography = Theme.of(context).coreTypography;
        return Container(
          padding: const EdgeInsets.all(CoreSpacing.space4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                countryCodePickerTitle ?? 'Select Country Code',
                style: typography.bodyLargeSemiBold,
              ),
              const SizedBox(height: CoreSpacing.space4),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: phonePrefixes?.length ?? 0,
                  itemBuilder: (context, index) {
                    final prefixes = phonePrefixes;
                    if (prefixes == null) return const SizedBox();
                    final prefix = prefixes[index];
                    return ListTile(
                      title: Text(prefix, style: typography.bodyLargeRegular),
                      onTap: () {
                        onPhonePrefixChanged?.call(prefix);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
