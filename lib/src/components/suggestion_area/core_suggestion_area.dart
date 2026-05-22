import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

part 'parts/ai_toggle.dart';

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
  const CoreSuggestionArea(
      {super.key,
      this.suggestionAreaPlaceholder = defaultSuggestionAreaPlaceholder,
      this.isEmpty = true});

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

  // TODO: [CA-665] Delete isEmpty once chips list is implemented.
  // https://ripplearc.youtrack.cloud/issue/CA-665
  final bool isEmpty;

  @override
  State<CoreSuggestionArea> createState() => _CoreSuggestionAreaState();
}

class _CoreSuggestionAreaState extends State<CoreSuggestionArea> {
  bool _isAiMode = true;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    return Container(
      width: double.infinity,
      height: CoreSpacing.space16,
      alignment: AlignmentDirectional.centerStart,
      margin: const EdgeInsets.symmetric(horizontal: CoreSpacing.space4),
      child: widget.isEmpty
          ? Text(
              widget.suggestionAreaPlaceholder,
              style: typography.bodyMediumRegular.copyWith(
                color: colors.textDark,
              ),
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _AIToggle(
                  isAiMode: _isAiMode,
                  onChanged: (value) {
                    setState(() {
                      _isAiMode = value;
                    });
                  },
                ),
                const SizedBox(width: CoreSpacing.space3),
                // TODO: [CA-665] Replace placeholder text with chips list.
                // https://ripplearc.youtrack.cloud/issue/CA-665
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      widget.suggestionAreaPlaceholder,
                      key: ValueKey<bool>(_isAiMode),
                      style: typography.bodyMediumRegular.copyWith(
                        color: colors.textDark,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
