import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/pixel_reader.dart';
import '../../utils/test_harness.dart';

void main() {
  const messageText = 'Could not load your rates';
  const actionText = 'Try again';

  Text messageWidget(WidgetTester tester) =>
      tester.widget<Text>(find.text(messageText));

  testWidgets('shows the message in bodySmallRegular and the error colour',
      (tester) async {
    final theme = CoreTheme.light();
    await tester.pumpWidget(
      buildTestApp(const CoreInlineErrorRow(message: messageText),
          theme: theme),
    );

    final style = messageWidget(tester).style!;
    expect(style.color, theme.coreColors.textError);
    expect(style.fontSize, theme.coreTypography.bodySmallRegular.fontSize);
    expect(style.fontWeight, theme.coreTypography.bodySmallRegular.fontWeight);
  });

  testWidgets('draws the error icon at 16 dp in the iconRed colour',
      (tester) async {
    final theme = CoreTheme.dark();
    await tester.pumpWidget(
      buildTestApp(const CoreInlineErrorRow(message: messageText),
          theme: theme),
    );

    final icon = tester.widget<CoreIconWidget>(find.byType(CoreIconWidget));
    expect(icon.icon, CoreIcons.error);
    expect(icon.size, CoreIconSize.size16);
    expect(icon.color, theme.coreColors.iconRed);
  });

  testWidgets('puts 8 dp between the icon and the message', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        const CoreInlineErrorRow(message: messageText),
        theme: CoreTheme.light(),
      ),
    );

    final iconRight = tester.getTopRight(find.byType(CoreIconWidget)).dx;
    final textLeft = tester.getTopLeft(find.text(messageText)).dx;
    expect(textLeft - iconRight, CoreSpacing.space2);
  });

  testWidgets('shows no action when none is given', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        const CoreInlineErrorRow(message: messageText),
        theme: CoreTheme.light(),
      ),
    );

    expect(find.text(actionText), findsNothing);
  });

  testWidgets('shows the action in bodyLargeSemiBold and textLink',
      (tester) async {
    final theme = CoreTheme.light();
    await tester.pumpWidget(
      buildTestApp(
        CoreInlineErrorRow(
          message: messageText,
          actionLabel: actionText,
          onAction: () {},
        ),
        theme: theme,
      ),
    );

    final style = tester.widget<Text>(find.text(actionText)).style!;
    expect(style.color, theme.coreColors.textLink);
    expect(style.fontWeight, theme.coreTypography.bodyLargeSemiBold.fontWeight);
    expect(style.fontSize, theme.coreTypography.bodyLargeSemiBold.fontSize);
  });

  testWidgets('calls onAction once per tap on the action', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      buildTestApp(
        CoreInlineErrorRow(
          message: messageText,
          actionLabel: actionText,
          onAction: () => taps++,
        ),
        theme: CoreTheme.light(),
      ),
    );

    await tester.tap(find.text(actionText));
    expect(taps, 1);
    await tester.tap(find.text(actionText));
    expect(taps, 2);
  });

  testWidgets('actionKey finds the action and a tap on it calls onAction',
      (tester) async {
    const actionKey = Key('retry');
    var taps = 0;
    await tester.pumpWidget(
      buildTestApp(
        CoreInlineErrorRow(
          message: messageText,
          actionLabel: actionText,
          onAction: () => taps++,
          actionKey: actionKey,
        ),
        theme: CoreTheme.light(),
      ),
    );

    await tester.tap(find.byKey(actionKey));
    expect(taps, 1);
  });

  testWidgets('a tap on the message does not call onAction', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      buildTestApp(
        CoreInlineErrorRow(
          message: messageText,
          actionLabel: actionText,
          onAction: () => taps++,
        ),
        theme: CoreTheme.light(),
      ),
    );

    await tester.tap(find.text(messageText));
    expect(taps, 0);
  });

  testWidgets('the action tap zone is at least 48 x 48 dp', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        CoreInlineErrorRow(
          message: messageText,
          actionLabel: actionText,
          onAction: () {},
          actionKey: const Key('retry'),
        ),
        theme: CoreTheme.light(),
      ),
    );

    final zone = tester.getSize(find.byKey(const Key('retry')));
    expect(zone.width, greaterThanOrEqualTo(CoreSpacing.space12));
    expect(zone.height, greaterThanOrEqualTo(CoreSpacing.space12));
  });

  testWidgets('a short action label still gets a 48 dp wide zone',
      (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        CoreInlineErrorRow(
          message: messageText,
          actionLabel: 'OK',
          onAction: () {},
          actionKey: const Key('retry'),
        ),
        theme: CoreTheme.light(),
      ),
    );

    expect(
      tester.getSize(find.byKey(const Key('retry'))).width,
      CoreSpacing.space12,
    );
  });

  testWidgets('a tap inside the zone beside a short label calls onAction',
      (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      buildTestApp(
        CoreInlineErrorRow(
          message: messageText,
          actionLabel: 'OK',
          onAction: () => taps++,
          actionKey: const Key('retry'),
        ),
        theme: CoreTheme.light(),
      ),
    );

    final zone = tester.getRect(find.byKey(const Key('retry')));
    await tester.tapAt(zone.topLeft + const Offset(2, 2));
    expect(taps, 1);
  });

  testWidgets('keeps its own height under a parent with loose height',
      (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        const Align(
          alignment: Alignment.topLeft,
          child: CoreInlineErrorRow(message: messageText),
        ),
        theme: CoreTheme.light(),
      ),
    );
    final withoutAction = tester.getSize(find.byType(CoreInlineErrorRow));

    await tester.pumpWidget(
      buildTestApp(
        Align(
          alignment: Alignment.topLeft,
          child: CoreInlineErrorRow(
            message: messageText,
            actionLabel: actionText,
            onAction: () {},
          ),
        ),
        theme: CoreTheme.light(),
      ),
    );
    final withAction = tester.getSize(find.byType(CoreInlineErrorRow));

    expect(withoutAction.height, lessThan(CoreSpacing.space12));
    expect(withAction.height, CoreSpacing.space12);
  });

  testWidgets(
      'puts the icon on the start side and the action at the end in '
      'right-to-left', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        Directionality(
          textDirection: TextDirection.rtl,
          child: SizedBox(
            width: 320,
            child: CoreInlineErrorRow(
              message: messageText,
              actionLabel: actionText,
              onAction: () {},
            ),
          ),
        ),
        theme: CoreTheme.light(),
      ),
    );

    final icon = tester.getCenter(find.byType(CoreIconWidget)).dx;
    final message = tester.getCenter(find.text(messageText)).dx;
    final action = tester.getCenter(find.text(actionText)).dx;
    expect(icon, greaterThan(message));
    expect(message, greaterThan(action));
  });

  testWidgets(
      'keeps half the row less the gap for the message at twice the text '
      'size on a narrow row', (tester) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: buildTestApp(
          SizedBox(
            width: 320,
            child: CoreInlineErrorRow(
              message: 'Could not open your saved prices.',
              actionLabel: actionText,
              onAction: () {},
              actionKey: const Key('retry'),
            ),
          ),
          theme: CoreTheme.light(),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(
      tester.getSize(find.text('Could not open your saved prices.')).width,
      greaterThanOrEqualTo(
        320 / 2 - CoreSpacing.space3 - CoreSpacing.space2 - CoreIconSize.size16,
      ),
    );
  });

  testWidgets(
      'a tap on the last 2 dp of the zone at the row end calls onAction',
      (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      buildTestApp(
        SizedBox(
          width: 320,
          child: CoreInlineErrorRow(
            message: messageText,
            actionLabel: actionText,
            onAction: () => taps++,
            actionKey: const Key('retry'),
          ),
        ),
        theme: CoreTheme.light(),
      ),
    );

    final row = tester.getRect(find.byType(CoreInlineErrorRow));
    final zone = tester.getRect(find.byKey(const Key('retry')));
    expect(zone.right, row.right);
    await tester.tapAt(Offset(zone.right - 2, zone.center.dy));
    expect(taps, 1);
  });

  testWidgets(
      'in right-to-left a tap on the last 2 dp of the zone at the row '
      'end calls onAction', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      buildTestApp(
        Directionality(
          textDirection: TextDirection.rtl,
          child: SizedBox(
            width: 320,
            child: CoreInlineErrorRow(
              message: messageText,
              actionLabel: actionText,
              onAction: () => taps++,
              actionKey: const Key('retry'),
            ),
          ),
        ),
        theme: CoreTheme.light(),
      ),
    );

    final zone = tester.getRect(find.byKey(const Key('retry')));
    await tester.tapAt(Offset(zone.left + 2, zone.center.dy));
    expect(taps, 1);
  });

  testWidgets('the action label ends at the row edge', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        SizedBox(
          width: 320,
          child: CoreInlineErrorRow(
            message: messageText,
            actionLabel: actionText,
            onAction: () {},
          ),
        ),
        theme: CoreTheme.light(),
      ),
    );

    final row = tester.getRect(find.byType(CoreInlineErrorRow));
    final label = tester.getRect(find.text(actionText));
    expect(label.right, row.right);
  });

  testWidgets('in right-to-left the action label starts at the row edge',
      (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        Directionality(
          textDirection: TextDirection.rtl,
          child: SizedBox(
            width: 320,
            child: CoreInlineErrorRow(
              message: messageText,
              actionLabel: actionText,
              onAction: () {},
            ),
          ),
        ),
        theme: CoreTheme.light(),
      ),
    );

    final row = tester.getRect(find.byType(CoreInlineErrorRow));
    final label = tester.getRect(find.text(actionText));
    expect(label.left, row.left);
  });

  testWidgets('a long action label is capped at exactly half the row',
      (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        SizedBox(
          width: 320,
          child: CoreInlineErrorRow(
            message: messageText,
            actionLabel: 'Try this again right now over the other connection',
            onAction: () {},
            actionKey: const Key('retry'),
          ),
        ),
        theme: CoreTheme.light(),
      ),
    );

    expect(tester.getSize(find.byKey(const Key('retry'))).width, 160);
  });

  testWidgets('wraps without overflow at twice the text size', (tester) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: buildTestApp(
          SizedBox(
            width: 320,
            child: CoreInlineErrorRow(
              message: messageText,
              actionLabel: actionText,
              onAction: () {},
            ),
          ),
          theme: CoreTheme.light(),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('a one-line message has its icon centred on the line',
      (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        const CoreInlineErrorRow(message: messageText),
        theme: CoreTheme.light(),
      ),
    );

    expect(
      tester.getCenter(find.byType(CoreIconWidget)).dy,
      tester.getCenter(find.text(messageText)).dy,
    );
  });

  testWidgets(
      'a long message wraps and the icon stays centred on its first line',
      (tester) async {
    const longMessage =
        'Could not load your rates because the connection dropped twice in '
        'a row, so please check it and try once more';
    await tester.pumpWidget(
      buildTestApp(
        const SizedBox(
          width: 200,
          child: CoreInlineErrorRow(message: longMessage),
        ),
        theme: CoreTheme.light(),
      ),
    );

    final text = tester.getRect(find.text(longMessage));
    final icon = tester.getRect(find.byType(CoreIconWidget));
    expect(text.height, greaterThan(40));
    expect(icon.center.dy, text.top + 8);
  });

  for (final scale in [1.3, 2.0]) {
    testWidgets(
        'at ${scale}x text the icon stays centred on the first line of a '
        'wrapped message', (tester) async {
      const longMessage =
          'Could not load your rates because the connection dropped twice in '
          'a row, so please check it and try once more';
      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(scale)),
          child: buildTestApp(
            const SizedBox(
              width: 200,
              child: CoreInlineErrorRow(message: longMessage),
            ),
            theme: CoreTheme.light(),
          ),
        ),
      );

      final text = tester.getRect(find.text(longMessage));
      final icon = tester.getRect(find.byType(CoreIconWidget));
      final style = CoreTheme.light().coreTypography.bodySmallRegular;
      final lineHeight = scale * style.fontSize! * style.height!;
      expect(text.height, greaterThan(lineHeight));
      expect(icon.center.dy, closeTo(text.top + lineHeight / 2, 0.5));
    });
  }

  testWidgets('keeps 12 dp between the message and the action', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        SizedBox(
          width: 320,
          child: CoreInlineErrorRow(
            message: 'x' * 400,
            actionLabel: actionText,
            onAction: () {},
            actionKey: const Key('retry'),
          ),
        ),
        theme: CoreTheme.light(),
      ),
    );

    final message = tester.getRect(find.text('x' * 400));
    final zone = tester.getRect(find.byKey(const Key('retry')));
    expect(zone.left - message.right, CoreSpacing.space3);
  });

  test('rejects an action label without a callback', () {
    expect(
      () => CoreInlineErrorRow(message: messageText, actionLabel: actionText),
      throwsAssertionError,
    );
  });

  test('rejects a callback without an action label', () {
    expect(
      () => CoreInlineErrorRow(message: messageText, onAction: () {}),
      throwsAssertionError,
    );
  });

  testWidgets('announces the message as one live region, with no other label',
      (tester) async {
    final handle = tester.ensureSemantics();
    try {
      await tester.pumpWidget(
        buildTestApp(
          const CoreInlineErrorRow(message: messageText),
          theme: CoreTheme.light(),
        ),
      );

      final node = tester.getSemantics(find.bySemanticsLabel(messageText));
      expect(node.getSemanticsData().flagsCollection.isLiveRegion, isTrue);
      expect(
        find.semantics.byPredicate(
          (n) => n.getSemanticsData().label.isNotEmpty,
          describeMatch: (plurality) => 'labelled nodes',
        ),
        findsOneWidget,
      );
    } finally {
      handle.dispose();
    }
  });

  testWidgets(
      'the action is a separate labelled button outside the live region',
      (tester) async {
    final handle = tester.ensureSemantics();
    try {
      await tester.pumpWidget(
        buildTestApp(
          CoreInlineErrorRow(
            message: messageText,
            actionLabel: actionText,
            onAction: () {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      final action = tester.getSemantics(find.bySemanticsLabel(actionText));
      final data = action.getSemanticsData();
      expect(data.flagsCollection.isButton, isTrue);
      expect(data.flagsCollection.isLiveRegion, isFalse);
      expect(data.hasAction(SemanticsAction.tap), isTrue);
    } finally {
      handle.dispose();
    }
  });

  group('keyboard and press', () {
    const actionKey = Key('retry');
    const boundaryKey = Key('boundary');

    Widget row(ThemeData theme, VoidCallback onAction) => buildTestApp(
          RepaintBoundary(
            key: boundaryKey,
            child: ColoredBox(
              color: theme.coreColors.pageBackground,
              child: CoreInlineErrorRow(
                message: messageText,
                actionLabel: actionText,
                onAction: onAction,
                actionKey: actionKey,
              ),
            ),
          ),
          theme: theme,
        );

    testWidgets('Tab then Enter calls onAction once', (tester) async {
      var taps = 0;
      await tester.pumpWidget(row(CoreTheme.light(), () => taps++));

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();

      expect(taps, 1);
    });

    testWidgets('Tab then Space calls onAction once', (tester) async {
      var taps = 0;
      await tester.pumpWidget(row(CoreTheme.light(), () => taps++));

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();

      expect(taps, 1);
    });

    testWidgets(
        'Tab draws a 3 dp outlineFocus stadium ring 12 dp from the label '
        'and moves nothing', (tester) async {
      final theme = CoreTheme.light();
      const ringKey = Key('inline_error_action_focus_ring');
      await tester.pumpWidget(row(theme, () {}));
      final restSize = tester.getSize(find.byKey(actionKey));
      final restText = tester.getTopLeft(find.text(actionText));
      expect(find.byKey(ringKey), findsNothing);

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();

      final label = tester.getRect(find.text(actionText));
      final ring = tester.getRect(find.byKey(ringKey));
      expect(ring.left, label.left - CoreSpacing.space3);
      expect(ring.right, label.right + CoreSpacing.space3);
      expect(ring.top, label.top - 5);
      expect(ring.bottom, label.bottom + 5);
      final shape = tester
          .widget<DecoratedBox>(
            find.descendant(
              of: find.byKey(ringKey),
              matching: find.byType(DecoratedBox),
            ),
          )
          .decoration as ShapeDecoration;
      final border = shape.shape as StadiumBorder;
      expect(border.side.color, theme.coreColors.outlineFocus);
      expect(border.side.width, 3);
      expect(
        await pixelAt(
          tester,
          find.byKey(boundaryKey),
          Offset(ring.center.dx, ring.top + 1),
        ),
        theme.coreColors.outlineFocus.toARGB32(),
      );
      expect(tester.getSize(find.byKey(actionKey)), restSize);
      expect(tester.getTopLeft(find.text(actionText)), restText);
    });

    testWidgets('a touch tap draws no ring', (tester) async {
      await tester.pumpWidget(row(CoreTheme.light(), () {}));

      await tester.tap(find.byKey(actionKey));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('inline_error_action_focus_ring')),
        findsNothing,
      );
    });

    testWidgets(
        'pressed, the label turns buttonPress with no fill and returns '
        'to textLink on release', (tester) async {
      final theme = CoreTheme.light();
      await tester.pumpWidget(row(theme, () {}));
      final zone = tester.getRect(find.byKey(actionKey));
      Color? labelColor() =>
          tester.widget<Text>(find.text(actionText)).style!.color;
      expect(labelColor(), theme.coreColors.textLink);

      final gesture = await tester.startGesture(zone.center);
      await tester.pump();
      expect(labelColor(), theme.coreColors.buttonPress);
      expect(
        await pixelAt(
          tester,
          find.byKey(boundaryKey),
          zone.topLeft + const Offset(10, 5),
        ),
        theme.coreColors.pageBackground.toARGB32(),
      );

      await gesture.up();
      await tester.pump();
      expect(labelColor(), theme.coreColors.textLink);
    });
  });
}
