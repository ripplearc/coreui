import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

const Key _pushRouteKey = Key('core_app_bar_push_route');

/// Pushes [appBar] onto a second route so the implied-leading behaviour has a
/// route it can actually pop back to.
Future<void> _pumpPushedBar(WidgetTester tester, CoreAppBar appBar) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: CoreTheme.light(),
      home: Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            key: _pushRouteKey,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => Scaffold(
                  appBar: appBar,
                  body: const SizedBox.shrink(),
                ),
              ),
            ),
            child: const Text('push'),
          ),
        ),
      ),
    ),
  );

  await tester.tap(find.byKey(_pushRouteKey));
  await tester.pumpAndSettle();
}

Widget _buildBarApp(CoreAppBar appBar, {ThemeData? theme}) {
  return MaterialApp(
    theme: theme ?? CoreTheme.light(),
    home: Scaffold(
      appBar: appBar,
      body: const SizedBox.shrink(),
    ),
  );
}

void main() {
  group('CoreAppBar preferred size', () {
    test('defaults to kToolbarHeight when no padding is given', () {
      const bar = CoreAppBar(titleText: 'Projects');

      expect(bar.preferredSize.height, CoreSpacing.space14);
      expect(bar.preferredSize.height, kToolbarHeight);
    });

    test('adds vertical padding on top of the content height', () {
      const bar = CoreAppBar(
        titleText: 'Projects',
        padding: EdgeInsets.symmetric(
          horizontal: CoreSpacing.space4,
          vertical: CoreSpacing.space2,
        ),
      );

      expect(
        bar.preferredSize.height,
        CoreSpacing.space14 + CoreSpacing.space2 * 2,
      );
    });

    test('ignores horizontal padding', () {
      const bar = CoreAppBar(
        titleText: 'Projects',
        padding: EdgeInsets.symmetric(horizontal: CoreSpacing.space4),
      );

      expect(bar.preferredSize.height, CoreSpacing.space14);
    });

    test('honours an explicit height', () {
      const bar = CoreAppBar(titleText: 'Projects', height: CoreSpacing.space16);

      expect(bar.preferredSize.height, CoreSpacing.space16);
    });
  });

  group('CoreAppBar asserts', () {
    test('rejects title and titleText together', () {
      expect(
        () => CoreAppBar(titleText: 'Projects', title: const Text('Projects')),
        throwsAssertionError,
      );
    });

    test('rejects a height below the 48x48 tap target guideline', () {
      expect(
        () => CoreAppBar(
          titleText: 'Projects',
          height: CoreSpacing.space12 - CoreSpacing.space1,
        ),
        throwsAssertionError,
      );
    });

    test('accepts a height exactly at the guideline', () {
      expect(
        () => const CoreAppBar(
          titleText: 'Projects',
          height: CoreSpacing.space12,
        ),
        returnsNormally,
      );
    });
  });

  group('CoreAppBar layout', () {
    testWidgets('content box keeps the full height when padding is applied',
        (tester) async {
      await tester.pumpWidget(
        _buildBarApp(
          const CoreAppBar(
            titleText: 'Projects',
            padding: EdgeInsets.symmetric(vertical: CoreSpacing.space2),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // The regression this guards: folding padding into a fixed preferred
      // size shrinks the toolbar and drags tap targets under 48x48.
      final toolbar = tester.getSize(find.byType(NavigationToolbar));
      expect(toolbar.height, CoreSpacing.space14);
    });

    testWidgets('consumes the status bar inset without shrinking the toolbar',
        (tester) async {
      const statusBar = 44.0;
      const bar = CoreAppBar(
        titleText: 'Projects',
        padding: EdgeInsets.symmetric(vertical: CoreSpacing.space2),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const MediaQuery(
            data: MediaQueryData(
              padding: EdgeInsets.only(top: statusBar),
            ),
            child: Scaffold(
              appBar: bar,
              body: SizedBox.shrink(),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Scaffold allocates preferredSize plus the inset, and the inner AppBar
      // consumes the inset, so the content box keeps its full height and the
      // decoration still extends behind the status bar.
      expect(
        tester.getSize(find.byType(CoreAppBar)).height,
        bar.preferredSize.height + statusBar,
      );
      expect(
        tester.getSize(find.byType(NavigationToolbar)).height,
        CoreSpacing.space14,
      );
    });

    testWidgets('renders titleText with the headline colour', (tester) async {
      await tester.pumpWidget(
        _buildBarApp(const CoreAppBar(titleText: 'Projects')),
      );
      await tester.pump(const Duration(milliseconds: 100));

      final text = tester.widget<Text>(find.text('Projects'));
      final colors = CoreTheme.light().coreColors;
      expect(text.style!.color, colors.textHeadline);
    });

    testWidgets('renders an arbitrary title widget', (tester) async {
      await tester.pumpWidget(
        _buildBarApp(
          const CoreAppBar(
            title: Row(
              children: [
                Text('Project'),
                CoreIconWidget(icon: CoreIcons.arrowDropDown),
              ],
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Project'), findsOneWidget);
      expect(find.byType(CoreIconWidget), findsOneWidget);
    });

    testWidgets('shows actions and fires their callbacks', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _buildBarApp(
          CoreAppBar(
            titleText: 'Projects',
            actions: [
              CoreIconWidget(
                key: const Key('core_app_bar_search'),
                icon: CoreIcons.search,
                semanticLabel: 'Search',
                onTap: () => tapped = true,
              ),
            ],
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.byKey(const Key('core_app_bar_search')));
      expect(tapped, isTrue);
    });

    testWidgets('implies no back button on a poppable route by default',
        (tester) async {
      await _pumpPushedBar(tester, const CoreAppBar(titleText: 'Projects'));

      // The app bar design has no back button, so the bar must not sprout one
      // just because the route happens to be poppable.
      expect(find.byType(CoreAppBar), findsOneWidget);
      expect(find.byType(BackButton), findsNothing);
    });

    testWidgets('implyLeading opts into the Material back button',
        (tester) async {
      await _pumpPushedBar(
        tester,
        const CoreAppBar(titleText: 'Projects', implyLeading: true),
      );

      expect(find.byType(BackButton), findsOneWidget);

      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      expect(find.byType(CoreAppBar), findsNothing);
      expect(find.byKey(_pushRouteKey), findsOneWidget);
    });

    testWidgets('renders an explicit leading widget without implyLeading', (tester) async {
      await tester.pumpWidget(
        _buildBarApp(
          CoreAppBar(
            titleText: 'Projects',
            leading: CoreIconWidget(
              key: const Key('core_app_bar_back'),
              icon: CoreIcons.arrowLeft,
              semanticLabel: 'Back',
              onTap: () {},
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Renders even though implyLeading defaults to false — the two are
      // independent, so an explicit leading is never silently dropped.
      expect(find.byKey(const Key('core_app_bar_back')), findsOneWidget);
      expect(find.byType(BackButton), findsNothing);
    });
  });

  group('CoreAppBar elevation', () {
    testWidgets('shadow draws the CoreShadows shadow and no Material one',
        (tester) async {
      await tester.pumpWidget(
        _buildBarApp(const CoreAppBar(titleText: 'Projects')),
      );
      await tester.pump(const Duration(milliseconds: 100));

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.elevation, 0);
      expect(appBar.scrolledUnderElevation, 0);

      final bar = tester.widget<CoreAppBar>(find.byType(CoreAppBar));
      expect(bar.decorationShadow, CoreShadows.medium);
    });

    testWidgets('none draws no shadow at all', (tester) async {
      await tester.pumpWidget(
        _buildBarApp(
          const CoreAppBar(elevation: CoreAppBarElevation.none),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.elevation, 0);

      final bar = tester.widget<CoreAppBar>(find.byType(CoreAppBar));
      expect(bar.decorationShadow, isNull);
    });

    testWidgets('material uses Material elevation and no decoration shadow',
        (tester) async {
      await tester.pumpWidget(
        _buildBarApp(
          const CoreAppBar(
            titleText: 'Projects',
            elevation: CoreAppBarElevation.material,
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.elevation, greaterThan(0));
      expect(appBar.shadowColor, CoreTheme.light().coreColors.shadowGrey10);

      final bar = tester.widget<CoreAppBar>(find.byType(CoreAppBar));
      expect(bar.decorationShadow, isNull);
    });
  });

  group('CoreAppBar theming', () {
    testWidgets('falls back to pageBackground in the light theme',
        (tester) async {
      await tester.pumpWidget(
        _buildBarApp(const CoreAppBar(titleText: 'Projects')),
      );
      await tester.pump(const Duration(milliseconds: 100));

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.backgroundColor, CoreTheme.light().coreColors.pageBackground);
    });

    testWidgets('tracks the dark theme background', (tester) async {
      await tester.pumpWidget(
        _buildBarApp(
          const CoreAppBar(titleText: 'Projects'),
          theme: CoreTheme.dark(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.backgroundColor, CoreTheme.dark().coreColors.pageBackground);
    });

    testWidgets('an explicit backgroundColor wins over the theme',
        (tester) async {
      final colors = CoreTheme.light().coreColors;
      await tester.pumpWidget(
        _buildBarApp(
          CoreAppBar(titleText: 'Projects', backgroundColor: colors.iconWhite),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.backgroundColor, colors.iconWhite);
    });
  });
}
