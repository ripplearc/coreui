import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  Widget buildIconGrid(
    String sizeTitle,
    List<MapEntry<String, CoreIconData>> icons,
    double size, {
    Map<String, Color>? iconColors,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 24, top: 32),
          child: Text(
            sizeTitle,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Wrap(
          spacing: 24,
          runSpacing: 24,
          children: icons.map((entry) {
            return SizedBox(
              width: 32,
              height: 32,
              child: Center(
                child: CoreIconWidget(
                  icon: entry.value,
                  size: size,
                  // color: iconColors?[entry.key] ?? Colors.black87,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  testGoldens('Core Icon System Test', (tester) async {
    final builder = GoldenBuilder.column()
      ..addScenario(
        'Icon System',
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                color: const Color(0xFF464F5B),
                padding: const EdgeInsets.all(32),
                child: const Text(
                  'Icon',
                  style: TextStyle(
                    fontSize: 48,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // 16x16 Icons
              buildIconGrid(
                '16×16',
                [
                  const MapEntry('info', CoreIcons.info),
                  const MapEntry('warning', CoreIcons.warning),
                  const MapEntry('error', CoreIcons.error),
                  const MapEntry('calendar', CoreIcons.calendar),
                  const MapEntry('close', CoreIcons.close),
                  const MapEntry('cancel', CoreIcons.placeholder),
                  const MapEntry('chevronRight', CoreIcons.arrowRight),
                ],
                16,
              ),

              // 20x20 Icons
              buildIconGrid(
                '20×20',
                [
                  const MapEntry('close', CoreIcons.close),
                  const MapEntry('minimize', CoreIcons.placeholder),
                  const MapEntry('menu', CoreIcons.arrowDown),
                  const MapEntry('edit', CoreIcons.edit),
                  const MapEntry('clock', CoreIcons.warning),
                  const MapEntry('info', CoreIcons.info),
                  const MapEntry('multiply', CoreIcons.unfoldLess),
                  const MapEntry('diamond', CoreIcons.unfoldMore),
                  const MapEntry('addUser', CoreIcons.personAdd),
                  const MapEntry('back', CoreIcons.backSpace),
                  const MapEntry('percent', CoreIcons.percent),
                  const MapEntry('minus', CoreIcons.minus),
                  const MapEntry('divide', CoreIcons.slash),
                  const MapEntry('division', CoreIcons.divide),
                  const MapEntry('cross', CoreIcons.cross),
                  const MapEntry('plus', CoreIcons.add),
                  const MapEntry('plusMinus', CoreIcons.plusMinus),
                  const MapEntry('chevronRight', CoreIcons.arrowRight),
                  const MapEntry('link', CoreIcons.link),
                  const MapEntry('trash', CoreIcons.delete),
                  const MapEntry('check', CoreIcons.check),
                  const MapEntry('checkBlank', CoreIcons.checkBlank),
                  const MapEntry('calendar', CoreIcons.calendar),
                  const MapEntry('moreVert', CoreIcons.moreVert),
                  const MapEntry('history', CoreIcons.history),
                  const MapEntry('left', CoreIcons.backspaceLeft),
                  const MapEntry('search', CoreIcons.search),
                  const MapEntry('settings', CoreIcons.settings),
                  const MapEntry('square', CoreIcons.cChar),
                  const MapEntry('cost', CoreIcons.cost),
                  const MapEntry('favorite', CoreIcons.favorite),
                  const MapEntry('calculate', CoreIcons.calculate),
                ],
                20,
              ),

              // 24x24 Icons Row 1
              buildIconGrid(
                '24×24',
                [
                  const MapEntry('eye', CoreIcons.eye),
                  const MapEntry('eyeOff', CoreIcons.eyeOff),
                  const MapEntry('clock', CoreIcons.error),
                  const MapEntry('warning', CoreIcons.warning),
                  const MapEntry('cross', CoreIcons.cross),
                  const MapEntry('info', CoreIcons.info),
                  const MapEntry('chevronDown', CoreIcons.arrowDropDown),
                  const MapEntry('success', CoreIcons.success),
                  const MapEntry('mail', CoreIcons.email),
                  const MapEntry('google', CoreIcons.google),
                  const MapEntry(
                    'facebook',
                    CoreIcons.facebook,
                  ),
                  const MapEntry('back', CoreIcons.backspaceLeft),
                  const MapEntry('apple', CoreIcons.apple),
                  const MapEntry('windows', CoreIcons.microsoft),
                  const MapEntry('mobile', CoreIcons.phone),
                  const MapEntry('user', CoreIcons.person),
                  const MapEntry('plus', CoreIcons.add),
                  const MapEntry('square', CoreIcons.checkBlank),
                  const MapEntry('check', CoreIcons.check),
                ],
                24,
                iconColors: {
                  'facebook': CoreIconColors.blue,
                },
              ),

              // 24x24 Icons Row 2
              buildIconGrid(
                '',
                [
                  const MapEntry('bell', CoreIcons.notification),
                  const MapEntry('search', CoreIcons.search),
                  const MapEntry('mathOperations', CoreIcons.calculator),
                  const MapEntry('grid', CoreIcons.mathOperations),
                  const MapEntry('users', CoreIcons.people),
                  const MapEntry('home', CoreIcons.home),
                  const MapEntry('wallet', CoreIcons.cost),
                  const MapEntry('more', CoreIcons.moreVert),
                  const MapEntry('edit', CoreIcons.edit),
                  const MapEntry('trash', CoreIcons.delete),
                  const MapEntry('heart', CoreIcons.favorite),
                  const MapEntry('image', CoreIcons.fileSearch),
                  const MapEntry('copy', CoreIcons.copy),
                  const MapEntry('share', CoreIcons.share),
                  const MapEntry('list', CoreIcons.list),
                  const MapEntry('lock', CoreIcons.lock),
                  const MapEntry('chevronRight', CoreIcons.arrowRight),
                  const MapEntry('image', CoreIcons.image),
                  const MapEntry('docs', CoreIcons.docs),
                ],
                24,
              ),

              // 24x24 Icons Row 3
              buildIconGrid(
                '',
                [
                  const MapEntry('chat', CoreIcons.message),
                  const MapEntry('chevronDown', CoreIcons.arrowDropDown),
                  const MapEntry('editDocument', CoreIcons.editDocument),
                  const MapEntry('copy', CoreIcons.emptyFile),
                  const MapEntry('template', CoreIcons.tabDuplicate),
                  const MapEntry('flag', CoreIcons.addComment),
                  const MapEntry('lock', CoreIcons.unlock),
                  const MapEntry('arrowUp', CoreIcons.arrowUp),
                  const MapEntry('radio', CoreIcons.radioChecked),
                  const MapEntry('circle', CoreIcons.radio),
                  const MapEntry('calendar', CoreIcons.calendar),
                  const MapEntry('history', CoreIcons.history),
                  const MapEntry('download', CoreIcons.download),
                  const MapEntry('calculator', CoreIcons.calculate),
                  const MapEntry('dollar', CoreIcons.dollar),
                  const MapEntry('camera', CoreIcons.camera),
                  const MapEntry('image', CoreIcons.image),
                  const MapEntry('chevronUp', CoreIcons.arrowDropUp),
                  const MapEntry('percent', CoreIcons.percent),
                ],
                24,
              ),

              // 24x24 Icons Row 4
              buildIconGrid(
                '',
                [
                  const MapEntry(
                      'indeterminateCheckBox', CoreIcons.indeterminateCheckBox),
                  const MapEntry('dropbox', CoreIcons.dropbox),
                  const MapEntry('drive', CoreIcons.googleDrive),
                  const MapEntry('cloud', CoreIcons.onedrive),
                  const MapEntry('cloudOff', CoreIcons.cloudOff),
                  const MapEntry('back', CoreIcons.arrowLeft),
                  const MapEntry('play', CoreIcons.play),
                  const MapEntry('success', CoreIcons.success),
                  const MapEntry('launch', CoreIcons.launch),
                  const MapEntry('camera', CoreIcons.cameraSwitch),
                  const MapEntry('block', CoreIcons.block),
                  const MapEntry('check', CoreIcons.checkMark),
                  const MapEntry('tag', CoreIcons.tag),
                  const MapEntry('verified', CoreIcons.verified),
                ],
                24,
              ),

              // 32x32 Icons
              buildIconGrid(
                '32×32',
                [
                  const MapEntry('plus', CoreIcons.addFile),
                ],
                32,
              ),
            ],
          ),
        ),
      );

    await tester.pumpWidgetBuilder(
      builder.build(),
      surfaceSize: const Size(800, 1550),
    );

    await screenMatchesGolden(tester, 'core_icon_system');
  });
}
