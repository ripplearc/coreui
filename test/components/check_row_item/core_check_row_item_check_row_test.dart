import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/pixel_reader.dart';
import '../../utils/test_harness.dart';

void main() {
  final theme = CoreTheme.light();
  final colors = theme.coreColors;
  final typography = theme.coreTypography;

  final rowFinder = find.byType(CoreCheckRowItem);

  Future<void> pumpRow(WidgetTester tester, CoreCheckRowItem row) {
    return tester.pumpWidget(
      buildTestApp(SizedBox(width: 360, child: row), theme: theme),
    );
  }

  CoreCheckRowItem checkRow({
    bool selected = false,
    bool enabled = true,
    bool showDivider = true,
    String? subtitle,
    Widget? leading,
    ValueChanged<bool>? onChanged,
  }) {
    return CoreCheckRowItem.checkRow(
      title: 'John Doe',
      subtitle: subtitle,
      selected: selected,
      enabled: enabled,
      showDivider: showDivider,
      leading: leading,
      onChanged: onChanged ?? (_) {},
    );
  }

  group('CoreCheckRowItem.initialsFor', () {
    for (final (name, initials) in [
      ('Judy Smith', 'JS'),
      ('marco reyes', 'MR'),
      ('Anne Marie Smith', 'AM'),
      ('madonna', 'M'),
      ('  Judy   Smith  ', 'JS'),
      ('   ', ''),
      ('', ''),
    ]) {
      test('"$name" gives "$initials"', () {
        expect(CoreCheckRowItem.initialsFor(name), initials);
      });
    }
  });

  group('CoreCheckRowItem.checkRow – look', () {
    testWidgets('shows two initials, as the storyboard Send to list does; '
        'the Dropdown cell keeps one', (tester) async {
      await pumpRow(tester, checkRow());
      expect(find.text('JD'), findsOneWidget);

      await pumpRow(
        tester,
        CoreCheckRowItem(title: 'John Doe', selected: false, onChanged: (_) {}),
      );
      expect(find.text('J'), findsOneWidget);
      expect(find.text('JD'), findsNothing);
    });

    testWidgets('uses the Figma Check row text styles and colours',
        (tester) async {
      await pumpRow(tester, checkRow(subtitle: 'john@acme.com'));

      expect(
        tester.widget<Text>(find.text('John Doe')).style,
        typography.bodyLargeMedium.copyWith(color: colors.textHeadline),
      );
      expect(
        tester.widget<Text>(find.text('john@acme.com')).style,
        typography.bodyMediumRegular.copyWith(color: colors.textBody),
      );
      expect(
        tester.widget<Text>(find.text('JD')).style,
        typography.bodyLargeSemiBold.copyWith(color: colors.textLink),
      );
      final avatar = tester.widget<CoreAvatar>(find.byType(CoreAvatar));
      expect(avatar.backgroundColor, colors.backgroundBlueLight);
    });

    testWidgets('has 20 dp sides, 12 dp gaps and a 40 dp avatar',
        (tester) async {
      await pumpRow(tester, checkRow());

      final row = tester.getRect(rowFinder);
      final avatar = tester.getRect(find.byType(CoreAvatar));
      final name = tester.getRect(find.text('John Doe'));
      final checkbox = tester.getRect(find.byType(CoreIconWidget));
      expect(row.height, 64);
      expect(avatar.size, const Size.square(40));
      expect(avatar.left - row.left, CoreSpacing.space5);
      expect(name.left - avatar.right, CoreSpacing.space3);
      expect(row.right - checkbox.right, CoreSpacing.space5);
    });

    testWidgets('ticks in iconDark and leaves the box iconGrayMid',
        (tester) async {
      for (final selected in [true, false]) {
        await pumpRow(tester, checkRow(selected: selected));

        final icon = tester.widget<CoreIconWidget>(find.byType(CoreIconWidget));
        expect(icon.color, selected ? colors.iconDark : colors.iconGrayMid);
      }
    });

    testWidgets('a selected row is not filled, unlike the Dropdown cell',
        (tester) async {
      await pumpRow(tester, checkRow(selected: true));

      final material = tester.widget<Material>(
        find.descendant(of: rowFinder, matching: find.byType(Material)),
      );
      expect(material.color, colors.transparent);
    });

    testWidgets('draws an inset divider that adds no height', (tester) async {
      await pumpRow(tester, checkRow());
      final divider = tester.widget<CoreDivider>(find.byType(CoreDivider));
      expect(divider.indent, CoreSpacing.space5);
      expect(divider.endIndent, CoreSpacing.space5);
      expect(
        tester.getRect(find.byType(CoreDivider)).bottom,
        tester.getRect(rowFinder).bottom,
      );
      final withDivider = tester.getSize(rowFinder).height;

      await pumpRow(tester, checkRow(showDivider: false));
      expect(find.byType(CoreDivider), findsNothing);
      expect(tester.getSize(rowFinder).height, withDivider);
    });

    testWidgets('the Dropdown cell never draws a divider', (tester) async {
      await pumpRow(
        tester,
        CoreCheckRowItem(title: 'John Doe', selected: false, onChanged: (_) {}),
      );

      expect(find.byType(CoreDivider), findsNothing);
    });

    testWidgets('keeps the initial inside the 40 dp avatar at 200% text',
        (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: buildTestApp(
            SizedBox(width: 360, child: checkRow()),
            theme: theme,
          ),
        ),
      );

      final avatar = tester.getRect(find.byType(CoreAvatar));
      final initial = tester.getRect(find.text('JD'));
      expect(avatar.contains(initial.center), isTrue);
      expect(initial.height, lessThanOrEqualTo(avatar.height));
      expect(tester.takeException(), isNull);
    });
  });

  group('CoreCheckRowItem.checkRow – pressed', () {
    for (final parent in [colors.pageBackground, colors.backgroundOrangeLight]) {
      testWidgets(
          'fills Background Grey Mid while pressed, visible '
          '${parent == colors.pageBackground ? 'on the page' : 'inside a coloured parent'}',
          (tester) async {
        final boundary = GlobalKey();
        await tester.pumpWidget(
          buildTestApp(
            RepaintBoundary(
              key: boundary,
              child: Container(
                width: 360,
                color: parent,
                child: checkRow(showDivider: false),
              ),
            ),
            theme: theme,
          ),
        );
        final row = tester.getRect(rowFinder);
        // Between the avatar and the name, where only the fill shows.
        final probe = Offset(row.left + 64, row.top + 4);
        final boundaryFinder = find.byKey(boundary);

        final gesture = await tester.startGesture(row.center);
        await tester.pumpAndSettle();
        expect(
          await pixelAt(tester, boundaryFinder, probe),
          colors.backgroundGrayMid.toARGB32(),
        );
        expect(colors.backgroundGrayMid, isNot(parent));

        await gesture.up();
        await tester.pumpAndSettle();
        expect(
          await pixelAt(tester, boundaryFinder, probe),
          parent.toARGB32(),
        );
      });
    }
  });

  group('CoreCheckRowItem – taps and disabled, both looks', () {
    final looks = <String, CoreCheckRowItem Function(bool, bool, ValueChanged<bool>)>{
      'Dropdown cell': (selected, enabled, onChanged) => CoreCheckRowItem(
            title: 'John Doe',
            subtitle: 'john@acme.com',
            selected: selected,
            enabled: enabled,
            onChanged: onChanged,
          ),
      'Check row': (selected, enabled, onChanged) => CoreCheckRowItem.checkRow(
            title: 'John Doe',
            subtitle: 'john@acme.com',
            selected: selected,
            enabled: enabled,
            onChanged: onChanged,
          ),
    };

    for (final MapEntry(key: name, value: build) in looks.entries) {
      testWidgets('$name toggles on each of two taps', (tester) async {
        final calls = <bool>[];
        var selected = false;
        await tester.pumpWidget(
          buildTestApp(
            StatefulBuilder(
              builder: (context, setState) => SizedBox(
                width: 360,
                child: build(selected, true, (value) {
                  calls.add(value);
                  setState(() => selected = value);
                }),
              ),
            ),
            theme: theme,
          ),
        );

        await tester.tap(rowFinder);
        await tester.pump();
        await tester.tap(rowFinder);
        await tester.pump();

        expect(calls, [true, false]);
      });

      testWidgets('$name disabled ignores two taps', (tester) async {
        var calls = 0;
        await pumpRow(tester, build(false, false, (_) => calls++));

        await tester.tap(rowFinder);
        await tester.pump();
        await tester.tap(rowFinder);
        await tester.pump();

        expect(calls, 0);
      });

      testWidgets('$name disabled dims the text and keeps the box',
          (tester) async {
        await pumpRow(tester, build(true, true, (_) {}));
        final enabledBox =
            tester.widget<CoreIconWidget>(find.byType(CoreIconWidget)).color;

        await pumpRow(tester, build(true, false, (_) {}));
        final initials = name == 'Check row' ? 'JD' : 'J';
        for (final text in ['John Doe', 'john@acme.com', initials]) {
          expect(
            tester.widget<Text>(find.text(text)).style!.color,
            colors.textDisable,
          );
        }
        expect(
          tester.widget<CoreIconWidget>(find.byType(CoreIconWidget)).color,
          enabledBox,
        );
      });

      testWidgets('$name reads as disabled to a screen reader',
          (tester) async {
        final handle = tester.ensureSemantics();
        await pumpRow(tester, build(false, false, (_) {}));

        final data = tester.getSemantics(rowFinder).getSemanticsData();
        expect(data.flagsCollection.isEnabled, ui.Tristate.isFalse);
        handle.dispose();
      });
    }

    testWidgets('a disabled row keeps a custom avatar text colour',
        (tester) async {
      await pumpRow(
        tester,
        CoreCheckRowItem.checkRow(
          title: 'John Doe',
          selected: false,
          enabled: false,
          avatarTextColor: colors.textSuccess,
          onChanged: (_) {},
        ),
      );

      expect(
        tester.widget<Text>(find.text('JD')).style!.color,
        colors.textSuccess,
      );
    });
  });

  group('CoreCheckRowItem – screen reader label', () {
    final cases = <String, (CoreCheckRowItem, String)>{
      'Check row with a second line reads both lines': (
        CoreCheckRowItem.checkRow(
          title: 'Judy Smith',
          subtitle: 'Homeowner · judy.smith@gmail.com',
          selected: false,
          onChanged: (_) {},
        ),
        'Judy Smith, Homeowner · judy.smith@gmail.com',
      ),
      'Check row without a second line reads the name': (
        CoreCheckRowItem.checkRow(
          title: 'Judy Smith',
          selected: false,
          onChanged: (_) {},
        ),
        'Judy Smith',
      ),
      'Dropdown cell reads the name only': (
        CoreCheckRowItem(
          title: 'Judy Smith',
          subtitle: 'judy.smith@gmail.com',
          selected: false,
          onChanged: (_) {},
        ),
        'Judy Smith',
      ),
      'semanticLabel overrides the Check row default': (
        CoreCheckRowItem.checkRow(
          title: 'Judy Smith',
          subtitle: 'judy.smith@gmail.com',
          semanticLabel: 'Judy, owner',
          selected: false,
          onChanged: (_) {},
        ),
        'Judy, owner',
      ),
    };

    for (final MapEntry(key: name, value: (row, label)) in cases.entries) {
      testWidgets(name, (tester) async {
        final handle = tester.ensureSemantics();
        await pumpRow(tester, row);

        expect(
          tester.getSemantics(rowFinder).getSemanticsData().label,
          label,
        );
        handle.dispose();
      });
    }
  });

  group('CoreCheckRowItem – tap size, every look', () {
    final cases = <String, CoreCheckRowItem>{
      'Dropdown cell': CoreCheckRowItem(
        title: 'John Doe',
        selected: false,
        onChanged: (_) {},
      ),
      'Dropdown cell, small leading': CoreCheckRowItem(
        title: 'John Doe',
        selected: false,
        leading: const SizedBox.square(dimension: 8),
        onChanged: (_) {},
      ),
      'Check row': CoreCheckRowItem.checkRow(
        title: 'John Doe',
        selected: false,
        onChanged: (_) {},
      ),
      'Check row, small leading, no divider': CoreCheckRowItem.checkRow(
        title: 'John Doe',
        selected: false,
        showDivider: false,
        leading: const SizedBox.square(dimension: 8),
        onChanged: (_) {},
      ),
    };

    for (final MapEntry(key: name, value: row) in cases.entries) {
      testWidgets('$name is at least 48 dp high', (tester) async {
        await pumpRow(tester, row);

        expect(
          tester.getSize(rowFinder).height,
          greaterThanOrEqualTo(kMinInteractiveDimension),
        );
      });
    }
  });

  group('CoreCheckRowItem – keyboard focus, both looks', () {
    const boundaryKey = Key('check_row_boundary');

    final looks = <String, CoreCheckRowItem Function(bool, ValueChanged<bool>)>{
      'Dropdown cell': (enabled, onChanged) => CoreCheckRowItem(
            title: 'John Doe',
            selected: false,
            enabled: enabled,
            onChanged: onChanged,
          ),
      'Check row': (enabled, onChanged) => CoreCheckRowItem.checkRow(
            title: 'John Doe',
            selected: false,
            enabled: enabled,
            showDivider: false,
            onChanged: onChanged,
          ),
    };

    Future<void> pumpBoundary(WidgetTester tester, CoreCheckRowItem row) {
      return tester.pumpWidget(
        buildTestApp(
          RepaintBoundary(
            key: boundaryKey,
            child: Container(
              width: 360,
              color: colors.backgroundOrangeLight,
              child: row,
            ),
          ),
          theme: theme,
        ),
      );
    }

    Future<int> ringPixel(WidgetTester tester) {
      final row = tester.getRect(rowFinder);
      return pixelAt(
        tester,
        find.byKey(boundaryKey),
        Offset(row.left + 1, row.center.dy),
      );
    }

    for (final MapEntry(key: name, value: build) in looks.entries) {
      testWidgets('$name: Tab draws an outlineFocus ring, Enter toggles',
          (tester) async {
        final calls = <bool>[];
        await pumpBoundary(tester, build(true, calls.add));
        expect(
          await ringPixel(tester),
          colors.backgroundOrangeLight.toARGB32(),
        );

        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pumpAndSettle();
        expect(await ringPixel(tester), colors.outlineFocus.toARGB32());
        final row = tester.getRect(rowFinder);
        expect(
          await pixelAt(
            tester,
            find.byKey(boundaryKey),
            Offset(row.left + 64, row.top + 6),
          ),
          colors.backgroundOrangeLight.toARGB32(),
          reason: 'focus adds the ring only, no grey fill',
        );

        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pump();
        expect(calls, [true, true]);
      });

      testWidgets('$name: a touch tap after Tab clears the ring',
          (tester) async {
        await pumpBoundary(tester, build(true, (_) {}));
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pumpAndSettle();
        expect(await ringPixel(tester), colors.outlineFocus.toARGB32());

        await tester.tap(rowFinder);
        await tester.pumpAndSettle();

        expect(
          await ringPixel(tester),
          isNot(colors.outlineFocus.toARGB32()),
        );
      });

      testWidgets('$name: Tab skips a disabled row', (tester) async {
        var calls = 0;
        await pumpBoundary(tester, build(false, (_) => calls++));

        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pumpAndSettle();
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pump();

        expect(
          await ringPixel(tester),
          colors.backgroundOrangeLight.toARGB32(),
        );
        expect(calls, 0);
      });
    }
  });
}
