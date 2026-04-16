import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

void main() {
  setUpAll(() async {
    await loadFonts();
  });

  testWidgets('CoreButton Golden - Custom Child with Shadows', (tester) async {
    final typography = AppTypographyExtension.create();
    final colors = AppColorsExtension.create();

    await tester.binding.setSurfaceSize(const Size(400, 200));

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          extensions: [typography, colors],
        ),
        home: Scaffold(
          backgroundColor: colors.pageBackground,
          body: Center(
            child: Builder(builder: (context) {
              return CoreButton(
                onPressed: () {},
                size: CoreButtonSize.medium,
                variant: CoreButtonVariant.secondary,
                shadows: CoreShadows.small,
                isDisabled: true,
                trailing: true,
                fullWidth: false,
                icon: CoreIconWidget(
                  icon: CoreIcons.edit,
                  color: colors.iconDark,
                  size: CoreSpacing.space4,
                ),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'O.C: ',
                        style: typography.bodySmallRegular.copyWith(
                          color: colors.textBody,
                        ),
                      ),
                      TextSpan(
                        text: '6ft',
                        style: typography.bodySmallSemiBold.copyWith(
                          color: colors.textDark,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );

    await expectLater(
      find.byType(CoreButton),
      matchesGoldenFile('goldens/core_button_custom_child.png'),
    );
  });
}
