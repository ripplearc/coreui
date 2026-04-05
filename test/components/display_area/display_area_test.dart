import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

void main() {
  group('DisplayArea Widget Tests', () {
    testWidgets('renders DisplayArea with correct dimensions and decoration',
        (WidgetTester tester) async {
      addTearDown(() => tester.view.resetPhysicalSize());
      tester.view.physicalSize = const ui.Size(1100, 1600);

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light().copyWith(
            textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto'),
          ),
          home: const Scaffold(
            body: CoreDisplayArea(),
          ),
        ),
      );

      final displayAreaFinder = find.byType(CoreDisplayArea);
      expect(displayAreaFinder, findsOneWidget);

      final container = tester.widget<Container>(
        find
            .descendant(
              of: displayAreaFinder,
              matching: find.byType(Container),
            )
            .first,
      );

      final decoration = container.decoration as BoxDecoration;
      final colors = AppColorsExtension.of(tester.element(displayAreaFinder));
      final size = tester.getSize(find.byType(CoreDisplayArea));
      expect(size.height, CoreSpacing.space57);
      expect(size.width,
          tester.view.physicalSize.width / tester.view.devicePixelRatio);
      expect(decoration.color, colors.backgroundBlueLight);

      final borderRadius = decoration.borderRadius as BorderRadius;
      expect(
          borderRadius.bottomLeft, const Radius.circular(CoreSpacing.space7));
      expect(
          borderRadius.bottomRight, const Radius.circular(CoreSpacing.space7));
    });

    testWidgets('triggers onClose when close icon is tapped',
        (WidgetTester tester) async {
      bool closed = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreDisplayArea(
              onClose: () => closed = true,
            ),
          ),
        ),
      );

      final closeIconFinder = find.byType(CoreIconWidget);
      expect(closeIconFinder, findsOneWidget);

      await tester.tap(closeIconFinder);
      await tester.pumpAndSettle();
      expect(closed, isTrue);
    });
  });
}
