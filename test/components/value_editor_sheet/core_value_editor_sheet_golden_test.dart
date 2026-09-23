import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

/// Wraps [child] in the harness every golden here shares, so the variants
/// differ only by the sheet they render.
Widget _host({required bool dark, required Widget child}) {
  final theme = dark ? CoreTheme.dark() : CoreTheme.light();
  final base = dark ? ThemeData.dark() : ThemeData.light();
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: theme.copyWith(
      textTheme: base.textTheme.apply(fontFamily: 'Roboto'),
    ),
    home: Scaffold(body: child),
  );
}

Future<void> _expectGolden(
  WidgetTester tester,
  Widget child,
  String fileName, {
  bool dark = false,
}) async {
  tester.view.devicePixelRatio = 3.0;
  addTearDown(() => tester.view.resetDevicePixelRatio());
  await tester.binding.setSurfaceSize(const Size(412, 800));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(_host(dark: dark, child: child));
  await tester.pumpAndSettle();

  await expectLater(
    find.byType(CoreValueEditorSheet),
    matchesGoldenFile('goldens/$fileName'),
  );
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await loadFonts();
  });

  testWidgets('CoreValueEditorSheet Component Visual Regression Test',
      (WidgetTester tester) async {
    await _expectGolden(
      tester,
      const CoreValueEditorSheet(
        titles: ['Title 1', 'Title 2', 'Title 3', 'Title 4'],
        addSizeTitle: 'Add size',
        editSizeTitle: 'Edit size',
        resultLabel: 'Update',
        unitOptions: ['m', 'cm', 'mm'],
        unitGroupLabel: 'Unit',
        initialData: CoreSizeCardData(
          id: '1',
          values: ['10', '20', '30', '40'],
        ),
        initialIndex: 0,
      ),
      'core_value_editor_sheet_component.png',
    );
  });

}

