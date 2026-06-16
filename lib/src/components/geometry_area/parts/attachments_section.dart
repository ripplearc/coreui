part of '../core_geometry_area.dart';

class _AttachmentsSection extends StatelessWidget {
  const _AttachmentsSection({
    required this.attachmentsTitleLabel,
    required this.viewAllAttachmentsLabel,
    required this.mediaButtonLabel,
    required this.documentButtonLabel,
    this.onMediaButtonPressed,
    this.onDocumentButtonPressed,
    this.onViewAllAttachmentsPressed,
  });

  final String attachmentsTitleLabel;
  final String viewAllAttachmentsLabel;
  final String mediaButtonLabel;
  final String documentButtonLabel;
  final VoidCallback? onMediaButtonPressed;
  final VoidCallback? onDocumentButtonPressed;
  final VoidCallback? onViewAllAttachmentsPressed;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);

    final mediaPressed = onMediaButtonPressed;
    final documentPressed = onDocumentButtonPressed;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: CoreSpacing.space4,
        vertical: CoreSpacing.space1,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                attachmentsTitleLabel,
                style: typography.bodyLargeSemiBold.copyWith(
                  color: colors.textHeadline,
                ),
              ),
              if (onViewAllAttachmentsPressed != null)
                Semantics(
                  button: true,
                  label: viewAllAttachmentsLabel,
                  excludeSemantics: true,
                  child: GestureDetector(
                    onTap: onViewAllAttachmentsPressed,
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          viewAllAttachmentsLabel,
                          style: typography.bodySmallMedium.copyWith(
                            color: colors.textLink,
                          ),
                        ),
                        CoreIconWidget(
                          icon: CoreIcons.arrowRight,
                          color: colors.iconDark,
                          size: CoreIconSize.size24,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          if (mediaPressed != null || documentPressed != null) ...[
            const SizedBox(height: CoreSpacing.space4),
            Row(
              children: [
                if (mediaPressed != null)
                  Expanded(
                    child: CoreButton(
                      label: mediaButtonLabel,
                      variant: CoreButtonVariant.secondary,
                      icon: const CoreIconWidget(
                        icon: CoreIcons.image,
                      ),
                      onPressed: mediaPressed,
                    ),
                  ),
                if (mediaPressed != null && documentPressed != null)
                  const SizedBox(width: CoreSpacing.space4),
                if (documentPressed != null)
                  Expanded(
                    child: CoreButton(
                      label: documentButtonLabel,
                      variant: CoreButtonVariant.secondary,
                      icon: const CoreIconWidget(
                        icon: CoreIcons.file,
                      ),
                      onPressed: documentPressed,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
