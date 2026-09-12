import 'package:example/blocs/suggestion_area_showcase_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

void main() {
  group('SuggestionAreaShowcaseBloc bind offers', () {
    late SuggestionAreaShowcaseBloc bloc;

    setUp(() => bloc = SuggestionAreaShowcaseBloc());

    tearDown(() => bloc.close());

    Future<void> type(String digits, String unit) async {
      for (final digit in digits.split('')) {
        bloc.add(DigitPressed(digit));
      }
      bloc.add(UnitSelected(unit));
      await pumpEventQueue();
    }

    test(
        'a value typed before any key offers to bind it to every open '
        'dimension', () async {
      await type('8', 'ft');

      expect(bloc.state.isTyping, isTrue);
      expect(bloc.state.activeInputLabel, isNull);
      expect(
        bloc.state.aiSuggestions.map((s) => s.label).toList(),
        ['Length:', 'Width:'],
      );
      for (final offer in bloc.state.aiSuggestions) {
        expect(offer.kind, SuggestionKind.bind);
        expect(offer.value, '8');
        expect(offer.unit, 'ft');
      }
      expect(
        bloc.state.aiSuggestions.first.semanticsLabel,
        'Name 8 ft as Length',
      );
      expect(
        bloc.state.conversionSuggestions.map((s) => '${s.value} ${s.unit}'),
        ['96 in', '2.67 yd'],
      );
    });

    test('a value typed after a key is named already and gets no bind offer',
        () async {
      bloc.add(const KeySelected('Length'));
      await type('8', 'ft');

      expect(bloc.state.activeInputLabel, 'Length');
      expect(bloc.state.aiSuggestions, isEmpty);
    });

    test('accepting a bind offer names the entry and finalizes it', () async {
      await type('8', 'ft');

      bloc.state.aiSuggestions.first.onTap();
      await pumpEventQueue();

      expect(bloc.state.isTyping, isFalse);
      expect(bloc.state.activeInputLabel, isNull);
      expect(bloc.state.finalizedValues, {'Length': 8.0});
      expect(bloc.state.completedChips.single.label, 'Length');
      expect(bloc.state.completedChips.single.value, '8 ft');
      expect(bloc.state.aiSuggestions, isEmpty);
      expect(bloc.state.conversionSuggestions, isEmpty);
    });

    test('a finalized dimension is no longer offered', () async {
      await type('8', 'ft');
      bloc.state.aiSuggestions.first.onTap();
      await pumpEventQueue();

      await type('10', 'ft');

      expect(
        bloc.state.aiSuggestions.map((s) => s.label).toList(),
        ['Width:'],
      );
    });

    test('a value without a unit is not offered for binding', () async {
      bloc.add(const DigitPressed('8'));
      await pumpEventQueue();

      expect(bloc.state.isTyping, isTrue);
      expect(bloc.state.aiSuggestions, isEmpty);
    });
  });
}
