import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Manually loads fonts for golden tests without relying on golden_toolkit.
Future<void> loadFonts() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  final robotoLoader = FontLoader('Roboto')
    ..addFont(rootBundle.load('test/assets/fonts/Roboto-Regular.ttf'))
    ..addFont(rootBundle.load('test/assets/fonts/Roboto-Medium.ttf'))
    ..addFont(rootBundle.load('test/assets/fonts/Roboto-Bold.ttf'));

  await Future.wait([
    robotoLoader.load(),
  ]);
}
