import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../../../ripplearc_coreui.dart';
import '../calculator_chips/core_calculator_chip_theme.dart';
import 'display_area_stage_controller.dart' as logic;

part 'display_area_sections/history_panel/banded_wrap.dart';
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
/// ## Accessibility
///
/// The value text is a live region: a screen reader announces the new value
/// (or [errorTitle]) whenever it changes, so a result computed from the
/// keyboard is heard without moving focus. Each dependent-key pill announces
/// its label — or [CoreDependentKeyData.semanticsLabel] — followed by
/// [CoreDependentKeyData.semanticsHint], the spoken counterpart of the
/// trailing icon that says what a tap does.
///
/// ## Test keys
///
/// Every dependent-key pill carries a stable [Key] for Patrol and widget
/// tests: [CoreDependentKeyData.testKey], or [dependentKeyTestKey] by
/// position in the rendered row.
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
///
/// ## Large text
///
/// The collapsed area is 228 dp tall at the default text size and at any
/// smaller one. At a larger text size it grows with what it shows, up to
/// 228 dp times the scale of the text, so the value stays visible: at 200%
/// a chip, a two-line label and the value need about 260 dp, and the area
/// is that tall. Past that limit the area still cuts what does not fit, as
/// a placeholder that wraps onto many lines at 300% does.
///
/// From about 125% text up, the close icon of the collapsed area is centred
/// on the first row of chips and stays beside that row when the chips wrap
/// onto more rows. Below that the icon is taller than a chip row and sits
/// where it always did, its centre 2.5 dp below the chip's at 100%.
class CoreDisplayArea extends StatefulWidget {
  /// Chip-count threshold. More than this value activates the three-stage path.
  static const int _twoRowChipThreshold = 5;

  /// The default [Key] of the pill at [index] in [resolvedDependentKeys]:
  /// `calc_dep_pill_<index>`. [CoreDependentKeyData.testKey] overrides it.
  static Key dependentKeyTestKey(int index) => ValueKey('calc_dep_pill_$index');

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
    this.onPreviousSessionTapped,
    this.restoreSemanticsLabel,
    this.emptyTapeTrailing,
    this.workedFirstBand,
  }) : assert(
          onPreviousSessionTapped == null || restoreSemanticsLabel != null,
          'A tappable session card needs restoreSemanticsLabel: a control a '
          'screen reader cannot announce is invisible to it.',
        );

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

  /// A widget placed at the end of the row that shows [historyPlaceholder]
  /// while [chipsList] is empty: the calculator's System of units pill.
  /// Defaults to `null`, which leaves the row as it was.
  ///
  /// The row makes room for it: the placeholder takes the width that is left
  /// between the close icon and the widget and wraps when it needs to, so the
  /// two never overlap on a narrow phone. The widget is laid out at its own
  /// width, so keep it to a short word: one wider than the space beside the
  /// close icon overflows the row rather than wrapping its own text. It
  /// leaves with the placeholder: not rendered once the tape has a chip, nor
  /// in [DisplayAreaStage.expandedPrevious] and [DisplayAreaStage.fullScreen],
  /// where the close icon and its row are hidden. The widget brings its own
  /// semantics; a tappable one should carry a label.
  ///
  /// With a widget in the slot the row is at least 48 dp tall, the library's
  /// tap target, 8 dp more than the 40 dp close icon alone, and the area
  /// absorbs it. A small [CoreButton], as below, already meets that target:
  /// its 36 dp body sits in its own 48 dp hit area, so it needs no second
  /// one.
  ///
  /// The close icon and the widget are centred on that first 48 dp and stay
  /// at the top of the row. A widget taller than 48 dp, such as a small
  /// [CoreButton] at the largest text size, starts at the top of the row
  /// instead, and the close icon stays centred on the first 48 dp, a few dp
  /// above the widget's centre. A placeholder that wraps past it, as it does
  /// beside a wide widget at a large text size, grows the row downward and
  /// moves neither of them, so both stay inside the collapsed area and can
  /// be tapped.
  /// ```dart
  /// emptyTapeTrailing: CoreButton(
  ///   size: CoreButtonSize.small,
  ///   variant: CoreButtonVariant.secondary,
  ///   fullWidth: false,
  ///   semanticsLabel: l10n.unitSystemPill(state.unitSystem),
  ///   onPressed: () => bloc.add(const UnitSystemSwitched()),
  ///   child: Text(l10n.unitSystemName(state.unitSystem)),
  /// ),
  /// ```
  final Widget? emptyTapeTrailing;

  /// The chips of [chipsList] a grey band is drawn behind: the part of the
  /// chain that is worked first, `2` and `+3` in `2 + 3 × 4` (UX Design Doc
  /// rule 4.6). The band is drawn behind the chips, so no chip moves and
  /// the gaps do not change. It reaches 6 dp past the chips at each side
  /// and 4 dp above and below, into the 8 dp gaps, with 12 dp corners and a
  /// 1 px edge; chips on one run share a box and a span that wraps gets a
  /// box per run. A span that runs past the last chip stops at the last
  /// chip, and one that starts past it draws nothing, so the band is never
  /// behind the error chip. Defaults to `null`, no band. The consumer works
  /// the span out from the keys; the area only shows it.
  /// ```dart
  /// workedFirstBand: CoreWorkedFirstBand(
  ///   start: 0,
  ///   end: 1,
  ///   semanticsLabel: l10n.workedFirst('2 plus 3', '5'),
  /// ),
  /// ```
  final CoreWorkedFirstBand? workedFirstBand;

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

  /// Called with a session's `id` when the user taps its card in the history
  /// panel, so the consumer can restore that tape.
  ///
  /// Only sessions carrying a [CoreHistorySessionData.id] are tappable; the
  /// rest render as plain cards. Requires [restoreSemanticsLabel].
  /// ```dart
  /// onPreviousSessionTapped: (id) => controller.restoreSession(id),
  /// ```
  final ValueChanged<String>? onPreviousSessionTapped;

  /// The semantic label announced by screen readers for a session card.
  ///
  /// Required alongside [onPreviousSessionTapped]: localisation is the
  /// consumer's responsibility. Pass a localised string from the app layer:
  /// ```dart
  /// restoreSemanticsLabel: AppLocalizations.of(context).restoreSession,
  /// ```
  final String? restoreSemanticsLabel;

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
    final typography = AppTypographyExtension.of(context);
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
          onPreviousSessionTapped: widget.onPreviousSessionTapped,
          restoreSemanticsLabel: widget.restoreSemanticsLabel,
          emptyTapeTrailing: widget.emptyTapeTrailing,
          workedFirstBand: widget.workedFirstBand,
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
                  band: widget.workedFirstBand,
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
              ? BoxConstraints(
                  minHeight: CoreSpacing.space57,
                  maxHeight: CoreSpacing.space57 *
                      _HistoryChips.largeTextFactor(context, typography),
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
