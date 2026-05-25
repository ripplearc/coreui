import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

part 'parts/ai_toggle.dart';
part 'parts/suggestion_list.dart';

/// A component that displays AI and unit conversion suggestions.
///
/// This widget provides a dedicated area for presenting smart recommendations
/// to the user, including AI-driven insights and contextual unit conversions.
///
/// Displays [suggestionAreaPlaceholder] when the suggestion list is empty
/// (controlled by [isEmpty]) or while acting as a placeholder before
/// suggestions are loaded.
// TODO: [CA-692] Add core_suggestion_area.md documentation file.
// https://ripplearc.youtrack.cloud/issue/CA-692/Suggestion-Area-ADD-md-file
class CoreSuggestionArea extends StatefulWidget {
  const CoreSuggestionArea({
    super.key,
    this.suggestionAreaPlaceholder = defaultSuggestionAreaPlaceholder,
    this.aiSuggestions,
    this.conversionSuggestions,
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

  @override
  State<CoreSuggestionArea> createState() => _CoreSuggestionAreaState();
}

class _CoreSuggestionAreaState extends State<CoreSuggestionArea> {
  SuggestionMode _mode = SuggestionMode.ai;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    final bool hasAi = widget.aiSuggestions?.isNotEmpty ?? false;
    final bool hasConv = widget.conversionSuggestions?.isNotEmpty ?? false;
    final bool hasBothLists = hasAi && hasConv;
    final bool hasAny = hasAi || hasConv;

    final activeList = hasBothLists
        ? (_mode == SuggestionMode.ai ? widget.aiSuggestions : widget.conversionSuggestions)
        : (hasAi ? widget.aiSuggestions : widget.conversionSuggestions);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      height: CoreSpacing.space16,
      alignment: AlignmentDirectional.centerStart,
      margin: const EdgeInsets.symmetric(horizontal: CoreSpacing.space4),
      child: !hasAny
          ? Text(
              widget.suggestionAreaPlaceholder,
              style: typography.bodyMediumRegular.copyWith(
                color: colors.textDark,
              ),
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasBothLists) ...[
                  Container(
                    height: CoreSpacing.space16,
                    alignment: Alignment.center,
                    child: _AIToggle(
                      mode: _mode,
                      onChanged: (value) {
                        setState(() {
                          _mode = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: CoreSpacing.space1),
                ],
                Expanded(
                  child: ClipRect(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _SuggestionList(
                        key: ValueKey(hasBothLists ? _mode : (hasAi ? SuggestionMode.ai : SuggestionMode.conversion)),
                        suggestions: activeList,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
