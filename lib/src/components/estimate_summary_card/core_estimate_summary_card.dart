import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

/// An extra charge already counted in the line total, shown under it as
/// "incl. delivery  +$85.00".
class CoreEstimateSummaryCharge {
  /// What the charge is, e.g. "incl. delivery" or "incl. 10% waste".
  final String label;

  /// The formatted amount, sign included, e.g. "+$85.00".
  final String amount;

  const CoreEstimateSummaryCharge({required this.label, required this.amount});
}

/// The "Adds to this estimate" card above a cost form's Add button: what the
/// line adds, an optional extra charge inside it, and the estimate's total
/// before and after.
///
/// Figma "Estimate Change" (`66335:151611`), shared by the material, labor
/// and equipment forms. Every string arrives formatted and localised, so the
/// card never formats money.
///
/// The grey "before" text uses `textBody`, not Figma's `textDisable`, which is
/// 2.4:1 on the blue fill in light and 2.6:1 in dark.
///
/// The card is one live region, so a screen reader reads the new totals as
/// the user types.
///
/// ```dart
/// CoreEstimateSummaryCard(
///   title: 'Adds to this estimate',
///   lineTotal: r'$605.00',
///   extraCharge: const CoreEstimateSummaryCharge(
///     label: 'incl. delivery',
///     amount: r'+$85.00',
///   ),
///   estimateName: 'Bedroom 2',
///   totalBeforeSuffix: r' total  $2,993.62 →',
///   totalAfter: r'$3,598.62',
/// )
/// ```
class CoreEstimateSummaryCard extends StatelessWidget {
  /// The caption, e.g. "Adds to this estimate".
  final String title;

  final String lineTotal;
  final CoreEstimateSummaryCharge? extraCharge;
  final String estimateName;

  /// The text after [estimateName], e.g. " total  $2,993.62 →".
  final String totalBeforeSuffix;

  final String totalAfter;

  const CoreEstimateSummaryCard({
    super.key,
    required this.title,
    required this.lineTotal,
    this.extraCharge,
    required this.estimateName,
    required this.totalBeforeSuffix,
    required this.totalAfter,
  });

  // Figma's own measurements: none of them is a CoreSpacing step.
  static const _padding = EdgeInsets.fromLTRB(15, 13, 15, 12);
  static const _radius = 14.0;
  static const _gap = SizedBox(height: 1);
  static const _dividerPadding = EdgeInsets.only(top: 9, bottom: 7);
  static const _amountHeight = 40.0;
  static const _rowHeight = 24.0;
  static const _amountLetterSpacing = -0.32;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).coreColors;
    final typography = Theme.of(context).coreTypography;
    final small = typography.bodySmallRegular.copyWith(color: colors.textBody);
    final charge = extraCharge;

    return MergeSemantics(
      child: Semantics(
        liveRegion: true,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.backgroundBlueLight,
            borderRadius: BorderRadius.circular(_radius),
          ),
          child: Padding(
            padding: _padding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(title, style: small),
                _gap,
                SizedBox(
                  height: _amountHeight,
                  child: Text(
                    lineTotal,
                    style: typography.headlineLargeSemiBold.copyWith(
                      color: colors.textHeadline,
                      letterSpacing: _amountLetterSpacing,
                    ),
                  ),
                ),
                if (charge != null) ...[
                  _gap,
                  SizedBox(
                    height: _rowHeight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(charge.label, style: small),
                        Text(charge.amount, style: small),
                      ],
                    ),
                  ),
                ],
                _gap,
                Padding(
                  padding: _dividerPadding,
                  child: CoreDivider(color: colors.lineBlue),
                ),
                _gap,
                SizedBox(
                  height: _rowHeight,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '$estimateName$totalBeforeSuffix',
                          style: small,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: CoreSpacing.space2),
                      Text(
                        totalAfter,
                        style: typography.bodyLargeSemiBold.copyWith(
                          color: colors.textHeadline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
