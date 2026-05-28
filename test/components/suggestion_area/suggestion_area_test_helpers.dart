import 'package:flutter/foundation.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

String testHiddenChipsText(int count) => '+$count';

String testExpandToggleSemantics(int hiddenCount) =>
    'Show $hiddenCount more suggestions';

const String testCollapseToggleSemantics = 'Show fewer suggestions';

/// [CoreSuggestionArea] with test-localized overflow strings.
CoreSuggestionArea testCoreSuggestionArea({
  Key? key,
  String suggestionAreaPlaceholder =
      CoreSuggestionArea.defaultSuggestionAreaPlaceholder,
  List<SuggestionData>? aiSuggestions,
  List<SuggestionData>? conversionSuggestions,
  ValueChanged<bool>? onExpandedChanged,
}) {
  return CoreSuggestionArea(
    key: key,
    suggestionAreaPlaceholder: suggestionAreaPlaceholder,
    aiSuggestions: aiSuggestions,
    conversionSuggestions: conversionSuggestions,
    onExpandedChanged: onExpandedChanged,
    hiddenChipsTextBuilder: testHiddenChipsText,
    expandToggleSemanticsLabelBuilder: testExpandToggleSemantics,
    collapseToggleSemanticsLabel: testCollapseToggleSemantics,
  );
}
