import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

/// A component that displays AI and unit conversion suggestions.
///
/// This widget provides a dedicated area for presenting smart recommendations
/// to the user, including AI-driven insights and contextual unit conversions.
///
/// Displays [suggestionAreaPlaceholder] when the suggestion list is empty
// TODO: [CA-692] Add core_suggestion_area.md documentation file.
// https://ripplearc.youtrack.cloud/issue/CA-692/Suggestion-Area-ADD-md-file
class CoreSuggestionArea extends StatelessWidget {
  const CoreSuggestionArea({
    super.key,
    this.suggestionAreaPlaceholder = defaultSuggestionAreaPlaceholder,
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

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    return Container(
      width: double.infinity,
      height: CoreSpacing.space16,
      alignment: AlignmentDirectional.centerStart,
      margin: const EdgeInsets.symmetric(horizontal: CoreSpacing.space4),
      child: Text(
        suggestionAreaPlaceholder,
        style: typography.bodyMediumRegular.copyWith(
          color: colors.textDark,
        ),
      ),
    );
  }
}
