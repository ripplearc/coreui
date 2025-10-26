import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';

class CoreTabs extends StatefulWidget {
  final List<String> tabs;
  final int initialIndex;
  final ValueChanged<int>? onChanged;

  const CoreTabs({
    super.key,
    required this.tabs,
    this.initialIndex = 0,
    this.onChanged,
  });

  @override
  State<CoreTabs> createState() => _CoreTabsState();
}

class _CoreTabsState extends State<CoreTabs>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    );

    _controller.addListener(() {
      if (_controller.indexIsChanging) {
        widget.onChanged?.call(_controller.index);
      }
    });
  }

  @override
  void didUpdateWidget(covariant CoreTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tabs.length != widget.tabs.length) {
      _controller.dispose();
      _controller = TabController(
        length: widget.tabs.length,
        vsync: this,
        initialIndex: widget.initialIndex,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: TabBar(
        enableFeedback: false,
        controller: _controller,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        indicatorColor: CoreBorderColors.tabsHighlight,
        indicatorWeight: CoreSpacing.space1,
        labelColor: CoreTextColors.headline,
        unselectedLabelColor: CoreTextColors.body,
        labelStyle:
            CoreTypography.bodyMediumSemiBold(color: CoreTextColors.headline),
        unselectedLabelStyle:
            CoreTypography.bodyMediumRegular(color: CoreTextColors.body),
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
