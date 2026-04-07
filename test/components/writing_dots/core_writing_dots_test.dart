import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

void main() {
  setUpAll(() async {
    await loadFonts();
  });

  group('CoreWritingDots', () {
    testWidgets('renders with default size', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CoreWritingDots(),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(CoreWritingDots), findsOneWidget);

      final lottieWidget = tester.widget<Lottie>(find.byType(Lottie));
      expect(lottieWidget.width, CoreSpacing.space3);
      expect(lottieWidget.height, CoreSpacing.space3);
    });

    testWidgets('renders with custom size', (tester) async {
      const customSize = CoreSpacing.space5;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CoreWritingDots(size: customSize),
          ),
        ),
      );

      await tester.pump();

      final lottieWidget = tester.widget<Lottie>(find.byType(Lottie));
      expect(lottieWidget.width, customSize);
      expect(lottieWidget.height, customSize);
    });
  });
}
