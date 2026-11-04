// File: test/components/navigation/core_bottom_nav_bar_test.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';
import '../../utils/a11y_guidelines.dart';

const _tabs = <BottomNavTab>[
  BottomNavTab(icon: CoreIcons.home, label: 'Home'),
  BottomNavTab(icon: CoreIcons.calculate, label: 'Calculations'),
  BottomNavTab(icon: CoreIcons.cost, label: 'Estimation'),
  BottomNavTab(icon: CoreIcons.members, label: 'Members'),
];

const _tabs2 = <BottomNavTab>[
  BottomNavTab(icon: CoreIcons.calculation, label: 'Calculations'),
  BottomNavTab(icon: CoreIcons.cost, label: 'Estimates'),
];

class _Harness extends StatelessWidget {
  const _Harness({
    required this.child,
  });

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: CoreTheme.light(),
      home: Scaffold(
        body: Center(
          child: child,
        ),
      ),
    );
  }
}

Future<void> _mount(
  WidgetTester tester, {
  required int selectedIndex,
  List<BottomNavTab> tabs = _tabs,
  VoidCallback? onAction,
  ValueChanged<int>? onTabSelected,
  String? actionButtonSemanticLabel,
}) async {
  await tester.pumpWidget(
    _Harness(
      child: CoreBottomNavBar(
        tabs: tabs,
        selectedIndex: selectedIndex,
        onTabSelected: onTabSelected ?? (_) {},
        onActionButtonPressed: onAction,
        actionButtonSemanticLabel: actionButtonSemanticLabel,
      ),
    ),
  );
  await tester.pump();
}

void main() {
  setUpAll(() async {
    try {
      await loadFonts();
    } catch (_) {}
    // The tab label asks for the package font; without it the test draws
    // square glyphs, so label widths would not match a real phone.
    await (FontLoader('packages/ripplearc_coreui/Roboto')
          ..addFont(rootBundle.load('test/assets/fonts/Roboto-Medium.ttf')))
        .load();
  });

  group('CoreBottomNavBar – API contract', () {
    test('asserts on fewer than 2 tabs', () {
      expect(
        () => CoreBottomNavBar(
          tabs: const [BottomNavTab(icon: CoreIcons.home, label: 'Home')],
          selectedIndex: 0,
          onTabSelected: (_) {},
        ),
        throwsAssertionError,
      );
    });

    test('asserts on more than 4 tabs', () {
      expect(
        () => CoreBottomNavBar(
          tabs: List.filled(
            5,
            const BottomNavTab(icon: CoreIcons.home, label: 'Home'),
          ),
          selectedIndex: 0,
          onTabSelected: (_) {},
        ),
        throwsAssertionError,
      );
    });
  });

  group('CoreBottomNavBar – rendering', () {
    testWidgets('renders with CoreTheme.light() and shows only active label', (tester) async {
      await _mount(tester, selectedIndex: 0);

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Calculations'), findsNothing);
      expect(find.text('Estimation'), findsNothing);
      expect(find.text('Members'), findsNothing);
    });

    testWidgets('renders 4 tabs + trailing action button', (tester) async {
      await _mount(tester, selectedIndex: 0);

      expect(find.byType(CoreIconWidget), findsNWidgets(5));
    });

    testWidgets('2-tab: shows only active label', (tester) async {
      await tester.pumpWidget(
        _Harness(
          child: CoreBottomNavBar(
            tabs: _tabs2,
            selectedIndex: 0,
            onTabSelected: (_) {},
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Calculations'), findsOneWidget);
      expect(find.text('Estimates'), findsNothing);
    });

    testWidgets('2-tab: renders 2 tab icons + trailing action button', (tester) async {
      await tester.pumpWidget(
        _Harness(
          child: CoreBottomNavBar(
            tabs: _tabs2,
            selectedIndex: 0,
            onTabSelected: (_) {},
            onActionButtonPressed: () {},
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(CoreIconWidget), findsNWidgets(3));
    });
  });

  group('CoreBottomNavBar – interactions', () {
    testWidgets('tapping a tab calls onTabSelected with correct index', (tester) async {
      int? tapped;
      await _mount(tester, selectedIndex: 0, onTabSelected: (i) => tapped = i);

      await tester.tap(find.byType(InkWell).at(2));
      await tester.pumpAndSettle();

      expect(tapped, 2);
    });

    testWidgets('trailing action button invokes callback', (tester) async {
      bool fired = false;
      await _mount(tester, selectedIndex: 0, onAction: () => fired = true);

      final trailing = find.byType(CoreIconWidget).last;
      await tester.tap(trailing);
      await tester.pumpAndSettle();

      expect(fired, isTrue);
    });

    testWidgets('2-tab: tapping second tab calls onTabSelected(1)', (tester) async {
      int? tapped;
      await tester.pumpWidget(
        _Harness(
          child: CoreBottomNavBar(
            tabs: _tabs2,
            selectedIndex: 0,
            onTabSelected: (i) => tapped = i,
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.byType(InkWell).at(1));
      await tester.pumpAndSettle();

      expect(tapped, 1);
    });
  });

  group('CoreBottomNavBar – semantics', () {
    testWidgets('custom label appears on trailing button semantics node', (tester) async {
      final handle = tester.ensureSemantics();

      await _mount(
        tester,
        selectedIndex: 0,
        onAction: () {},
        actionButtonSemanticLabel: 'Calculator',
      );

      final node = tester.getSemantics(find.bySemanticsLabel('Calculator'));
      expect(node.label, 'Calculator');
      expect(node.flagsCollection.isButton, isTrue);

      handle.dispose();
    });

    testWidgets('no custom semantics label when actionButtonSemanticLabel is null', (tester) async {
      final handle = tester.ensureSemantics();

      await _mount(tester, selectedIndex: 0, onAction: () {});

      expect(find.bySemanticsLabel('Calculator'), findsNothing);

      handle.dispose();
    });

    for (final tabs in [_tabs, _tabs2]) {
      testWidgets(
          '${tabs.length}-tab: a screen reader double tap selects each tab',
          (tester) async {
        final handle = tester.ensureSemantics();
        try {
          final selected = <int>[];
          await _mount(
            tester,
            selectedIndex: 0,
            tabs: tabs,
            onTabSelected: selected.add,
          );

          for (var index = 0; index < tabs.length; index++) {
            final node =
                tester.getSemantics(find.bySemanticsLabel(tabs[index].label));
            expect(node.getSemanticsData().hasAction(SemanticsAction.tap),
                isTrue);
            tester.semantics.tap(find.semantics.byLabel(tabs[index].label));
            await tester.pump();
          }

          expect(selected, List.generate(tabs.length, (i) => i));
        } finally {
          handle.dispose();
        }
      });
    }

    testWidgets('a screen reader double tap presses the action button once',
        (tester) async {
      final handle = tester.ensureSemantics();
      try {
        var presses = 0;
        await _mount(
          tester,
          selectedIndex: 0,
          onAction: () => presses++,
          actionButtonSemanticLabel: 'Calculator',
        );

        final node = tester.getSemantics(find.bySemanticsLabel('Calculator'));
        expect(node.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
        tester.semantics.tap(find.semantics.byLabel('Calculator'));
        await tester.pump();

        expect(presses, 1);
      } finally {
        handle.dispose();
      }
    });

    testWidgets('the action button with no callback has no tap action',
        (tester) async {
      final handle = tester.ensureSemantics();
      try {
        await _mount(
          tester,
          selectedIndex: 0,
          actionButtonSemanticLabel: 'Calculator',
        );

        final node = tester.getSemantics(find.bySemanticsLabel('Calculator'));
        expect(node.getSemanticsData().hasAction(SemanticsAction.tap), isFalse);
      } finally {
        handle.dispose();
      }
    });
  });

  group('CoreBottomNavBar – narrow screens', () {
    for (final width in [320.0, 360.0, 375.0]) {
      for (final selected in [0, _tabs.length - 1]) {
        testWidgets(
            '${width.toInt()} dp, tab $selected selected: every inactive tab '
            'is at least 48 dp', (tester) async {
          final handle = tester.ensureSemantics();
          try {
            tester.view.devicePixelRatio = 1;
            tester.view.physicalSize = Size(width, 667);
            addTearDown(tester.view.reset);
            await _mount(tester, selectedIndex: selected, onAction: () {});

            final active = tester
                .getSemantics(find.bySemanticsLabel(_tabs[selected].label));
            for (final tab in _tabs.where((t) => t != _tabs[selected])) {
              final node =
                  tester.getSemantics(find.bySemanticsLabel(tab.label));
              // Same float slack as Flutter's own tap-target guideline.
              expect(
                  node.rect.width,
                  greaterThanOrEqualTo(
                      kMinInteractiveDimension - precisionErrorTolerance),
                  reason: tab.label);
              expect(active.rect.width, greaterThan(node.rect.width));
            }
            expect(tester.takeException(), isNull);
          } finally {
            handle.dispose();
          }
        });
      }
    }
  });

  group('CoreBottomNavBar – narrow screens, active label', () {
    for (final width in [360.0, 375.0, 393.0]) {
      for (var selected = 0; selected < _tabs.length; selected++) {
        testWidgets(
            '${width.toInt()} dp: the active label '
            '"${_tabs[selected].label}" is not cut', (tester) async {
          tester.view.devicePixelRatio = 1;
          tester.view.physicalSize = Size(width, 667);
          addTearDown(tester.view.reset);
          await _mount(tester, selectedIndex: selected, onAction: () {});

          final label = tester.renderObject<RenderParagraph>(
              find.text(_tabs[selected].label));
          expect(label.size.width,
              greaterThanOrEqualTo(label.getMaxIntrinsicWidth(double.infinity)));
        });
      }
    }
  });

  group('CoreBottomNavBar – accessibility', () {
    testWidgets(
        'meets tap target, label and contrast guidelines for tabs and action button', (tester) async {
      await setupA11yTest(tester);
      await _mount(tester, selectedIndex: 0);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => CoreBottomNavBar(
          tabs: _tabs,
          selectedIndex: 0,
          onTabSelected: (_) {},
          onActionButtonPressed: null,
        ),
        find.byType(CoreBottomNavBar),
      );
    });

    testWidgets('2-tab: meets tap target, label and contrast guidelines', (tester) async {
      await setupA11yTest(tester);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => CoreBottomNavBar(
          tabs: _tabs2,
          selectedIndex: 0,
          onTabSelected: (_) {},
          onActionButtonPressed: null,
        ),
        find.byType(CoreBottomNavBar),
      );
    });

    testWidgets('trailing button with label meets tap target and label guidelines', (tester) async {
      await setupA11yTest(tester);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => CoreBottomNavBar(
          tabs: _tabs,
          selectedIndex: 0,
          onTabSelected: (_) {},
          onActionButtonPressed: () {},
          actionButtonSemanticLabel: 'Calculator',
        ),
        find.byType(CoreBottomNavBar),
      );
    });
  });
}
