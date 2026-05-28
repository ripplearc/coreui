part of 'suggestion_area_showcase_bloc.dart';

class SuggestionAreaShowcaseState {
  final bool isSuggestionExpanded;
  final List<SuggestionData> aiSuggestions;
  final List<SuggestionData> conversionSuggestions;

  const SuggestionAreaShowcaseState({
    this.isSuggestionExpanded = false,
    required this.aiSuggestions,
    required this.conversionSuggestions,
  });

  factory SuggestionAreaShowcaseState.initial() {
    return SuggestionAreaShowcaseState(
      aiSuggestions: [
        SuggestionData(
          label: 'Length:',
          value: '27',
          unit: 'ft',
          onTap: () {},
        ),
        SuggestionData(
          label: 'Area:',
          value: '90',
          unit: 'sq ft',
          onTap: () {},
        ),
        SuggestionData(
          label: 'Length:',
          value: '27',
          unit: 'ft',
          onTap: () {},
        ),
        SuggestionData(
          label: 'Area:',
          value: '90',
          unit: 'sq ft',
          onTap: () {},
        ),
        SuggestionData(
          label: 'Length:',
          value: '27',
          unit: 'ft',
          onTap: () {},
        ),
        SuggestionData(
          label: 'Area:',
          value: '90',
          unit: 'sq ft',
          onTap: () {},
        ),
      ],
      conversionSuggestions: [
        SuggestionData(
          label: 'M:',
          value: '3.048',
          unit: 'm',
          onTap: () {},
        ),
        SuggestionData(
          label: 'CM:',
          value: '304.8',
          unit: 'cm',
          onTap: () {},
        ),
      ],
    );
  }

  SuggestionAreaShowcaseState copyWith({
    bool? isSuggestionExpanded,
    List<SuggestionData>? aiSuggestions,
    List<SuggestionData>? conversionSuggestions,
  }) {
    return SuggestionAreaShowcaseState(
      isSuggestionExpanded: isSuggestionExpanded ?? this.isSuggestionExpanded,
      aiSuggestions: aiSuggestions ?? this.aiSuggestions,
      conversionSuggestions:
          conversionSuggestions ?? this.conversionSuggestions,
    );
  }
}
