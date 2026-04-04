import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';

/// A colored display area widget with rounded bottom corners,
/// used to present calculation results at the top of the layout.
class CoreDisplayArea extends StatelessWidget {
  const CoreDisplayArea({super.key});

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
    );
  }
}
