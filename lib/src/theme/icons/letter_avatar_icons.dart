/// Core letter avatar PNG paths
class CoreLetterAvatarPaths {
  static const String _basePath = 'assets/letter_avatars';

  /// Get the letter avatar path for a given letter (A-Z)
  /// [name] should be a full name
  static String getLetterAvatarPath(String name) {
    final uppercaseLetter = name.toUpperCase();
    if (uppercaseLetter.isEmpty) {
      return '$_basePath/R.png';
    }
    
    final charCode = uppercaseLetter[0].codeUnitAt(0);
    if (charCode < 65 || charCode > 90) {
      return '$_basePath/R.png';
    }

    return '$_basePath/${uppercaseLetter[0]}.png';
  }

  /// Letter avatar paths for each letter
  static const String a = '$_basePath/A.png';
  static const String b = '$_basePath/B.png';
  static const String c = '$_basePath/C.png';
  static const String d = '$_basePath/D.png';
  static const String e = '$_basePath/E.png';
  static const String f = '$_basePath/F.png';
  static const String g = '$_basePath/G.png';
  static const String h = '$_basePath/H.png';
  static const String i = '$_basePath/I.png';
  static const String j = '$_basePath/J.png';
  static const String k = '$_basePath/K.png';
  static const String l = '$_basePath/L.png';
  static const String m = '$_basePath/M.png';
  static const String n = '$_basePath/N.png';
  static const String o = '$_basePath/O.png';
  static const String p = '$_basePath/P.png';
  static const String q = '$_basePath/Q.png';
  static const String r = '$_basePath/R.png';
  static const String s = '$_basePath/S.png';
  static const String t = '$_basePath/T.png';
  static const String u = '$_basePath/U.png';
  static const String v = '$_basePath/V.png';
  static const String w = '$_basePath/W.png';
  static const String x = '$_basePath/X.png';
  static const String y = '$_basePath/Y.png';
  static const String z = '$_basePath/Z.png';
}
