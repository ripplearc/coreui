import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

/// The dots take their colour from the theme and meet 3:1 on the display
/// area's background in both themes (CA-1488, WCAG 1.4.11).
void main() {
  const paintedDotsKey = Key('painted_dots');

  setUpAll(() async {
    await loadFonts();
  });

  double contrast(Color a, Color b) {
    final la = a.computeLuminance();
    final lb = b.computeLuminance();
    final lighter = la > lb ? la : lb;
    final darker = la > lb ? lb : la;
    return (lighter + 0.05) / (darker + 0.05);
  }

  int channel(double value) => (value * 255).round();

  Future<void> pumpDots(
    WidgetTester tester, {
    required ThemeData theme,
    Color? color,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: Center(
          child: RepaintBoundary(
            key: paintedDotsKey,
            child: CoreWritingDots(size: CoreSpacing.space10, color: color),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));
  }

  Future<List<(int, int, int, int)>> paintedPixels(WidgetTester tester) async {
    final boundary = tester.renderObject<RenderRepaintBoundary>(
      find.byKey(paintedDotsKey),
    );
    final ByteData bytes = (await tester.runAsync<ByteData>(() async {
      final image = await boundary.toImage();
      final data = await image.toByteData();
      image.dispose();
      return data!;
    }))!;
    return [
      for (var i = 0; i < bytes.lengthInBytes; i += 4)
        if (bytes.getUint8(i + 3) > 0)
          (
            bytes.getUint8(i),
            bytes.getUint8(i + 1),
            bytes.getUint8(i + 2),
            bytes.getUint8(i + 3),
          ),
    ];
  }

  (int, int, int, int) opaque(Color color) =>
      (channel(color.r), channel(color.g), channel(color.b), 255);

  for (final (name, theme) in [
    ('light', CoreTheme.light()),
    ('dark', CoreTheme.dark()),
  ]) {
    testWidgets(
        'in the $name theme the dots are painted in iconDark, at least 3:1 '
        'on the display area background', (tester) async {
      await pumpDots(tester, theme: theme);

      final colors = theme.coreColors;
      final pixels = await paintedPixels(tester);
      expect(pixels, contains(opaque(colors.iconDark)));
      expect(
        pixels.where((pixel) => pixel.$4 == 255),
        everyElement(opaque(colors.iconDark)),
        reason: 'every dot is recoloured, not only the first',
      );
      expect(contrast(colors.iconDark, colors.backgroundBlueLight),
          greaterThanOrEqualTo(3));
    });
  }

  test(
      'in the light theme the token is the colour the animation file '
      'always had, so the light dots do not change', () {
    final file = File('assets/animations/writing_dots.json');
    final shapes = (jsonDecode(file.readAsStringSync())
        as Map<String, dynamic>)['layers'][0]['shapes'] as List<dynamic>;
    final fileColour = shapes
        .expand((shape) => (shape as Map<String, dynamic>)['it'] as List)
        .cast<Map<String, dynamic>>()
        .firstWhere((item) => item['ty'] == 'fl')['c']['k'] as List<dynamic>;
    final token = CoreTheme.light().coreColors.iconDark;

    expect(
      [channel(token.r), channel(token.g), channel(token.b)],
      [for (final part in fileColour.take(3)) channel(part as double)],
    );
  });

  testWidgets('a colour passed in wins over the token', (tester) async {
    final passedIn = CoreTheme.light().coreColors.textSuccess;
    await pumpDots(tester, theme: CoreTheme.light(), color: passedIn);

    final pixels = await paintedPixels(tester);
    expect(pixels, contains(opaque(passedIn)));
    expect(
        pixels, isNot(contains(opaque(CoreTheme.light().coreColors.iconDark))));
  });

  testWidgets(
      'a colour that is 40% opaque paints dots that are 40% opaque, '
      'not solid ones', (tester) async {
    final faded = CoreTheme.light().coreColors.iconDark.withValues(alpha: 0.4);
    await pumpDots(tester, theme: CoreTheme.light(), color: faded);

    final strongest = (await paintedPixels(tester))
        .map((pixel) => pixel.$4)
        .reduce((a, b) => a > b ? a : b);
    expect(strongest, closeTo(channel(0.4), 1));
  });

  testWidgets('a fully see-through colour paints no dots', (tester) async {
    final unseen = CoreTheme.light().coreColors.iconDark.withValues(alpha: 0);
    await pumpDots(tester, theme: CoreTheme.light(), color: unseen);

    expect(tester.takeException(), isNull);
    expect(await paintedPixels(tester), isEmpty);
  });

  for (final (name, theme, fallback) in [
    ('light', ThemeData.light(), AppColorsExtension.create()),
    ('dark', ThemeData.dark(), AppColorsExtension.createDark()),
  ]) {
    testWidgets(
        'under a plain $name theme without the CoreUI colours the dots take '
        'the iconDark of the $name CoreUI colours', (tester) async {
      await pumpDots(tester, theme: theme);

      expect(await paintedPixels(tester), contains(opaque(fallback.iconDark)));
    });
  }

  test(
      'the three fills in the animation file are named, which the key path '
      'that recolours them needs', () {
    final file = File('assets/animations/writing_dots.json');
    final shapes = (jsonDecode(file.readAsStringSync())
        as Map<String, dynamic>)['layers'][0]['shapes'] as List<dynamic>;
    final fills = shapes
        .expand((shape) => (shape as Map<String, dynamic>)['it'] as List)
        .cast<Map<String, dynamic>>()
        .where((item) => item['ty'] == 'fl');
    expect(fills.length, 3);
    expect(fills.map((fill) => fill['nm']), everyElement('Fill'));
  });

  testWidgets('the dots carry one colour and one opacity for the fills',
      (tester) async {
    await pumpDots(tester, theme: CoreTheme.dark());

    final lottie = tester.widget<Lottie>(find.byType(Lottie));
    final values = lottie.delegates!.values!;
    expect(values.whereType<ValueDelegate<Color>>().single.value,
        CoreTheme.dark().coreColors.iconDark);
    expect(values.whereType<ValueDelegate<int>>().single.value, 100);
  });
}
