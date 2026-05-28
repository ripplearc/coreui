part of 'suggestion_area_showcase_bloc.dart';

sealed class SuggestionAreaShowcaseEvent {
  const SuggestionAreaShowcaseEvent();
}

class SuggestionAreaExpanded extends SuggestionAreaShowcaseEvent {
  final bool isExpanded;

  const SuggestionAreaExpanded(this.isExpanded);
}
