import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

Widget _wrapWithTheme(Widget child) {
  return MaterialApp(
    theme: CoreTheme.light(),
    home: Scaffold(body: child),
  );
}

void main() {
  setUpAll(() async {
    await loadFonts();
  });

  group('CoreButton Widget Tests', () {
    testWidgets('renders label text when label is provided', (tester) async {
      await tester.pumpWidget(
        _wrapWithTheme(const CoreButton(label: 'Click Me')),
      );

      expect(find.text('Click Me'), findsOneWidget);
    });

    testWidgets('renders custom child widget when child is provided',
        (tester) async {
      await tester.pumpWidget(
        _wrapWithTheme(
          const CoreButton(
            child: Icon(Icons.add, key: Key('custom_child')),
          ),
        ),
      );

      expect(find.byKey(const Key('custom_child')), findsOneWidget);
      expect(find.text('Click Me'), findsNothing);
    });

    testWidgets('prefers child over label when both are provided',
        (tester) async {
      await tester.pumpWidget(
        _wrapWithTheme(
          const CoreButton(
            label: 'fallback',
            child: Icon(Icons.star, key: Key('star_icon')),
          ),
        ),
      );

      expect(find.byKey(const Key('star_icon')), findsOneWidget);
      expect(find.text('fallback'), findsNothing);
    });

    testWidgets('shows a leading icon when icon is provided and trailing=false',
        (tester) async {
      await tester.pumpWidget(
        _wrapWithTheme(
          const CoreButton(
            label: 'With Icon',
            icon: CoreIconWidget(icon: CoreIcons.add),
          ),
        ),
      );

      expect(find.byType(CoreIconWidget), findsOneWidget);
    });

    testWidgets('shows a trailing icon when trailing=true', (tester) async {
      await tester.pumpWidget(
        _wrapWithTheme(
          const CoreButton(
            label: 'With Trailing',
            icon: CoreIconWidget(icon: CoreIcons.arrowRight),
            trailing: true,
          ),
        ),
      );

      expect(find.byType(CoreIconWidget), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped and button is enabled',
        (tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        _wrapWithTheme(
          CoreButton(
            label: 'Tap Me',
            onPressed: () => pressed = true,
          ),
        ),
      );

      await tester.tap(find.byType(CoreButton));
      expect(pressed, isTrue);
    });

    testWidgets('does not call onPressed when isDisabled=true', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        _wrapWithTheme(
          CoreButton(
            label: 'Disabled',
            onPressed: () => pressed = true,
            isDisabled: true,
          ),
        ),
      );

      await tester.tap(find.byType(CoreButton));
      expect(pressed, isFalse);
    });

    testWidgets('does not call onPressed when onPressed is null',
        (tester) async {
      await tester.pumpWidget(
        _wrapWithTheme(
          const CoreButton(label: 'No Callback', onPressed: null),
        ),
      );

      await tester.tap(find.byType(CoreButton));
    });

    testWidgets('expands to full parent width when fullWidth=true',
        (tester) async {
      await tester.pumpWidget(
        _wrapWithTheme(
          const Align(
            alignment: Alignment.topLeft,
            child: CoreButton(label: 'Full', fullWidth: true),
          ),
        ),
      );

      final size = tester.getSize(find.byType(CoreButton));
      expect(size.width, equals(800.0));
    });

    testWidgets('shrinks to content width when fullWidth=false',
        (tester) async {
      await tester.pumpWidget(
        _wrapWithTheme(
          const Align(
            alignment: Alignment.topLeft,
            child: IntrinsicWidth(
              child: CoreButton(label: 'Compact', fullWidth: false),
            ),
          ),
        ),
      );

      final size = tester.getSize(find.byType(CoreButton));
      expect(size.width, lessThan(800.0));
    });

    testWidgets('social variant throws when size is not large', (tester) async {
      final List<FlutterErrorDetails> errors = [];
      final originalOnError = FlutterError.onError;
      addTearDown(() => FlutterError.onError = originalOnError);
      FlutterError.onError = (details) => errors.add(details);
      await tester.pumpWidget(
        _wrapWithTheme(
          const CoreButton(
            label: 'Social Small',
            variant: CoreButtonVariant.social,
            size: CoreButtonSize.small,
          ),
        ),
      );

      FlutterError.onError = FlutterError.presentError;

      expect(
        errors.any((e) => e.exception is ArgumentError),
        isTrue,
        reason: 'Expected an ArgumentError when social variant is not large',
      );
    });
    testWidgets('applies shadows when shadows are provided', (tester) async {
      await tester.pumpWidget(
        _wrapWithTheme(
          CoreButton(
            label: 'With Shadow',
            shadows: CoreShadows.small,
          ),
        ),
      );

      final decoratedBoxes = tester.widgetList<DecoratedBox>(
        find.descendant(
          of: find.byType(CoreButton),
          matching: find.byType(DecoratedBox),
        ),
      );

      expect(decoratedBoxes, isNotEmpty);

      final outerDecoration = decoratedBoxes.first.decoration as BoxDecoration;
      expect(outerDecoration.boxShadow, isNotNull);
      expect(outerDecoration.boxShadow, isNotEmpty);
    });

    testWidgets('has no shadows by default', (tester) async {
      await tester.pumpWidget(
        _wrapWithTheme(const CoreButton(label: 'No Shadow')),
      );

      final decoratedBoxes = tester.widgetList<DecoratedBox>(
        find.descendant(
          of: find.byType(CoreButton),
          matching: find.byType(DecoratedBox),
        ),
      );

      expect(decoratedBoxes, isNotEmpty);

      final outerDecoration = decoratedBoxes.first.decoration as BoxDecoration;
      expect(outerDecoration.boxShadow, isNull);
    });
  });
}
