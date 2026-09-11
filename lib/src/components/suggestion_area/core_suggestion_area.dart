import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

part 'parts/ai_toggle.dart';
part 'parts/suggestion_list.dart';
part 'parts/toggle_button.dart';

/// How [CoreSuggestionArea] lays out [CoreSuggestionArea.aiSuggestions] and
/// [CoreSuggestionArea.conversionSuggestions].
enum CoreSuggestionLayout {
  /// One row. When both lists are provided a leading AI / conversion toggle
  /// switches between them. The original layout; the calculator keeps it
  /// behind its "Strip layout" preference.
  toggle,

  /// Two rows, both visible at once with independent overflow: row 1 is the
  /// rung that fired (Area / Sheets / Cost…), row 2 is unit conversions of the
  /// value on screen. No toggle. The calculator's default (prototype
  /// `strip: 'tworow'`).
  twoRows,
}

/// A component that displays AI and unit conversion suggestions.
///
/// This widget provides a dedicated area for presenting smart recommendations
/// to the user, including AI-driven insights and contextual unit conversions.
/// [layout] picks between the single-row toggle presentation and the
/// calculator's two-row presentation, where the primary row and the
/// conversions row are visible together and overflow independently;
/// [secondRowHidden] lets the app fold the conversions row away when the
/// dependent-key band under the value needs the space.
///
/// Each [SuggestionData] carries a [SuggestionKind]; a [SuggestionKind.bind]
/// offer renders with the dashed [CoreChipOutline.dashed] look and a trailing
/// [bindSuffix], because accepting it relabels an existing chip instead of
/// adding a result.
///
/// Displays [suggestionAreaPlaceholder] when nothing is visible: both lists
/// are null or empty, or only conversions exist and [secondRowHidden] is set.
class CoreSuggestionArea extends StatefulWidget {
  const CoreSuggestionArea({
    super.key,
    this.suggestionAreaPlaceholder = defaultSuggestionAreaPlaceholder,
    this.aiSuggestions,
    this.conversionSuggestions,
    this.onExpandedChanged,
    required this.hiddenChipsTextBuilder,
    required this.expandToggleSemanticsLabelBuilder,
    required this.collapseToggleSemanticsLabel,
    required this.toggleSemanticsLabel,
    this.bindSuffix = defaultBindSuffix,
    this.layout = CoreSuggestionLayout.toggle,
    this.secondRowHidden = false,
    this.conversionsExpandToggleSemanticsLabelBuilder,
    this.conversionsCollapseToggleSemanticsLabel,
  });

  /// The default placeholder text shown when no suggestions are provided.
  static const String defaultSuggestionAreaPlaceholder =
      'Here you can see smart suggestions from us';

  /// Duration of every size transition in the area — expanding a row, folding
  /// the conversions row away, the container itself. Matches the display
  /// area's stage animation so the two surfaces move together.
  static const Duration animationDuration = Duration(milliseconds: 300);

  /// The default trailing marker of a [SuggestionKind.bind] chip.
  static const String defaultBindSuffix = '?';

  /// Placeholder text shown in the suggestion area.
  ///
  /// Defaults to [defaultSuggestionAreaPlaceholder]. Pass a localised string from
  /// the app layer:
  /// ```dart
  /// suggestionAreaPlaceholder: AppLocalizations.of(context).suggestionAreaPlaceholder,
  /// ```
  final String suggestionAreaPlaceholder;

  /// The list of AI recommendations to display. Nullable.
  final List<SuggestionData>? aiSuggestions;

  /// The list of conversion metrics to display. Nullable.
  final List<SuggestionData>? conversionSuggestions;

  /// Called when the suggestion area expands or collapses.
  ///
  /// Passes `true` when expanded, `false` when collapsed.
  final ValueChanged<bool>? onExpandedChanged;

  /// Builds the visible overflow label (e.g. `'+3'`). Must be localised by the app.
  final String Function(int count) hiddenChipsTextBuilder;

  /// Semantics label for the expand control when collapsed. Receives hidden chip count.
  final String Function(int hiddenCount) expandToggleSemanticsLabelBuilder;

  /// Semantics label for the collapse control when expanded.
  final String collapseToggleSemanticsLabel;

  /// Semantics label for the AI / conversion toggle shown when both lists are
  /// provided.
  ///
  /// Required: localisation is the consumer's responsibility. Pass a localised
  /// string from the app layer:
  /// ```dart
  /// toggleSemanticsLabel: AppLocalizations.of(context).toggleSuggestionMode,
  /// ```
  final String toggleSemanticsLabel;

  /// Trailing marker appended to a [SuggestionKind.bind] chip's last text
  /// segment ("Height: 8ft ?"), so an offer reads as a question rather than a
  /// fact. Defaults to [defaultBindSuffix]; override it per locale.
  final String bindSuffix;

  /// Which presentation to use. Defaults to [CoreSuggestionLayout.toggle], so
  /// existing callers are unchanged.
  final CoreSuggestionLayout layout;

  /// In [CoreSuggestionLayout.twoRows], folds the conversions row away (an
  /// [AnimatedSize] over [animationDuration]) so the display area's
  /// dependent-key band can take the space. Ignored in
  /// [CoreSuggestionLayout.toggle]. Defaults to `false`.
  final bool secondRowHidden;

  /// Semantics label for the conversions row's expand control in
  /// [CoreSuggestionLayout.twoRows], so a screen reader can tell it apart from
  /// the primary row's. Receives the hidden chip count. Falls back to
  /// [expandToggleSemanticsLabelBuilder] when null; ignored in
  /// [CoreSuggestionLayout.toggle].
  final String Function(int hiddenCount)?
      conversionsExpandToggleSemanticsLabelBuilder;

  /// Semantics label for the conversions row's collapse control in
  /// [CoreSuggestionLayout.twoRows]. Falls back to
  /// [collapseToggleSemanticsLabel] when null; ignored in
  /// [CoreSuggestionLayout.toggle].
  final String? conversionsCollapseToggleSemanticsLabel;

  @override
  State<CoreSuggestionArea> createState() => _CoreSuggestionAreaState();
}

class _CoreSuggestionAreaState extends State<CoreSuggestionArea> {
  SuggestionMode _mode = SuggestionMode.ai;
  bool _isExpanded = false;
  bool _isSecondaryExpanded = false;

  bool get _isAnyExpanded => _isExpanded || _isSecondaryExpanded;

  void _setExpanded({bool? primary, bool? secondary}) {
    final wasAnyExpanded = _isAnyExpanded;
    setState(() {
      if (primary != null) _isExpanded = primary;
      if (secondary != null) _isSecondaryExpanded = secondary;
    });
    if (wasAnyExpanded != _isAnyExpanded) {
      widget.onExpandedChanged?.call(_isAnyExpanded);
    }
  }

  void _collapseAll() {
    final wasAnyExpanded = _isAnyExpanded;
    _isExpanded = false;
    _isSecondaryExpanded = false;
    if (wasAnyExpanded) widget.onExpandedChanged?.call(false);
  }

  bool _areSuggestionsEqual(List<SuggestionData>? a, List<SuggestionData>? b) {
    if (identical(a, b)) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i].label != b[i].label ||
          a[i].value != b[i].value ||
          a[i].unit != b[i].unit ||
          a[i].kind != b[i].kind ||
          a[i].semanticsLabel != b[i].semanticsLabel) {
        return false;
      }
    }
    return true;
  }

  @override
  void didUpdateWidget(CoreSuggestionArea oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_areSuggestionsEqual(widget.aiSuggestions, oldWidget.aiSuggestions) ||
        !_areSuggestionsEqual(
            widget.conversionSuggestions, oldWidget.conversionSuggestions) ||
        widget.layout != oldWidget.layout) {
      _collapseAll();
    } else if (widget.secondRowHidden &&
        !oldWidget.secondRowHidden &&
        _isSecondaryExpanded) {
      _isSecondaryExpanded = false;
      if (!_isExpanded) widget.onExpandedChanged?.call(false);
    }
  }

  Widget _buildRow({
    required Key key,
    required List<SuggestionData>? suggestions,
    required bool isExpanded,
    required ValueChanged<bool> onExpandedChanged,
    Widget? leadingWidget,
    String Function(int hiddenCount)? expandToggleSemanticsLabelBuilder,
    String? collapseToggleSemanticsLabel,
  }) {
    return _SuggestionList(
      key: key,
      suggestions: suggestions,
      isExpanded: isExpanded,
      onExpandedChanged: onExpandedChanged,
      hiddenChipsTextBuilder: widget.hiddenChipsTextBuilder,
      expandToggleSemanticsLabelBuilder: expandToggleSemanticsLabelBuilder ??
          widget.expandToggleSemanticsLabelBuilder,
      collapseToggleSemanticsLabel:
          collapseToggleSemanticsLabel ?? widget.collapseToggleSemanticsLabel,
      bindSuffix: widget.bindSuffix,
      leadingWidget: leadingWidget,
    );
  }

  Widget _animatedSize({required Widget child}) {
    return ClipRect(
      child: AnimatedSize(
        duration: CoreSuggestionArea.animationDuration,
        alignment: AlignmentDirectional.topStart,
        curve: Curves.easeInOut,
        child: child,
      ),
    );
  }

  Widget _buildToggleLayout({required bool hasAi, required bool hasConv}) {
    final bool hasBothLists = hasAi && hasConv;
    final activeList = hasBothLists
        ? (_mode == SuggestionMode.ai
            ? widget.aiSuggestions
            : widget.conversionSuggestions)
        : (hasAi ? widget.aiSuggestions : widget.conversionSuggestions);

    return _animatedSize(
      child: _buildRow(
        key: const ValueKey('suggestion_row_toggle'),
        suggestions: activeList,
        isExpanded: _isExpanded,
        onExpandedChanged: (expanded) => _setExpanded(primary: expanded),
        leadingWidget: hasBothLists
            ? _AIToggle(
                mode: _mode,
                semanticsLabel: widget.toggleSemanticsLabel,
                onChanged: (value) {
                  setState(() {
                    _mode = value;
                  });
                },
              )
            : null,
      ),
    );
  }

  Widget _buildTwoRowLayout({required bool hasAi, required bool hasConv}) {
    final bool showSecondRow = hasConv && !widget.secondRowHidden;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _animatedSize(
          child: hasAi
              ? _buildRow(
                  key: const ValueKey('suggestion_row_primary'),
                  suggestions: widget.aiSuggestions,
                  isExpanded: _isExpanded,
                  onExpandedChanged: (expanded) =>
                      _setExpanded(primary: expanded),
                )
              : const SizedBox.shrink(),
        ),
        _animatedSize(
          child: showSecondRow
              ? _buildRow(
                  key: const ValueKey('suggestion_row_conversions'),
                  suggestions: widget.conversionSuggestions,
                  isExpanded: _isSecondaryExpanded,
                  onExpandedChanged: (expanded) =>
                      _setExpanded(secondary: expanded),
                  expandToggleSemanticsLabelBuilder:
                      widget.conversionsExpandToggleSemanticsLabelBuilder,
                  collapseToggleSemanticsLabel:
                      widget.conversionsCollapseToggleSemanticsLabel,
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    final bool hasAi = widget.aiSuggestions?.isNotEmpty ?? false;
    final bool hasConv = widget.conversionSuggestions?.isNotEmpty ?? false;
    final bool isTwoRows = widget.layout == CoreSuggestionLayout.twoRows;
    final bool hasVisible = isTwoRows
        ? hasAi || (hasConv && !widget.secondRowHidden)
        : hasAi || hasConv;

    return AnimatedContainer(
      duration: CoreSuggestionArea.animationDuration,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: CoreSpacing.space4),
      constraints: const BoxConstraints(minHeight: CoreSpacing.space16),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        heightFactor: 1.0,
        child: !hasVisible
            ? Text(
                widget.suggestionAreaPlaceholder,
                style: typography.bodyMediumRegular.copyWith(
                  color: colors.textDark,
                ),
              )
            : isTwoRows
                ? _buildTwoRowLayout(hasAi: hasAi, hasConv: hasConv)
                : _buildToggleLayout(hasAi: hasAi, hasConv: hasConv),
      ),
    );
  }
}
