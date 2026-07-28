import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

/// Captures the callback invocations of a [CoreMultiSelectSheet], since the
/// sheet is exercised across separate `pump` calls in a test body.
class _CallbackRecorder {
  final List<String> searchQueries = [];
  Set<String> appliedIds = const {};
}

void main() {
  const items = [
    CoreMultiSelectItem(id: 'roofing', label: 'Roofing'),
    CoreMultiSelectItem(id: 'wall', label: 'Wall'),
  ];

  Future<_CallbackRecorder> pumpAndShow(
    WidgetTester tester, {
    CoreMultiSelectListData? listData = const CoreMultiSelectListData(
      isLoading: false,
      items: items,
    ),
    Set<String> initialSelectedIds = const {},
  }) async {
    final recorder = _CallbackRecorder();
    await tester.pumpWidget(
      MaterialApp(
        theme: CoreTheme.light(),
        home: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => Scaffold(
                    body: CoreMultiSelectSheet(
                      title: 'Filter by tag',
                      searchHint: 'Search tags',
                      emptyLabel: 'No tags found',
                      initialSelectedIds: initialSelectedIds,
                      listData: listData,
                      onSearchQueryChanged: recorder.searchQueries.add,
                      onApply: (ids) => recorder.appliedIds = ids,
                      loadingIndicatorKey: const Key('sheet_loading_indicator'),
                      emptyLabelKey: const Key('sheet_empty_label'),
                      itemKeyOf: (id) => Key('sheet_item_$id'),
                      clearAllButtonKey: const Key('sheet_clear_all_button'),
                      applyButtonKey: const Key('sheet_apply_button'),
                    ),
                  ),
                ),
              ),
              child: const Text('open'),
            );
          },
        ),
      ),
    );
    await tester.tap(find.text('open'));
    // Pump the route transition with fixed durations rather than
    // pumpAndSettle: the loading state animates its indicator forever, which
    // would make pumpAndSettle time out.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    return recorder;
  }

  bool isItemChecked(WidgetTester tester, String id) {
    final tile = tester.widget<CheckboxListTile>(
      find.byKey(Key('sheet_item_$id')),
    );
    return tile.value == true;
  }

  group('CoreMultiSelectSheet', () {
    testWidgets('renders the title, search hint, and one row per item', (
      tester,
    ) async {
      await pumpAndShow(tester);

      expect(find.text('Filter by tag'), findsOneWidget);
      expect(find.text('Search tags'), findsOneWidget);
      expect(find.byKey(const Key('sheet_item_roofing')), findsOneWidget);
      expect(find.byKey(const Key('sheet_item_wall')), findsOneWidget);
    });

    testWidgets('shows the default Clear all and Apply button labels', (
      tester,
    ) async {
      await pumpAndShow(tester);

      expect(find.text('Clear all'), findsOneWidget);
      expect(find.text('Apply'), findsOneWidget);
    });

    testWidgets('shows the loading indicator while items are loading', (
      tester,
    ) async {
      await pumpAndShow(
        tester,
        listData: const CoreMultiSelectListData(isLoading: true, items: []),
      );

      expect(find.byKey(const Key('sheet_loading_indicator')), findsOneWidget);
      expect(find.byType(CheckboxListTile), findsNothing);
    });

    testWidgets('shows the empty label when there are no items',
        (tester) async {
      await pumpAndShow(
        tester,
        listData: const CoreMultiSelectListData(isLoading: false, items: []),
      );

      expect(find.byKey(const Key('sheet_empty_label')), findsOneWidget);
      expect(find.text('No tags found'), findsOneWidget);
      expect(find.byType(CheckboxListTile), findsNothing);
    });

    testWidgets(
      'renders title, search field, and buttons with no list when listData '
      'is null',
      (tester) async {
        await pumpAndShow(tester, listData: null);

        expect(find.text('Filter by tag'), findsOneWidget);
        expect(find.byKey(const Key('sheet_apply_button')), findsOneWidget);
        expect(find.byType(CheckboxListTile), findsNothing);
        expect(find.byKey(const Key('sheet_empty_label')), findsNothing);
        expect(find.byKey(const Key('sheet_loading_indicator')), findsNothing);
      },
    );

    testWidgets('forwards typed search queries to onSearchQueryChanged', (
      tester,
    ) async {
      final recorder = await pumpAndShow(tester);

      await tester.enterText(find.byType(TextFormField), 'Roof');
      await tester.pump();

      expect(recorder.searchQueries, ['Roof']);
    });

    testWidgets('pre-checks the initially selected ids', (tester) async {
      await pumpAndShow(tester, initialSelectedIds: {'wall'});

      expect(isItemChecked(tester, 'wall'), isTrue);
      expect(isItemChecked(tester, 'roofing'), isFalse);
    });

    testWidgets('toggles an item checkbox on tap', (tester) async {
      await pumpAndShow(tester);

      expect(isItemChecked(tester, 'roofing'), isFalse);

      await tester.tap(find.byKey(const Key('sheet_item_roofing')));
      await tester.pump();
      expect(isItemChecked(tester, 'roofing'), isTrue);

      await tester.tap(find.byKey(const Key('sheet_item_roofing')));
      await tester.pump();
      expect(isItemChecked(tester, 'roofing'), isFalse);
    });

    testWidgets('Clear all deselects every item without closing the sheet', (
      tester,
    ) async {
      await pumpAndShow(tester, initialSelectedIds: {'roofing', 'wall'});

      await tester.tap(find.byKey(const Key('sheet_clear_all_button')));
      await tester.pump();

      expect(find.byType(CoreMultiSelectSheet), findsOneWidget);
      expect(isItemChecked(tester, 'roofing'), isFalse);
      expect(isItemChecked(tester, 'wall'), isFalse);
    });

    testWidgets('Apply passes the selected ids to onApply and pops the sheet', (
      tester,
    ) async {
      final recorder = await pumpAndShow(tester);

      await tester.tap(find.byKey(const Key('sheet_item_roofing')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('sheet_apply_button')));
      await tester.pumpAndSettle();

      expect(recorder.appliedIds, {'roofing'});
      expect(find.byType(CoreMultiSelectSheet), findsNothing);
    });

    testWidgets(
      'keeps the search field, list, and buttons visible above the keyboard',
      (tester) async {
        // Present through CoreQuickSheet.show — the real presentation path —
        // because a plain Scaffold host would absorb the keyboard inset
        // itself and hide the bug. 780x1688 physical at DPR 2.0 is a 390x844
        // logical phone viewport.
        tester.view.physicalSize = const Size(780, 1688);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(() => tester.view.reset());

        await tester.pumpWidget(
          MaterialApp(
            theme: CoreTheme.light(),
            home: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => CoreQuickSheet.show<void>(
                  context: context,
                  child: CoreMultiSelectSheet(
                    title: 'Filter by tag',
                    searchHint: 'Search tags',
                    emptyLabel: 'No tags found',
                    initialSelectedIds: const {},
                    listData: const CoreMultiSelectListData(
                      isLoading: false,
                      items: items,
                    ),
                    onSearchQueryChanged: (_) {},
                    onApply: (_) {},
                    itemKeyOf: (id) => Key('sheet_item_$id'),
                    applyButtonKey: const Key('sheet_apply_button'),
                  ),
                ),
                child: const Text('open'),
              ),
            ),
          ),
        );
        await tester.tap(find.text('open'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));

        // Simulate the keyboard opening: 600 physical px = 300 logical.
        tester.view.viewInsets = const FakeViewPadding(bottom: 600);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));

        await tester.enterText(find.byType(TextFormField), 'Roof');
        await tester.pump();

        const keyboardTop = 844.0 - 300.0;
        expect(
          tester.getRect(find.byType(CoreTextField)).bottom,
          lessThanOrEqualTo(keyboardTop),
        );
        expect(
          tester.getRect(find.byKey(const Key('sheet_item_roofing'))).bottom,
          lessThanOrEqualTo(keyboardTop),
        );
        expect(
          tester.getRect(find.byKey(const Key('sheet_apply_button'))).bottom,
          lessThanOrEqualTo(keyboardTop),
        );
      },
    );

    testWidgets('the set passed to onApply is unmodifiable', (tester) async {
      final recorder = await pumpAndShow(tester);

      await tester.tap(find.byKey(const Key('sheet_item_roofing')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('sheet_apply_button')));
      await tester.pumpAndSettle();

      // Guard that onApply actually fired before probing mutability, so this
      // test cannot pass vacuously on the recorder's unmodifiable default.
      expect(recorder.appliedIds, {'roofing'});
      expect(
        () => recorder.appliedIds.add('wall'),
        throwsA(isA<UnsupportedError>()),
      );
    });
  });
}
