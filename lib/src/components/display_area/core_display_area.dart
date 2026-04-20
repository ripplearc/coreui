import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ripplearc_coreui.dart';
import 'bloc/display_area_expansion_bloc.dart';
import 'bloc/display_area_expansion_event.dart';

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
class CoreDisplayArea extends StatelessWidget {
  /// The default placeholder text shown when no chips are provided.
  static const String defaultHistoryPlaceholder =
      'Here will show what you type';

  /// The default semantic label for the close icon.
  static const String defaultCloseSemanticLabel = 'Close';

  /// Chip-count threshold. More than this value activates the three-stage path.
  static const int _twoRowChipThreshold = 5;

  const CoreDisplayArea({
    super.key,
    this.onClose,
    this.closeSemanticLabel = defaultCloseSemanticLabel,
    this.chipsList = const [],
    this.previousSessions = const [],
    this.historyPlaceholder = defaultHistoryPlaceholder,
    this.label = '',
    this.isTyping = false,
    this.value = '',
    this.hasError = false,
    this.errorMessage = '',
    this.errorTitle = '',
    this.dependentKeyLabel = '',
    this.dependentKeyValue = '',
    this.onPressedDependentKey,
    this.onStageChanged,
  });

  /// Called when the user taps the close icon.
  final VoidCallback? onClose;

  /// The semantic label announced by screen readers for the close icon.
  /// Defaults to [defaultCloseSemanticLabel].
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
  /// Defaults to [defaultHistoryPlaceholder]. Pass a localised string from
  /// the app layer:
  /// ```dart
  /// historyPlaceholder: AppLocalizations.of(context).historyPlaceholder,
  /// ```
  final String historyPlaceholder;

  /// Main label text shown in the label section. Defaults to `''`.
  final String label;

  /// Whether to display a typing-animation indicator next to [label].
  /// Defaults to `false`.
  final bool isTyping;

  /// Main value text shown in the value section. Defaults to `''`.
  final String value;

  /// Whether the display area is in an error state. Defaults to `false`.
  final bool hasError;

  /// Error message shown as a chip when [hasError] is `true`.
  final String errorMessage;

  /// The error title to display in the value section when [hasError] is true.
  /// Defaults to 'Error'.
  final String errorTitle;

  /// Label for the dependent key button in the value section. Defaults to `''`.
  final String dependentKeyLabel;

  /// Value for the dependent key button in the value section. Defaults to `''`.
  final String dependentKeyValue;

  /// Called when the user taps the dependent key button.
  final VoidCallback? onPressedDependentKey;

  /// Called whenever the expansion stage changes.
  ///
  /// Use this to drive external animations — for example sliding a keyboard
  /// component downward as the display area expands:
  /// ```dart
  /// onStageChanged: (stage) => setState(() => _stage = stage),
  /// ```
  final void Function(DisplayAreaStage stage)? onStageChanged;

  @override
  Widget build(BuildContext context) {
    final bool exceedsTwoRows = chipsList.length > _twoRowChipThreshold;

    return BlocProvider<DisplayAreaExpansionBloc>(
      create: (_) => DisplayAreaExpansionBloc(),
      child: BlocConsumer<DisplayAreaExpansionBloc, DisplayAreaExpansionState>(
        listener: (_, state) => onStageChanged?.call(state.stage),
        builder: (context, state) => _buildBody(
          context: context,
          state: state,
          bloc: context.read<DisplayAreaExpansionBloc>(),
          exceedsTwoRows: exceedsTwoRows,
        ),
      ),
    );
  }

  Widget _buildBody({
    required BuildContext context,
    required DisplayAreaExpansionState state,
    required DisplayAreaExpansionBloc bloc,
    required bool exceedsTwoRows,
  }) {
    final colors = AppColorsExtension.of(context);
    final int _kSwipeVelocityThreshold = 80;
    final stage = state.stage;
    final columnChildren = <Widget>[
      if (stage == DisplayAreaStage.fullScreen)
        Expanded(
          child: _HistoryPanel(
            onClose: () {
              bloc.add(CollapseEvent());
              onClose?.call();
            },
            closeSemanticLabel: closeSemanticLabel,
            chipsList: chipsList,
            previousSessions: previousSessions,
            historyPlaceholder: historyPlaceholder,
            errorMessage: errorMessage,
            hasError: hasError,
            stage: stage,
            showCurrentChips: false,
          ),
        )
      else
        _HistoryPanel(
          onClose: () {
            bloc.add(CollapseEvent());
            onClose?.call();
          },
          closeSemanticLabel: closeSemanticLabel,
          chipsList: chipsList,
          previousSessions: previousSessions,
          historyPlaceholder: historyPlaceholder,
          errorMessage: errorMessage,
          hasError: hasError,
          stage: stage,
        ),
      DecoratedBox(
        decoration: BoxDecoration(
          color: stage == DisplayAreaStage.fullScreen
              ? colors.backgroundBlueLight
              : colors.transparent,
          borderRadius: stage == DisplayAreaStage.fullScreen
              ? const BorderRadius.vertical(
                  top: Radius.circular(CoreSpacing.space7))
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: CoreSpacing.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (stage == DisplayAreaStage.fullScreen) ...[
                const SizedBox(height: CoreSpacing.space3),
                Center(
                  child: Container(
                    width: CoreSpacing.space8,
                    height: 2,
                    margin: const EdgeInsets.only(bottom: CoreSpacing.space4),
                    decoration: BoxDecoration(
                      color: colors.lineDarkOutline,
                      borderRadius: BorderRadius.circular(CoreSpacing.space1),
                    ),
                  ),
                ),
                _HistoryChips(
                  chipsList: chipsList,
                  hasError: hasError,
                  errorMessage: errorMessage,
                  isCollapsed: false,
                ),
              ],
              if (label.isNotEmpty || isTyping)
                _LabelSection(label: label, isTyping: isTyping),
              if (value.isNotEmpty ||
                  hasError ||
                  dependentKeyLabel.isNotEmpty ||
                  dependentKeyValue.isNotEmpty)
                _ValueSection(
                  value: value,
                  hasError: hasError,
                  errorTitle: errorTitle,
                  dependentKeyLabel: dependentKeyLabel,
                  dependentKeyValue: dependentKeyValue,
                  onPressedDependentKey: onPressedDependentKey,
                ),
              if (stage != DisplayAreaStage.collapsed)
                const SizedBox(height: CoreSpacing.space5),
              if (stage == DisplayAreaStage.fullScreen)
                const SizedBox(height: CoreSpacing.space10),
            ],
          ),
        ),
      ),
    ];

    final innerColumn = Column(
      mainAxisSize: stage == DisplayAreaStage.fullScreen
          ? MainAxisSize.max
          : MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columnChildren,
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragEnd: (details) {
        final velocity = details.primaryVelocity ?? 0;
        if (velocity > _kSwipeVelocityThreshold) {
          bloc.add(SwipeDownEvent(exceedsTwoRows: exceedsTwoRows));
        } else if (velocity < -_kSwipeVelocityThreshold) {
          bloc.add(SwipeUpEvent(exceedsTwoRows: exceedsTwoRows));
        }
      },
      child: AnimatedSize(
        duration: _kDisplayAreaAnimationDuration,
        curve: Curves.easeInOut,
        alignment: Alignment.topCenter,
        child: Container(
          width: double.infinity,
          height: stage == DisplayAreaStage.fullScreen
              ? MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.vertical
              : null,
          constraints: stage == DisplayAreaStage.collapsed
              ? const BoxConstraints(
                  minHeight: CoreSpacing.space57,
                  maxHeight: CoreSpacing.space57,
                )
              : null,
          decoration: BoxDecoration(
            color: stage == DisplayAreaStage.fullScreen
                ? colors.backgroundBlueMid
                : colors.backgroundBlueLight,
            borderRadius: stage == DisplayAreaStage.fullScreen
                ? BorderRadius.zero
                : const BorderRadius.only(
                    bottomLeft: Radius.circular(CoreSpacing.space7),
                    bottomRight: Radius.circular(CoreSpacing.space7),
                  ),
          ),
          child: stage == DisplayAreaStage.fullScreen
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
