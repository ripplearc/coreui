import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const Size kDefaultA11yScreenSize = Size(375, 667);

/// Configures the test surface size for accessibility tests and registers
/// tear-down to restore the original surface size after the test.
///
/// Use this at the start of an a11y test so tap target and layout checks
/// run against a consistent viewport. If [screenSize] is omitted,
/// [kDefaultA11yScreenSize] is used.
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

/// Asserts that the widget found by [target] meets accessibility guidelines
/// for tap target size (Android and iOS) and, unless [excludeLabelCheck] is true,
/// has an accessible label.
///
/// Optionally checks text contrast when [includeTextContrast] is true.
/// Fails if [target] does not match exactly one widget or any guideline fails.
Future<void> expectMeetsTapTargetAndLabelGuidelines(
  WidgetTester tester,
  Finder target, {
  bool includeTextContrast = false,
  bool excludeLabelCheck = false,
}) async {
  final semanticsHandle = tester.ensureSemantics();
  try {
    expect(target, findsOneWidget);

    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));

    if (!excludeLabelCheck) {
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    }

    if (includeTextContrast) {
      await expectLater(tester, meetsGuideline(textContrastGuideline));
    }
  } finally {
    semanticsHandle.dispose();
  }
}
