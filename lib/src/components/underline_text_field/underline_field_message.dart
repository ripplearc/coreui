import 'package:flutter/material.dart';

import '../../theme/app_typography_extension.dart';
import '../../theme/icons/core_icons.dart';
import '../../theme/spacing.dart';
import '../../theme/theme_extensions.dart';
import '../core_icon.dart';
import 'underline_field_metrics.dart';

class UnderlineFieldMessage extends StatelessWidget {
  final String text;
  final bool isError;

  const UnderlineFieldMessage({
    super.key,
    required this.text,
    required this.isError,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.coreColors;

    return Semantics(
      liveRegion: isError,
      child: Padding(
        padding: const EdgeInsets.only(
          top: UnderlineFieldMetrics.messageTopGap,
          left: UnderlineFieldMetrics.horizontalInset,
          right: UnderlineFieldMetrics.horizontalInset,
        ),
        child: Row(
          children: [
            ExcludeSemantics(
              child: CoreIconWidget(
                icon: isError ? CoreIcons.error : CoreIcons.info,
                size: CoreSpacing.space4,
                color: isError ? colors.iconRed : colors.iconGrayMid,
              ),
            ),
            const SizedBox(width: CoreSpacing.space2),
            Expanded(
              child: Text(
                text,
                style: theme.coreTypography.bodySmallRegular.copyWith(
                  color: isError ? colors.textError : colors.textBody,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
