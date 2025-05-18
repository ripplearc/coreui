import 'package:flutter/material.dart';

import '../../../core_ui.dart';

class CoreTextField extends StatelessWidget {
  final String? label;
  final String? helperText;
  final String? errorText;
  final bool obscureText;
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

  const CoreTextField({
    Key? key,
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      focusNode: focusNode,
      enabled: enabled,
      readOnly: readOnly,
      obscureText: obscureText,
      onChanged: onChanged,
      validator: validator,
      keyboardType: keyboardType,
      // style: CoreTypography.bodySmallRegular(),
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText,
        errorText: errorText,
        prefixIcon: prefix,
        suffixIcon: suffix,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: CoreBorderColors.lineDarkOutline),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: CoreBorderColors.lineDarkOutline),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: CoreBorderColors.outlineHover),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: CoreStatusColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: CoreStatusColors.error),
        ),
      ),
    );
  }
}
