part of '../core_suggestion_area.dart';

enum SuggestionMode { ai, conversion }

class SuggestionData {
  final String label;
  final String value;
  final String? unit;
  final VoidCallback onTap;

  SuggestionData({
    required this.label,
    required this.value,
    this.unit,
    required this.onTap,
  });
}

class SuggestionList extends StatefulWidget {
  final List<SuggestionData>? suggestions;

  const SuggestionList({
    super.key,
    this.suggestions,
  });

  @override
  State<SuggestionList> createState() => _SuggestionListState();
}

class _SuggestionListState extends State<SuggestionList> {
  late List<ValueNotifier<bool>> _notifiers;

  @override
  void initState() {
    super.initState();
    _initNotifiers();
  }

  @override
  void didUpdateWidget(SuggestionList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.suggestions != oldWidget.suggestions) {
      _disposeNotifiers();
      _initNotifiers();
    }
  }

  void _initNotifiers() {
    _notifiers = widget.suggestions?.map((_) => ValueNotifier(false)).toList() ?? [];
  }

  void _disposeNotifiers() {
    for (var notifier in _notifiers) {
      notifier.dispose();
    }
  }

  @override
  void dispose() {
    _disposeNotifiers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final suggestions = widget.suggestions;
    if (suggestions == null || suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Wrap(
        spacing: CoreSpacing.space2,
        alignment: WrapAlignment.start,
        children: List.generate(suggestions.length, (index) {
          final data = suggestions[index];
          return CoreChip(
            label: data.label,
            value: data.value,
            unit: data.unit,
            selected: _notifiers[index],
            onTap: data.onTap,
            isSmartChip: true,
            size: CoreChipSize.large,
          );
        }),
      ),
    );
  }
}
