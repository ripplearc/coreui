import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

void main() {
  setUpAll(() async {
    await loadFonts();
  });

  final colors = AppColorsExtension.create();

  testWidgets('CoreQuickSheet Golden Test - Basic Content',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 800));

    await tester.pumpWidget(
      MaterialApp(
        theme: CoreTheme.light().copyWith(
          textTheme: ThemeData().textTheme.apply(fontFamily: 'Roboto'),
        ),
        home: Scaffold(
          backgroundColor: colors.backgroundGrayMid,
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () {
                  CoreQuickSheet.show(
                    context: context,
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Basic Bottom Sheet',
                          ),
                          const SizedBox(height: CoreSpacing.space4),
                          const Text(
                            'This is a simple bottom sheet with minimal content.',
                          ),
                          const SizedBox(height: CoreSpacing.space6),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text('Action'),
                          ),
                          const SizedBox(height: CoreSpacing.space4),
                        ],
                      ),
                    ),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_quick_sheet_basic.png'),
    );
  });

  testWidgets('CoreQuickSheet Golden Test - Custom Background Color',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 800));

    await tester.pumpWidget(
      MaterialApp(
        theme: CoreTheme.light().copyWith(
          textTheme: ThemeData().textTheme.apply(fontFamily: 'Roboto'),
        ),
        home: Scaffold(
          backgroundColor: colors.backgroundGrayMid,
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () {
                  CoreQuickSheet.show(
                    context: context,
                    backgroundColor: colors.backgroundBlueLight,
                    child: const SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Custom Background',
                          ),
                          SizedBox(height: CoreSpacing.space4),
                          Text(
                            'This sheet has a custom background color.',
                          ),
                          SizedBox(height: CoreSpacing.space4),
                        ],
                      ),
                    ),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_quick_sheet_custom_bg.png'),
    );
  });

  testWidgets('CoreQuickSheet Golden Test - Long Content',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 800));

    await tester.pumpWidget(
      MaterialApp(
        theme: CoreTheme.light().copyWith(
          textTheme: ThemeData().textTheme.apply(fontFamily: 'Roboto'),
        ),
        home: Scaffold(
          backgroundColor: colors.backgroundGrayMid,
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () {
                  CoreQuickSheet.show(
                    context: context,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 15,
                      itemBuilder: (context, index) => ListTile(
                        leading: CircleAvatar(
                          backgroundColor: colors.orientMid,
                          child: Text('${index + 1}'),
                        ),
                        title: Text('Item ${index + 1}'),
                        subtitle: Text('Description for item ${index + 1}'),
                      ),
                    ),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_quick_sheet_long_content.png'),
    );
  });
}
