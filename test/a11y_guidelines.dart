import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const Size kDefaultA11yScreenSize = Size(375, 667);

Future<void> setupA11yTest(
  WidgetTester tester, {
  Size? screenSize,
}) async {
  final size = screenSize ?? kDefaultA11yScreenSize;
  await tester.binding.setSurfaceSize(size);

  addTearDown(() async {
    await tester.binding.setSurfaceSize(null);
  });
}

Future<void> expectMeetsTapTargetAndLabelGuidelines(
  WidgetTester tester,
  Finder target, {
  bool includeTextContrast = false,
  bool skipLabelCheck = false,
}) async {
  final semanticsHandle = tester.ensureSemantics();
  try {
    expect(target, findsOneWidget);

    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));

    if (!skipLabelCheck) {
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    }

    if (includeTextContrast) {
      await expectLater(tester, meetsGuideline(textContrastGuideline));
    }
  } finally {
    semanticsHandle.dispose();
  }
}
