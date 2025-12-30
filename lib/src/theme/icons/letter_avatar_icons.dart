/// Core letter avatar PNG paths
class CoreLetterAvatarPaths {
  static const String _basePath = 'assets/letter_avatars';
  static const String imageExtension = 'webp';

  /// Get the letter avatar path for a given letter (A-Z)
  /// [name] should be a full name
  static String getLetterAvatarPath(String name) {
    final uppercaseLetter = name.toUpperCase();
    if (uppercaseLetter.isEmpty) {
      return '$_basePath/R.$imageExtension';
    }
    
    final charCode = uppercaseLetter[0].codeUnitAt(0);
    if (charCode < 65 || charCode > 90) {
      return '$_basePath/R.$imageExtension';
    }

    return '$_basePath/${uppercaseLetter[0]}.$imageExtension';
  }

  /// Letter avatar paths for each letter (A-Z)
  static final List<String> letterPaths = List.generate(
    26,
    (index) => '$_basePath/${String.fromCharCode(65 + index)}.$imageExtension',
  );
}
