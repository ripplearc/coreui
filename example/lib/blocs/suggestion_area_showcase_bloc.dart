import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

part 'suggestion_area_showcase_event.dart';
part 'suggestion_area_showcase_state.dart';

class SuggestionAreaShowcaseBloc
    extends Bloc<SuggestionAreaShowcaseEvent, SuggestionAreaShowcaseState> {
  SuggestionAreaShowcaseBloc() : super(SuggestionAreaShowcaseState.initial()) {
    on<SuggestionAreaExpanded>((event, emit) {
      emit(state.copyWith(isSuggestionExpanded: event.isExpanded));
    });
  }
}
