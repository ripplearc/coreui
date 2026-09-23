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

  group('value equality', () {
    const info = CorePreferenceInfo(
      title: 'Fractional resolution',
      description: 'How finely fractions are rounded.',
      semanticsLabel: 'About fractional resolution',
      closeLabel: 'Close the explanation',
    );

    test('two text values reading the same are equal', () {
      expect(
        const CorePreferenceTextValue('1/16'),
        const CorePreferenceTextValue('1/16'),
      );
      expect(
        const CorePreferenceTextValue('1/16').hashCode,
        const CorePreferenceTextValue('1/16').hashCode,
      );
    });

    test('a muted text value differs from the same label unmuted', () {
      expect(
        const CorePreferenceTextValue('1/16', isMuted: true),
        isNot(const CorePreferenceTextValue('1/16')),
      );
    });

    test('two pill values in the same state are equal', () {
      expect(
        const CorePreferencePillValue('Imperial', isOn: true),
        const CorePreferencePillValue('Imperial', isOn: true),
      );
      expect(
        const CorePreferencePillValue('Imperial', isOn: true),
        isNot(const CorePreferencePillValue('Imperial', isOn: false)),
      );
    });

    test('a pill never equals a text value carrying the same label', () {
      expect(
        const CorePreferencePillValue('Imperial', isOn: true),
        isNot(const CorePreferenceTextValue('Imperial')),
        reason: 'the two variants render differently, so a caller comparing '
            'them must not be told they are the same value',
      );
    });

    test('two explanations with the same four strings are equal', () {
      expect(
        info,
        const CorePreferenceInfo(
          title: 'Fractional resolution',
          description: 'How finely fractions are rounded.',
          semanticsLabel: 'About fractional resolution',
          closeLabel: 'Close the explanation',
        ),
      );
    });

    test('an explanation differing only by close label is not equal', () {
      expect(
        info,
        isNot(const CorePreferenceInfo(
          title: 'Fractional resolution',
          description: 'How finely fractions are rounded.',
          semanticsLabel: 'About fractional resolution',
          closeLabel: 'Dismiss',
        )),
      );
    });

    test('two options with the same id and label are equal', () {
      expect(
        const CorePreferenceOption(id: '1/16', label: '1/16'),
        const CorePreferenceOption(id: '1/16', label: '1/16'),
      );
      expect(
        const CorePreferenceOption(id: '1/16', label: '1/16'),
        isNot(const CorePreferenceOption(id: '1/8', label: '1/16')),
      );
    });

    // Built through a function rather than as two `const` literals: equal
    // const expressions are canonicalised to one instance, which would make
    // the comparison below pass without `operator==` ever running.
    // ignore: prefer_const_constructors
    CorePreferenceRow fullRow() => CorePreferenceRow(
          key: 'fractional_resolution',
          label: 'Fractional resolution',
          value: const CorePreferenceTextValue('1/16'),
          options: const [
            CorePreferenceOption(id: '1/8', label: '1/8'),
            CorePreferenceOption(id: '1/16', label: '1/16'),
          ],
          selectedOptionId: '1/16',
          info: info,
        );

    test('two rows built from equal parts are equal', () {
      final left = fullRow();
      final right = fullRow();

      expect(identical(left, right), isFalse);
      expect(left, right);
      expect(left.hashCode, right.hashCode);
    });

    test('rows are compared by their options, not by list identity', () {
      // Deliberately NOT `const` lists: two equal const lists are the same
      // instance, so an identity comparison would pass here and the test
      // would prove nothing. These are two separate lists holding equal
      // options, which is the case listEquals exists for.
      List<CorePreferenceOption> oneEighth() =>
          [const CorePreferenceOption(id: '1/8', label: '1/8')];

      final left = rowWith(oneEighth());
      final right = rowWith(oneEighth());

      expect(identical(left.options, right.options), isFalse);
      expect(left, right);
      expect(left.hashCode, right.hashCode);
      expect(
        left,
        isNot(rowWith([const CorePreferenceOption(id: '1/16', label: '1/16')])),
      );
    });

    test('a row differing only by the option in force is not equal', () {
      const options = [
        CorePreferenceOption(id: '1/8', label: '1/8'),
        CorePreferenceOption(id: '1/16', label: '1/16'),
      ];
      expect(
        const CorePreferenceRow(
          key: 'fractional_resolution',
          label: 'Fractional resolution',
          value: CorePreferenceTextValue('1/16'),
          options: options,
          selectedOptionId: '1/16',
        ),
        isNot(const CorePreferenceRow(
          key: 'fractional_resolution',
          label: 'Fractional resolution',
          value: CorePreferenceTextValue('1/16'),
          options: options,
          selectedOptionId: '1/8',
        )),
        reason: 'the id in force is what the sub-sheet ticks, so two rows '
            'disagreeing on it are not interchangeable',
      );
    });

    test('two sections holding equal rows are equal', () {
      final left = CorePreferenceSection(
        title: 'Units',
        rows: [rowWith(const [])],
      );
      final right = CorePreferenceSection(
        title: 'Units',
        rows: [rowWith(const [])],
      );

      expect(left, right);
      expect(left.hashCode, right.hashCode);
    });

    test('an untitled section differs from the same rows under a heading', () {
      expect(
        CorePreferenceSection(rows: [rowWith(const [])]),
        isNot(CorePreferenceSection(title: 'Units', rows: [rowWith(const [])])),
      );
    });
  });
}
