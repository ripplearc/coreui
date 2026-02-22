import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';

/// A horizontal tab bar component following the Core design system.
///
/// Displays a list of selectable tabs with an indicator highlighting the
/// currently selected tab. Uses [TabController] internally to manage tab
/// selection state.
///
/// The tabs are horizontally scrollable when they exceed the available width.
///
/// Example:
/// ```dart
/// CoreTabs(
///   tabs: ['Tab 1', 'Tab 2', 'Tab 3'],
///   initialIndex: 0,
///   onChanged: (index) => print('Selected tab: $index'),
/// )
/// ```
///
/// See also:
///  * [TabBar], the underlying Flutter widget used for tab display.
class CoreTabs extends StatefulWidget {
  /// The list of tab labels to display.
  ///
  /// Must contain at least one tab.
  final List<String> tabs;

  /// The index of the initially selected tab.
  ///
  /// Defaults to 0 (the first tab).
  final int initialIndex;

  /// Called when the user selects a different tab.
  ///
  /// The callback provides the index of the newly selected tab.
  final ValueChanged<int>? onChanged;

  /// Creates a [CoreTabs] widget.
  ///
  /// The [tabs] parameter is required and must not be empty.
  const CoreTabs({
    super.key,
    required this.tabs,
    this.initialIndex = 0,
    this.onChanged,
  });

  @override
  State<CoreTabs> createState() => _CoreTabsState();
}

class _CoreTabsState extends State<CoreTabs> with TickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
    _controller.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (_controller.indexIsChanging) {
      widget.onChanged?.call(_controller.index);
    }
  }

  @override
  void didUpdateWidget(covariant CoreTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tabs.length != widget.tabs.length) {
      _controller.removeListener(_onTabChanged);
      _controller.dispose();
      _controller = TabController(
        length: widget.tabs.length,
        vsync: this,
        initialIndex: widget.initialIndex,
      );
      _controller.addListener(_onTabChanged);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: TabBar(
        enableFeedback: false,
        controller: _controller,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        indicatorColor: colors.tabsHighlight,
        indicatorWeight: CoreSpacing.space1,
        labelColor: colors.textHeadline,
        unselectedLabelColor: colors.textBody,
        labelStyle: typography.bodyMediumSemiBold,
        unselectedLabelStyle: typography.bodyMediumRegular,
        tabs: [
          for (final label in widget.tabs)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: CoreSpacing.space3),
              child: Tab(
                text: label,
                height: CoreSpacing.space10,
              ),
            ),
        ],
      ),
    );
  }
}
