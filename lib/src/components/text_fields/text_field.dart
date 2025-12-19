import 'package:flutter/material.dart';

import '../../theme/color_tokens.dart';
import '../../theme/icons/core_icons.dart';
import '../../theme/spacing.dart';
import '../../theme/typography_extension.dart';
import '../core_icon.dart';

/// A custom text field widget with optional label, helper text, and error text
/// [label] The label text displayed above the text field
/// [helperText] The helper text displayed below the text field
/// [hintText] The hint text displayed inside the text field
/// [errorTextList] The list of error messages displayed below the text field
/// [errorWidgetList] The list of error widgets displayed below the text field
/// [obscureText] Whether or not the text should be obscured
/// [controller] The controller for the text field
/// [onChanged] The callback function called when the text field value changes
/// [keyboardType] The keyboard type for the text field
/// [enabled] Whether or not the text field is enabled
/// [validator] The validator function for the text field
/// [focusNode] The focus node for the text field
/// [initialValue] The initial value for the text field
/// [readOnly] Whether or not the text field is read-only
/// [prefix] The widget displayed before the text field
/// [suffix] The widget displayed after the text field
/// [isPhoneNumber] Whether or not the text field is used for phone number input
/// [phonePrefix] The phone number prefix to display
/// [onPhonePrefixChanged] The callback function called when the phone prefix changes
/// [phonePrefixes] The list of available phone number prefixes
/// [countryCodePickerTitle] The title for the country code picker dialog
class CoreTextField extends StatelessWidget {
  final String? label;
  final String? helperText;
  final String? hintText;
  final List<String>? errorTextList;
  final List<Widget>? errorWidgetList;
  final bool obscureText;
  final bool isPhoneNumber;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final bool enabled;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final String? initialValue;
  final bool readOnly;
  final Widget? prefix;
  final Widget? suffix;
  final String? phonePrefix;
  final void Function(String?)? onPhonePrefixChanged;
  final List<String>? phonePrefixes;
  final String? countryCodePickerTitle;

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
    final typography = Theme.of(context).extension<TypographyExtension>();

    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      focusNode: focusNode,
      enabled: enabled,
      readOnly: readOnly,
      obscureText: obscureText,
      onChanged: onChanged,
      validator: validator,
      cursorColor:
          isDisabled ? Colors.transparent : CoreBorderColors.outlineFocus,
      keyboardType: isPhoneNumber ? TextInputType.phone : keyboardType,
      style: typography?.bodyLargeRegular.copyWith(
        color: isDisabled ? CoreTextColors.disable : CoreTextColors.dark,
      ),
      decoration: InputDecoration(
        floatingLabelStyle: typography?.bodyLargeSemiBold.copyWith(
          color: isDisabled
              ? CoreTextColors.disable
              : CoreBorderColors.outlineFocus,
        ),
        hoverColor:
            isDisabled ? CoreBackgroundColors.backgroundGrayMid : CoreBackgroundColors.pageBackground,
        fillColor:
            isDisabled ? CoreBackgroundColors.backgroundGrayMid : CoreBackgroundColors.pageBackground,
        filled: true,
        labelText: label,
        labelStyle: typography?.bodyLargeRegular.copyWith(
          color: isDisabled ? CoreTextColors.disable : CoreTextColors.headline,
        ),
        prefixIcon: prefixWidget,
        hintText: hintText,
        hintStyle: typography?.bodyLargeRegular.copyWith(
          color: isDisabled ? CoreTextColors.disable : CoreTextColors.disable,
        ),
        suffixIcon:
            (obscureText ? suffix ?? const Icon(Icons.visibility) : suffix),
        error: (errorTextList == null && errorWidgetList == null)
            ? null
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    _buildErrorWidgetList(context, errorTextList, errorWidgetList) ?? [],
              ),
        helper: helperText == null
            ? null
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CoreIconWidget(
                    icon: CoreIcons.info,
                    size: 16,
                    color: isDisabled
                        ? CoreIconColors.grayMid
                        : CoreIconColors.grayMid,
                  ),
                  const SizedBox(width: CoreSpacing.space1),
                  Text(
                    helperText!,
                    style: typography?.bodySmallRegular.copyWith(
                        color: isDisabled
                            ? CoreTextColors.disable
                            : CoreTextColors.headline),
                  ),
                ],
              ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(
            color: isDisabled
                ? CoreBorderColors.lineMid
                : CoreBorderColors.lineDarkOutline,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(
            color: isDisabled
                ? CoreBorderColors.lineMid
                : CoreBorderColors.lineDarkOutline,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: CoreTextColors.dark),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: CoreStatusColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: CoreStatusColors.error),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: CoreBorderColors.lineMid),
        ),
      ),
    );
  }

  List<Widget>? _buildErrorWidgetList(
      BuildContext context,
      List<String>? errorTextList, List<Widget>? errorWidgetList) {
    if (errorTextList == null && errorWidgetList == null) return null;
    if (errorTextList != null && errorWidgetList != null) {
      throw ArgumentError(
          'errorTextList and errorWidgetList cannot be provided together');
    }
    if (errorTextList != null) {
      return errorTextList
          .map((errorText) => _buildErrorWidget(context, errorText: errorText))
          .toList();
    }
    if (errorWidgetList != null) {
      return errorWidgetList
          .map((errorWidget) => _buildErrorWidget(context, errorWidget: errorWidget))
          .toList();
    }
    return null;
  }

  Widget _buildErrorWidget(BuildContext context, {String? errorText, Widget? errorWidget}) {
    final typography = Theme.of(context).extension<TypographyExtension>();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const CoreIconWidget(
          icon: CoreIcons.error,
          size: 16,
          color: CoreIconColors.red,
        ),
        const SizedBox(width: CoreSpacing.space1),
        if (errorWidget != null)
          Expanded(child: errorWidget)
        else if (errorText != null)
          Expanded(
            child: Text(
              errorText,
              style:
                   typography?.bodySmallRegular
                  .copyWith(color: CoreTextColors.error),
            ),
          ),
      ],
    );
  }

  Widget? _buildPhonePrefixButton(BuildContext context) {
    final typography = Theme.of(context).extension<TypographyExtension>();
    
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
                    style: typography?.bodyLargeRegular.copyWith(
                      color: CoreTextColors.headline,
                    ),
                  ),
                  const SizedBox(width: CoreSpacing.space1),
                  const CoreIconWidget(
                    icon: CoreIcons.arrowDropDown,
                    color: CoreTextColors.headline,
                    size: 18,
                  ),
                ],
              ),
            ),
            const SizedBox(width: CoreSpacing.space3),
            Container(
              height: 20,
              width: 1,
              color: CoreBorderColors.lineMid,
            ),
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
        final typography = Theme.of(context).extension<TypographyExtension>();
        return Container(
          padding: const EdgeInsets.all(CoreSpacing.space4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                countryCodePickerTitle ?? 'Select Country Code',
                style: typography?.bodyLargeSemiBold,
              ),
              const SizedBox(height: CoreSpacing.space4),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: phonePrefixes?.length ?? 0,
                  itemBuilder: (context, index) {
                    final prefix = phonePrefixes![index];
                    return ListTile(
                      title: Text(
                        prefix,
                        style: typography?.bodyLargeRegular,
                      ),
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
