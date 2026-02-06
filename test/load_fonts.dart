import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Manually loads fonts for golden tests without relying on golden_toolkit.
Future<void> loadFonts() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await loadMaterialIcons();
  final robotoLoader = FontLoader('Roboto')
    ..addFont(rootBundle.load('test/assets/fonts/Roboto-Regular.ttf'))
    ..addFont(rootBundle.load('test/assets/fonts/Roboto-Medium.ttf'))
    ..addFont(rootBundle.load('test/assets/fonts/Roboto-Bold.ttf'));

  await Future.wait([
    robotoLoader.load(),
  ]);
}

Future<void> loadMaterialIcons() async {
  try {
    final iconLoader = FontLoader('MaterialIcons')
      ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
    await iconLoader.load();
  } catch (e) {
    // Fallback to empty font to prevent crashes
    final fallbackLoader = FontLoader('MaterialIcons')
      ..addFont(Future.value(ByteData.view(Uint8List(0).buffer)));
    await fallbackLoader.load();
  }
}