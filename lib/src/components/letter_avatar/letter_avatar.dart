import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/src/constants.dart';

import '../../theme/icons/letter_avatar_icons.dart';

/// A widget that displays a letter avatar PNG based on the first letter of a name.
class CoreLetterAvatar extends StatelessWidget {
  /// Name whose first letter, A to Z in any case, picks the image. An empty
  /// name or one starting with another character shows the R avatar.
  final String name;

  /// Screen-reader label. When null the reader announces the English
  /// "Letter avatar for" and [name].
  final String? semanticLabel;

  /// Creates a square avatar that fills the width it is given.
  const CoreLetterAvatar({
    super.key,
    required this.name,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final imagePath = CoreLetterAvatarPaths.getLetterAvatarPath(name);
    return Semantics(
      label: semanticLabel ?? 'Letter avatar for $name',
      image: true,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath, package: CoreConstants.packageName),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
