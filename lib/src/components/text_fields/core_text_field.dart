import 'package:flutter/material.dart';

import '../../../core_ui.dart';

class CoreTextField extends StatelessWidget {
  final String? label;
  final String? helperText;
  final String? errorText;
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

  const CoreTextField(
      {super.key,
      this.label,
      this.helperText,
      this.errorText,
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
      this.phonePrefixes});

  @override
  Widget build(BuildContext context) {
    Widget? prefixWidget = prefix;

    // Create phone number prefix dropdown if isPhoneNumber is true
    if (isPhoneNumber) {
      prefixWidget = _buildPhonePrefixDropdown(context);
    }

    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      focusNode: focusNode,
      enabled: enabled,
      readOnly: readOnly,
      obscureText: obscureText,
      onChanged: onChanged,
      validator: validator,
      keyboardType: isPhoneNumber ? TextInputType.phone : keyboardType,
      style: CoreTypography.bodyLargeRegular(color: CoreTextColors.dark),
      decoration: InputDecoration(
        filled: !enabled,
        fillColor: CoreBackgroundColors.backgroundGrayMid,
        labelText: label,
        prefixIcon: prefixWidget,
        suffixIcon:
            obscureText ? suffix ?? const Icon(Icons.visibility) : suffix,
        //todo icon need to be updated after merging new icons to the token colors
        error: errorText == null
            ? null
            : Row(
                children: [
                  const CoreIconWidget(
                    icon: CoreIcons.error,
                    size: 16,
                    color: CoreIconColors.red,
                  ),
                  const SizedBox(width: CoreSpacing.space1),
                  Text(
                    errorText!,
                    style: CoreTypography.bodySmallRegular(
                        color: CoreTextColors.error),
                  ),
                ],
              ),
        helper: helperText == null
            ? null
            : Row(
                children: [
                  const CoreIconWidget(
                    icon: CoreIcons.info,
                    size: 16,
                    color: CoreIconColors.grayMid,
                  ),
                  const SizedBox(width: CoreSpacing.space1),
                  Text(
                    helperText!,
                    style: CoreTypography.bodySmallRegular(
                        color: CoreTextColors.headline),
                  ),
                ],
              ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: CoreBorderColors.lineDarkOutline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: CoreBorderColors.lineDarkOutline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: CoreBorderColors.outlineHover),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: CoreStatusColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: CoreStatusColors.error),
        ),
      ),
    );
  }

  Widget? _buildPhonePrefixDropdown(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      width: 100,
      child: Row(
        children: [
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: phonePrefix,
              isDense: true,
              icon: Padding(
                padding: const EdgeInsetsDirectional.only(start: 4),
                child: CoreIconWidget(
                  icon: CoreIcons.arrowDropDown,
                  color: CoreTextColors.headline,
                  size: 18,
                ),
              ),
              onChanged: enabled && !readOnly ? onPhonePrefixChanged : null,
              items: phonePrefixes?.map((String prefix) {
                return DropdownMenuItem<String>(
                  value: prefix,
                  child: Text(
                    prefix,
                    style: CoreTypography.bodyLargeRegular(
                      color: CoreTextColors.headline,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(width: CoreSpacing.space3),
          Container(
            height: 20,
            width: 1,
            color: CoreBorderColors.lineMid,
          ),
        ],
      ),
    );
  }
}
