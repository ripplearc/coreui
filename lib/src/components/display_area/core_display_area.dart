import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';

part 'display_area_sections/history_panel/history_chips.dart';
part 'display_area_sections/history_panel/history_panel.dart';

/// A colored display area widget with rounded bottom corners,
/// used to present calculation results at the top of the layout.
class CoreDisplayArea extends StatelessWidget {
  const CoreDisplayArea({
    super.key,
    this.onClose,
    this.closeSemanticLabel = 'Close',
    this.chipsList = const [],
  });

  /// Called when the user taps the close icon.
  final VoidCallback? onClose;

  /// The semantic label announced by screen readers for the close icon.
  /// Defaults to `'Close'`. Pass a localized string from the app layer:
  /// ```dart
  /// closeSemanticLabel: AppLocalizations.of(context).closeButton,
  /// ```
  final String closeSemanticLabel;
  
  /// The list of [CoreCalculatorChip] widgets displayed in the history panel.
  /// Defaults to an empty list when no chips are provided.
  final List<CoreCalculatorChip> chipsList;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    return Container(
      height: CoreSpacing.space57,
      width: double.infinity,
      decoration: BoxDecoration(
          color: colors.backgroundBlueLight,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(CoreSpacing.space7),
            bottomRight: Radius.circular(CoreSpacing.space7),
          )),
      padding: const EdgeInsets.symmetric(horizontal: CoreSpacing.space4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _HistoryPanel(
            onClose: onClose,
            closeSemanticLabel: closeSemanticLabel,
            chipsList: chipsList,
          ),
        ],
      ),
    );
  }
}
