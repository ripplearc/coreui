import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

ThemeData _withRoboto(ThemeData base) {
  return base.copyWith(
    textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto'),
  );
}

void main() {
  setUpAll(() async {
    await loadFonts();
    TestWidgetsFlutterBinding.ensureInitialized();
  });
  Future<void> pumpToasts(WidgetTester tester, {ThemeData? theme}) async {
    final colors = theme?.coreColors ?? AppColorsExtension.create();
    await tester.binding.setSurfaceSize(const Size(1050, 660));

    final toasts = <Widget>[
      Toast.error(
        title: 'Error Title',
        description: 'This is an error message that needs attention',
        closeLabel: 'Close',
        onClose: () {},
      ),
      Toast.warning(
        title: 'Warning Title',
        description: 'This is a warning message to be careful about',
        closeLabel: 'Close',
        onClose: () {},
      ),
      Toast.info(
        title: 'Info Title',
        description: 'This is an informational message for you',
        closeLabel: 'Close',
        onClose: () {},
      ),
      Toast.success(
        title: 'Success Title',
        description: 'This is a success message, well done!',
        closeLabel: 'Close',
        onClose: () {},
      ),
      Toast.error(
        description: 'This is an error message without a title',
        closeLabel: 'Close',
        onClose: () {},
      ),
      Toast.warning(
        description: 'This is a warning message without a title',
        closeLabel: 'Close',
        onClose: () {},
      ),
      Toast.info(
        description: 'This is an info message without a title',
        closeLabel: 'Close',
        onClose: () {},
      ),
      Toast.success(
        description: 'This is a success message without a title',
        closeLabel: 'Close',
        onClose: () {},
      ),
      Toast.error(
        title:
            'This is a very long title that should wrap to multiple lines gracefully',
        description:
            'This is an equally long description that demonstrates how the toast handles extended content without breaking the layout',
        closeLabel: 'Close',
        onClose: () {},
      ),
      Toast.receipt(
        description: 'Saved to history',
        highlight: 'Calc 60ft²',
        actionLabel: 'Undo',
        onAction: () {},
        secondaryLabel: 'View',
        onSecondary: () {},
        onClose: () {},
        duration: null,
      ),
      Toast.receipt(
        description: 'Saved to history',
        highlight: 'Calc 60ft²',
        actionLabel: 'Undo',
        onAction: () {},
        onClose: () {},
        duration: null,
      ),
      Toast.receipt(
        description: 'Saved to history',
        actionLabel: 'Undo',
        onAction: () {},
        secondaryLabel: 'View',
        onSecondary: () {},
        onClose: () {},
        duration: null,
      ),
      Toast.acknowledgement(description: 'Added to Bedroom 2'),
    ];

    final widget = MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: Scaffold(
        backgroundColor: colors.pageBackground,
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: toasts
                .map((toast) => SizedBox(width: 500, child: toast))
                .toList(),
          ),
        ),
      ),
    );

    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();
  }

  testWidgets('Toast Component Visual Regression Test',
      (WidgetTester tester) async {
    await pumpToasts(tester);

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/toast_component.png'),
    );
  });

  testWidgets('Toast Component Visual Regression Test (dark)',
      (WidgetTester tester) async {
    await pumpToasts(tester, theme: _withRoboto(CoreTheme.dark()));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/toast_component_dark.png'),
    );
  });
}
