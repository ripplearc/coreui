import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await loadFonts();
  });

  testWidgets('SizeEntryBottomSheet Component Visual Regression Test',
      (WidgetTester tester) async {
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() => tester.view.resetDevicePixelRatio());
    await tester.binding.setSurfaceSize(const Size(412, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final widget = MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: CoreTheme.light().copyWith(
        textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto'),
      ),
      home: const Scaffold(
        body: SizeEntryBottomSheet(
          titles: ['Title 1', 'Title 2', 'Title 3', 'Title 4'],
          addSizeTitle: 'Add size',
          editSizeTitle: 'Edit size',
          initialData: CoreSizeCardData(
            id: '1',
            values: ['10', '20', '30', '40'],
          ),
          initialIndex: 0,
        ),
      ),
    );

    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(SizeEntryBottomSheet),
      matchesGoldenFile('goldens/size_entry_bottom_sheet_component.png'),
    );
  });
}
