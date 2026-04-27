import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../load_fonts.dart';

void main() {
  setUpAll(() async {
    await loadFonts();
  });

  Widget buildIconSizeRow(String name, String pixelValue, double size) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              name,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            width: 80,
            child: Text(
              pixelValue,
              style: const TextStyle(fontFamily: 'Roboto', fontSize: 14),
            ),
          ),
          CoreIconWidget(
            icon: CoreIcons.search,
            size: size,
            color: Colors.black87,
          ),
        ],
      ),
    );
  }

  testWidgets('Core Icon Size Tokens Test', (tester) async {
    await tester.binding.setSurfaceSize(const Size(500, 400));

    final widget = MaterialApp(
      theme: ThemeData(
        fontFamily: 'Roboto',
        textTheme: const TextTheme().apply(fontFamily: 'Roboto'),
      ),
      home: Scaffold(
        body: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                color: Colors.grey.shade200,
                child: const Text(
                  'Icon Size System',
                  style: TextStyle(fontSize: 14, fontFamily: 'Roboto'),
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(
                        'Token',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      child: Text(
                        'pixels',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Example',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              buildIconSizeRow('size16', '16px', CoreIconSize.size16),
              buildIconSizeRow('size20', '20px', CoreIconSize.size20),
              buildIconSizeRow('size24', '24px', CoreIconSize.size24),
              buildIconSizeRow('size32', '32px', CoreIconSize.size32),
            ],
          ),
        ),
      ),
    );

    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_icon_size_tokens.png'),
    );
  });
}
