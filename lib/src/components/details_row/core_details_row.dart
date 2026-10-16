import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';

/// A rounded grey row that folds a detail of a form away: a label, a bold
/// value, an optional link-style action after a dot, and a chevron.
///
/// A tap anywhere on the row but the action calls [onToggle]; while
/// [expanded], [child] shows under the row in the same card. The action's
/// tap zone is at least 48 dp square.
class CoreDetailsRow extends StatelessWidget {
  /// The name of the detail, e.g. "Delivery".
  final String label;

  /// The detail's value, already formatted, e.g. `$150` or `—`.
  final String value;

  /// Whether the [child] panel shows under the row.
  final bool expanded;

  /// Called when the row is tapped anywhere but the action.
  final VoidCallback onToggle;

  /// Link-style text after a dot, e.g. "Add note"; given with [onAction].
  final String? actionLabel;

  /// Called when [actionLabel] is tapped.
  final VoidCallback? onAction;

  /// The panel shown under the row while [expanded].
  final Widget? child;

  /// Screen-reader label for the toggle. Defaults to [label] then [value].
  final String? semanticLabel;

  static const _indent = EdgeInsetsDirectional.only(start: CoreSpacing.space4);
  static const double _dotSlotWidth = 18;
  static const Duration _chevronTurnDuration = Duration(milliseconds: 150);

  /// Creates a details row.
  const CoreDetailsRow({
    super.key,
    required this.label,
    required this.value,
    required this.expanded,
    required this.onToggle,
    this.actionLabel,
    this.onAction,
    this.child,
    this.semanticLabel,
  }) : assert((actionLabel == null) == (onAction == null));

  Widget _buildAction(
    String action,
    AppColorsExtension colors,
    AppTypographyExtension typography,
  ) {
    return Semantics(
      container: true,
      button: true,
      label: action,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onAction,
        // Excluded inside the detector so its tap action stays on the action.
        child: ExcludeSemantics(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: CoreSpacing.space12,
              minHeight: CoreSpacing.space12,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: _dotSlotWidth,
                  child: Text(
                    '·',
                    textAlign: TextAlign.center,
                    style: typography.bodySmallRegular.copyWith(
                      color: colors.textDisable,
                    ),
                  ),
                ),
                Text(
                  action,
                  style: typography.bodyMediumSemiBold.copyWith(
                    color: colors.textLink,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummary(
    AppColorsExtension colors,
    AppTypographyExtension typography,
  ) {
    return Text.rich(
      TextSpan(
        text: '$label ',
        style: typography.bodyMediumRegular.copyWith(color: colors.textBody),
        children: [
          TextSpan(
            text: value,
            style: typography.bodyMediumSemiBold.copyWith(
              color: colors.textHeadline,
            ),
          ),
        ],
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    final action = actionLabel;
    final panel = child;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.backgroundGrayLight,
        borderRadius: BorderRadius.circular(CoreSpacing.space3),
        border: Border.all(color: colors.lineLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // The whole row toggles; the action's own detector wins its taps.
          Semantics(
            container: true,
            button: true,
            expanded: expanded,
            label: semanticLabel ?? '$label $value',
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onToggle,
              // No end inset: the chevron's 48 dp square centres it 24 dp in.
              child: Padding(
                padding: _indent,
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: ExcludeSemantics(
                              child: _buildSummary(colors, typography),
                            ),
                          ),
                          if (action != null)
                            _buildAction(action, colors, typography),
                        ],
                      ),
                    ),
                    ExcludeSemantics(
                      child: SizedBox.square(
                        dimension: CoreSpacing.space12,
                        child: Center(
                          child: AnimatedRotation(
                            turns: expanded ? 0.5 : 0,
                            duration: _chevronTurnDuration,
                            child: CoreIconWidget(
                              icon: CoreIcons.arrowDown,
                              size: CoreIconSize.size20,
                              color: colors.iconGrayMid,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (expanded && panel != null)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: CoreSpacing.space4,
                vertical: CoreSpacing.space3,
              ),
              child: panel,
            ),
        ],
      ),
    );
  }
}
