/// Core corner radius tokens for rounded surfaces.
///
/// A token is named by its dp value, so `radius8` is 8 dp. This differs from
/// `CoreSpacing`, which names a token by a multiplier of 4 dp (`space8` is
/// 32 dp). Do not swap a `CoreSpacing` radius for the `CoreRadius` token with
/// the same number.
class CoreRadius {
  CoreRadius._();

  /// 6 dp: the compact status badge and the neutral tag.
  static const double radius6 = 6.0;

  /// 8 dp: the regular status badge.
  static const double radius8 = 8.0;
}
