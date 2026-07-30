import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

class AppBarShowcaseScreen extends StatelessWidget {
  const AppBarShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CoreAppBar(titleText: 'App Bar Showcase'),
      body: ListView(
        padding: const EdgeInsets.all(CoreSpacing.space4),
        children: [
          const _Section(
            title: 'Flat bar, no shadow',
            description:
                'Sits flush on the page background. Auth screens use this '
                'shape. No back button is implied — a screen that needs a '
                'close or back affordance passes one as leading.',
            bar: CoreAppBar(
              titleText: 'Reset password',
              elevation: CoreAppBarElevation.none,
            ),
          ),
          _Section(
            title: 'Title and action',
            description:
                'Centered title with padding. Padding is added to the '
                'preferred size, so the content box keeps its full height.',
            bar: CoreAppBar(
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
            ),
          ),
          _Section(
            title: 'Custom title row',
            description:
                'An arbitrary title widget — here a project selector with an '
                'icon cluster trailing it.',
            bar: CoreAppBar(
              height: CoreSpacing.space16,
              titleSpacing: 0,
              padding: const EdgeInsets.only(
                left: CoreSpacing.space1,
                right: CoreSpacing.space4,
              ),
              title: const Row(
                children: [
                  Flexible(
                    child: Text(
                      'Riverside Tower',
                      overflow: TextOverflow.ellipsis,
                    ),
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
            ),
          ),
          _Section(
            title: 'Back button with project title',
            description:
                'A project detail screen. The back icon is passed explicitly '
                'as leading and owns space3 padding around a 24pt glyph, so '
                'its tap target measures 48x48.',
            bar: CoreAppBar(
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
            ),
          ),
          const _Section(
            title: 'Material elevation',
            description:
                'Uses Material elevation instead of a CoreShadows shadow, for '
                'surfaces that must match an elevated Material sibling.',
            bar: CoreAppBar(
              titleText: 'New Project',
              elevation: CoreAppBarElevation.material,
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.description,
    required this.bar,
  });

  final String title;
  final String description;
  final CoreAppBar bar;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).coreColors;
    final typography = Theme.of(context).coreTypography;

    return Padding(
      padding: const EdgeInsets.only(bottom: CoreSpacing.space8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: typography.titleMediumSemiBold
                .copyWith(color: colors.textHeadline),
          ),
          const SizedBox(height: CoreSpacing.space1),
          Text(
            description,
            style: typography.bodySmallRegular.copyWith(color: colors.textBody),
          ),
          const SizedBox(height: CoreSpacing.space3),
          SizedBox(
            height: bar.preferredSize.height,
            child: bar,
          ),
        ],
      ),
    );
  }
}
