import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';

/// A non-toggleable input chip that displays a text token with a remove button.
///
/// Unlike [CoreChip], [CoreInputChip] carries no selection state. It represents
/// a committed token (e.g. an email address or tag) that the user can remove by
/// tapping the close (×) button. The remove button meets the 48 dp minimum
/// tap-target requirement.
///
/// ## Example
/// ```dart
/// CoreInputChip(
///   label: 'alice@example.com',
///   onRemove: () => setState(() => emails.remove('alice@example.com')),
/// )
/// ```
class CoreInputChip extends StatelessWidget {
  const CoreInputChip({
    super.key,
    required this.label,
    this.onRemove,
    this.removeSemanticLabel,
    this.removeOnChipTap = false,
  });

  /// The text token displayed inside the chip.
  final String label;

  /// Called when the user taps the close (×) button.
  ///
  /// When null, the remove button is not rendered and the chip becomes
  /// display-only (e.g. a locked token in a viewer role).
  final VoidCallback? onRemove;

  /// When true, tapping anywhere on the chip invokes [onRemove], and the
  /// whole chip is exposed as a single semantic button labeled with
  /// [removeSemanticLabel]. The close (×) icon stays visible as the removal
  /// affordance but is no longer a separate tap target.
  ///
  /// For chips whose entire pill clears a value on tap — e.g.
  /// [CoreDateFilterChip]'s active pill. Has no effect while [onRemove] is
  /// null.
  final bool removeOnChipTap;

  /// Semantic label for the remove button.
  ///
  /// Callers should pass a localized string. When null or empty, defaults to
  /// `'Remove $label'` in English — an empty string would otherwise produce a
  /// silent screen-reader announcement for the remove button.
  ///
  /// Include the chip's [label] in the string (e.g. via a parameterized
  /// translation such as `'Remove {label}'`); a generic label like 'Remove'
  /// makes every chip in a list announce identically to screen readers.
  final String? removeSemanticLabel;

  /// Key used for the close (×) affordance inside the chip.
  ///
  /// Use this in tests to locate it:
  /// `find.byKey(CoreInputChip.removeButtonKey)`. In the default mode the
  /// keyed subtree is the remove button's tap target; with
  /// [removeOnChipTap] the whole chip is the tap target and the key marks
  /// the decorative icon.
  static const Key removeButtonKey = Key('core_input_chip_remove_button');

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    final removeLabel = removeSemanticLabel;
    final effectiveRemoveLabel = removeLabel == null || removeLabel.isEmpty
        ? 'Remove $label'
        : removeLabel;
    final wholeChipRemoves = removeOnChipTap && onRemove != null;

    final removeIcon = ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: CoreSpacing.space12,
        minHeight: CoreSpacing.space12,
      ),
      child: Center(
        child: CoreIconWidget(
          icon: CoreIcons.close,
          color: colors.iconGrayMid,
          size: CoreIconSize.size20,
        ),
      ),
    );

    final chipBody = Container(
      padding: const EdgeInsets.only(
        left: CoreSpacing.space3,
      ),
      decoration: BoxDecoration(
        color: colors.chipGrey,
        borderRadius: BorderRadius.circular(CoreSpacing.space6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: ExcludeSemantics(
              child: Text(
                label,
                style: typography.bodyMediumSemiBold.copyWith(
                  color: colors.textDark,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
          if (onRemove != null) ...[
            const SizedBox(width: CoreSpacing.space2),
            if (wholeChipRemoves)
              // The whole chip is the tap target; the icon is decorative.
              ExcludeSemantics(
                child: KeyedSubtree(key: removeButtonKey, child: removeIcon),
              )
            else
              Semantics(
                label: effectiveRemoveLabel,
                button: true,
                child: GestureDetector(
                  key: removeButtonKey,
                  behavior: HitTestBehavior.opaque,
                  onTap: onRemove,
                  child: removeIcon,
                ),
              ),
          ],
        ],
      ),
    );

    if (wholeChipRemoves) {
      return Semantics(
        label: effectiveRemoveLabel,
        button: true,
        container: true,
        child: InkWell(
          onTap: onRemove,
          borderRadius: BorderRadius.circular(CoreSpacing.space6),
          child: chipBody,
        ),
      );
    }

    return Semantics(
      label: label,
      container: true,
      child: chipBody,
    );
  }
}
