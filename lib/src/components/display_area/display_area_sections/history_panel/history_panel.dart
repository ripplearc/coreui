part of '../../core_display_area.dart';

/// The upper history section of [CoreDisplayArea].
///
/// Manages the close icon, the [_HistoryChips] of the current session,
/// and the [_PreviousChipsSection] for earlier sessions.
///
/// Stage-based behaviour:
/// - [DisplayAreaStage.collapsed] / [DisplayAreaStage.expandedCurrent]:
///   close icon is visible.
/// - [DisplayAreaStage.expandedPrevious] / [DisplayAreaStage.fullScreen]:
///   close icon and its reserved space are removed via [AnimatedSize].
/// - [DisplayAreaStage.expandedPrevious] / [DisplayAreaStage.fullScreen]:
///   [_PreviousChipsSection] slides in below the current chips.
/// - [DisplayAreaStage.fullScreen]: the entire panel content is scrollable.
class _HistoryPanel extends StatelessWidget {
  const _HistoryPanel({
    this.onClose,
    this.closeSemanticLabel = 'Close',
    required this.chipsList,
    this.previousSessions = const [],
    this.historyPlaceholder = 'Here will show what you type',
    required this.hasError,
    required this.errorMessage,
    required this.stage,
    this.showCurrentChips = true,
  });

  final VoidCallback? onClose;
  final String closeSemanticLabel;
  final List<CoreCalculatorChip> chipsList;
  final List<CoreHistorySessionData> previousSessions;
  final String historyPlaceholder;
  final bool hasError;
  final String errorMessage;
  final DisplayAreaStage stage;
  final bool showCurrentChips;

  static const double _closeBorderWidth = 1.5;

  bool get _showCloseIcon =>
      stage == DisplayAreaStage.collapsed ||
      stage == DisplayAreaStage.expandedCurrent;

  bool get _showPreviousSection =>
      (stage == DisplayAreaStage.expandedPrevious ||
          stage == DisplayAreaStage.fullScreen) &&
      previousSessions.isNotEmpty;

  bool get _isCollapsed => stage == DisplayAreaStage.collapsed;

  bool get _isFullScreen => stage == DisplayAreaStage.fullScreen;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);

    final previousSection = _showPreviousSection
        ? Container(
            width: double.infinity,
            color: colors.backgroundBlueMid,
            padding: const EdgeInsets.only(
              top: CoreSpacing.space3,
              bottom: CoreSpacing.space3,
            ),
            child: _PreviousChipsSection(
              sessions: stage == DisplayAreaStage.expandedPrevious
                  ? [previousSessions.last]
                  : previousSessions,
            ),
          )
        : const SizedBox.shrink();

    final mainColumn = SafeArea(
      child: Column(
        mainAxisSize: _isFullScreen ? MainAxisSize.max : MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isFullScreen && _showPreviousSection)
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: previousSection,
              ),
            )
          else
            AnimatedSize(
              duration: _kDisplayAreaAnimationDuration,
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: previousSection,
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: CoreSpacing.space4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: CoreSpacing.space3),
                if (stage == DisplayAreaStage.expandedPrevious)
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
                if (showCurrentChips)
                  Row(
                    crossAxisAlignment:
                        stage == DisplayAreaStage.expandedCurrent
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.center,
                    children: [
                      AnimatedSize(
                        duration: _kDisplayAreaAnimationDuration,
                        curve: Curves.easeInOut,
                        alignment: Alignment.centerLeft,
                        child: _showCloseIcon
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: stage ==
                                                DisplayAreaStage.expandedCurrent
                                            ? CoreSpacing.space2
                                            : 0),
                                    decoration: BoxDecoration(
                                      color: colors.backgroundBlueMid,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: colors.outlineFocus,
                                        width: _closeBorderWidth,
                                      ),
                                    ),
                                    child: CoreIconWidget(
                                      icon: CoreIcons.cross,
                                      // TODO: [CA-640] Change to CoreIconSize
                                      // https://ripplearc.youtrack.cloud/agiles/176-9/179-48?issue=CA-640
                                      size: CoreSpacing.space7,
                                      color: colors.iconDark,
                                      visualDensity: VisualDensity.compact,
                                      padding: const EdgeInsets.all(
                                          CoreSpacing.space3),
                                      onTap: onClose,
                                      semanticLabel: closeSemanticLabel,
                                    ),
                                  ),
                                  const SizedBox(width: CoreSpacing.space2),
                                ],
                              )
                            : const SizedBox.shrink(),
                      ),
                      if (chipsList.isNotEmpty)
                        Expanded(
                          child: _HistoryChips(
                            chipsList: chipsList,
                            hasError: hasError,
                            errorMessage: errorMessage,
                            isCollapsed: _isCollapsed,
                          ),
                        )
                      else
                        Flexible(
                          child: Text(
                            historyPlaceholder,
                            style: typography.bodyMediumRegular
                                .copyWith(color: colors.textHeadline),
                          ),
                        ),
                    ],
                  ),
                const SizedBox(height: CoreSpacing.space1),
              ],
            ),
          ),
        ],
      ),
    );

    return mainColumn;
  }
}

/// Previous calculation sessions rendered vertically with dividers.
class _PreviousChipsSection extends StatelessWidget {
  const _PreviousChipsSection({required this.sessions});

  final List<CoreHistorySessionData> sessions;
  static const double _dividerThickness = 1;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < sessions.length; i++) ...[
          if (i > 0)
            Divider(
              thickness: _dividerThickness,
              color: colors.lineDarkOutline,
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: CoreSpacing.space4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: CoreSpacing.space4),
                Text(
                  sessions[i].dateLabel,
                  style: typography.titleMediumSemiBold.copyWith(
                    color: colors.textDark,
                  ),
                ),
                const SizedBox(height: CoreSpacing.space5),
                Wrap(
                  spacing: CoreSpacing.space2,
                  runSpacing: CoreSpacing.space2,
                  children: sessions[i].chipsList,
                ),
                const SizedBox(height: CoreSpacing.space5),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    sessions[i].value,
                    style: typography.headlineLargeSemiBold
                        .copyWith(color: colors.textDark),
                  ),
                ),
                const SizedBox(height: CoreSpacing.space1),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
