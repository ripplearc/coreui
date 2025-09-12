import 'package:flutter/material.dart';
import 'package:ripplearc_core_ui/core_ui.dart';

/// Describes a single bottom navigation tab.
///
/// Each tab has an [icon] and a text [label]. The label is shown only for the
/// active tab; inactive tabs show the icon only.
///
/// ### Example
/// ```dart
/// const tabs = [
///   BottomNavTab(icon: CoreIcons.home,      label: 'Home'),
///   BottomNavTab(icon: CoreIcons.calculate, label: 'Calculations'),
///   BottomNavTab(icon: CoreIcons.cost,      label: 'Estimation'),
///   BottomNavTab(icon: CoreIcons.members,   label: 'Members'),
/// ];
/// ```
class BottomNavTab {
  /// The icon displayed for this tab.
  final CoreIconData icon;

  /// The text label displayed when the tab is active.
  final String label;

  const BottomNavTab({
    required this.icon,
    required this.label,
  });
}

/// Bottom navigation bar with exactly four tabs and an optional trailing
/// circular action button (e.g., a calculator shortcut).
///
/// This is a fully controlled widget:
/// - The parent owns selection via [selectedIndex].
/// - User interactions are reported via [onTabSelected].
/// - [tabs] must contain exactly 4 items (enforced by assert).
///
/// ### Behavior
/// - A sliding “pill” animates beneath the active tab.
/// - Active tab shows icon + label; inactive tabs show the icon only.
/// - Animations use [animationDuration] and `Curves.easeOut`.
///
/// ### Theming
/// If an [AppColorsExtension] is present in the theme, its colors are used
/// (text, icons, borders, backgrounds). Otherwise CoreUI fallbacks are applied
/// (e.g., [CoreTextColors], [CoreIconColors], [CoreBackgroundColors]).
///
/// ```dart
/// MaterialApp(
///   theme: ThemeData(
///     extensions: [
///       AppColorsExtension(
///         // define your palette here...
///       ),
///     ],
///   ),
///   home: const HomeScreen(),
/// );
/// ```
///
/// ### Layout & Responsiveness
/// The bar scales its paddings, icon/label sizes, and pill dimensions from
/// design ratios. Wrap in padding/margins that fit your app’s layout.
///
/// ### Accessibility
/// - Labels are text and respect text scaling.
/// - Use concise, descriptive [BottomNavTab.label]s.
/// - Consider semantics for [onActionButtonPressed] if provided.
///
/// ### Debug note
/// During the selection animation, you might briefly see a debug-only
/// `RenderFlex overflow` warning as the label fades in while the container
/// expands. This resolves within the same frame and does not appear or hide
/// content in release/profile builds.
///
/// ---
/// ## Examples
///
/// ### 1) Basic usage
/// ```dart
/// class HomeScreen extends StatefulWidget {
///   const HomeScreen({super.key});
///   @override
///   State<HomeScreen> createState() => _HomeScreenState();
/// }
///
/// class _HomeScreenState extends State<HomeScreen> {
///   int _index = 0;
///
///   static const _tabs = [
///     BottomNavTab(icon: CoreIcons.home,      label: 'Home'),
///     BottomNavTab(icon: CoreIcons.calculate, label: 'Calculations'),
///     BottomNavTab(icon: CoreIcons.cost,      label: 'Estimation'),
///     BottomNavTab(icon: CoreIcons.members,   label: 'Members'),
///   ];
///
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       body: Center(child: Text('Tab: ${_tabs[_index].label}')),
///       bottomNavigationBar: SafeArea(
///         minimum: const EdgeInsets.all(16),
///         child: CoreBottomNavBar(
///           tabs: _tabs,
///           selectedIndex: _index,
///           onTabSelected: (i) => setState(() => _index = i),
///         ),
///       ),
///     );
///   }
/// }
/// ```
///
/// ### 2) With trailing action button
/// ```dart
/// CoreBottomNavBar(
///   tabs: _tabs,
///   selectedIndex: _index,
///   onTabSelected: (i) => setState(() => _index = i),
///   onActionButtonPressed: () {
///     // e.g., open quick calculator
///     Navigator.of(context).pushNamed('/quick-calc');
///   },
/// )
/// ```
///
/// ### 3) External state (BLoC)
/// ```dart
/// CoreBottomNavBar(
///   tabs: _tabs,
///   selectedIndex: context.select((BottomNavBloc b) => b.state.index),
///   onTabSelected: (i) =>
///       context.read<BottomNavBloc>().add(BottomNavTabSelectedEvent(i)),
/// )
/// ```

class CoreBottomNavBar extends StatefulWidget {
  /// The four tabs rendered by the navigation bar.
  ///
  /// Must contain exactly 4 items; otherwise the widget asserts.
  final List<BottomNavTab> tabs;

  /// The index (0–3) of the currently selected tab.
  ///
  /// This value is owned by the parent and should be updated when
  /// [onTabSelected] is invoked.
  final int selectedIndex;

  /// Called when the user selects a tab by tapping it.
  ///
  /// Update [selectedIndex] in the parent to reflect the new value.
  final ValueChanged<int> onTabSelected;

  /// The duration for the pill slide, width, and label fade animations.
  ///
  /// Defaults to 600ms to match CoreUI motion guidelines.
  final Duration animationDuration;

  /// If provided, displays a trailing circular action button and invokes this
  /// callback when the button is tapped.
  ///
  /// If null, no trailing button is shown.
  final VoidCallback? onActionButtonPressed;

  const CoreBottomNavBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    this.animationDuration = const Duration(milliseconds: 600),
    this.onActionButtonPressed,
  }) : assert(tabs.length == 4, 'CoreBottomNavBar supports exactly 4 tabs');

  @override
  State<CoreBottomNavBar> createState() => _CoreBottomNavBarState();
}

class _CoreBottomNavBarState extends State<CoreBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColorsExtension>();

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: appColors?.pageBackground ?? CoreBackgroundColors.pageBackground,
        borderRadius: BorderRadius.circular(48),
        boxShadow: [
          BoxShadow(
            color: CoreShadowColors.shadowGrey6,
            offset: const Offset(0, 2),
            blurRadius: 4,
            spreadRadius: -2,
          ),
          BoxShadow(
            color: CoreShadowColors.shadowGrey10,
            offset: const Offset(0, 4),
            blurRadius: 8,
            spreadRadius: -2,
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final layout = _computeLayout(constraints.maxWidth);
          return Row(
            children: [
              _buildNavTabRow(appColors, layout),
              SizedBox(width: layout.tabRowTrailingIconGap),
              _buildTrailingICon(appColors, layout),
            ],
          );
        },
      ),
    );
  }

  // --- Layout Computation ---

  _NavLayout _computeLayout(double maxWidth) {
    final bottomNavBarWidth = maxWidth;

    final tabRowBarWidth = bottomNavBarWidth * _BottomNavBarRatios.tabRowWidth;

    final tabRowTrailingIconGap =
        bottomNavBarWidth * _BottomNavBarRatios.trailingIconGap;

    final actionButtonSize =
        bottomNavBarWidth * _BottomNavBarRatios.actionButtonSize;

    final barHorizontalPad =
        tabRowBarWidth * _BottomNavBarRatios.barHorizontalPad;

    final tabGap = tabRowBarWidth * _BottomNavBarRatios.tabGap;

    final inactiveTabWidth =
        tabRowBarWidth * _BottomNavBarRatios.inactiveTabWidth;

    final activeTabWidth = tabRowBarWidth * _BottomNavBarRatios.activeTabWidth;

    final tabHeight = actionButtonSize;

    final pillHeight = tabHeight * _BottomNavBarRatios.pillHeight;

    final pillRadius = tabHeight / 2;

    final iconSize = tabHeight * _BottomNavBarRatios.iconSize;

    final labelFontSize = tabHeight * _BottomNavBarRatios.labelFontSize;

    final tabInnerPad = tabHeight * _BottomNavBarRatios.tabInnerPad;

    final iconLabelGap = tabHeight * _BottomNavBarRatios.iconLabelGap;

    final pillLeft = widget.selectedIndex * (inactiveTabWidth + tabGap);

    return _NavLayout(
      bottomNavBarWidth: bottomNavBarWidth,
      tabRowBarWidth: tabRowBarWidth,
      tabRowTrailingIconGap: tabRowTrailingIconGap,
      actionButtonSize: actionButtonSize,
      barHorizontalPad: barHorizontalPad,
      tabGap: tabGap,
      inactiveTabWidth: inactiveTabWidth,
      activeTabWidth: activeTabWidth,
      tabHeight: tabHeight,
      pillHeight: pillHeight,
      pillRadius: pillRadius,
      iconSize: iconSize,
      labelFontSize: labelFontSize,
      tabInnerPad: tabInnerPad,
      iconLabelGap: iconLabelGap,
      pillLeft: pillLeft,
    );
  }

  Widget _buildNavTabRow(AppColorsExtension? colors, _NavLayout layout) {
    return Container(
      width: layout.tabRowBarWidth,
      padding: EdgeInsets.symmetric(horizontal: layout.barHorizontalPad),
      decoration: BoxDecoration(
        color: colors?.backgroundDarkGray ??
            CoreBackgroundColors.backgroundDarkGray,
        borderRadius: BorderRadius.circular(60),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          _buildSlidingPill(colors, layout),
          _buildTabs(colors, layout),
        ],
      ),
    );
  }

  Widget _buildSlidingPill(AppColorsExtension? colors, _NavLayout layout) {
    return AnimatedPositioned(
      duration: widget.animationDuration,
      curve: Curves.easeOut,
      left: layout.pillLeft,
      width: layout.activeTabWidth,
      height: layout.pillHeight,
      child: Container(
        decoration: BoxDecoration(
          color: colors?.pageBackground ?? CoreBackgroundColors.pageBackground,
          border: Border.all(
              color: colors?.lineMid ?? CoreBorderColors.lineMid, width: 2),
          borderRadius: BorderRadius.circular(layout.pillRadius),
        ),
      ),
    );
  }

  Widget _buildTabs(AppColorsExtension? colors, _NavLayout layout) {
    return Row(
      children: [
        for (var index = 0; index < widget.tabs.length; index++) ...[
          _buildTab(colors, layout, index),
          if (index != widget.tabs.length - 1) SizedBox(width: layout.tabGap),
        ],
      ],
    );
  }

  Widget _buildTab(AppColorsExtension? colors, _NavLayout layout, int index) {
    final isActive = index == widget.selectedIndex;
    final width = isActive ? layout.activeTabWidth : layout.inactiveTabWidth;

    return AnimatedContainer(
      duration: widget.animationDuration,
      curve: Curves.easeOut,
      width: width,
      height: layout.tabHeight,
      padding: EdgeInsets.symmetric(horizontal: layout.tabInnerPad),
      child: InkWell(
        borderRadius: BorderRadius.circular(layout.pillRadius),
        onTap: () => widget.onTabSelected(index),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CoreIconWidget(
              icon: widget.tabs[index].icon,
              size: layout.iconSize,
              color: isActive
                  ? colors?.iconDark ?? CoreIconColors.dark
                  : colors?.iconGrayMid ?? CoreIconColors.grayMid,
            ),
            AnimatedSwitcher(
              duration: widget.animationDuration,
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeOut,
              layoutBuilder: (currentChild, previousChildren) => Stack(
                alignment: Alignment.centerLeft,
                children: [
                  for (final prev in previousChildren)
                    Opacity(opacity: 0.2, child: prev),
                  if (currentChild != null) currentChild,
                ],
              ),
              transitionBuilder: (child, anim) =>
                  FadeTransition(opacity: anim, child: child),
              child: isActive
                  ? Padding(
                      key: ValueKey('active-$index'),
                      padding: EdgeInsets.only(left: layout.iconLabelGap),
                      child: Text(
                        widget.tabs[index].label,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: TextStyle(
                          fontSize: layout.labelFontSize,
                          color: colors?.textLink ?? CoreTextColors.link,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(key: ValueKey('inactive')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrailingICon(AppColorsExtension? colors, _NavLayout layout) {
    return Container(
      width: layout.actionButtonSize,
      height: layout.actionButtonSize,
      decoration: BoxDecoration(
        color: colors?.backgroundDarkGray ??
            CoreBackgroundColors.backgroundDarkGray,
        borderRadius: BorderRadius.circular(layout.actionButtonSize / 2),
      ),
      child: Center(
        child: CoreIconWidget(
          icon: CoreIcons.calculator,
          color: colors?.iconWhite ?? CoreIconColors.white,
          size: layout.actionButtonSize *
              (_BaseBottomNavBarDimensions.baseIconSize /
                  _BaseBottomNavBarDimensions.baseActionButton),
          onTap: widget.onActionButtonPressed,
        ),
      ),
    );
  }
}

/// Design tokens / reference dimensions for the bottom navigation bar.
/// Values are based on design specs (e.g., from Figma) and used for scaling.
class _BaseBottomNavBarDimensions {
  static const double baseBottomNavBarWidth = 328;
  static const double baseTabRowWidth = 268;
  static const double baseActionButton = 52;
  static const double baseInactiveTabWidth = 40;
  static const double baseActiveTabWidth = 124;
  static const double baseTabHeight = 52;
  static const double basePillHeight = 40;
  static const double baseIconSize = 24;
  static const double baseLabelFontSize = 12;
  static const double baseTabRowTrailingIconGap = 8;
  static const double baseTabInnerPad = 8;
  static const double baseTabRowBarHorizontalPad = 6;
  static const double baseTabGap = 4;
  static const double baseIconLabelGap = 4;
}

/// Precomputed ratios to avoid repeated divisions at runtime.
class _BottomNavBarRatios {
  // Relative to bottom nav bar (content) width
  static const double tabRowWidth =
      _BaseBottomNavBarDimensions.baseTabRowWidth /
          _BaseBottomNavBarDimensions.baseBottomNavBarWidth;
  static const double trailingIconGap =
      _BaseBottomNavBarDimensions.baseTabRowTrailingIconGap /
          _BaseBottomNavBarDimensions.baseBottomNavBarWidth;
  static const double actionButtonSize =
      _BaseBottomNavBarDimensions.baseActionButton /
          _BaseBottomNavBarDimensions.baseBottomNavBarWidth;

  // Relative to tab row bar width
  static const double barHorizontalPad =
      _BaseBottomNavBarDimensions.baseTabRowBarHorizontalPad /
          _BaseBottomNavBarDimensions.baseTabRowWidth;
  static const double tabGap = _BaseBottomNavBarDimensions.baseTabGap /
      _BaseBottomNavBarDimensions.baseTabRowWidth;
  static const double inactiveTabWidth =
      _BaseBottomNavBarDimensions.baseInactiveTabWidth /
          _BaseBottomNavBarDimensions.baseTabRowWidth;
  static const double activeTabWidth =
      _BaseBottomNavBarDimensions.baseActiveTabWidth /
          _BaseBottomNavBarDimensions.baseTabRowWidth;

  // Relative to tab height
  static const double pillHeight = _BaseBottomNavBarDimensions.basePillHeight /
      _BaseBottomNavBarDimensions.baseTabHeight;
  static const double iconSize = _BaseBottomNavBarDimensions.baseIconSize /
      _BaseBottomNavBarDimensions.baseTabHeight;
  static const double labelFontSize =
      _BaseBottomNavBarDimensions.baseLabelFontSize /
          _BaseBottomNavBarDimensions.baseTabHeight;
  static const double tabInnerPad =
      _BaseBottomNavBarDimensions.baseTabInnerPad /
          _BaseBottomNavBarDimensions.baseTabHeight;
  static const double iconLabelGap =
      _BaseBottomNavBarDimensions.baseIconLabelGap /
          _BaseBottomNavBarDimensions.baseTabHeight;
}

/// Holds all computed layout values derived from the available width.
class _NavLayout {
  final double bottomNavBarWidth;
  final double tabRowBarWidth;
  final double tabRowTrailingIconGap;
  final double actionButtonSize;
  final double barHorizontalPad;
  final double tabGap;
  final double inactiveTabWidth;
  final double activeTabWidth;
  final double tabHeight;
  final double pillHeight;
  final double pillRadius;
  final double iconSize;
  final double labelFontSize;
  final double tabInnerPad;
  final double iconLabelGap;
  final double pillLeft;

  const _NavLayout({
    required this.bottomNavBarWidth,
    required this.tabRowBarWidth,
    required this.tabRowTrailingIconGap,
    required this.actionButtonSize,
    required this.barHorizontalPad,
    required this.tabGap,
    required this.inactiveTabWidth,
    required this.activeTabWidth,
    required this.tabHeight,
    required this.pillHeight,
    required this.pillRadius,
    required this.iconSize,
    required this.labelFontSize,
    required this.tabInnerPad,
    required this.iconLabelGap,
    required this.pillLeft,
  });
}
