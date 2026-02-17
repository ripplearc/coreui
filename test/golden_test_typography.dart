import 'package:ripplearc_coreui/ripplearc_coreui.dart';

/// Creates an AppTypographyExtension with explicit Roboto font family
/// for use in golden tests where fonts need to be explicitly specified.
AppTypographyExtension createGoldenTestTypography() {
  final base = AppTypographyExtension.create();
  return AppTypographyExtension(
    headlineLargeRegular:
        base.headlineLargeRegular.copyWith(fontFamily: 'Roboto'),
    headlineLargeSemiBold:
        base.headlineLargeSemiBold.copyWith(fontFamily: 'Roboto'),
    headlineMediumRegular:
        base.headlineMediumRegular.copyWith(fontFamily: 'Roboto'),
    headlineMediumSemiBold:
        base.headlineMediumSemiBold.copyWith(fontFamily: 'Roboto'),
    titleLargeRegular: base.titleLargeRegular.copyWith(fontFamily: 'Roboto'),
    titleLargeMedium: base.titleLargeMedium.copyWith(fontFamily: 'Roboto'),
    titleLargeSemiBold: base.titleLargeSemiBold.copyWith(fontFamily: 'Roboto'),
    titleMediumRegular: base.titleMediumRegular.copyWith(fontFamily: 'Roboto'),
    titleMediumMedium: base.titleMediumMedium.copyWith(fontFamily: 'Roboto'),
    titleMediumSemiBold:
        base.titleMediumSemiBold.copyWith(fontFamily: 'Roboto'),
    bodyLargeRegular: base.bodyLargeRegular.copyWith(fontFamily: 'Roboto'),
    bodyLargeMedium: base.bodyLargeMedium.copyWith(fontFamily: 'Roboto'),
    bodyLargeSemiBold: base.bodyLargeSemiBold.copyWith(fontFamily: 'Roboto'),
    bodyMediumRegular: base.bodyMediumRegular.copyWith(fontFamily: 'Roboto'),
    bodyMediumMedium: base.bodyMediumMedium.copyWith(fontFamily: 'Roboto'),
    bodyMediumSemiBold: base.bodyMediumSemiBold.copyWith(fontFamily: 'Roboto'),
    bodySmallRegular: base.bodySmallRegular.copyWith(fontFamily: 'Roboto'),
    bodySmallMedium: base.bodySmallMedium.copyWith(fontFamily: 'Roboto'),
    bodySmallSemiBold: base.bodySmallSemiBold.copyWith(fontFamily: 'Roboto'),
  );
}
