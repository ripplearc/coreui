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
  /// it. Dismisses itself after [Toast.duration]; carries no close button.
  receipt,
  acknowledgement,
}

/// A notification widget that displays temporary messages to users.
///
/// Use [Toast.error], [Toast.warning], [Toast.info], or [Toast.success]
/// factory constructors to create a toast with the appropriate visual style.
/// Use [Toast.receipt] for the self-dismissing confirmation that offers an
/// action to undo what it reports. Use [Toast.acknowledgement] for the dark
/// toast that only reports a finished task.
///
/// The four alerts draw a plain close x labelled [closeLabel] for screen
/// readers. [actionLabel] adds a text button beside it; taking it fires
/// [onAction], then [onClose].
class Toast extends StatefulWidget {
  final String? title;
  final String description;

  /// The receipt's tail, set after a middot in the lighter weight: what was
  /// saved, where [description] is that it was saved.
  final String? highlight;

  /// Called when the toast closes: from the close x, after an action, or when
  /// a receipt's [duration] runs out. Without it, the close x pops the current
  /// route; an action never pops one, because it may have just opened a page.
  final VoidCallback? onClose;
  final String? closeLabel;

  /// Label of the toast's action — the receipt's `Undo`, or an alert's text
  /// button beside its close x, such as `View`. Localised by the caller.
  final String? actionLabel;

  /// Fires once when the action is taken, before [onClose].
  final VoidCallback? onAction;

  /// Label of the receipt's quieter second action — `View`. Travels with
  /// [onSecondary]; omit both to render the receipt with `Undo` alone.
  final String? secondaryLabel;

  /// Fires once when the receipt's second action is taken, before [onClose].
  /// Taking it locks out [onAction], as taking [onAction] locks out this one.
  final VoidCallback? onSecondary;

  /// How long the receipt stays before it dismisses itself through [onClose].
  /// `null` keeps it until something else removes it, and so does a screen
  /// reader: a timed window a user cannot reach is worse than none.
  final Duration? duration;
  final _ToastType _type;

  static const int _primaryActionFlex = 2;

  static const double _secondaryActionOpacity = 0.85;

  static const double _largeRadius = CoreSpacing.space3;

  static const double _receiptActionMaxWidthFraction = 0.6;

  static const double _receiptRowLeadingWidth =
      CoreIconSize.size24 + CoreSpacing.space3 * 2;

  static const double _radius = CoreSpacing.space2;

  static const double _verticalPadding = CoreSpacing.space3;

  static const double _iconToTargetInset =
      (CoreSpacing.space12 - CoreIconSize.size24) / 2;

  static const double _acknowledgementHeight = CoreSpacing.space12;

  static const double _acknowledgementRowMinHeight =
      _acknowledgementHeight - Toast._verticalPadding * 2;

  static const double _acknowledgementTickSize = 21.3;

  static const double _receiptVerticalPaddingAroundTheTapTarget =
      CoreSpacing.space1;

  static const double _smallAlertHeight = CoreSpacing.space10;

  static const double _smallAlertSurfaceInset =
      (CoreSpacing.space12 - _smallAlertHeight) / 2;

  const Toast._({
    required this.description,
    required _ToastType type,
    this.closeLabel,
    this.title,
    this.highlight,
    this.onClose,
    this.actionLabel,
    this.onAction,
    this.secondaryLabel,
    this.onSecondary,
    this.duration,
  })  : assert(
          (actionLabel == null) == (onAction == null),
          'actionLabel and onAction travel together: an action with no label '
          'is invisible to a screen reader, and a label with no action is a '
          'dead control.',
        ),
        _type = type;

  factory Toast.error({
    required String description,
    required String closeLabel,
    String? title,
    VoidCallback? onClose,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return Toast._(
      description: description,
      title: title,
      closeLabel: closeLabel,
      type: _ToastType.error,
      onClose: onClose,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  factory Toast.warning({
    required String description,
    required String closeLabel,
    String? title,
    VoidCallback? onClose,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return Toast._(
      description: description,
      title: title,
      closeLabel: closeLabel,
      type: _ToastType.warning,
      onClose: onClose,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  factory Toast.info({
    required String description,
    required String closeLabel,
    String? title,
    VoidCallback? onClose,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return Toast._(
      description: description,
      title: title,
      closeLabel: closeLabel,
      type: _ToastType.info,
      onClose: onClose,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  factory Toast.success({
    required String description,
    required String closeLabel,
    String? title,
    VoidCallback? onClose,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return Toast._(
      description: description,
      title: title,
      closeLabel: closeLabel,
      type: _ToastType.success,
      onClose: onClose,
      actionLabel: actionLabel,
      onAction: onAction,
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
  /// receipt never needs a close button. [onClose] is required because it is
  /// the only way a receipt can leave the screen. A `null` [duration] keeps
  /// it there until something else removes it, and so does a screen reader —
  /// see [duration].
  ///
  /// [secondaryLabel] adds the quieter second action (`View`). It travels with
  /// [onSecondary]: an interactive control with no label is invisible to a
  /// screen reader.
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
    String? secondaryLabel,
    VoidCallback? onSecondary,
    Duration? duration = const Duration(seconds: 5),
  }) {
    assert(
      (secondaryLabel == null) == (onSecondary == null),
      'secondaryLabel and onSecondary travel together: an action with no '
      'label is invisible to a screen reader, and a label with no action is '
      'a dead control.',
    );
    return Toast._(
      description: description,
      highlight: highlight,
      type: _ToastType.receipt,
      actionLabel: actionLabel,
      onAction: onAction,
      secondaryLabel: secondaryLabel,
      onSecondary: onSecondary,
      onClose: onClose,
      duration: duration,
    );
  }

  /// Reports a finished task on a dark surface behind a green tick — "Added to
  /// Bedroom 2".
  ///
  /// It carries no action and no close button, so whoever shows it removes
  /// it; [CoreToast.showAcknowledgement] does that on a timer. The
  /// [description] is the whole message and is localised by the caller.
  factory Toast.acknowledgement({required String description}) {
    return Toast._(
      description: description,
      type: _ToastType.acknowledgement,
    );
  }

  @override
  State<Toast> createState() => _ToastState();
}

class _ToastState extends State<Toast> {
  static const double _closeFocusRingWidth = 2;
  static const double _actionFocusRingWidth = 3;
  static const double _actionFocusRingOutsetY = 5;

  Timer? _dismissTimer;
  bool _answered = false;
  bool _isClosePressed = false;
  bool _isCloseFocused = false;
  bool _isActionPressed = false;
  bool _isActionFocused = false;
  bool _isSecondaryPressed = false;
  bool _isSecondaryFocused = false;
  bool? _assistiveTechHoldsTheToast;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final holds = MediaQuery.maybeAccessibleNavigationOf(context) ?? false;
    if (holds == _assistiveTechHoldsTheToast) return;
    _assistiveTechHoldsTheToast = holds;
    _restartDismissTimer();
  }

  @override
  void didUpdateWidget(covariant Toast oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_reportsTheSameAs(oldWidget)) {
      if (_answered || oldWidget.duration == widget.duration) return;
    } else {
      _answered = false;
    }
    _restartDismissTimer();
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    super.dispose();
  }

  bool _reportsTheSameAs(Toast other) =>
      other.description == widget.description &&
      other.highlight == widget.highlight &&
      other.actionLabel == widget.actionLabel &&
      other.onAction == widget.onAction;

  void _restartDismissTimer() {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    final duration = widget.duration;
    final theUserNeedsTheWindowOpen = _assistiveTechHoldsTheToast ?? false;
    if (_answered || duration == null || theUserNeedsTheWindowOpen) return;
    _dismissTimer = Timer(duration, _dismissWithoutAnAction);
  }

  void _answer(VoidCallback? callback) {
    if (_answered) return;
    _answered = true;
    _dismissTimer?.cancel();
    try {
      callback?.call();
    } finally {
      widget.onClose?.call();
    }
  }

  void _close() {
    final onClose = widget.onClose;
    if (onClose != null) {
      onClose();
    } else {
      Navigator.of(context).pop();
    }
  }

  void _dismissWithoutAnAction() => _answer(null);

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  bool get _isSmallAlert => widget.closeLabel != null && widget.title == null;

  bool get _hasTitledControls =>
      widget.closeLabel != null && widget.title != null;

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
      case _ToastType.acknowledgement:
        return CoreIcons.checkMark;
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
      case _ToastType.acknowledgement:
        return _isDark ? colors.backgroundGrayMid : colors.backgroundDarkGray;
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
      case _ToastType.acknowledgement:
        return colors.textInverse;
    }
  }

  @override
  Widget build(BuildContext context) {
    final typography = Theme.of(context).coreTypography;
    final colors = Theme.of(context).coreColors;
    final isReceipt = widget._type == _ToastType.receipt;
    final isAcknowledgement = widget._type == _ToastType.acknowledgement;
    final closeLabel = widget.closeLabel;
    final actionLabel = widget.actionLabel;
    final isSmallAlert = _isSmallAlert;
    final horizontalPadding =
        isSmallAlert ? CoreSpacing.space3 : CoreSpacing.space4;
    final verticalPadding = isSmallAlert
        ? 0.0
        : isReceipt
            ? Toast._receiptVerticalPaddingAroundTheTapTarget
            : Toast._verticalPadding;

    final toast = Semantics(
      container: !isSmallAlert,
      button: !isReceipt && widget.onClose != null,
      // The receipt is the one toast that is both timed and actionable: a
      // screen reader has to be told it arrived, or the Undo window closes
      // before its user knows there was one. An acknowledgement is nothing
      // but its message, so it is announced too.
      liveRegion: isReceipt || isAcknowledgement,
      label: widget.title,
      hint: widget.title != null ? widget.description : null,
      child: Container(
        key: isSmallAlert ? null : const Key('toast_surface'),
        padding: EdgeInsetsDirectional.fromSTEB(
          horizontalPadding,
          _hasTitledControls
              ? verticalPadding - Toast._iconToTargetInset
              : verticalPadding,
          closeLabel == null
              ? horizontalPadding
              : horizontalPadding +
                  CoreSpacing.space1 -
                  Toast._iconToTargetInset,
          verticalPadding,
        ),
        decoration: BoxDecoration(
          color: isSmallAlert ? null : _getBackgroundColor(colors),
          borderRadius: BorderRadius.circular(
            isReceipt || isAcknowledgement
                ? Toast._largeRadius
                : Toast._radius,
          ),
          border: isReceipt
              ? Border.all(
                  color: colors.lineHighlight,
                  width: CoreButton.hairlineBorderWidth,
                )
              : null,
          boxShadow: isReceipt || isSmallAlert
              ? null
              : isAcknowledgement
                  ? CoreShadows.floating
                  : CoreShadows.medium,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: isReceipt || isSmallAlert
                ? CoreSpacing.space12
                : isAcknowledgement
                    ? Toast._acknowledgementRowMinHeight
                    : 0,
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
                      typography,
                      colors,
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
                      : _buildAlertControls(typography, colors, closeLabel),
                ),
        ),
      ),
    );
    if (!isSmallAlert) return toast;

    // The small alert's surface is drawn 40 dp high, but its controls keep
    // 48 dp targets, so they stand 4 dp past its top and bottom edges.
    return Semantics(
      container: true,
      child: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Toast._smallAlertSurfaceInset,
              ),
              child: DecoratedBox(
                key: const Key('toast_surface'),
                decoration: BoxDecoration(
                  color: _getBackgroundColor(colors),
                  borderRadius: BorderRadius.circular(Toast._radius),
                  boxShadow: CoreShadows.medium,
                ),
              ),
            ),
          ),
          toast,
        ],
      ),
    );
  }

  Widget _buildRow(
    AppColorsExtension colors, {
    required Widget text,
    required Widget? trailing,
  }) {
    final titleLineInset = EdgeInsets.only(
      top: _hasTitledControls ? Toast._iconToTargetInset : 0,
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: _hasTitledControls
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        Padding(padding: titleLineInset, child: _buildLeading(colors)),
        const SizedBox(width: CoreSpacing.space3),
        Expanded(child: Padding(padding: titleLineInset, child: text)),
        if (trailing != null) ...[
          const SizedBox(width: CoreSpacing.space3),
          trailing,
        ],
      ],
    );
  }

  Widget _buildLeading(AppColorsExtension colors) {
    final isAcknowledgement = widget._type == _ToastType.acknowledgement;
    final icon = CoreIconWidget(
      icon: _icon,
      size: isAcknowledgement
          ? Toast._acknowledgementTickSize
          : CoreIconSize.size24,
      color: _getIconColor(colors),
    );
    if (!isAcknowledgement) return icon;

    return DecoratedBox(
      key: const Key('toast_tick_circle'),
      decoration: BoxDecoration(
        color: colors.statusSuccess,
        shape: BoxShape.circle,
      ),
      child: SizedBox.square(
        dimension: CoreIconSize.size24,
        child: Center(child: icon),
      ),
    );
  }

  Widget _buildStackedText(
    AppTypographyExtension typography,
    AppColorsExtension colors,
  ) {
    if (_isSmallAlert) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: CoreSpacing.space2 + Toast._smallAlertSurfaceInset,
        ),
        child: Text(
          widget.description,
          style: typography.bodyMediumMedium.copyWith(color: colors.textDark),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.title ?? widget.description,
          style: widget._type == _ToastType.acknowledgement
              ? typography.bodyMediumSemiBold.copyWith(
                  color: _isDark ? colors.textHeadline : colors.textInverse,
                )
              : typography.bodyLargeMedium.copyWith(
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

  Widget _buildActionCluster(
    AppTypographyExtension typography,
    AppColorsExtension colors,
    String actionLabel,
    double rowWidth,
  ) {
    final secondAction = _buildSecondAction(typography, colors);
    final actions = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (secondAction != null) ...[
          Flexible(child: secondAction),
          const SizedBox(width: CoreSpacing.space4),
        ],
        Flexible(
          flex: Toast._primaryActionFlex,
          child: _buildReceiptAction(actionLabel),
        ),
      ],
    );
    if (!rowWidth.isFinite) return actions;

    final widthTheMessageShares = rowWidth - Toast._receiptRowLeadingWidth;
    if (widthTheMessageShares <= 0) return actions;

    final widthHeldForSecondAction = secondAction == null
        ? 0.0
        : CoreSpacing.space12 + CoreSpacing.space4;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth:
            widthTheMessageShares * Toast._receiptActionMaxWidthFraction +
                widthHeldForSecondAction,
      ),
      child: actions,
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

  Widget? _buildSecondAction(
    AppTypographyExtension typography,
    AppColorsExtension colors,
  ) {
    final secondaryLabel = widget.secondaryLabel;
    final onSecondary = widget.onSecondary;
    if (secondaryLabel == null || onSecondary == null) return null;

    // Its own Material, so the InkWell works on any parent. Pressed and
    // focused, it draws the library Text button looks on its label, as the
    // alert's text button does, not a tint over the 48 dp target.
    return Semantics(
      container: true,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          key: const Key('toast_secondary_button'),
          onTap: () => _answer(onSecondary),
          onHighlightChanged: (isPressed) =>
              setState(() => _isSecondaryPressed = isPressed),
          onFocusChange: (isFocused) =>
              setState(() => _isSecondaryFocused = isFocused),
          splashFactory: NoSplash.splashFactory,
          overlayColor: WidgetStateProperty.all(colors.transparent),
          child: Semantics(
            button: true,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: CoreSpacing.space12,
                minHeight: CoreSpacing.space12,
                maxHeight: CoreSpacing.space12,
              ),
              child: Center(
                widthFactor: 1,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Text(
                      secondaryLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: typography.bodyLargeSemiBold.copyWith(
                        color: (_isSecondaryPressed
                                ? colors.buttonPress
                                : colors.textLink)
                            .withValues(alpha: Toast._secondaryActionOpacity),
                      ),
                    ),
                    if (_isSecondaryFocused)
                      _buildTextFocusRing(
                        colors,
                        const Key('toast_secondary_focus_ring'),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFocusRing(AppColorsExtension colors, Key key) {
    return Positioned(
      key: key,
      left: -CoreSpacing.space3,
      right: -CoreSpacing.space3,
      top: -_actionFocusRingOutsetY,
      bottom: -_actionFocusRingOutsetY,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: colors.outlineFocus,
            width: _actionFocusRingWidth,
          ),
          borderRadius: BorderRadius.circular(CoreSpacing.space10),
        ),
      ),
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

  Widget _buildAlertControls(
    AppTypographyExtension typography,
    AppColorsExtension colors,
    String closeLabel,
  ) {
    final actionLabel = widget.actionLabel;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (actionLabel != null) ...[
          _buildAlertAction(typography, colors, actionLabel),
          const SizedBox(width: CoreSpacing.space1),
        ],
        _buildCloseButton(colors, closeLabel),
      ],
    );
  }

  Widget _buildAlertAction(
    AppTypographyExtension typography,
    AppColorsExtension colors,
    String actionLabel,
  ) {
    // The library Text button: pressed, the label turns Button/Press; focused,
    // a 3 px ring whose outer edge is 12 px beside and 5 px above and below
    // the label. Neither is a tint over the 48 dp target.
    return Semantics(
      container: true,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          key: const Key('toast_action_button'),
          onTap: () => _answer(widget.onAction),
          onHighlightChanged: (isPressed) =>
              setState(() => _isActionPressed = isPressed),
          onFocusChange: (isFocused) =>
              setState(() => _isActionFocused = isFocused),
          splashFactory: NoSplash.splashFactory,
          overlayColor: WidgetStateProperty.all(colors.transparent),
          child: Semantics(
            button: true,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: CoreSpacing.space12,
                minHeight: CoreSpacing.space12,
              ),
              child: Center(
                widthFactor: 1,
                heightFactor: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: CoreSpacing.space1,
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Text(
                        actionLabel,
                        style: typography.bodyMediumSemiBold.copyWith(
                          color: _isActionPressed
                              ? colors.buttonPress
                              : colors.textLink,
                        ),
                      ),
                      if (_isActionFocused)
                        _buildTextFocusRing(
                          colors,
                          const Key('toast_action_focus_ring'),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCloseButton(AppColorsExtension colors, String closeLabel) {
    // Its own Material, so the InkWell works on any parent. The press and
    // focus looks are drawn on the icon, not as a tint over the 48 dp area.
    return Semantics(
      container: true,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          key: const Key('toast_close_button'),
          onTap: _close,
          onHighlightChanged: (isPressed) =>
              setState(() => _isClosePressed = isPressed),
          onFocusChange: (isFocused) =>
              setState(() => _isCloseFocused = isFocused),
          splashFactory: NoSplash.splashFactory,
          overlayColor: WidgetStateProperty.all(colors.transparent),
          child: Semantics(
            button: true,
            label: closeLabel,
            child: SizedBox.square(
              dimension: CoreSpacing.space12,
              child: Center(
                child: DecoratedBox(
                  key: const Key('toast_close_focus_ring'),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: _isCloseFocused
                        ? Border.all(
                            color: colors.outlineFocus,
                            width: _closeFocusRingWidth,
                          )
                        : null,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(CoreSpacing.space1),
                    child: CoreIconWidget(
                      icon: CoreIcons.cross,
                      size: CoreIconSize.size24,
                      color: _isClosePressed
                          ? colors.buttonPress
                          : colors.iconDark,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
