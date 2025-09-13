// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/src/theme/color_tokens.dart';

import '../load_fonts.dart';

void main() {
  setUpAll(() async {
    await loadFonts();
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  String separateName(String name) {
    final separatedName = name
        .replaceAllMapped(
          RegExp(r'([A-Z])'),
          (Match match) => ' ${match.group(1)}',
        )
        .trim();

    return separatedName.isNotEmpty
        ? separatedName[0].toUpperCase() + separatedName.substring(1)
        : separatedName;
  }

  Widget buildColorSwatch(String name, Color color) {
    return SizedBox(
      width: 100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            separateName(name),
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '#${color.value.toRadixString(16).toUpperCase().padLeft(8, '0')}',
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget buildColorGrid(String title, List<MapEntry<String, Color>> colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: colors.map((entry) {
              return buildColorSwatch(entry.key, entry.value);
            }).toList(),
          ),
        ],
      ),
    );
  }

  testWidgets('Core Color Tokens Golden Test', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1024, 2700));

    final widget = MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildColorGrid('Text Colors', [
                const MapEntry('headline', CoreTextColors.headline),
                const MapEntry('dark', CoreTextColors.dark),
                const MapEntry('body', CoreTextColors.body),
                const MapEntry('disable', CoreTextColors.disable),
                const MapEntry('inverse', CoreTextColors.inverse),
                const MapEntry('link', CoreTextColors.link),
                const MapEntry('info', CoreTextColors.info),
                const MapEntry('warning', CoreTextColors.warning),
                const MapEntry('error', CoreTextColors.error),
                const MapEntry('success', CoreTextColors.success),
              ]),
              buildColorGrid('Background Colors', [
                const MapEntry(
                    'pageBackground', CoreBackgroundColors.pageBackground),
                const MapEntry('backgroundGrayLight',
                    CoreBackgroundColors.backgroundGrayLight),
                const MapEntry('backgroundGrayMid',
                    CoreBackgroundColors.backgroundGrayMid),
                const MapEntry('backgroundBlueLight',
                    CoreBackgroundColors.backgroundBlueLight),
                const MapEntry('backgroundBlueMid',
                    CoreBackgroundColors.backgroundBlueMid),
                const MapEntry('backgroundGreenLight',
                    CoreBackgroundColors.backgroundGreenLight),
                const MapEntry('backgroundGreenMid',
                    CoreBackgroundColors.backgroundGreenMid),
                const MapEntry('backgroundRedLight',
                    CoreBackgroundColors.backgroundRedLight),
                const MapEntry(
                    'backgroundRedMid', CoreBackgroundColors.backgroundRedMid),
                const MapEntry('backgroundOrangeLight',
                    CoreBackgroundColors.backgroundOrangeLight),
                const MapEntry('backgroundOrangeMid',
                    CoreBackgroundColors.backgroundOrangeMid),
                const MapEntry('backgroundDarkGray',
                    CoreBackgroundColors.backgroundDarkGray),
                const MapEntry('backgroundDarkOrient',
                    CoreBackgroundColors.backgroundDarkOrient),
                const MapEntry('backgroundOrientLight',
                    CoreBackgroundColors.backgroundOrientLight),
                const MapEntry('backgroundOrientMid',
                    CoreBackgroundColors.backgroundOrientMid),
              ]),
              buildColorGrid('Border Colors', [
                const MapEntry('lineLight', CoreBorderColors.lineLight),
                const MapEntry('lineMid', CoreBorderColors.lineMid),
                const MapEntry(
                    'lineDarkOutline', CoreBorderColors.lineDarkOutline),
                const MapEntry('lineHighlight', CoreBorderColors.lineHighlight),
                const MapEntry('outlineHover', CoreBorderColors.outlineHover),
                const MapEntry('outlineFocus', CoreBorderColors.outlineFocus),
                const MapEntry('tabsHighlight', CoreBorderColors.tabsHighlight),
              ]),
              buildColorGrid('Status Colors', [
                const MapEntry('error', CoreStatusColors.error),
                const MapEntry('success', CoreStatusColors.success),
              ]),
              buildColorGrid('Keyboard Colors', [
                const MapEntry('numbers', CoreKeyboardColors.numbers),
                const MapEntry('calculate', CoreKeyboardColors.calculate),
                const MapEntry('units', CoreKeyboardColors.units),
                const MapEntry('functions', CoreKeyboardColors.functions),
                const MapEntry('actions', CoreKeyboardColors.actions),
                const MapEntry('main', CoreKeyboardColors.main),
              ]),
              buildColorGrid('Icon Colors', [
                const MapEntry('dark', CoreIconColors.dark),
                const MapEntry('grayDark', CoreIconColors.grayDark),
                const MapEntry('grayMid', CoreIconColors.grayMid),
                const MapEntry('grayLight', CoreIconColors.grayLight),
                const MapEntry('white', CoreIconColors.white),
                const MapEntry('red', CoreIconColors.red),
                const MapEntry('orient', CoreIconColors.orient),
                const MapEntry('orange', CoreIconColors.orange),
                const MapEntry('blue', CoreIconColors.blue),
                const MapEntry('green', CoreIconColors.green),
              ]),
              buildColorGrid('Chip Colors', [
                const MapEntry('grey', CoreChipColors.gray),
                const MapEntry('primary', CoreChipColors.primary),
                const MapEntry('red', CoreChipColors.red),
                const MapEntry('orange', CoreChipColors.orange),
                const MapEntry('blue', CoreChipColors.blue),
                const MapEntry('green', CoreChipColors.green),
              ]),
              buildColorGrid('Button Colors', [
                const MapEntry('surface', CoreButtonColors.surface),
                const MapEntry('hover', CoreButtonColors.hover),
                const MapEntry('press', CoreButtonColors.press),
                const MapEntry('disable', CoreButtonColors.disable),
              ]),
              buildColorGrid('Alert Colors', [
                const MapEntry('red', CoreAlertColors.red),
                const MapEntry('orange', CoreAlertColors.orange),
                const MapEntry('blue', CoreAlertColors.blue),
                const MapEntry('green', CoreAlertColors.green),
              ]),
              buildColorGrid('Shadow Colors', [
                MapEntry('shadowGrey3', CoreShadowColors.shadowGrey3),
                MapEntry('shadowGrey5', CoreShadowColors.shadowGrey5),
                MapEntry('shadowGrey6', CoreShadowColors.shadowGrey6),
                MapEntry('shadowGrey7', CoreShadowColors.shadowGrey7),
                MapEntry('shadowGrey8', CoreShadowColors.shadowGrey8),
                MapEntry('shadowGrey10', CoreShadowColors.shadowGrey10),
                MapEntry('shadowGrey18', CoreShadowColors.shadowGrey18),
              ]),
            ],
          ),
        ),
      ),
    );

    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_color_tokens.png'),
    );
  });
}
