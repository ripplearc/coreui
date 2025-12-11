import 'package:flutter/material.dart';

import '../../theme/spacing.dart';
import '../../theme/theme_extensions.dart';
import '../../theme/typography_extension.dart';
import 'keyboard_models.dart';

/// A tile widget for displaying a single function key.
///
/// [keyType] is the key data to display.
/// [onTap] is called when the key is tapped.
/// [hasPadding] determines whether to add padding around the key (default: false).
/// [customHint] is an optional custom semantic hint. If not provided, uses keyType.semanticLabel.
class FunctionKeyTile extends StatelessWidget {
  final KeyType keyType;
  final VoidCallback onTap;
  final bool hasPadding;
  final String? customHint;

  const FunctionKeyTile({
    super.key,
    required this.keyType,
    required this.onTap,
    this.hasPadding = false,
    this.customHint,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = TypographyExtension.of(context);

    final semanticHint = customHint ??
        keyType.semanticLabel ??
        'Tap to use ${keyType.label} function';

    final semanticLabel = keyType.semanticLabel != null
        ? '${keyType.label} function key'
        : 'Function key ${keyType.label}';

    return Semantics(
      label: semanticLabel,
      button: true,
      hint: semanticHint,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: hasPadding
              ? const EdgeInsets.symmetric(
                  horizontal: CoreSpacing.space1,
                  vertical: CoreSpacing.space1,
                )
              : null,
          decoration: BoxDecoration(
            color: colors.backgroundGrayMid,
            borderRadius: BorderRadius.circular(CoreSpacing.space2),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (keyType.icon != null) ...[
                  Icon(
                    keyType.icon,
                    color: colors.textHeadline,
                    size: CoreSpacing.space4,
                  ),
                  const SizedBox(width: CoreSpacing.space1),
                ],
                Text(
                  keyType.label,
                  style: typography.bodyMediumRegular.copyWith(
                    color: colors.textHeadline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
