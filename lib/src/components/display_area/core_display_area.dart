import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';

part 'display_area_sections/history_panel/history_panel.dart';

/// A colored display area widget with rounded bottom corners,
/// used to present calculation results at the top of the layout.
class CoreDisplayArea extends StatelessWidget {
  const CoreDisplayArea({super.key, this.onClose});

  /// Called when the user taps the close icon.
  final VoidCallback? onClose;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _HistoryPanel(
            onClose: onClose,
          ),
          const Spacer()
        ],
      ),
    );
  }
}
