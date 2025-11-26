import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

void main() {
  setUpAll(() async {
    await loadFonts();
  });

  testWidgets('CoreTooltip Golden Test - Top Position',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 300));

    final widget = MaterialApp(
      theme: CoreTheme.light(),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CoreTooltip.top(
            message: 'Tooltip above with arrow pointing down',
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('Top'),
            ),
          ),
        ),
      ),
    );

    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Top'), warnIfMissed: false);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/tooltip_top.png'),
    );
  });

  testWidgets('CoreTooltip Golden Test - Bottom Position',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 300));

    final widget = MaterialApp(
      theme: CoreTheme.light(),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CoreTooltip.bottom(
            message: 'Tooltip below',
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('Bottom'),
            ),
          ),
        ),
      ),
    );

    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Bottom'), warnIfMissed: false);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/tooltip_bottom.png'),
    );
  });

  testWidgets('CoreTooltip Golden Test - Left Position',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(500, 300));

    final widget = MaterialApp(
      theme: CoreTheme.light(),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CoreTooltip.left(
            message: 'Tooltip left',
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('Left'),
            ),
          ),
        ),
      ),
    );

    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Left'), warnIfMissed: false);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/tooltip_left.png'),
    );
  });

  testWidgets('CoreTooltip Golden Test - Right Position',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(500, 300));

    final widget = MaterialApp(
      theme: CoreTheme.light(),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CoreTooltip.right(
            message: 'Tooltip right',
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('Right'),
            ),
          ),
        ),
      ),
    );

    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Right'), warnIfMissed: false);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/tooltip_right.png'),
    );
  });

  testWidgets('CoreTooltip Golden Test - No Arrow Position',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 300));

    final widget = MaterialApp(
      theme: CoreTheme.light(),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CoreTooltip.none(
            message: 'Tooltip without arrow',
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('No Arrow'),
            ),
          ),
        ),
      ),
    );

    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    await tester.tap(find.text('No Arrow'), warnIfMissed: false);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/tooltip_no_arrow.png'),
    );
  });
}
