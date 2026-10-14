import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/test_harness.dart';

void main() {
  const buttonKey = Key('lookup_rate_button');

  Widget buildButton({required VoidCallback onTap}) {
    return buildTestApp(
      CoreOutlinedIconButton(
        key: buttonKey,
        icon: CoreIcons.search,
        onTap: onTap,
        semanticLabel: 'Look up a rate',
      ),
      theme: CoreTheme.light(),
    );
  }

  group('CoreOutlinedIconButton', () {
    testWidgets('draws the icon at 20 dp in iconGrayMid', (tester) async {
      await tester.pumpWidget(buildButton(onTap: () {}));

      final icon = tester.widget<CoreIconWidget>(find.byType(CoreIconWidget));
      expect(icon.icon, CoreIcons.search);
      expect(icon.size, CoreIconSize.size20);
      expect(icon.color, CoreTheme.light().coreColors.iconGrayMid);
    });

    testWidgets('draws a 36 dp box with a 1 dp lineMid edge and 9 dp corners',
        (tester) async {
      await tester.pumpWidget(buildButton(onTap: () {}));

      final box = find.descendant(
        of: find.byType(CoreOutlinedIconButton),
        matching: find.byType(Material),
      );
      expect(tester.getSize(box), const Size.square(36));
      final shape =
          tester.widget<Material>(box).shape as RoundedRectangleBorder;
      expect(shape.side.color, CoreTheme.light().coreColors.lineMid);
      expect(shape.side.width, 1);
      expect(shape.borderRadius, BorderRadius.circular(9));
    });

    testWidgets('takes taps on a 48 dp square', (tester) async {
      await tester.pumpWidget(buildButton(onTap: () {}));

      expect(
        tester.getSize(find.byType(CoreOutlinedIconButton)),
        const Size.square(48),
      );
    });

    testWidgets('a tap on the centre of the box calls onTap once',
        (tester) async {
      var taps = 0;
      await tester.pumpWidget(buildButton(onTap: () => taps++));

      await tester.tap(find.byKey(buttonKey));

      expect(taps, 1);
    });

    testWidgets('a tap outside the box but inside the 48 dp square calls onTap',
        (tester) async {
      var taps = 0;
      await tester.pumpWidget(buildButton(onTap: () => taps++));

      final topLeft = tester.getTopLeft(find.byKey(buttonKey));
      await tester.tapAt(topLeft + const Offset(2, 2));

      expect(taps, 1);
    });

    testWidgets('reads as one button named by semanticLabel', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(buildButton(onTap: () {}));

      expect(
        tester.getSemantics(find.byType(CoreOutlinedIconButton)),
        matchesSemantics(
          label: 'Look up a rate',
          isButton: true,
          hasTapAction: true,
        ),
      );
      handle.dispose();
    });
  });
}
