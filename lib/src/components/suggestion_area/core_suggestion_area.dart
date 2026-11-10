import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

part 'parts/ai_toggle.dart';
part 'parts/conversions_tag.dart';
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
  /// rung that fired (Area / Sheets / Cost…) at full size, row 2 is unit
  /// conversions of the value on screen as a visibly secondary row — one
  /// leading [CoreSuggestionArea.conversionsRowTagLabel] tag, then value-only
  /// [CoreChipSize.mini] chips. No toggle. The calculator's default (prototype
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
/// dependent-key band under the value needs the space. In two rows the
/// conversions row is the secondary one: a leading [conversionsRowTagLabel]
/// tag says "conversion" once, so its chips carry only the re-expressed value
/// at [CoreChipSize.mini], and the row announces [conversionsRowSemanticsLabel]
/// as a group.
///
/// Each [SuggestionData] carries a [SuggestionKind]; a [SuggestionKind.bind]
/// offer renders with the dashed [CoreChipOutline.dashed] look and a trailing
/// [bindSuffix], because accepting it relabels an existing chip instead of
/// adding a result.
///
/// Displays [suggestionAreaPlaceholder] when nothing is visible: both lists
/// are null or empty, or only conversions exist and [secondRowHidden] is set,
/// and no [note] is set.
///
/// ## Strip note
///
/// [note] is the strip's own slot for a short warning — "12ft was not added."
/// — in the warning colour, up to two lines. While set it is what the strip
/// shows, in place of the suggestions and the placeholder alike, so the app
/// sets it on a refused key and clears it on the next one without touching
/// its lists. At the default text size two lines fit inside the strip's
/// minimum height, so a one-row strip does not move and the keyboard below
/// stays put.
///
/// ## Accessibility
///
/// The area is a live region labelled with the suggestions on screen, so a
/// screen reader announces a new rung or a fresh set of conversions without
/// moving focus; [suggestionsSemanticsLabelBuilder] builds that text. Each
/// chip keeps its own node inside the region, and the placeholder and the
/// note are live regions of their own, so an emptied strip and a refusal are
/// heard too.
///
/// ## Test keys
///
/// Every chip carries a stable [Key] for Patrol and widget tests:
/// [SuggestionData.testKey], or [chipTestKey] / [conversionChipTestKey] by
/// position in its row. The note carries [noteKey].
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
    this.conversionsRowTagLabel = defaultConversionsRowTagLabel,
    this.conversionsRowSemanticsLabel = defaultConversionsRowSemanticsLabel,
    this.suggestionsSemanticsLabelBuilder,
    this.note,
  });

  /// The default placeholder text shown when no suggestions are provided.
  static const String defaultSuggestionAreaPlaceholder =
      'Here you can see smart suggestions from us';

  /// The default text of the tag that leads the conversions row in
  /// [CoreSuggestionLayout.twoRows].
  static const String defaultConversionsRowTagLabel = 'as';

  /// The default group label the conversions row announces in
  /// [CoreSuggestionLayout.twoRows].
  static const String defaultConversionsRowSemanticsLabel =
      'Convert to other units';

  /// Duration of every size transition in the area — expanding a row, folding
  /// the conversions row away, the container itself. Matches the display
  /// area's stage animation so the two surfaces move together.
  static const Duration animationDuration = Duration(milliseconds: 300);

  /// The default trailing marker of a [SuggestionKind.bind] chip.
  static const String defaultBindSuffix = '?';

  /// The default [Key] of the chip at [index] on the primary row, and on the
  /// single row of [CoreSuggestionLayout.toggle]: `calc_strip_chip_<index>`.
  /// [SuggestionData.testKey] overrides it.
  static Key chipTestKey(int index) => ValueKey('calc_strip_chip_$index');

  /// The [Key] the [note] text carries, for Patrol and widget tests:
  /// `calc_strip_note`.
  static const Key noteKey = ValueKey('calc_strip_note');

  /// The default [Key] of the chip at [index] on the conversions row of
  /// [CoreSuggestionLayout.twoRows]: `calc_strip_conversion_<index>`, so the
  /// two rows never share a key. [SuggestionData.testKey] overrides it.
  static Key conversionChipTestKey(int index) =>
      ValueKey('calc_strip_conversion_$index');

  /// The live-region text used when [suggestionsSemanticsLabelBuilder] is
  /// null: each suggestion's [SuggestionData.semanticsLabel], or its label,
  /// value and unit, joined with commas (`Area: 220 ft², Cost: $84.25`).
  static String defaultSuggestionsSemanticsLabel(
      List<SuggestionData> suggestions) {
    return suggestions
        .map((data) =>
            data.semanticsLabel ??
            [data.label, data.value, data.unit]
                .whereType<String>()
                .where((part) => part.isNotEmpty)
                .join(' '))
        .join(', ');
  }

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
  ///
  /// Expected to carry [SuggestionKind.conversion] data only. In
  /// [CoreSuggestionLayout.twoRows] this list is the secondary row, and that
  /// row drops every chip's label by position, not by kind — a `bind` or
  /// `memory` suggestion routed here would render as a bare value behind the
  /// [conversionsRowTagLabel] tag. Put such suggestions in [aiSuggestions].
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

  /// Text of the tag that leads the conversions row in
  /// [CoreSuggestionLayout.twoRows] — a small ruler icon and this word, so
  /// "conversion" is said once for the row and its chips show only the
  /// re-expressed value ("as 264in 7.33yd"). Decorative: excluded from
  /// semantics, the row's [conversionsRowSemanticsLabel] speaks instead.
  /// Defaults to [defaultConversionsRowTagLabel]; override it per locale.
  /// Ignored in [CoreSuggestionLayout.toggle].
  final String conversionsRowTagLabel;

  /// Group label a screen reader announces on entering the conversions row
  /// in [CoreSuggestionLayout.twoRows], giving its value-only chips their
  /// context. Defaults to [defaultConversionsRowSemanticsLabel]; override it
  /// per locale. Ignored in [CoreSuggestionLayout.toggle].
  final String conversionsRowSemanticsLabel;

  /// Builds the text a screen reader announces when the visible suggestions
  /// change. The area is a live region labelled with this text, so a new
  /// rung or a fresh set of conversions is heard without moving focus. The
  /// list holds the suggestions on screen in reading order — the active list
  /// in [CoreSuggestionLayout.toggle], both rows in
  /// [CoreSuggestionLayout.twoRows] with the conversions row left out while
  /// [secondRowHidden]; chips folded behind the `+N` control are included,
  /// as that control reveals them. Defaults to
  /// [defaultSuggestionsSemanticsLabel]; pass a localised builder when the
  /// joined chip text does not read well aloud.
  final String Function(List<SuggestionData> suggestions)?
      suggestionsSemanticsLabelBuilder;

  /// A short warning the strip shows in place of everything else while set —
  /// "12ft was not added." — in `textWarningStrong` at `bodyLargeRegular`, up
  /// to two lines, the second ending in an ellipsis. `null` or an empty
  /// string, the default, shows the suggestions or the placeholder as usual.
  /// Setting it folds an expanded row and reports that through
  /// [onExpandedChanged] the way a suggestion change does; clearing it brings
  /// the rows back collapsed. A two-row strip folds to one row under it, as
  /// it does when its lists empty. At the default text size two lines fit
  /// inside the strip's minimum height; at a larger text scale they are
  /// taller than it, as two chip rows are. Announced as a live region. Pass a
  /// localised string from the app layer:
  /// ```dart
  /// note: state.refusal == null
  ///     ? null
  ///     : AppLocalizations.of(context).notAdded(state.refusal),
  /// ```
  final String? note;

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

  static String? _noteOf(CoreSuggestionArea area) {
    final note = area.note;
    return note == null || note.isEmpty ? null : note;
  }

  @override
  void didUpdateWidget(CoreSuggestionArea oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_areSuggestionsEqual(widget.aiSuggestions, oldWidget.aiSuggestions) ||
        !_areSuggestionsEqual(
            widget.conversionSuggestions, oldWidget.conversionSuggestions) ||
        widget.layout != oldWidget.layout ||
        (_noteOf(widget) != null && _noteOf(oldWidget) == null)) {
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
    bool isSecondary = false,
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
      isSecondary: isSecondary,
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

  List<SuggestionData>? _activeToggleList({
    required bool hasAi,
    required bool hasConv,
  }) {
    if (hasAi && hasConv) {
      return _mode == SuggestionMode.ai
          ? widget.aiSuggestions
          : widget.conversionSuggestions;
    }
    return hasAi ? widget.aiSuggestions : widget.conversionSuggestions;
  }

  List<SuggestionData> _announcedSuggestions({
    required bool hasAi,
    required bool hasConv,
  }) {
    if (widget.layout == CoreSuggestionLayout.toggle) {
      return _activeToggleList(hasAi: hasAi, hasConv: hasConv) ?? const [];
    }
    return [
      ...?widget.aiSuggestions,
      if (!widget.secondRowHidden) ...?widget.conversionSuggestions,
    ];
  }

  Widget _buildToggleLayout({required bool hasAi, required bool hasConv}) {
    final bool hasBothLists = hasAi && hasConv;

    return _animatedSize(
      child: _buildRow(
        key: const ValueKey('suggestion_row_toggle'),
        suggestions: _activeToggleList(hasAi: hasAi, hasConv: hasConv),
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
              ? Semantics(
                  container: true,
                  explicitChildNodes: true,
                  label: widget.conversionsRowSemanticsLabel,
                  child: _buildRow(
                    key: const ValueKey('suggestion_row_conversions'),
                    suggestions: widget.conversionSuggestions,
                    isExpanded: _isSecondaryExpanded,
                    onExpandedChanged: (expanded) =>
                        _setExpanded(secondary: expanded),
                    leadingWidget:
                        _ConversionsTag(label: widget.conversionsRowTagLabel),
                    expandToggleSemanticsLabelBuilder:
                        widget.conversionsExpandToggleSemanticsLabelBuilder,
                    collapseToggleSemanticsLabel:
                        widget.conversionsCollapseToggleSemanticsLabel,
                    isSecondary: true,
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildMessage(String text, TextStyle style,
      {Key? key, int? maxLines}) {
    return Semantics(
      container: true,
      liveRegion: true,
      child: Text(
        text,
        key: key,
        maxLines: maxLines,
        overflow: maxLines == null ? TextOverflow.clip : TextOverflow.ellipsis,
        style: style,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    final note = _noteOf(widget);
    final bool hasAi = widget.aiSuggestions?.isNotEmpty ?? false;
    final bool hasConv = widget.conversionSuggestions?.isNotEmpty ?? false;
    final bool isTwoRows = widget.layout == CoreSuggestionLayout.twoRows;
    final bool hasVisible = isTwoRows
        ? hasAi || (hasConv && !widget.secondRowHidden)
        : hasAi || hasConv;

    final Widget content;
    if (note != null) {
      content = _buildMessage(
        note,
        typography.bodyLargeRegular.copyWith(color: colors.textWarningStrong),
        key: CoreSuggestionArea.noteKey,
        maxLines: 2,
      );
    } else if (!hasVisible) {
      content = _buildMessage(
        widget.suggestionAreaPlaceholder,
        typography.bodyMediumRegular.copyWith(color: colors.textDark),
      );
    } else {
      content = Semantics(
        container: true,
        explicitChildNodes: true,
        liveRegion: true,
        label: (widget.suggestionsSemanticsLabelBuilder ??
                CoreSuggestionArea.defaultSuggestionsSemanticsLabel)(
            _announcedSuggestions(hasAi: hasAi, hasConv: hasConv)),
        child: isTwoRows
            ? _buildTwoRowLayout(hasAi: hasAi, hasConv: hasConv)
            : _buildToggleLayout(hasAi: hasAi, hasConv: hasConv),
      );
    }

    return AnimatedContainer(
      duration: CoreSuggestionArea.animationDuration,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: CoreSpacing.space4),
      constraints: const BoxConstraints(minHeight: CoreSpacing.space16),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        heightFactor: 1.0,
        child: content,
      ),
    );
  }
}
