import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';
import 'display_area_test_helpers.dart';

void main() {
  group('CoreDisplayArea empty tape trailing slot at a large text size', () {
    const pillKey = Key('units_pill');

    setUpAll(() async {
      await loadFonts();
    });

    for (final (width, scale) in [(390.0, 3.12), (375.0, 3.12), (320.0, 3.0)]) {
      testWidgets(
          'at $width dp with text at $scale times the size the close icon and '
          'the widget stay inside the collapsed area and take a tap',
          (WidgetTester tester) async {
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });
        tester.view.physicalSize = ui.Size(width, 844);
        tester.view.devicePixelRatio = 1.0;
        var closeTaps = 0;
        var pillTaps = 0;

        await tester.pumpWidget(
          MaterialApp(
            theme: CoreTheme.light().copyWith(
              textTheme:
                  ThemeData.light().textTheme.apply(fontFamily: 'Roboto'),
            ),
            home: Scaffold(
              body: MediaQuery.withClampedTextScaling(
                minScaleFactor: scale,
                maxScaleFactor: scale,
                child: CoreDisplayArea(
                  closeSemanticLabel: testCloseSemanticLabel,
                  historyPlaceholder: testHistoryPlaceholder,
                  onClose: () => closeTaps++,
                  emptyTapeTrailing: CoreButton(
                    key: pillKey,
                    size: CoreButtonSize.small,
                    variant: CoreButtonVariant.secondary,
                    fullWidth: false,
                    semanticsLabel: 'System of units: Imperial',
                    onPressed: () => pillTaps++,
                    child: const Text('Imperial'),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        final areaRect = tester.getRect(find.byType(CoreDisplayArea));
        final iconRect = tester.getRect(find.byType(CoreIconWidget));
        final pillRect = tester.getRect(find.byKey(pillKey));
        final textRect = tester.getRect(find.text(testHistoryPlaceholder));
        expect(areaRect.height, CoreSpacing.space57);
        expect(textRect.height, greaterThan(pillRect.height),
            reason: 'the placeholder must wrap past the widget, or the row '
                'never grows and this proves nothing');
        expect(iconRect.top, greaterThanOrEqualTo(areaRect.top));
        expect(iconRect.bottom, lessThanOrEqualTo(areaRect.bottom));
        expect(pillRect.top, greaterThanOrEqualTo(areaRect.top));
        expect(pillRect.bottom, lessThanOrEqualTo(areaRect.bottom));
        expect(iconRect.top, lessThan(pillRect.bottom),
            reason: 'the close icon starts beside the widget, at the top of '
                'the row');

        await tester.tap(find.byType(CoreIconWidget));
        await tester.tap(find.byKey(pillKey));
        expect(closeTaps, 1);
        expect(pillTaps, 1);
      });
    }
  });
}
