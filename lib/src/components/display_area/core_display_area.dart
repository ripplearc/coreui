import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';

class CoreDisplayArea extends StatelessWidget {
  const CoreDisplayArea({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    return Container(
      height: CoreSpacing.space57_5,
      width: double.infinity,
      decoration: BoxDecoration(
          color: colors.backgroundBlueLight,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(CoreSpacing.space7),
            bottomRight: Radius.circular(CoreSpacing.space7),
          )),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [],
      ),
    );
  }
}
