import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

part 'parts/ai_toggle.dart';
part 'parts/suggestion_list.dart';
part 'parts/toggle_button.dart';

/// A component that displays AI and unit conversion suggestions.
///
/// This widget provides a dedicated area for presenting smart recommendations
/// to the user, including AI-driven insights and contextual unit conversions.
///
/// Displays [suggestionAreaPlaceholder] when both [aiSuggestions] and
/// [conversionSuggestions] are null or empty.
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
  });

  /// The default placeholder text shown when no suggestions are provided.
  static const String defaultSuggestionAreaPlaceholder =
      'Here you can see smart suggestions from us';

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

  @override
  State<CoreSuggestionArea> createState() => _CoreSuggestionAreaState();
}

class _CoreSuggestionAreaState extends State<CoreSuggestionArea> {
  SuggestionMode _mode = SuggestionMode.ai;
  bool _isExpanded = false;

  bool _areSuggestionsEqual(List<SuggestionData>? a, List<SuggestionData>? b) {
    if (identical(a, b)) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i].label != b[i].label ||
          a[i].value != b[i].value ||
          a[i].unit != b[i].unit) {
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
            widget.conversionSuggestions, oldWidget.conversionSuggestions)) {
      if (_isExpanded) {
        widget.onExpandedChanged?.call(false);
      }
      _isExpanded = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    final bool hasAi = widget.aiSuggestions?.isNotEmpty ?? false;
    final bool hasConv = widget.conversionSuggestions?.isNotEmpty ?? false;
    final bool hasBothLists = hasAi && hasConv;
    final bool hasAny = hasAi || hasConv;

    final activeList = hasBothLists
        ? (_mode == SuggestionMode.ai
            ? widget.aiSuggestions
            : widget.conversionSuggestions)
        : (hasAi ? widget.aiSuggestions : widget.conversionSuggestions);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: CoreSpacing.space4),
      constraints: const BoxConstraints(minHeight: CoreSpacing.space16),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        heightFactor: 1.0,
        child: !hasAny
            ? Text(
                widget.suggestionAreaPlaceholder,
                style: typography.bodyMediumRegular.copyWith(
                  color: colors.textDark,
                ),
              )
            : ClipRect(
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  alignment: AlignmentDirectional.topStart,
                  curve: Curves.easeInOut,
                  child: _SuggestionList(
                    suggestions: activeList,
                    isExpanded: _isExpanded,
                    onExpandedChanged: (expanded) {
                      setState(() {
                        _isExpanded = expanded;
                      });
                      widget.onExpandedChanged?.call(expanded);
                    },
                    hiddenChipsTextBuilder: widget.hiddenChipsTextBuilder,
                    expandToggleSemanticsLabelBuilder:
                        widget.expandToggleSemanticsLabelBuilder,
                    collapseToggleSemanticsLabel:
                        widget.collapseToggleSemanticsLabel,
                    leadingWidget: hasBothLists
                        ? _AIToggle(
                            mode: _mode,
                            onChanged: (value) {
                              setState(() {
                                _mode = value;
                              });
                            },
                          )
                        : null,
                  ),
                ),
              ),
      ),
    );
  }
}
