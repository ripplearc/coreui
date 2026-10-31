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

  /// Key of the 40 dp face of the tab at [index], where the press fill and
  /// the focus ring are drawn.
  static Key tabKey(int index) => Key('core_tabs_tab_$index');

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

    final tabBar = IntrinsicWidth(
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
        // The press fill and the focus ring are drawn on the 40 dp face only,
        // not on the whole 48 dp tap area.
        overlayColor: WidgetStateProperty.all(colors.transparent),
        splashFactory: NoSplash.splashFactory,
        // Replaces Flutter's 16 a side with the 4px gap between tabs; the 12
        // side padding below is the tab's own.
        labelPadding: const EdgeInsetsDirectional.only(end: CoreSpacing.space1),
        labelColor: colors.textHeadline,
        unselectedLabelColor: colors.textBody,
        labelStyle: typography.bodyMediumSemiBold,
        unselectedLabelStyle: typography.bodyMediumRegular,
        tabs: [
          for (final (index, label) in widget.tabs.indexed)
            _TabFace(faceKey: CoreTabs.tabKey(index), label: label),
        ],
      ),
    );

    // Our own Material, so the press fill also shows inside a coloured parent.
    return Material(type: MaterialType.transparency, child: tabBar);
  }
}

class _TabFace extends StatefulWidget {
  const _TabFace({required this.faceKey, required this.label});

  final Key faceKey;
  final String label;

  @override
  State<_TabFace> createState() => _TabFaceState();
}

class _TabFaceState extends State<_TabFace> {
  static const double _focusWidth = 2;

  bool _isPressed = false;

  void _setPressed(bool isPressed) => setState(() => _isPressed = isPressed);

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    // The focus node is the one of the TabBar's InkWell around this tab.
    final isFocused = Focus.of(context).hasFocus;

    return Listener(
      onPointerDown: (_) => _setPressed(true),
      onPointerUp: (_) => _setPressed(false),
      onPointerCancel: (_) => _setPressed(false),
      // The 8 on top makes a 48 dp tap area around the 40 dp face.
      child: Padding(
        padding: const EdgeInsets.only(top: CoreSpacing.space2),
        // The ring paints over the indicator. The Ink fill below paints on
        // the Material, under the indicator, so a pressed tab keeps its line.
        child: DecoratedBox(
          key: widget.faceKey,
          decoration: BoxDecoration(
            border: isFocused
                ? Border.all(color: colors.outlineFocus, width: _focusWidth)
                : null,
          ),
          child: Ink(
            color: _isPressed ? colors.backgroundGrayMid : colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: CoreSpacing.space3),
            child: Tab(text: widget.label, height: CoreSpacing.space10),
          ),
        ),
      ),
    );
  }
}
