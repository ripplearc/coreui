import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

void main() {
  CorePreferenceRow rowWith(List<CorePreferenceOption> options) {
    return CorePreferenceRow(
      key: 'fractional_resolution',
      label: 'Fractional resolution',
      value: const CorePreferenceTextValue('1/16'),
      options: options,
    );
  }

  group('CorePreferenceRow.isSelectable', () {
    test('a row with no options is inert', () {
      expect(rowWith(const []).isSelectable, isFalse);
    });

    test('a row with a single option is inert', () {
      expect(
        rowWith(const [CorePreferenceOption(id: 'std', label: 'std')])
            .isSelectable,
        isFalse,
        reason: 'there is nothing to choose between, so opening a sub-sheet '
            'would show the user a list of one',
      );
    });

    test('a row with two options opens a sub-sheet', () {
      expect(
        rowWith(const [
          CorePreferenceOption(id: '1/8', label: '1/8'),
          CorePreferenceOption(id: '1/16', label: '1/16'),
        ]).isSelectable,
        isTrue,
      );
    });
  });
}
