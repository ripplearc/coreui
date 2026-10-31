import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

/// A horizontal tab selection component that displays multiple options
/// with smooth animated transitions between selections.
///
/// This is a **controlled** widget — the parent is responsible for tracking
/// the selected index and passing it via [selectedIndex]. When the user taps
/// a tab, [onChanged] is called with the new index, and the parent should
/// update [selectedIndex] accordingly to reflect the change visually.
///
/// Example:
/// ```dart
/// CoreSelectButton(
///   tabs: ['Tab 1', 'Tab 2', 'Tab 3'],
///   selectedIndex: _selectedIndex,
///   onChanged: (index) => setState(() => _selectedIndex = index),
/// )
/// ```
class CoreSelectButton extends StatelessWidget {
  /// The list of tab labels to display.
  final List<String> tabs;

  /// The index of the currently selected tab (0-based).
  ///
  /// This is a controlled property — the parent must update this value
  /// in response to [onChanged] to reflect the new selection visually.
  final int selectedIndex;

  /// Called when the user taps a tab. The tapped tab's index is passed
  /// as the argument. If null, taps are still registered but have no effect.
  final ValueChanged<int>? onChanged;

  const CoreSelectButton({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    this.onChanged,
  })  : assert(selectedIndex >= 0, 'selectedIndex must be >= 0'),
        assert(tabs.length == 0 || selectedIndex < tabs.length,
            'selectedIndex must be < tabs.length');

  /// Key of the tap target of the segment at [index], at least 48 x 48 dp.
  static Key tapTargetKey(int index) =>
      Key('core_select_button_tap_target_$index');

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    const trackInset = (CoreSpacing.space12 - CoreSpacing.space10) / 2;

    return Stack(
      children: [
        Positioned.fill(
          top: trackInset,
          bottom: trackInset,
          child: Container(
            key: const Key('core_select_button_outer'),
            decoration: BoxDecoration(
              color: colors.pageBackground,
              borderRadius: BorderRadius.circular(CoreSpacing.space12),
              boxShadow: CoreShadows.small,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: CoreSpacing.space1),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                tabs.isEmpty ? 0 : tabs.length * 2 - 1,
                (index) {
                  if (index.isOdd) {
                    return const SizedBox(width: CoreSpacing.space1);
                  }
                  final tabIndex = index ~/ 2;
                  return _Segment(
                    index: tabIndex,
                    label: tabs[tabIndex],
                    selected: tabIndex == selectedIndex,
                    onTap: () {
                      if (tabIndex != selectedIndex) {
                        onChanged?.call(tabIndex);
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Segment extends StatefulWidget {
  const _Segment({
    required this.index,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final int index;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_Segment> createState() => _SegmentState();
}

class _SegmentState extends State<_Segment> {
  static const Duration _transitionDuration = Duration(milliseconds: 200);
  static const double _segmentHeight = CoreSpacing.space8;
  static const double _bodyMediumLineHeight = CoreSpacing.space5;
  static const double _verticalPadding =
      (_segmentHeight - _bodyMediumLineHeight) / 2;
  static const double _focusWidth = 2;

  bool _isPressed = false;
  bool _isFocused = false;

  Color _fill(AppColorsExtension colors) {
    if (widget.selected) return colors.tabsHighlight;
    return _isPressed ? colors.backgroundGrayMid : colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final focusInset = _isFocused ? _focusWidth : 0.0;

    return Semantics(
      selected: widget.selected,
      button: true,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          key: CoreSelectButton.tapTargetKey(widget.index),
          onTap: widget.onTap,
          onHighlightChanged: (isPressed) =>
              setState(() => _isPressed = isPressed),
          onFocusChange: (isFocused) => setState(() => _isFocused = isFocused),
          splashFactory: NoSplash.splashFactory,
          overlayColor: WidgetStateProperty.all(colors.transparent),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: CoreSpacing.space12,
              minHeight: CoreSpacing.space12,
            ),
            child: Center(
              widthFactor: 1,
              heightFactor: 1,
              child: AnimatedContainer(
                key: Key('core_select_button_segment_${widget.index}'),
                duration: _transitionDuration,
                curve: Curves.easeOut,
                padding: EdgeInsets.symmetric(
                  horizontal: CoreSpacing.space4 - focusInset,
                  vertical: _verticalPadding - focusInset,
                ),
                decoration: BoxDecoration(
                  color: _fill(colors),
                  borderRadius: BorderRadius.circular(CoreSpacing.space12),
                  border: _isFocused
                      ? Border.all(
                          color: colors.lineHighlight,
                          width: _focusWidth,
                        )
                      : null,
                  boxShadow: widget.selected ? CoreShadows.medium : null,
                ),
                child: Text(
                  widget.label,
                  style: widget.selected
                      ? typography.bodyMediumSemiBold.copyWith(
                          // tabsHighlight is bright cyan in both modes; use dark
                          // text in dark mode (textInverse = gray900) so it
                          // passes contrast.
                          color:
                              isDark ? colors.textInverse : colors.textHeadline,
                        )
                      : typography.bodyMediumRegular.copyWith(
                          color: colors.textBody,
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
