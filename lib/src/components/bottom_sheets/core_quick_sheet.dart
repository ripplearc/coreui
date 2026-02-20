import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/src/theme/spacing.dart';
import 'package:ripplearc_coreui/src/theme/theme_extensions.dart';

/// A standardized bottom sheet component with consistent styling and behavior.
///
/// [CoreQuickSheet] provides a reusable bottom sheet with:
/// - Automatic height sizing based on content (up to 90% of screen height)
/// - Custom drag handle with consistent styling
/// - Configurable dismiss behavior
/// - Theme-aware background color
///
/// Example usage:
/// ```dart
/// CoreQuickSheet.show(
///   context: context,
///   child: YourContentWidget(),
/// );
/// ```
class CoreQuickSheet {
  CoreQuickSheet._();

  /// Maximum height ratio of the screen (90%)
  static const double _maxHeightRatio = 0.9;

  /// Border radius for the top corners
  static const double _borderRadius = 28.0;

  /// Shows a bottom sheet with the provided [child] widget.
  ///
  /// Parameters:
  /// - [context]: The build context
  /// - [child]: The content widget to display in the bottom sheet
  /// - [isDismissible]: Whether tapping outside closes the sheet (default: true)
  /// - [enableDrag]: Whether dragging down closes the sheet (default: true)
  /// - [useSafeArea]: Whether to respect safe area insets (default: false)
  /// - [backgroundColor]: Optional custom background color (defaults to theme's pageBackground)
  ///
  /// Returns a [Future] that resolves when the bottom sheet is dismissed.
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
    bool useSafeArea = false,
    Color? backgroundColor,
  }) {
    final colorTheme = AppColorsExtension.of(context);

    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: colorTheme.transparent,
      builder: (context) => _CoreQuickSheetContent(
        useSafeArea: useSafeArea,
        backgroundColor: backgroundColor ?? colorTheme.pageBackground,
        child: child,
      ),
    );
  }
}

/// Internal widget that builds the bottom sheet content with handle and styling.
class _CoreQuickSheetContent extends StatelessWidget {
  const _CoreQuickSheetContent({
    required this.child,
    required this.useSafeArea,
    required this.backgroundColor,
  });

  final Widget child;
  final bool useSafeArea;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorsExtension.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final maxHeight = screenHeight * CoreQuickSheet._maxHeightRatio;

    Widget content = Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(CoreQuickSheet._borderRadius),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: CoreSpacing.space4,
            ),
            child: Container(
              width: CoreSpacing.space8,
              height: CoreSpacing.space1,
              decoration: BoxDecoration(
                color: colorTheme.lineDarkOutline,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          Flexible(
            child: child,
          ),
        ],
      ),
    );

    content = ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: maxHeight,
      ),
      child: content,
    );

    if (useSafeArea) {
      content = SafeArea(top: false, child: content);
    }

    return content;
  }
}
