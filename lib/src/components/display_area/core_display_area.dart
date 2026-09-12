import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../ripplearc_coreui.dart';
import 'display_area_stage_controller.dart' as logic;

part 'display_area_sections/history_panel/history_chips.dart';
part 'display_area_sections/history_panel/history_panel.dart';
part 'display_area_sections/label_section.dart';
part 'display_area_sections/value_section.dart';

/// Shared animation duration used across all display-area expansion transitions.
const Duration _kDisplayAreaAnimationDuration = Duration(milliseconds: 300);

/// A self-contained display area with a gesture-driven multi-stage expansion.
///
/// [hasError] toggles the error state. When true, [errorTitle] replaces the
/// value display and [errorMessage] appears as an error chip.
///
/// ## Dependent keys
///
/// An answer keeps its assumption on screen: [dependentKeys] renders a row of
/// pills under the value — editable assumptions (`Rate: $12.3/ft²`), toggles
/// that respell the value (`Shown as: in/12in`), and one-time offers
/// (`Re-input 38.30° as 38°30′`). The row is end-aligned and scrolls
/// horizontally when the pills outgrow the width.
///
/// ## Swipe interaction
///
/// **When chips fit in two rows or fewer** (`chipsList.length ≤ 5`):
/// - 1st swipe → reveals previous-session chips.
/// - 2nd swipe → full-screen history view.
///
/// **When chips exceed two rows** (`chipsList.length > 5`):
/// - 1st swipe → reveals all current-session chips (haptic feedback).
/// - 2nd swipe → reveals previous-session chips (haptic feedback).
/// - 3rd swipe → full-screen history view.
///
/// The close icon and its reserved space are hidden in
/// [DisplayAreaStage.expandedPrevious] and [DisplayAreaStage.fullScreen].
/// Use [onStageChanged] to react to stage transitions — for example to
/// animate a keyboard component out of view.
class CoreDisplayArea extends StatefulWidget {
  /// Chip-count threshold. More than this value activates the three-stage path.
  static const int _twoRowChipThreshold = 5;

  const CoreDisplayArea({
    super.key,
    this.onClose,
    required this.closeSemanticLabel,
    this.chipsList = const [],
    this.previousSessions = const [],
    required this.historyPlaceholder,
    this.label,
    this.isTyping = false,
    this.value,
    this.hasError = false,
    this.errorMessage = '',
    this.errorTitle = '',
    this.dependentKeys = const [],
    @Deprecated('Use dependentKeys. The single-pill adapter is removed in the '
        'next minor release.')
    this.dependentKeyLabel,
    @Deprecated('Use dependentKeys. The single-pill adapter is removed in the '
        'next minor release.')
    this.dependentKeyValue,
    @Deprecated('Use dependentKeys. The single-pill adapter is removed in the '
        'next minor release.')
    this.onPressedDependentKey,
    this.onStageChanged,
  });

  /// Called when the user taps the close icon.
  final VoidCallback? onClose;

  /// The semantic label announced by screen readers for the close icon.
  ///
  /// Required: localisation is the consumer's responsibility. Pass a localised
  /// string from the app layer:
  /// ```dart
  /// closeSemanticLabel: AppLocalizations.of(context).closeButton,
  /// ```
  final String closeSemanticLabel;

  /// Current-session chips displayed in the history panel.
  /// Defaults to an empty list.
  final List<CoreCalculatorChip> chipsList;

  /// Past sessions revealed in [DisplayAreaStage.expandedPrevious]
  /// and [DisplayAreaStage.fullScreen].
  /// Defaults to an empty list.
  final List<CoreHistorySessionData> previousSessions;

  /// Placeholder text shown when [chipsList] is empty.
  ///
  /// Required: localisation is the consumer's responsibility. Pass a localised
  /// string from the app layer:
  /// ```dart
  /// historyPlaceholder: AppLocalizations.of(context).historyPlaceholder,
  /// ```
  final String historyPlaceholder;

  /// Main label text shown in the label section. Defaults to `null`.
  final String? label;

  /// Whether to display a typing-animation indicator next to [label].
  /// Defaults to `false`.
  final bool isTyping;

  /// Main value text shown in the value section. Defaults to `null`.
  final String? value;

  /// Whether the display area is in an error state. Defaults to `false`.
  final bool hasError;

  /// Error message shown as a chip when [hasError] is `true`.
  final String errorMessage;

  /// The error title to display in the value section when [hasError] is true.
  /// Defaults to 'Error'.
  final String errorTitle;

  /// The pills rendered under the value, in order. Defaults to an empty list.
  ///
  /// The row is end-aligned and scrolls horizontally: when the pills outgrow
  /// the width the trailing pill stays in view and the leading ones scroll in
  /// from the start edge. Every user-facing string on a pill comes from the
  /// consumer: the label, the value and the optional
  /// [CoreDependentKeyData.semanticsLabel].
  final List<CoreDependentKeyData> dependentKeys;

  /// Label for the legacy single dependent-key pill. Defaults to `null`.
  ///
  /// Deprecated adapter: rendered as one [CoreDependentKeyKind.editable] pill
  /// appended after [dependentKeys]. Use [dependentKeys] instead.
  @Deprecated('Use dependentKeys. The single-pill adapter is removed in the '
      'next minor release.')
  final String? dependentKeyLabel;

  /// Value for the legacy single dependent-key pill. Defaults to `null`.
  ///
  /// Deprecated adapter: see [dependentKeyLabel].
  @Deprecated('Use dependentKeys. The single-pill adapter is removed in the '
      'next minor release.')
  final String? dependentKeyValue;

  /// Called when the user taps the legacy single dependent-key pill.
  ///
  /// Deprecated adapter: see [dependentKeyLabel].
  @Deprecated('Use dependentKeys. The single-pill adapter is removed in the '
      'next minor release.')
  final VoidCallback? onPressedDependentKey;

  /// The pills `build` renders: [dependentKeys] followed by the legacy
  /// single pill when [dependentKeyLabel] or [dependentKeyValue] is set.
  ///
  /// Exposed so tests can assert the adapter without reaching into the
  /// widget tree; `build` consumes this same getter.
  @visibleForTesting
  List<CoreDependentKeyData> get resolvedDependentKeys {
    final legacyLabel = dependentKeyLabel;
    final legacyValue = dependentKeyValue;
    final hasLegacy = (legacyLabel?.isNotEmpty ?? false) ||
        (legacyValue?.isNotEmpty ?? false);
    return [
      ...dependentKeys,
      if (hasLegacy)
        CoreDependentKeyData(
          label: legacyLabel ?? '',
          value: legacyValue ?? '',
          kind: CoreDependentKeyKind.editable,
          onPressed: onPressedDependentKey,
        ),
    ];
  }

  /// Called whenever the expansion stage changes.
  ///
  /// Use this to drive external animations — for example sliding a keyboard
  /// component downward as the display area expands:
  /// ```dart
  /// onStageChanged: (stage) => setState(() => _stage = stage),
  /// ```
  final void Function(DisplayAreaStage stage)? onStageChanged;

  @override
  State<CoreDisplayArea> createState() => _CoreDisplayAreaState();
}

class _CoreDisplayAreaState extends State<CoreDisplayArea> {
  DisplayAreaStage _stage = DisplayAreaStage.collapsed;

  void _updateStage(DisplayAreaStage next) {
    if (next == _stage) return;
    if (next.index > _stage.index) HapticFeedback.mediumImpact();
    if (next.index < _stage.index) HapticFeedback.lightImpact();
    setState(() => _stage = next);
    widget.onStageChanged?.call(next);
  }

  @override
  void didUpdateWidget(CoreDisplayArea oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.previousSessions.isEmpty &&
        oldWidget.previousSessions.isNotEmpty &&
        (_stage == DisplayAreaStage.expandedPrevious ||
            _stage == DisplayAreaStage.fullScreen)) {
      final exceedsTwoRows =
          widget.chipsList.length > CoreDisplayArea._twoRowChipThreshold;
      _updateStage(exceedsTwoRows
          ? DisplayAreaStage.expandedCurrent
          : DisplayAreaStage.collapsed);
    }
  }

  void _handleCollapse() {
    _updateStage(DisplayAreaStage.collapsed);
    widget.onClose?.call();
  }

  static const int _kSwipeVelocityThreshold = 80;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final mq = MediaQuery.of(context);
    final dependentKeys = widget.resolvedDependentKeys;

    final columnChildren = <Widget>[
      Flexible(
        flex: _stage == DisplayAreaStage.fullScreen ? 1 : 0,
        child: _HistoryPanel(
          key: const Key('display_area_history_panel'),
          onClose: _handleCollapse,
          closeSemanticLabel: widget.closeSemanticLabel,
          chipsList: widget.chipsList,
          previousSessions: widget.previousSessions,
          historyPlaceholder: widget.historyPlaceholder,
          errorMessage: widget.errorMessage,
          hasError: widget.hasError,
          stage: _stage,
          showCurrentChips: _stage != DisplayAreaStage.fullScreen,
        ),
      ),
      DecoratedBox(
        decoration: BoxDecoration(
          color: _stage == DisplayAreaStage.fullScreen
              ? colors.backgroundBlueLight
              : colors.transparent,
          borderRadius: _stage == DisplayAreaStage.fullScreen
              ? const BorderRadius.vertical(
                  top: Radius.circular(CoreSpacing.space7))
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: CoreSpacing.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_stage == DisplayAreaStage.fullScreen) ...[
                const SizedBox(height: CoreSpacing.space3),
                const _DragHandle(),
                _HistoryChips(
                  chipsList: widget.chipsList,
                  hasError: widget.hasError,
                  errorMessage: widget.errorMessage,
                  isCollapsed: false,
                ),
              ],
              if ((widget.label?.isNotEmpty ?? false) || widget.isTyping)
                _LabelSection(label: widget.label, isTyping: widget.isTyping),
              if ((widget.value?.isNotEmpty ?? false) ||
                  widget.hasError ||
                  dependentKeys.isNotEmpty)
                _ValueSection(
                  value: widget.value,
                  hasError: widget.hasError,
                  errorTitle: widget.errorTitle,
                  dependentKeys: dependentKeys,
                ),
              if (_stage != DisplayAreaStage.collapsed)
                const SizedBox(height: CoreSpacing.space5),
              if (_stage == DisplayAreaStage.fullScreen)
                const SizedBox(height: CoreSpacing.space10),
            ],
          ),
        ),
      ),
    ];

    final innerColumn = Column(
      mainAxisSize: _stage == DisplayAreaStage.fullScreen
          ? MainAxisSize.max
          : MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columnChildren,
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragEnd: (details) {
        final velocity = details.primaryVelocity ?? 0;
        final exceedsTwoRows =
            widget.chipsList.length > CoreDisplayArea._twoRowChipThreshold;

        if (velocity > _kSwipeVelocityThreshold) {
          final nextStage = logic.DisplayAreaStageController.next(
            _stage,
            exceedsTwoRows: exceedsTwoRows,
          );
          if (widget.previousSessions.isEmpty &&
              (nextStage == DisplayAreaStage.expandedPrevious ||
                  nextStage == DisplayAreaStage.fullScreen)) {
            return;
          }
          _updateStage(nextStage);
        } else if (velocity < -_kSwipeVelocityThreshold) {
          final nextStage = logic.DisplayAreaStageController.previous(
            _stage,
            exceedsTwoRows: exceedsTwoRows,
          );
          _updateStage(nextStage);
        }
      },
      child: AnimatedSize(
        duration: _kDisplayAreaAnimationDuration,
        curve: Curves.easeInOut,
        alignment: Alignment.topCenter,
        child: Container(
          width: double.infinity,
          height: _stage == DisplayAreaStage.fullScreen
              ? mq.size.height - mq.padding.vertical - mq.viewInsets.bottom
              : null,
          constraints: _stage == DisplayAreaStage.collapsed
              ? const BoxConstraints(
                  minHeight: CoreSpacing.space57,
                  maxHeight: CoreSpacing.space57,
                )
              : null,
          decoration: BoxDecoration(
            color: _stage == DisplayAreaStage.fullScreen
                ? colors.backgroundBlueMid
                : colors.backgroundBlueLight,
            borderRadius: _stage == DisplayAreaStage.fullScreen
                ? BorderRadius.zero
                : const BorderRadius.only(
                    bottomLeft: Radius.circular(CoreSpacing.space7),
                    bottomRight: Radius.circular(CoreSpacing.space7),
                  ),
          ),
          child: _stage == DisplayAreaStage.fullScreen
              ? innerColumn
              : SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: innerColumn,
                ),
        ),
      ),
    );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    return Center(
      child: Container(
        width: CoreSpacing.space8,
        height: 2,
        margin: const EdgeInsets.only(bottom: CoreSpacing.space4),
        decoration: BoxDecoration(
          color: colors.lineDarkOutline,
          borderRadius: BorderRadius.circular(CoreSpacing.space1),
        ),
      ),
    );
  }
}
