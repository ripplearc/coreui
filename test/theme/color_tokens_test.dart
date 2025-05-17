import 'package:core_ui/src/theme/color_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  Widget _buildColorSwatch(String name, Color color) {
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
            name,
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

  Widget _buildColorGrid(String title, List<MapEntry<String, Color>> colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: colors.map((entry) {
            return _buildColorSwatch(entry.key, entry.value);
          }).toList(),
        ),
      ],
    );
  }

  testGoldens('Core Color Tokens Test', (tester) async {
    final builder = GoldenBuilder.column()
      ..addScenario(
        'Text Colors',
        _buildColorGrid(
          'Text Colors',
          [
            MapEntry('headline', CoreTextColors.headline),
            MapEntry('dark', CoreTextColors.dark),
            MapEntry('body', CoreTextColors.body),
            MapEntry('disable', CoreTextColors.disable),
            MapEntry('inverse', CoreTextColors.inverse),
            MapEntry('link', CoreTextColors.link),
            MapEntry('info', CoreTextColors.info),
            MapEntry('warning', CoreTextColors.warning),
            MapEntry('error', CoreTextColors.error),
            MapEntry('success', CoreTextColors.success),
          ],
        ),
      )
      ..addScenario(
        'Background Colors',
        _buildColorGrid(
          'Background Colors',
          [
            MapEntry('pageBackground', CoreBackgroundColors.pageBackground),
            MapEntry('backgroundGrayLight',
                CoreBackgroundColors.backgroundGrayLight),
            MapEntry(
                'backgroundGrayMid', CoreBackgroundColors.backgroundGrayMid),
            MapEntry('backgroundBlueLight',
                CoreBackgroundColors.backgroundBlueLight),
            MapEntry(
                'backgroundBlueMid', CoreBackgroundColors.backgroundBlueMid),
            MapEntry('backgroundGreenLight',
                CoreBackgroundColors.backgroundGreenLight),
            MapEntry(
                'backgroundGreenMid', CoreBackgroundColors.backgroundGreenMid),
            MapEntry(
                'backgroundRedLight', CoreBackgroundColors.backgroundRedLight),
            MapEntry('backgroundRedMid', CoreBackgroundColors.backgroundRedMid),
            MapEntry('backgroundOrangeLight',
                CoreBackgroundColors.backgroundOrangeLight),
            MapEntry('backgroundOrangeMid',
                CoreBackgroundColors.backgroundOrangeMid),
            MapEntry(
                'backgroundDarkGray', CoreBackgroundColors.backgroundDarkGray),
            MapEntry('backgroundDarkOrient',
                CoreBackgroundColors.backgroundDarkOrient),
            MapEntry('backgroundOrientLight',
                CoreBackgroundColors.backgroundOrientLight),
            MapEntry('backgroundOrientMid',
                CoreBackgroundColors.backgroundOrientMid),
          ],
        ),
      )
      ..addScenario(
        'Border Colors',
        _buildColorGrid(
          'Border Colors',
          [
            MapEntry('lineLight', CoreBorderColors.lineLight),
            MapEntry('lineMid', CoreBorderColors.lineMid),
            MapEntry('lineDarkOutline', CoreBorderColors.lineDarkOutline),
            MapEntry('lineHighlight', CoreBorderColors.lineHighlight),
            MapEntry('outlineHover', CoreBorderColors.outlineHover),
            MapEntry('outlineFocus', CoreBorderColors.outlineFocus),
            MapEntry('tabsHighlight', CoreBorderColors.tabsHighlight),
          ],
        ),
      )
      ..addScenario(
        'Status Colors',
        _buildColorGrid(
          'Status Colors',
          [
            MapEntry('error', CoreStatusColors.error),
            MapEntry('success', CoreStatusColors.success),
          ],
        ),
      )
      ..addScenario(
        'Keyboard Colors',
        _buildColorGrid(
          'Keyboard Colors',
          [
            MapEntry('numbers', CoreKeyboardColors.numbers),
            MapEntry('calculate', CoreKeyboardColors.calculate),
            MapEntry('units', CoreKeyboardColors.units),
            MapEntry('functions', CoreKeyboardColors.functions),
            MapEntry('actions', CoreKeyboardColors.actions),
            MapEntry('main', CoreKeyboardColors.main),
          ],
        ),
      )
      ..addScenario(
        'Icon Colors',
        _buildColorGrid(
          'Icon Colors',
          [
            MapEntry('dark', CoreIconColors.dark),
            MapEntry('grayDark', CoreIconColors.grayDark),
            MapEntry('grayMid', CoreIconColors.grayMid),
            MapEntry('grayLight', CoreIconColors.grayLight),
            MapEntry('white', CoreIconColors.white),
            MapEntry('red', CoreIconColors.red),
            MapEntry('orient', CoreIconColors.orient),
            MapEntry('orange', CoreIconColors.orange),
            MapEntry('blue', CoreIconColors.blue),
            MapEntry('green', CoreIconColors.green),
          ],
        ),
      )
      ..addScenario(
        'Chip Colors',
        _buildColorGrid(
          'Chip Colors',
          [
            MapEntry('grey', CoreChipColors.gray),
            MapEntry('primary', CoreChipColors.primary),
            MapEntry('red', CoreChipColors.red),
            MapEntry('orange', CoreChipColors.orange),
            MapEntry('blue', CoreChipColors.blue),
            MapEntry('green', CoreChipColors.green),
          ],
        ),
      )
      ..addScenario(
        'Button Colors',
        _buildColorGrid(
          'Button Colors',
          [
            MapEntry('surface', CoreButtonColors.surface),
            MapEntry('hover', CoreButtonColors.hover),
            MapEntry('press', CoreButtonColors.press),
            MapEntry('disable', CoreButtonColors.disable),
          ],
        ),
      )
      ..addScenario(
        'Alert Colors',
        _buildColorGrid(
          'Alert Colors',
          [
            MapEntry('red', CoreAlertColors.red),
            MapEntry('orange', CoreAlertColors.orange),
            MapEntry('blue', CoreAlertColors.blue),
            MapEntry('green', CoreAlertColors.green),
          ],
        ),
      )
      ..addScenario(
        'Shadow Colors',
        _buildColorGrid(
          'Shadow Colors',
          [
            MapEntry('shadowGrey3', CoreShadowColors.shadowGrey3),
            MapEntry('shadowGrey5', CoreShadowColors.shadowGrey5),
            MapEntry('shadowGrey6', CoreShadowColors.shadowGrey6),
            MapEntry('shadowGrey7', CoreShadowColors.shadowGrey7),
            MapEntry('shadowGrey8', CoreShadowColors.shadowGrey8),
            MapEntry('shadowGrey10', CoreShadowColors.shadowGrey10),
            MapEntry('shadowGrey18', CoreShadowColors.shadowGrey18),
          ],
        ),
      );

    await tester.pumpWidgetBuilder(
      builder.build(),
      surfaceSize: const Size(1024, 4096),
    );

    await screenMatchesGolden(tester, 'core_color_tokens');
  });
}
