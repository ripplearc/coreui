import 'package:flutter/material.dart';

import '../../theme/app_typography_extension.dart';
import '../../theme/icon_sizes.dart';
import '../../theme/icons/core_icons.dart';
import '../../theme/icons/icon_data.dart';
import '../../theme/shadows.dart';
import '../../theme/spacing.dart';
import '../../theme/theme_extensions.dart';
import '../buttons/core_button.dart';
import '../core_icon.dart';

/// Defines the type of toast notification and its visual styling.
enum _ToastType {
  /// Error toast with red background and icon for critical issues.
  error,

  /// Warning toast with orange background and icon for cautionary messages.
  warning,

  /// Information toast with blue background and icon for general notifications.
  info,

  /// Success toast with green background and icon for positive confirmations.
  success,

  /// Receipt toast confirming something was saved, with an action that undoes
  /// it. Carries no close button — it leaves through [Toast.onClose].
  receipt,
}

/// A notification widget that displays temporary messages to users.
///
/// Use [Toast.error], [Toast.warning], [Toast.info], or [Toast.success]
/// factory constructors to create a toast with the appropriate visual style.
/// Use [Toast.receipt] for the confirmation that offers an action to undo
/// what it reports; it leaves through [Toast.onClose].
class Toast extends StatefulWidget {
  final String? title;
  final String description;

  /// The receipt's tail, set after a middot in the lighter weight: what was
  /// saved, where [description] is that it was saved.
  final String? highlight;
  final VoidCallback? onClose;
  final String? closeLabel;

  /// Label of the receipt's action — `Undo`. Localised by the caller.
  final String? actionLabel;

  /// Fires once when the receipt's action is taken, before [onClose].
  final VoidCallback? onAction;

  final _ToastType _type;

  static const double _receiptRadius = CoreSpacing.space3;

  static const double _receiptActionMaxWidthFraction = 0.6;

  static const double _receiptRowLeadingWidth =
      CoreIconSize.size24 + CoreSpacing.space3 * 2;

  static const double _radius = CoreSpacing.space2;

  static const double _verticalPadding = CoreSpacing.space3;

  static const double _receiptVerticalPaddingAroundTheTapTarget =
      CoreSpacing.space1;

  const Toast._({
    required this.description,
    required _ToastType type,
    this.closeLabel,
    this.title,
    this.highlight,
    this.onClose,
    this.actionLabel,
    this.onAction,
  }) : _type = type;

  factory Toast.error({
    required String description,
    required String closeLabel,
    String? title,
    VoidCallback? onClose,
  }) {
    return Toast._(
      description: description,
      title: title,
      closeLabel: closeLabel,
      type: _ToastType.error,
      onClose: onClose,
    );
  }

  factory Toast.warning({
    required String description,
    required String closeLabel,
    String? title,
    VoidCallback? onClose,
  }) {
    return Toast._(
      description: description,
      title: title,
      closeLabel: closeLabel,
      type: _ToastType.warning,
      onClose: onClose,
    );
  }

  factory Toast.info({
    required String description,
    required String closeLabel,
    String? title,
    VoidCallback? onClose,
  }) {
    return Toast._(
      description: description,
      title: title,
      closeLabel: closeLabel,
      type: _ToastType.info,
      onClose: onClose,
    );
  }

  factory Toast.success({
    required String description,
    required String closeLabel,
    String? title,
    VoidCallback? onClose,
  }) {
    return Toast._(
      description: description,
      title: title,
      closeLabel: closeLabel,
      type: _ToastType.success,
      onClose: onClose,
    );
  }

  /// Confirms that something was banked and offers the action that takes it
  /// back — "**Saved to history** · Calc 60ft²" with `Undo`.
  ///
  /// [description] is the lead, set in the heavier weight; [highlight] is the
  /// tail after a middot, naming what was saved. [onAction] fires at most
  /// once.
  ///
  /// Answering the receipt calls [onClose], so it never needs a close button.
  /// [onClose] is required because it is the only way a receipt leaves the
  /// screen.
  ///
  /// Every user-facing string comes from the consumer — localisation is the
  /// caller's responsibility:
  /// ```dart
  /// Toast.receipt(
  ///   description: AppLocalizations.of(context).savedToHistory,
  ///   highlight: 'Calc 60ft²',
  ///   actionLabel: AppLocalizations.of(context).undo,
  ///   onAction: controller.undoBanking,
  /// );
  /// ```
  factory Toast.receipt({
    required String description,
    required String actionLabel,
    required VoidCallback onAction,
    required VoidCallback onClose,
    String? highlight,
  }) {
    return Toast._(
      description: description,
      highlight: highlight,
      type: _ToastType.receipt,
      actionLabel: actionLabel,
      onAction: onAction,
      onClose: onClose,
    );
  }

  @override
  State<Toast> createState() => _ToastState();
}

class _ToastState extends State<Toast> {
  bool _answered = false;

  void _answer(VoidCallback? callback) {
    if (_answered) return;
    _answered = true;
    try {
      callback?.call();
    } finally {
      widget.onClose?.call();
    }
  }

  CoreIconData get _icon {
    switch (widget._type) {
      case _ToastType.error:
        return CoreIcons.error;
      case _ToastType.warning:
        return CoreIcons.warning;
      case _ToastType.info:
        return CoreIcons.info;
      case _ToastType.success:
      case _ToastType.receipt:
        return CoreIcons.success;
    }
  }

  Color _getBackgroundColor(AppColorsExtension colors) {
    switch (widget._type) {
      case _ToastType.error:
        return colors.alertRed;
      case _ToastType.warning:
        return colors.alertOrange;
      case _ToastType.info:
        return colors.alertBlue;
      case _ToastType.success:
        return colors.alertGreen;
      case _ToastType.receipt:
        return colors.backgroundBlueLight;
    }
  }

  Color _getIconColor(AppColorsExtension colors) {
    switch (widget._type) {
      case _ToastType.error:
        return colors.iconRed;
      case _ToastType.warning:
        return colors.iconOrange;
      case _ToastType.info:
        return colors.iconBlue;
      case _ToastType.success:
        return colors.iconGreen;
      case _ToastType.receipt:
        return colors.iconDark;
    }
  }

  @override
  Widget build(BuildContext context) {
    final typography = Theme.of(context).coreTypography;
    final colors = Theme.of(context).coreColors;
    final isReceipt = widget._type == _ToastType.receipt;
    final closeLabel = widget.closeLabel;
    final actionLabel = widget.actionLabel;

    return Semantics(
      container: true,
      button: !isReceipt && widget.onClose != null,
      // The receipt is the one toast that offers an action rather than a
      // close button: a screen reader has to be told it arrived, or its user
      // never learns there is an Undo to take.
      liveRegion: isReceipt,
      label: widget.title,
      hint: widget.title != null ? widget.description : null,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: CoreSpacing.space4,
          vertical: isReceipt
              ? Toast._receiptVerticalPaddingAroundTheTapTarget
              : Toast._verticalPadding,
        ),
        decoration: BoxDecoration(
          color: _getBackgroundColor(colors),
          borderRadius: BorderRadius.circular(
            isReceipt ? Toast._receiptRadius : Toast._radius,
          ),
          border: isReceipt
              ? Border.all(
                  color: colors.lineHighlight,
                  width: CoreButton.hairlineBorderWidth,
                )
              : null,
          boxShadow: isReceipt ? null : CoreShadows.medium,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: isReceipt ? CoreSpacing.space12 : 0,
          ),
          // A Row hands a non-flex child unbounded width, so the width the
          // receipt's action has to fit into is measured above it. Only the
          // receipt needs that: a LayoutBuilder cannot report an intrinsic
          // width, which is what an IntrinsicWidth host asks the other
          // variants for.
          child: isReceipt && actionLabel != null
              ? LayoutBuilder(
                  builder: (context, constraints) => _buildRow(
                    colors,
                    text: _buildReceiptText(typography, colors),
                    trailing: _buildActionCluster(
                      actionLabel,
                      constraints.maxWidth,
                    ),
                  ),
                )
              : _buildRow(
                  colors,
                  text: _buildStackedText(typography, colors),
                  trailing: closeLabel == null
                      ? null
                      : _buildCloseButton(typography, colors, closeLabel),
                ),
        ),
      ),
    );
  }

  Widget _buildRow(
    AppColorsExtension colors, {
    required Widget text,
    required Widget? trailing,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CoreIconWidget(
          icon: _icon,
          size: CoreIconSize.size24,
          color: _getIconColor(colors),
        ),
        const SizedBox(width: CoreSpacing.space3),
        Expanded(child: text),
        const SizedBox(width: CoreSpacing.space3),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _buildStackedText(
    AppTypographyExtension typography,
    AppColorsExtension colors,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.title ?? widget.description,
          style: typography.bodyLargeMedium.copyWith(
            color: colors.textDark,
          ),
        ),
        if (widget.title != null)
          Padding(
            padding: const EdgeInsets.only(top: CoreSpacing.space1),
            child: Text(
              widget.description,
              style: typography.bodySmallRegular.copyWith(
                color: colors.textBody,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildActionCluster(String actionLabel, double rowWidth) {
    final action = _buildReceiptAction(actionLabel);
    if (!rowWidth.isFinite) return action;

    final widthTheMessageShares = rowWidth - Toast._receiptRowLeadingWidth;
    if (widthTheMessageShares <= 0) return action;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth:
            widthTheMessageShares * Toast._receiptActionMaxWidthFraction,
      ),
      child: action,
    );
  }

  Widget _buildReceiptText(
    AppTypographyExtension typography,
    AppColorsExtension colors,
  ) {
    final highlight = widget.highlight;

    return Text.rich(
      key: const Key('toast_receipt_message'),
      TextSpan(
        children: [
          TextSpan(
            text: widget.description,
            style: typography.bodyLargeSemiBold.copyWith(
              color: colors.textLink,
            ),
          ),
          if (highlight != null)
            TextSpan(
              text: ' · $highlight',
              style: typography.bodyLargeRegular.copyWith(
                color: colors.textLink,
              ),
            ),
        ],
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildReceiptAction(String actionLabel) {
    final button = CoreButton(
      key: const Key('toast_action_button'),
      label: actionLabel,
      semanticsLabel: actionLabel,
      onPressed: () => _answer(widget.onAction),
      size: CoreButtonSize.large,
      fullWidth: false,
    );

    return Semantics(container: true, child: button);
  }

  Widget _buildCloseButton(
    AppTypographyExtension typography,
    AppColorsExtension colors,
    String closeLabel,
  ) {
    return GestureDetector(
      key: const Key('toast_close_button'),
      onTap: widget.onClose ?? () => Navigator.of(context).pop(),
      child: Semantics(
        button: true,
        label: closeLabel,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: CoreSpacing.space12,
            minHeight: CoreSpacing.space12,
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  closeLabel,
                  style: typography.bodyMediumSemiBold.copyWith(
                    color: colors.textLink,
                  ),
                ),
                const SizedBox(width: CoreSpacing.space2),
                CoreIconWidget(
                  icon: CoreIcons.close,
                  size: CoreIconSize.size24,
                  color: colors.iconDark,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
