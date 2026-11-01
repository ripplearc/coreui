import 'package:flutter/material.dart';

import '../../theme/app_typography_extension.dart';
import '../../theme/icon_sizes.dart';
import '../../theme/icons/core_icons.dart';
import '../../theme/shadows.dart';
import '../../theme/spacing.dart';
import '../../theme/theme_extensions.dart';
import '../core_icon.dart';

/// Where a [CoreSearchBox] sits, which sets its shape and sizes.
enum CoreSearchBoxType {
  /// On a page: pill shape, 24 dp dark icons, Body Medium text and a light
  /// shadow.
  pill,

  /// Inside a bottom sheet: 12 dp corners, 20 dp grey icons and Body Large
  /// text.
  sheet,
}

/// A search input field with a search icon and a clear button, matching the
/// design library's Search Bar.
///
/// [type] picks the Pill look for pages or the Sheet look for bottom sheets.
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

  /// The library variant to draw. Defaults to [CoreSearchBoxType.pill].
  final CoreSearchBoxType type;

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
    this.type = CoreSearchBoxType.pill,
  });

  /// Key on the inner text field.
  ///
  /// Use this in tests to type into or read the field without a type-based
  /// finder: `tester.enterText(find.byKey(CoreSearchBox.textFieldKey), ...)`.
  /// The key is shared by every [CoreSearchBox]; when a screen renders more
  /// than one, scope the lookup with `find.descendant`.
  static const Key textFieldKey = Key('core_search_box_text_field');

  /// Key on the clear (×) button's tap target.
  ///
  /// Use this in tests to locate it:
  /// `find.byKey(CoreSearchBox.clearButtonKey)`. The button is only present
  /// while the field has text and is enabled. Shared by every instance,
  /// like [textFieldKey].
  static const Key clearButtonKey = Key('core_search_box_clear_button');

  @override
  State<CoreSearchBox> createState() => _CoreSearchBoxState();
}

class _CoreSearchBoxState extends State<CoreSearchBox> {
  static const double _tapTargetSize = CoreSpacing.space12;
  static const double _sheetIconSize = CoreIconSize.size20;
  static const double _pillIconSize = CoreIconSize.size24;
  static const double _sheetRadius = CoreSpacing.space3;
  static const double _pillRadius = CoreSpacing.space12;
  static const double _clearFocusRingWidth = 2;
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _hasText = false;
  bool _isClearPressed = false;
  bool _isClearFocused = false;
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
    final isPill = widget.type == CoreSearchBoxType.pill;
    final iconSize = isPill ? _pillIconSize : _sheetIconSize;
    final iconColor = isDisabled
        ? colors.iconGrayLight
        : (isPill ? colors.iconDark : colors.iconGrayMid);
    final textStyle =
        isPill ? typography.bodyMediumRegular : typography.bodyLargeRegular;
    final radius =
        BorderRadius.circular(isPill ? _pillRadius : _sheetRadius);
    // The clear button keeps a 48 dp tap square; this end inset puts its
    // icon 16 dp from the field's edge, as in the library.
    final clearEndInset = CoreSpacing.space4 - (_tapTargetSize - iconSize) / 2;
    OutlineInputBorder outline(Color color) => OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: color),
        );

    final field = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: isPill ? CoreShadows.extraSmall : null,
      ),
      child: TextFormField(
        key: CoreSearchBox.textFieldKey,
        controller: _controller,
        focusNode: _focusNode,
        enabled: widget.enabled,
        onChanged: widget.onChanged,
        onFieldSubmitted: (_) => widget.onSearch?.call(),
        textInputAction: TextInputAction.search,
        cursorColor: colors.outlineFocus,
        style: textStyle.copyWith(
          color: isDisabled ? colors.textDisable : colors.textHeadline,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: textStyle.copyWith(color: colors.textBody),
          fillColor:
              isDisabled ? colors.backgroundGrayMid : colors.pageBackground,
          filled: true,
          // The decorator adds 4 dp after a prefix icon, so this end inset
          // makes the library's 8 dp gap between the icon and the text.
          prefixIcon: Padding(
            padding: const EdgeInsetsDirectional.only(
              start: CoreSpacing.space4,
              end: CoreSpacing.space1,
            ),
            child: CoreIconWidget(
              icon: CoreIcons.search,
              size: iconSize,
              color: iconColor,
            ),
          ),
          prefixIconConstraints:
              const BoxConstraints(minHeight: _tapTargetSize),
          suffixIcon: _hasText && !isDisabled
              ? Padding(
                  padding: EdgeInsetsDirectional.only(end: clearEndInset),
                  child: Semantics(
                    button: true,
                    label: widget.clearSemanticLabel,
                    // Pressed and focused looks follow the alert close x: on
                    // the icon, with no tint over the 48 dp target.
                    child: InkWell(
                      key: CoreSearchBox.clearButtonKey,
                      onTap: _handleClear,
                      onHighlightChanged: (isPressed) =>
                          setState(() => _isClearPressed = isPressed),
                      onFocusChange: (isFocused) =>
                          setState(() => _isClearFocused = isFocused),
                      splashFactory: NoSplash.splashFactory,
                      overlayColor:
                          WidgetStateProperty.all(colors.transparent),
                      child: SizedBox.square(
                        dimension: _tapTargetSize,
                        child: Center(
                          child: DecoratedBox(
                            key: const Key('core_search_box_clear_focus_ring'),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: _isClearFocused
                                  ? Border.all(
                                      color: colors.outlineFocus,
                                      width: _clearFocusRingWidth,
                                    )
                                  : null,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(CoreSpacing.space1),
                              child: CoreIconWidget(
                                icon: CoreIcons.cross,
                                size: iconSize,
                                color: _isClearPressed
                                    ? colors.buttonPress
                                    : iconColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : null,
          suffixIconConstraints: const BoxConstraints(
            minWidth: _tapTargetSize,
            minHeight: _tapTargetSize,
          ),
          border: outline(colors.lineMid),
          enabledBorder: outline(colors.lineMid),
          disabledBorder: outline(colors.lineMid),
          focusedBorder: outline(colors.outlineFocus),
          contentPadding: const EdgeInsetsDirectional.only(
            end: CoreSpacing.space4,
            top: CoreSpacing.space3,
            bottom: CoreSpacing.space3,
          ),
        ),
      ),
    );
    // Its own Material, so the field works on any parent: a TextFormField
    // throws without one.
    return Material(type: MaterialType.transparency, child: field);
  }
}
