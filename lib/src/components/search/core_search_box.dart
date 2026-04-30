import 'package:flutter/material.dart';

import '../../theme/app_typography_extension.dart';
import '../../theme/icons/core_icons.dart';
import '../../theme/spacing.dart';
import '../../theme/theme_extensions.dart';
import '../core_icon.dart';

/// A borderless search input field with a built-in search icon and a clear button.
///
/// Unlike [CoreTextField], [CoreSearchBox] has no visible border — it is intended
/// for use as a global or in-page search bar where a flat appearance is preferred.
class CoreSearchBox extends StatefulWidget {
  /// The placeholder text shown when the field is empty.
  final String? hintText;

  /// Optional controller for reading or setting the field value.
  final TextEditingController? controller;

  /// Called whenever the text changes.
  final void Function(String)? onChanged;

  /// Called when the user submits via the keyboard search action.
  final VoidCallback? onSearch;

  /// Called when the user taps the clear button. The field is cleared automatically.
  final VoidCallback? onClear;

  /// Whether the field is interactive. Defaults to true.
  final bool enabled;

  /// Optional focus node for controlling focus programmatically.
  final FocusNode? focusNode;

  /// Semantic label for the clear button. Defaults to 'Clear search'.
  final String clearSemanticLabel;

  const CoreSearchBox({
    super.key,
    this.hintText,
    this.controller,
    this.onChanged,
    this.onSearch,
    this.onClear,
    this.enabled = true,
    this.focusNode,
    this.clearSemanticLabel = 'Clear search',
  });

  @override
  State<CoreSearchBox> createState() => _CoreSearchBoxState();
}

class _CoreSearchBoxState extends State<CoreSearchBox> {
  static const double _iconConstraintSize = CoreSpacing.space12;
  static const double _iconSize = CoreSpacing.space5;
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _hasText = false;
  bool _ownsController = false;
  bool _ownsFocusNode = false;

  @override
  void initState() {
    super.initState();
    final controller = widget.controller;
    if (controller == null) {
      _controller = TextEditingController();
      _ownsController = true;
    } else {
      _controller = controller;
    }
    final focusNode = widget.focusNode;
    if (focusNode == null) {
      _focusNode = FocusNode();
      _ownsFocusNode = true;
    } else {
      _focusNode = focusNode;
    }
    _hasText = _controller.text.isNotEmpty;
    _controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(CoreSearchBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _controller.removeListener(_onControllerChanged);
      if (_ownsController) {
        _controller.dispose();
        _ownsController = false;
      }
      final newController = widget.controller;
      if (newController == null) {
        _controller = TextEditingController();
        _ownsController = true;
      } else {
        _controller = newController;
      }
      _hasText = _controller.text.isNotEmpty;
      _controller.addListener(_onControllerChanged);
    }
    if (oldWidget.focusNode != widget.focusNode) {
      if (_ownsFocusNode) {
        _focusNode.dispose();
        _ownsFocusNode = false;
      }
      final newFocusNode = widget.focusNode;
      if (newFocusNode == null) {
        _focusNode = FocusNode();
        _ownsFocusNode = true;
      } else {
        _focusNode = newFocusNode;
      }
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    if (_ownsController) _controller.dispose();
    if (_ownsFocusNode) _focusNode.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  void _handleClear() {
    _controller.clear();
    widget.onClear?.call();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).coreColors;
    final typography = Theme.of(context).coreTypography;
    final isDisabled = !widget.enabled;

    return TextFormField(
      controller: _controller,
      focusNode: _focusNode,
      enabled: widget.enabled,
      onChanged: widget.onChanged,
      onFieldSubmitted: (_) => widget.onSearch?.call(),
      textInputAction: TextInputAction.search,
      cursorColor: colors.outlineFocus,
      style: typography.bodyLargeRegular.copyWith(
        color: isDisabled ? colors.textDisable : colors.textDark,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: typography.bodyLargeRegular.copyWith(
          color: colors.textDisable,
        ),
        fillColor: isDisabled ? colors.backgroundGrayMid : colors.pageBackground,
        filled: true,
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: CoreSpacing.space3),
          child: CoreIconWidget(
            icon: CoreIcons.search,
            size: _iconSize,
            color: isDisabled ? colors.textDisable : colors.iconGrayMid,
          ),
        ),
        prefixIconConstraints: BoxConstraints(minWidth: _iconConstraintSize, minHeight: _iconConstraintSize),
        suffixIcon: _hasText && !isDisabled
            ? Semantics(
                button: true,
                label: widget.clearSemanticLabel,
                child: InkWell(
                  key: const ValueKey('core_search_box_clear_button'),
                  onTap: _handleClear,
                  borderRadius: BorderRadius.circular(CoreSpacing.space5),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: CoreSpacing.space3,
                    ),
                    child: CoreIconWidget(
                      icon: CoreIcons.close,
                      size: _iconSize,
                      color: colors.iconGrayMid,
                    ),
                  ),
                ),
              )
            : null,
        suffixIconConstraints: BoxConstraints(minWidth: _iconConstraintSize, minHeight: _iconConstraintSize),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(
          vertical: CoreSpacing.space3,
          horizontal: CoreSpacing.space4,
        ),
      ),
    );
  }
}
