import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../await_images_extension.dart';
import '../../load_fonts.dart';

void main() {
  setUpAll(() async {
    await loadFonts();
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  final typography = AppTypographyExtension.create();
  final colors = AppColorsExtension.create();

  Widget buildAvatarItem(String name, String letter) {
    return SizedBox(
      width: 100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CoreLetterAvatar(name: name),
          const SizedBox(height: CoreSpacing.space2),
          Text(
            letter,
            style: typography.bodyMediumSemiBold
                .copyWith(color: colors.textDark),
            textAlign: TextAlign.center,
          ),
          Text(
            name,
            style: typography.bodySmallRegular
                .copyWith(color: colors.textBody),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  testWidgets('CoreLetterAvatar Golden Test', (WidgetTester tester) async {
    final letterAvatars = <Widget>[
      buildAvatarItem('Alice', 'A'),
      buildAvatarItem('Bob', 'B'),
      buildAvatarItem('Charlie', 'C'),
      buildAvatarItem('David', 'D'),
      buildAvatarItem('Emma', 'E'),
      buildAvatarItem('Frank', 'F'),
      buildAvatarItem('Grace', 'G'),
      buildAvatarItem('Henry', 'H'),
      buildAvatarItem('Ivy', 'I'),
      buildAvatarItem('Jack', 'J'),
      buildAvatarItem('Kate', 'K'),
      buildAvatarItem('Liam', 'L'),
      buildAvatarItem('Mia', 'M'),
      buildAvatarItem('Noah', 'N'),
      buildAvatarItem('Olivia', 'O'),
      buildAvatarItem('Paul', 'P'),
      buildAvatarItem('Quinn', 'Q'),
      buildAvatarItem('Ryan', 'R'),
      buildAvatarItem('Sophia', 'S'),
      buildAvatarItem('Tom', 'T'),
      buildAvatarItem('Uma', 'U'),
      buildAvatarItem('Victor', 'V'),
      buildAvatarItem('Wendy', 'W'),
      buildAvatarItem('Xavier', 'X'),
      buildAvatarItem('Yara', 'Y'),
      buildAvatarItem('Zoe', 'Z'),
    ];

    final widget = MaterialApp(
      home: Scaffold(
        backgroundColor: colors.pageBackground,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(CoreSpacing.space8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Letter Avatars (A-Z)',
                style: typography.bodyLargeSemiBold
                    .copyWith(color: colors.textDark),
              ),
              const SizedBox(height: CoreSpacing.space6),
              Wrap(
                spacing: CoreSpacing.space6,
                runSpacing: CoreSpacing.space6,
                children: letterAvatars,
              ),
            ],
          ),
        ),
      ),
    );

    await tester.binding.setSurfaceSize(const Size(800, 850));
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await tester.awaitImages();

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/letter_avatar_component.png'),
    );
  });
}
