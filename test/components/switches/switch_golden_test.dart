import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

ThemeData _createTestTheme() {
  return CoreTheme.light().copyWith(
    textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto'),
  );
}

ThemeData _createDarkTestTheme() {
  return CoreTheme.dark().copyWith(
    textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Roboto'),
  );
}

Widget _buildVariants() {
  return const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CoreSwitch(
        type: CoreSwitchType.normal,
        value: false,
        onChanged: _noop,
      ),
      SizedBox(height: 10),
      CoreSwitch(
        type: CoreSwitchType.normal,
        value: true,
        onChanged: _noop,
      ),
      SizedBox(height: 10),
      CoreSwitch(
        type: CoreSwitchType.lock,
        value: false,
        onChanged: _noop,
        activeLabel: 'Lock',
        inactiveLabel: 'Unlock',
      ),
      SizedBox(height: 10),
      CoreSwitch(
        type: CoreSwitchType.lock,
        value: true,
        onChanged: _noop,
        activeLabel: 'Lock',
        inactiveLabel: 'Unlock',
      ),
      SizedBox(height: 10),
      CoreSwitch(
        type: CoreSwitchType.normal,
        value: false,
        onChanged: _noop,
        activeLabel: 'Public',
        inactiveLabel: 'Private',
      ),
      SizedBox(height: 10),
      CoreSwitch(
        type: CoreSwitchType.normal,
        value: true,
        onChanged: _noop,
        activeLabel: 'Public',
        inactiveLabel: 'Private',
      ),
      SizedBox(height: 10),
      CoreSwitch(
        type: CoreSwitchType.imperial,
        value: false,
        onChanged: _noop,
        activeLabel: 'Metric',
        inactiveLabel: 'Imperial',
      ),
      SizedBox(height: 10),
      CoreSwitch(
        type: CoreSwitchType.imperial,
        value: true,
        onChanged: _noop,
        activeLabel: 'Metric',
        inactiveLabel: 'Imperial',
      ),
    ],
  );
}

Widget _buildLooks({
  required ValueChanged<bool>? onChanged,
  bool? onlyShowHide,
}) {
  Widget row(CoreSwitchType type, {String? on, String? off}) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            for (final value in [false, true]) ...[
              CoreSwitch(
                type: type,
                value: value,
                onChanged: onChanged,
                activeLabel: on,
                inactiveLabel: off,
              ),
              const SizedBox(width: 8),
            ],
          ],
        ),
      );

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      row(CoreSwitchType.showHide),
      if (onlyShowHide != true) ...[
        row(CoreSwitchType.normal),
        row(CoreSwitchType.normal, on: 'Public', off: 'Private'),
        row(CoreSwitchType.lock, on: 'Lock', off: 'Unlock'),
        row(CoreSwitchType.imperial, on: 'Metric', off: 'Imperial'),
      ],
    ],
  );
}

void _noop(bool _) {}

void main() {
  setUpAll(() async {
    await loadFonts();
  });

  Future<void> pumpVariants(
    WidgetTester tester,
    ThemeData theme, {
    Widget? child,
    Size size = const Size(200, 500),
  }) async {
    final colors = theme.coreColors;
    final widget = MaterialApp(
      theme: theme,
      home: Scaffold(
        backgroundColor: colors.pageBackground,
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: child ?? _buildVariants(),
        ),
      ),
    );
    await tester.binding.setSurfaceSize(size);

    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();
  }

  testWidgets('CoreSwitch Golden Test - All Variants',
      (WidgetTester tester) async {
    await pumpVariants(tester, _createTestTheme());

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/switch_component.png'),
    );
  });

  testWidgets('CoreSwitch Golden Test - All Variants - Dark',
      (WidgetTester tester) async {
    await pumpVariants(tester, _createDarkTestTheme());

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/switch_component_dark.png'),
    );
  });

  for (final (name, theme) in [
    ('switch_focused', _createTestTheme()),
    ('switch_focused_dark', _createDarkTestTheme()),
  ]) {
    testWidgets('CoreSwitch Golden Test - $name', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(120, 80));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          home: Scaffold(
            backgroundColor: theme.coreColors.pageBackground,
            body: const Padding(
              padding: EdgeInsets.all(16),
              child: CoreSwitch(value: false, onChanged: _noop),
            ),
          ),
        ),
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/$name.png'),
      );
    });
  }
  final themes = {
    '': _createTestTheme,
    '_dark': _createDarkTestTheme,
  };

  themes.forEach((suffix, theme) {
    final mode = suffix.isEmpty ? 'Light' : 'Dark';

    testWidgets('CoreSwitch Golden Test - Show Hide - $mode',
        (WidgetTester tester) async {
      await pumpVariants(
        tester,
        theme(),
        child: _buildLooks(onChanged: _noop, onlyShowHide: true),
        size: const Size(200, 100),
      );

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/switch_show_hide$suffix.png'),
      );
    });

    testWidgets('CoreSwitch Golden Test - Disabled - $mode',
        (WidgetTester tester) async {
      await pumpVariants(
        tester,
        theme(),
        child: _buildLooks(onChanged: null),
        size: const Size(220, 340),
      );

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/switch_disabled$suffix.png'),
      );
    });
  });
}
