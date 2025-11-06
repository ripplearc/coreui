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

  Widget _buildAvatarItem(Widget avatar, String label) {
    return SizedBox(
      width: 120,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          avatar,
          const SizedBox(height: CoreSpacing.space2),
          Text(
            label,
            style: CoreTypography.bodySmallRegular(color: CoreTextColors.body),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  testWidgets('CoreAvatar Golden Test', (WidgetTester tester) async {
    final avatars = <Widget>[
      _buildAvatarItem(
        const CoreAvatar(
          radius: 20,
          backgroundColor: CoreIconColors.blue,
        ),
        'Small (r=20)',
      ),
      _buildAvatarItem(
        const CoreAvatar(
          radius: 30,
          backgroundColor: CoreIconColors.green,
        ),
        'Medium (r=30)',
      ),
      _buildAvatarItem(
        const CoreAvatar(
          radius: 40,
          backgroundColor: CoreIconColors.orange,
        ),
        'Large (r=40)',
      ),
      _buildAvatarItem(
        const CoreAvatar(
          radius: 30,
          backgroundColor: CoreIconColors.blue,
          child: CoreIconWidget(
            icon: CoreIcons.person,
            color: CoreIconColors.white,
            size: 24,
          ),
        ),
        'With Icon',
      ),
      _buildAvatarItem(
        const CoreAvatar(
          minRadius: 20,
          maxRadius: 30,
          backgroundColor: CoreIconColors.red,
        ),
        'Min/Max Radius',
      ),
      _buildAvatarItem(
        const CoreAvatar(
          radius: 30,
          child: CoreLetterAvatar(name: 'John Doe'),
        ),
        'With Letter Avatar',
      ),
    ];

    final widget = MaterialApp(
      home: Scaffold(
        backgroundColor: CoreBackgroundColors.pageBackground,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(CoreSpacing.space8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Core Avatar Variants',
                style: CoreTypography.bodyLargeSemiBold(color: CoreTextColors.dark),
              ),
              const SizedBox(height: CoreSpacing.space6),
              Wrap(
                spacing: CoreSpacing.space6,
                runSpacing: CoreSpacing.space6,
                children: avatars,
              ),
            ],
          ),
        ),
      ),
    );

    await tester.binding.setSurfaceSize(const Size(940, 220));
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await tester.awaitImages();

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/core_avatar_component.png'),
    );
  });
}

