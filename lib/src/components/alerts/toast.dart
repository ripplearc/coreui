import 'dart:async';

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
  /// it. Auto-dismisses; carries no close button.
  receipt,
}

/// A notification widget that displays temporary messages to users.
///
/// Use [Toast.error], [Toast.warning], [Toast.info], or [Toast.success]
/// factory constructors to create a toast with the appropriate visual style.
/// Use [Toast.receipt] for the self-dismissing confirmation that offers an
/// action to undo what it reports.
class Toast extends StatefulWidget {
  final String? title;
  final String description;
  final String? highlight;
  final VoidCallback? onClose;
  final String? closeLabel;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Duration? duration;
  final _ToastType _type;

  /// Corner radius of the receipt surface. The other variants keep the
  /// tighter [_radius].
  static const double _receiptRadius = CoreSpacing.space3;

  /// How much of the receipt row the action may take before it is made to
  /// give ground to the message.
  static const double _actionClusterMaxWidthFraction = 0.7;

  static const double _radius = CoreSpacing.space2;

  const Toast._({
    required this.description,
    required _ToastType type,
    this.closeLabel,
    this.title,
    this.highlight,
    this.onClose,
    this.actionLabel,
    this.onAction,
    this.duration,
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
  /// once, and taking the action cancels the auto-dismiss.
  ///
  /// The toast dismisses itself after [duration] by calling [onClose], so a
  /// receipt never needs a close button. Pass `null` to keep it on screen
  /// until the caller removes it.
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
    String? highlight,
    VoidCallback? onClose,
    Duration? duration = const Duration(seconds: 5),
  }) {
    return Toast._(
      description: description,
      highlight: highlight,
      type: _ToastType.receipt,
      actionLabel: actionLabel,
      onAction: onAction,
      onClose: onClose,
      duration: duration,
    );
  }

  @override
  State<Toast> createState() => _ToastState();
}

class _ToastState extends State<Toast> {
  Timer? _dismissTimer;
  bool _answered = false;

  @override
  void initState() {
    super.initState();
    final duration = widget.duration;
    // Only when someone is listening. The widget cannot take itself off the
    // screen — onClose is what does that — so a timer without one would mark
    // the receipt answered and leave a live-looking toast whose action has
    // gone quietly dead.
    if (duration != null && widget.onClose != null) {
      _dismissTimer = Timer(duration, _handleDismissTimer);
    }
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    super.dispose();
  }

  // First tap wins, and it dismisses: a second Undo would roll back a second
  // session, and an answered receipt must never be left on screen.
  void _answer(VoidCallback? callback) {
    if (_answered) return;
    _answered = true;
    _dismissTimer?.cancel();
    callback?.call();
    widget.onClose?.call();
  }

  // The timer answers the toast with nothing: no action was taken, and the
  // receipt still has to come off the screen.
  void _handleDismissTimer() => _answer(null);

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

    return Semantics(
      container: true,
      button: !isReceipt && widget.onClose != null,
      // The receipt is the one toast that is both timed and actionable: a
      // screen reader has to be told it arrived, or the Undo window closes
      // before its user knows there was one.
      liveRegion: isReceipt,
      label: widget.title ?? _receiptLabel,
      hint: widget.title != null ? widget.description : null,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: CoreSpacing.space4,
          // Tighter, because the row below is already pinned to the tap-target
          // height — which also keeps both receipt shapes the same height.
          vertical: isReceipt ? CoreSpacing.space1 : CoreSpacing.space3,
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
          child: LayoutBuilder(
            // A Row hands a non-flex child unbounded width, so the space the
            // action has to fit into has to be measured above it.
            builder: (context, constraints) => Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CoreIconWidget(
                  icon: _icon,
                  size: CoreIconSize.size24,
                  color: _getIconColor(colors),
                ),
                const SizedBox(width: CoreSpacing.space3),
                Expanded(
                  child: isReceipt
                      ? _buildReceiptText(typography, colors)
                      : _buildStackedText(typography, colors),
                ),
                const SizedBox(width: CoreSpacing.space3),
                if (isReceipt)
                  _buildActionCluster(typography, colors, constraints.maxWidth)
                else if (closeLabel != null)
                  _buildCloseButton(typography, colors, closeLabel),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// What a screen reader reads for a receipt: the lead and the tail are one
  /// sentence, not two labels.
  String get _receiptLabel {
    final highlight = widget.highlight;
    return highlight == null
        ? widget.description
        : '${widget.description} · $highlight';
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


  // Capped rather than flexed. A flex child would split the free space with
  // the message evenly and ellipsise the action while the row still had
  // room; a bare intrinsic action overflows the row once a longer language
  // stretches its label. The cap only bites when the action would otherwise
  // take most of the row, and CoreButton ellipsises its own label once it is
  // handed a bounded width.
  Widget _buildActionCluster(
    AppTypographyExtension typography,
    AppColorsExtension colors,
    double rowWidth,
  ) {
    final actions = Row(
      mainAxisSize: MainAxisSize.min,
      children: _buildReceiptActions(typography, colors),
    );

    if (!rowWidth.isFinite) return actions;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: rowWidth * Toast._actionClusterMaxWidthFraction,
      ),
      child: actions,
    );
  }

  // The receipt reads as one line: the lead carries the weight, the tail
  // names what was saved.
  Widget _buildReceiptText(
    AppTypographyExtension typography,
    AppColorsExtension colors,
  ) {
    final highlight = widget.highlight;

    return Text.rich(
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

  List<Widget> _buildReceiptActions(
    AppTypographyExtension typography,
    AppColorsExtension colors,
  ) {
    // Unreachable: Toast.receipt requires the label. Drop the action rather
    // than render a control a screen reader cannot announce.
    final actionLabel = widget.actionLabel;
    assert(actionLabel != null, 'A receipt toast always carries its action.');
    if (actionLabel == null) return const [];

    return [
      Flexible(
        child: CoreButton(
          key: const Key('toast_action_button'),
          label: actionLabel,
          semanticsLabel: actionLabel,
          onPressed: () => _answer(widget.onAction),
          size: CoreButtonSize.large,
          fullWidth: false,
        ),
      ),
    ];
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
