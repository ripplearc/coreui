import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/src/constants.dart';

import '../../theme/icons/letter_avatar_icons.dart';

/// A widget that displays a letter avatar PNG based on the first letter of a name.
/// [name] is the name used to determine which letter avatar to display.
/// The letter avatar is determined by the first letter of the name (A-Z).
/// [semanticLabel] is an optional semantic label for accessibility.
class CoreLetterAvatar extends StatelessWidget {
  final String name;
  final String? semanticLabel;

  const CoreLetterAvatar({
    super.key,
    required this.name,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final imagePath = CoreLetterAvatarPaths.getLetterAvatarPath(name);
    final imageWidget = Image.asset(
      imagePath,
      package: CoreConstants.packageName,
      semanticLabel: semanticLabel ?? 'Letter avatar for $name',
    );
    
    return imageWidget;
  }
}
