import 'package:flutter/material.dart';

import '../../theme/color_tokens.dart';
import '../../theme/icons/core_icons.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../core_icon.dart';

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
      style: CoreTypography.bodyLargeRegular(
        color: isDisabled ? CoreTextColors.disable : CoreTextColors.dark,
      ),
      decoration: InputDecoration(
        floatingLabelStyle: CoreTypography.bodyLargeSemiBold(
          color: isDisabled
              ? CoreTextColors.disable
              : CoreBorderColors.outlineFocus,
        ),
        hoverColor:
            isDisabled ? CoreBackgroundColors.backgroundGrayMid : Colors.white,
        fillColor:
            isDisabled ? CoreBackgroundColors.backgroundGrayMid : Colors.white,
        filled: true,
        labelText: label,
        labelStyle: CoreTypography.bodyLargeRegular(
          color: isDisabled ? CoreTextColors.disable : CoreTextColors.headline,
        ),
        prefixIcon: prefixWidget,
        hintText: hintText,
        hintStyle: CoreTypography.bodyLargeRegular(
          color: isDisabled ? CoreTextColors.disable : CoreTextColors.disable,
        ),
        suffixIcon:
            (obscureText ? suffix ?? const Icon(Icons.visibility) : suffix),
        error: (errorTextList == null && errorWidgetList == null)
            ? null
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    _buildErrorWidgetList(errorTextList, errorWidgetList) ?? [],
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
                    style: CoreTypography.bodySmallRegular(
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
      List<String>? errorTextList, List<Widget>? errorWidgetList) {
    if (errorTextList == null && errorWidgetList == null) return null;
    if (errorTextList != null && errorWidgetList != null) {
      throw Exception(
          'errorTextList and errorWidgetList cannot be provided together');
    }
    if (errorTextList != null) {
      return errorTextList
          .map((errorText) => _buildErrorWidget(errorText: errorText))
          .toList();
    }
    if (errorWidgetList != null) {
      return errorWidgetList
          .map((errorWidget) => _buildErrorWidget(errorWidget: errorWidget))
          .toList();
    }
    return null;
  }

  Widget _buildErrorWidget({String? errorText, Widget? errorWidget}) {
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
                  CoreTypography.bodySmallRegular(color: CoreTextColors.error),
            ),
          ),
      ],
    );
  }

  Widget? _buildPhonePrefixButton(BuildContext context) {
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
                    style: CoreTypography.bodyLargeRegular(
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
        return Container(
          padding: const EdgeInsets.all(CoreSpacing.space4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                countryCodePickerTitle ?? 'Select Country Code',
                style: CoreTypography.bodyLargeSemiBold(),
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
                        style: CoreTypography.bodyLargeRegular(),
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
