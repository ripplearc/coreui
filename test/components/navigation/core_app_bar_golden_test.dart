import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

ThemeData _createTestTheme() {
  return CoreTheme.light().copyWith(
    textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto'),
  );
}

ThemeData _createDarkTestTheme() {
  return CoreTheme.dark().copyWith(
    textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Roboto'),
  );
}

/// Shape A — flat bar with no shadow, as the auth screens use.
CoreAppBar _flatBar() => const CoreAppBar(
      titleText: 'Reset password',
      elevation: CoreAppBarElevation.none,
    );

/// Shape B — shadowed bar with a custom title row and an action cluster.
CoreAppBar _customTitleRowBar() => CoreAppBar(
      height: CoreSpacing.space16,
      titleSpacing: 0,
      padding: const EdgeInsets.only(
        left: CoreSpacing.space1,
        right: CoreSpacing.space4,
      ),
      title: const Row(
        children: [
          Flexible(
            child: Text('Riverside Tower', overflow: TextOverflow.ellipsis),
          ),
          SizedBox(width: CoreSpacing.space1),
          CoreIconWidget(
            icon: CoreIcons.arrowDropDown,
            size: CoreIconSize.size24,
          ),
        ],
      ),
      actions: [
        CoreIconWidget(
          icon: CoreIcons.search,
          semanticLabel: 'Search',
          onTap: () {},
        ),
        const SizedBox(width: CoreSpacing.space4),
        CoreIconWidget(
          icon: CoreIcons.notification,
          semanticLabel: 'Notifications',
          onTap: () {},
        ),
      ],
    );

/// Shape C — back button alongside the project title, as a project detail
/// screen uses. The icon owns [CoreSpacing.space3] padding around a 24pt
/// glyph, giving it a 48x48 tap target.
CoreAppBar _backWithTitleBar() => CoreAppBar(
      titleText: 'Riverside Tower',
      titleSpacing: CoreSpacing.space1,
      padding: const EdgeInsets.only(right: CoreSpacing.space4),
      leading: CoreIconWidget(
        icon: CoreIcons.arrowLeft,
        size: CoreIconSize.size24,
        padding: const EdgeInsets.all(CoreSpacing.space3),
        semanticLabel: 'Back',
        onTap: () {},
      ),
    );

/// Shape D — Material elevation rather than a CoreShadows shadow.
CoreAppBar _materialElevationBar() => const CoreAppBar(
      titleText: 'New Project',
      elevation: CoreAppBarElevation.material,
    );

/// Shape E — plain centered title with a single action.
CoreAppBar _titleTextBar() => CoreAppBar(
      titleText: 'Projects',
      centerTitle: true,
      padding: const EdgeInsets.symmetric(
        horizontal: CoreSpacing.space4,
        vertical: CoreSpacing.space2,
      ),
      actions: [
        CoreIconWidget(
          icon: CoreIcons.search,
          semanticLabel: 'Search',
          onTap: () {},
        ),
      ],
    );

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await loadFonts();
  });

  group('CoreAppBar Screenshot Tests', () {
    const width = 390.0;
    const ratio = 1.0;

    Future<void> pumpBar({
      required WidgetTester tester,
      required CoreAppBar bar,
      required ThemeData theme,
    }) async {
      // Scope the view to the bar's own preferredSize so the golden captures
      // exactly the bar, with no empty body space below it.
      tester.view.physicalSize = Size(width, bar.preferredSize.height);
      tester.view.devicePixelRatio = ratio;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Scaffold(
            appBar: bar,
            body: const SizedBox.shrink(),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
    }

    final cases = <String, CoreAppBar Function()>{
      'flat_no_shadow': _flatBar,
      'custom_title_row': _customTitleRowBar,
      'back_with_title': _backWithTitleBar,
      'material_elevation': _materialElevationBar,
      'title_text': _titleTextBar,
    };

    cases.forEach((name, build) {
      testWidgets('renders $name', (tester) async {
        await pumpBar(
          tester: tester,
          bar: build(),
          theme: _createTestTheme(),
        );

        await expectLater(
          find.byType(CoreAppBar),
          matchesGoldenFile('goldens/core_app_bar_$name.png'),
        );
      });

      testWidgets('renders $name – dark theme', (tester) async {
        await pumpBar(
          tester: tester,
          bar: build(),
          theme: _createDarkTestTheme(),
        );

        await expectLater(
          find.byType(CoreAppBar),
          matchesGoldenFile('goldens/core_app_bar_${name}_dark.png'),
        );
      });
    });
  });
}
