import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/test_harness.dart';

void main() {
  group('CoreFilterChip', () {
    testWidgets('renders label text', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          const CoreFilterChip(label: 'Tags'),
          theme: CoreTheme.light(),
        ),
      );

      expect(find.text('Tags'), findsOneWidget);
    });

    testWidgets('does not expose as button when onTap is null', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          const CoreFilterChip(label: 'Tags'),
          theme: CoreTheme.light(),
        ),
      );

      final handle = tester.ensureSemantics();
      final node = tester.getSemantics(find.byType(CoreFilterChip));
      expect(node.label, contains('Tags'));
      expect(node.flagsCollection.isButton, isFalse);
      handle.dispose();
    });

    testWidgets('invokes onTap when tapped and exposes semantics as button', (
      tester,
    ) async {
      var tapCount = 0;

      await tester.pumpWidget(
        buildTestApp(
          CoreFilterChip(
            label: 'Tags',
            onTap: () => tapCount++,
          ),
          theme: CoreTheme.light(),
        ),
      );

      final handle = tester.ensureSemantics();
      final node = tester.getSemantics(find.byType(CoreFilterChip));
      expect(node.label, contains('Tags'));
      expect(node.flagsCollection.isButton, isTrue);

      await tester.tap(find.text('Tags'));
      await tester.pump();

      expect(tapCount, 1);
      handle.dispose();
    });

    testWidgets('draws a 32 dp pill inside a 48 dp touch area', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          CoreFilterChip(label: 'Tags', onTap: () {}),
          theme: CoreTheme.light(),
        ),
      );

      final chipSize = tester.getSize(find.byType(CoreFilterChip));
      final pill = find.byKey(CoreFilterChip.pillKey);
      expect(chipSize.height, CoreSpacing.space12);
      expect(chipSize.width, greaterThanOrEqualTo(CoreSpacing.space12));
      expect(tester.getSize(pill).height, CoreSpacing.space8);
    });

    testWidgets('draws the library arrow: 24 dp glyph in textDark', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          CoreFilterChip(label: 'Tags', onTap: () {}),
          theme: CoreTheme.light(),
        ),
      );

      final arrow = tester.widget<CoreIconWidget>(
        find.descendant(
          of: find.byType(CoreFilterChip),
          matching: find.byType(CoreIconWidget),
        ),
      );
      final colors = AppColorsExtension.of(
        tester.element(find.byType(CoreFilterChip)),
      );
      expect(arrow.size, CoreIconSize.size24);
      expect(arrow.color, colors.textDark);
    });

    testWidgets('draws the focus border on the pill when focused with Tab', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          CoreFilterChip(label: 'Tags', onTap: () {}),
          theme: CoreTheme.light(),
        ),
      );
      final pill = find.byKey(CoreFilterChip.pillKey);
      final restingSize = tester.getSize(pill);

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();

      final decoration = tester.widget<Container>(pill).decoration;
      final border = (decoration as BoxDecoration).border as Border;
      final colors = AppColorsExtension.of(tester.element(pill));
      expect(border.top.color, colors.outlineFocus);
      expect(border.top.width, 2);
      expect(tester.getSize(pill), restingSize);
    });

    testWidgets('fills the pill Grey Mid while pressed, every time', (
      tester,
    ) async {
      var tapCount = 0;
      await tester.pumpWidget(
        buildTestApp(
          CoreFilterChip(label: 'Tags', onTap: () => tapCount++),
          theme: CoreTheme.light(),
        ),
      );
      final pill = find.byKey(CoreFilterChip.pillKey);
      final colors = AppColorsExtension.of(tester.element(pill));
      Color? pillFill() =>
          (tester.widget<Container>(pill).decoration as BoxDecoration).color;

      for (var press = 1; press <= 2; press++) {
        final gesture = await tester.startGesture(tester.getCenter(pill));
        await tester.pump();
        expect(pillFill(), colors.backgroundGrayMid);

        await gesture.up();
        await tester.pump();
        expect(pillFill(), colors.pageBackground);
        expect(tapCount, press);
      }
    });

    testWidgets('grows the pill so a 200% label is not cut', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: buildTestApp(
            CoreFilterChip(label: 'Tags', onTap: () {}),
            theme: CoreTheme.light(),
          ),
        ),
      );

      final label = tester.renderObject<RenderBox>(find.text('Tags'));
      final pill = tester.getRect(find.byKey(CoreFilterChip.pillKey));
      expect(
        label.size.height,
        greaterThanOrEqualTo(label.getMinIntrinsicHeight(label.size.width)),
      );
      expect(pill.height, greaterThan(CoreSpacing.space8));
      final labelRect = tester.getRect(find.text('Tags'));
      expect(pill.top, lessThanOrEqualTo(labelRect.top));
      expect(pill.bottom, greaterThanOrEqualTo(labelRect.bottom));
    });

    testWidgets('works with no Material above it', (tester) async {
      var tapCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Center(
            child: CoreFilterChip(label: 'Tags', onTap: () => tapCount++),
          ),
        ),
      );
      await tester.tap(find.text('Tags'));
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(tapCount, 1);
    });
  });
}
