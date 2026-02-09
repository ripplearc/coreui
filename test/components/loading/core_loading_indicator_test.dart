import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';
import '../../load_fonts.dart';
import '../../utils/a11y_guidelines.dart';
import '../../utils/test_harness.dart';

void main() {
  setUpAll(() async {
    await loadFonts();
  });

  group('CoreLoadingIndicator', () {
    testWidgets('renders with default size', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CoreLoadingIndicator(),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(CoreLoadingIndicator), findsOneWidget);

      expect(find.byType(Center), findsOneWidget);

      final sizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(CoreLoadingIndicator),
          matching: find.byType(SizedBox),
        ),
      );
      expect(find.byType(Lottie), findsOneWidget);
      expect(sizedBox.width, 80.0);
      expect(sizedBox.height, 80.0);
    });

    testWidgets('renders with custom size', (tester) async {
      const customSize = 120.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CoreLoadingIndicator(size: customSize),
          ),
        ),
      );

      await tester.pump();

      final sizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(CoreLoadingIndicator),
          matching: find.byType(SizedBox),
        ),
      );
      expect(sizedBox.width, customSize);
      expect(sizedBox.height, customSize);
    });

    testWidgets('is centered', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CoreLoadingIndicator(),
          ),
        ),
      );

      await tester.pump();

      final center = find.ancestor(
        of: find.byType(Lottie),
        matching: find.byType(Center),
      );
      expect(center, findsOneWidget);
    });

    testWidgets('applies custom BoxFit', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CoreLoadingIndicator(fit: BoxFit.fill),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(CoreLoadingIndicator), findsOneWidget);

      final lottieWidget = tester.widget<Lottie>(find.byType(Lottie));

      expect(lottieWidget.fit, BoxFit.fill);
    });
  });

  group('CoreLoadingIndicator – accessibility', () {
    testWidgets('exposes a loading semantic label', (tester) async {
      await setupA11yTest(tester);

      await tester.pumpWidget(
        buildTestApp(
          const CoreLoadingIndicator(),
        ),
      );

      final semantics = tester.getSemantics(find.byType(CoreLoadingIndicator));
      expect(semantics.label, 'Loading');
    });
  });
}
