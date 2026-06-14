import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

void _setTestViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}

Widget _buildShowTrigger({
  CoreSizeCardData? initialData,
  int? initialIndex,
}) {
  return MaterialApp(
    theme: CoreTheme.light(),
    home: Scaffold(
      body: Builder(
        builder: (context) {
          return ElevatedButton(
            onPressed: () {
              SizeEntryBottomSheet.show(
                context: context,
                titles: const ['Rail', 'O.C.'],
                addSizeTitle: 'Add size',
                editSizeTitle: 'Edit size',
                initialData: initialData,
                initialIndex: initialIndex,
              );
            },
            child: const Text('Show'),
          );
        },
      ),
    ),
  );
}

void main() {
  group('SizeEntryBottomSheet', () {
    testWidgets('renders Add mode with correct title and field labels',
        (tester) async {
      _setTestViewport(tester);
      await tester.pumpWidget(_buildShowTrigger());
      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      expect(find.byType(SizeEntryBottomSheet), findsOneWidget);
      expect(find.text('Add size'), findsOneWidget);
      expect(find.text('Rail*'), findsOneWidget);
      expect(find.text('O.C.*'), findsOneWidget);
    });

    testWidgets('renders Edit mode with correct title and pre-filled values',
        (tester) async {
      _setTestViewport(tester);
      await tester.pumpWidget(
        _buildShowTrigger(
          initialData: const CoreSizeCardData(id: '1', values: ['5', '8ft']),
          initialIndex: 0,
        ),
      );
      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      expect(find.byType(SizeEntryBottomSheet), findsOneWidget);
      expect(find.text('Edit size'), findsOneWidget);
      expect(find.text('5'), findsWidgets);
      expect(find.text('8ft'), findsWidgets);
    });
  });
}
