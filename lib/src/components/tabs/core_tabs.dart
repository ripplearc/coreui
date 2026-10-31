import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';

/// A horizontal tab bar component following the Core design system.
///
/// Displays a list of selectable tabs with an indicator highlighting the
/// currently selected tab. Uses [TabController] internally to manage tab
/// selection state.
///
/// The tabs are horizontally scrollable when they exceed the available width.
/// A 4 dp gap follows every tab, so the bottom line runs 4 dp past the last.
///
/// Example:
/// ```dart
/// CoreTabs(
///   tabs: ['Tab 1', 'Tab 2', 'Tab 3'],
///   selectedIndex: 0,
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
  final int selectedIndex;

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
    this.selectedIndex = 0,
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
      initialIndex: widget.selectedIndex,
    );
    _controller.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (!_controller.indexIsChanging) {
      widget.onChanged?.call(_controller.index);
    }
  }

  @override
  void didUpdateWidget(covariant CoreTabs oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!listEquals(oldWidget.tabs, widget.tabs)) {
      _controller.removeListener(_onTabChanged);
      _controller.dispose();

      _controller = TabController(
        length: widget.tabs.length,
        vsync: this,
        initialIndex: widget.selectedIndex,
      );

      _controller.addListener(_onTabChanged);
    } else if (oldWidget.selectedIndex != widget.selectedIndex &&
        widget.selectedIndex != _controller.index) {
      _controller.animateTo(widget.selectedIndex);
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

    return IntrinsicWidth(
      child: TabBar(
        enableFeedback: false,
        controller: _controller,
        isScrollable: true,
        // Sized to the label so the indicator stops short of the gap between
        // tabs, which lives in labelPadding.
        indicatorSize: TabBarIndicatorSize.label,
        tabAlignment: TabAlignment.start,
        // No radius: square ends, as Figma draws them. Weight 0 because the
        // underline sits inside the 40 dp tab, not below it.
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: colors.tabsHighlight,
            width: CoreSpacing.space1,
          ),
        ),
        indicatorWeight: 0,
        dividerColor: colors.lineDarkOutline,
        // Replaces Flutter's 16 a side with the 4px gap between tabs; the 12
        // side padding below is the tab's own.
        labelPadding: const EdgeInsetsDirectional.only(end: CoreSpacing.space1),
        labelColor: colors.textHeadline,
        unselectedLabelColor: colors.textBody,
        labelStyle: typography.bodyMediumSemiBold,
        unselectedLabelStyle: typography.bodyMediumRegular,
        tabs: [
          for (final label in widget.tabs)
            // The 8 on top makes a 48 dp tap area around the 40 dp tab.
            Padding(
              padding: const EdgeInsets.fromLTRB(
                CoreSpacing.space3,
                CoreSpacing.space2,
                CoreSpacing.space3,
                0,
              ),
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
