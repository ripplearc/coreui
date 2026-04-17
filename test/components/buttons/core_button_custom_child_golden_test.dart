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

    await tester.binding.setSurfaceSize(const Size(400, 400));

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          extensions: [typography, colors],
        ),
        home: Scaffold(
          backgroundColor: colors.pageBackground,
          body: Center(
            child: Builder(
              builder: (context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Small Size",
                      style: typography.bodySmallRegular.copyWith(
                        color: colors.textDark,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: CoreSpacing.space4,
                      ),
                      child: CoreButton(
                        onPressed: () {},
                        size: CoreButtonSize.small,
                        shadows: CoreShadows.small,
                        variant: CoreButtonVariant.secondary,
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
                      ),
                    ),
                    Text(
                      'Medium Size',
                      style: typography.bodySmallRegular.copyWith(
                        color: colors.textDark,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: CoreSpacing.space4,
                      ),
                      child: CoreButton(
                        onPressed: () {},
                        size: CoreButtonSize.medium,
                        shadows: CoreShadows.small,
                        variant: CoreButtonVariant.secondary,
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
                      ),
                    ),
                    Text(
                      'Large Size',
                      style: typography.bodySmallRegular.copyWith(
                        color: colors.textDark,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: CoreSpacing.space4,
                      ),
                      child: CoreButton(
                        onPressed: () {},
                        size: CoreButtonSize.large,
                        shadows: CoreShadows.small,
                        variant: CoreButtonVariant.secondary,
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
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/core_button_custom_child.png'),
    );
  });
}
