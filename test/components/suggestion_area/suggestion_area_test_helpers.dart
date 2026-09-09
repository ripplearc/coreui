import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

String testHiddenChipsText(int count) => '+$count';

String testExpandToggleSemantics(int hiddenCount) =>
    'Show $hiddenCount more suggestions';

const String testCollapseToggleSemantics = 'Show fewer suggestions';

const String testToggleSemanticsLabel = 'Toggle suggestion mode';

/// [CoreSuggestionArea] with test-localized overflow and toggle strings.
CoreSuggestionArea testCoreSuggestionArea({
  Key? key,
  String suggestionAreaPlaceholder =
      CoreSuggestionArea.defaultSuggestionAreaPlaceholder,
  List<SuggestionData>? aiSuggestions,
  List<SuggestionData>? conversionSuggestions,
  ValueChanged<bool>? onExpandedChanged,
  String toggleSemanticsLabel = testToggleSemanticsLabel,
  String bindSuffix = CoreSuggestionArea.defaultBindSuffix,
  CoreSuggestionLayout layout = CoreSuggestionLayout.toggle,
  bool secondRowHidden = false,
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
    toggleSemanticsLabel: toggleSemanticsLabel,
    bindSuffix: bindSuffix,
    layout: layout,
    secondRowHidden: secondRowHidden,
  );
}

/// Pumps [area] inside the light-themed app shell the widget tests share.
Future<void> pumpSuggestionArea(WidgetTester tester, Widget area) {
  return tester.pumpWidget(
    MaterialApp(theme: CoreTheme.light(), home: Scaffold(body: area)),
  );
}
