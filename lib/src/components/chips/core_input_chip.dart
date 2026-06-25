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
    required this.onRemove,
  });

  /// The text token displayed inside the chip.
  final String label;

  /// Called when the user taps the close (×) button.
  final VoidCallback onRemove;

  /// Key used for the remove button inside the chip.
  ///
  /// Use this in tests to locate the tap target:
  /// `find.byKey(CoreInputChip.removeButtonKey)`.
  static const Key removeButtonKey = Key('core_input_chip_remove_button');

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);

    return Semantics(
      label: label,
      container: true,
      child: Container(
        padding: const EdgeInsets.only(
          left: CoreSpacing.space3,
        ),
        decoration: BoxDecoration(
          color: colors.chipGrey,
          borderRadius: BorderRadius.circular(CoreSpacing.space6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ExcludeSemantics(
              child: Text(
                label,
                style: typography.bodyMediumSemiBold.copyWith(
                  color: colors.textDark,
                ),
              ),
            ),
            const SizedBox(width: CoreSpacing.space2),
            Semantics(
              label: 'Remove $label',
              button: true,
              child: GestureDetector(
                key: removeButtonKey,
                behavior: HitTestBehavior.opaque,
                onTap: onRemove,
                child: ConstrainedBox(
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
