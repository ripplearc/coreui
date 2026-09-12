part of '../core_display_area.dart';

class _ValueSection extends StatelessWidget {
  const _ValueSection({
    required this.value,
    required this.hasError,
    required this.errorTitle,
    required this.dependentKeys,
  });

  final String? value;
  final bool hasError;
  final String errorTitle;
  final List<CoreDependentKeyData> dependentKeys;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);

    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            hasError && errorTitle.isNotEmpty ? errorTitle : (value ?? ''),
            style: typography.headlineLargeSemiBold
                .copyWith(color: colors.textDark),
          ),
          if (dependentKeys.isNotEmpty)
            _DependentKeyRow(dependentKeys: dependentKeys),
        ],
      ),
    );
  }
}

class _DependentKeyRow extends StatelessWidget {
  const _DependentKeyRow({required this.dependentKeys});

  final List<CoreDependentKeyData> dependentKeys;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < dependentKeys.length; i++) ...[
            if (i > 0) const SizedBox(width: CoreSpacing.space2),
            _DependentKeyPill(data: dependentKeys[i]),
          ],
        ],
      ),
    );
  }
}

class _DependentKeyPill extends StatelessWidget {
  const _DependentKeyPill({required this.data});

  final CoreDependentKeyData data;

  String get _formattedLabel {
    final label = data.label.trimRight();
    if (label.isEmpty) return '';
    if (data.kind == CoreDependentKeyKind.offer) return '$label ';
    return label.endsWith(':') ? '$label ' : '$label: ';
  }

  CoreIconData? get _trailingIcon => switch (data.kind) {
        CoreDependentKeyKind.editable => CoreIcons.edit,
        CoreDependentKeyKind.toggle => CoreIcons.swapHorizontal,
        CoreDependentKeyKind.offer => null,
      };

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    final formattedLabel = _formattedLabel;
    final trailingIcon = _trailingIcon;

    return CoreButton(
      onPressed: data.onPressed,
      semanticsLabel: data.semanticsLabel ?? '$formattedLabel${data.value}',
      size: CoreButtonSize.medium,
      shadows: CoreShadows.small,
      variant: CoreButtonVariant.secondary,
      trailing: true,
      fullWidth: false,
      icon: trailingIcon == null
          ? null
          : CoreIconWidget(
              icon: trailingIcon,
              color: colors.iconDark,
              size: CoreIconSize.size16,
            ),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: formattedLabel,
              style: typography.bodySmallRegular.copyWith(
                color: colors.textBody,
              ),
            ),
            TextSpan(
              text: data.value,
              style: typography.bodySmallSemiBold.copyWith(
                color: colors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
