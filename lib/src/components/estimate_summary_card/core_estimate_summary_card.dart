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
/// card never formats money. Its padding, radius and gaps are Figma's own
/// measurements; none of them is a CoreSpacing step. The amount and the rows
/// grow with the text size rather than clip. On a narrow card the new total
/// takes at most half the totals row and the " total … →" suffix most of the
/// rest, so a long estimate name ellipsises but keeps its first letters, and
/// the amounts shrink rather than clip.
///
/// [CoreEstimateSummaryCard.empty] is the card before the line can total: a
/// dash in place of the amount and a [note] naming the missing field in place
/// of the totals row.
///
/// The grey "before" text and the dash use `textBody`, not Figma's
/// `textDisable`, which is 2.4:1 on the blue fill in light and 2.6:1 in dark.
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

  /// What the line adds to the estimate, e.g. "$605.00". Null on an empty card.
  final String? lineTotal;

  /// A charge already counted in [lineTotal], shown in its own row.
  final CoreEstimateSummaryCharge? extraCharge;

  /// The estimate the line is added to, e.g. "Bedroom 2". Ellipsised first
  /// when the totals row runs out of room.
  final String? estimateName;

  /// The text after [estimateName], e.g. " total  $2,993.62 →".
  final String? totalBeforeSuffix;

  /// The estimate's total once the line is added, e.g. "$3,598.62".
  final String? totalAfter;

  /// Why there is no total yet, e.g. "Needs a rate before it can total".
  final String? note;

  /// Shown in place of the amount by [CoreEstimateSummaryCard.empty].
  static const String emptyAmount = '—';

  const CoreEstimateSummaryCard({
    super.key,
    required this.title,
    required String this.lineTotal,
    this.extraCharge,
    required String this.estimateName,
    required String this.totalBeforeSuffix,
    required String this.totalAfter,
  }) : note = null;

  const CoreEstimateSummaryCard.empty({
    super.key,
    required this.title,
    required String this.note,
  })  : lineTotal = null,
        extraCharge = null,
        estimateName = null,
        totalBeforeSuffix = null,
        totalAfter = null;

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
    final note = this.note;
    final silentDash = ExcludeSemantics(
      child: Text(
        emptyAmount,
        style: typography.titleLargeSemiBold.copyWith(color: colors.textBody),
      ),
    );

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
                ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: _amountHeight),
                  child: Align(
                    alignment: lineTotal == null
                        ? Alignment.centerLeft
                        : Alignment.topLeft,
                    child: switch (lineTotal) {
                      final total? => FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            total,
                            style: typography.headlineLargeSemiBold.copyWith(
                              color: colors.textHeadline,
                              letterSpacing: _amountLetterSpacing,
                            ),
                          ),
                        ),
                      null => silentDash,
                    },
                  ),
                ),
                if (charge != null) ...[
                  _gap,
                  ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: _rowHeight),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            charge.label,
                            style: small,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: CoreSpacing.space2),
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
                if ((estimateName, totalBeforeSuffix, totalAfter)
                    case (final name?, final before?, final after?))
                  ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: _rowHeight),
                    child: _TotalsRow(
                      estimateName: name,
                      totalBeforeSuffix: before,
                      totalAfter: after,
                      beforeStyle: small,
                      afterStyle: typography.bodyLargeSemiBold.copyWith(
                        color: colors.textHeadline,
                      ),
                    ),
                  )
                else if (note != null)
                  Text(note, style: small),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TotalsRow extends StatelessWidget {
  final String estimateName;
  final String totalBeforeSuffix;
  final String totalAfter;
  final TextStyle beforeStyle;
  final TextStyle afterStyle;

  const _TotalsRow({
    required this.estimateName,
    required this.totalBeforeSuffix,
    required this.totalAfter,
    required this.beforeStyle,
    required this.afterStyle,
  });

  static const _afterMaxWidthFactor = 0.5;
  static const _suffixMaxWidthFactor = 0.7;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, row) => Row(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, before) => Row(
                children: [
                  Flexible(
                    child: Text(
                      estimateName,
                      style: beforeStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _ShrinkToFit(
                    maxWidth: before.maxWidth * _suffixMaxWidthFactor,
                    child: Text(totalBeforeSuffix, style: beforeStyle),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: CoreSpacing.space2),
          _ShrinkToFit(
            maxWidth: row.maxWidth * _afterMaxWidthFactor,
            child: Text(totalAfter, style: afterStyle),
          ),
        ],
      ),
    );
  }
}

class _ShrinkToFit extends StatelessWidget {
  final double maxWidth;
  final Widget child;

  const _ShrinkToFit({required this.maxWidth, required this.child});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: FittedBox(fit: BoxFit.scaleDown, child: child),
    );
  }
}
