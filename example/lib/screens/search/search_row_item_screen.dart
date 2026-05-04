import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

class SearchRowItemShowcaseScreen extends StatelessWidget {
  const SearchRowItemShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final typography = AppTypographyExtension.of(context);
    final colors = AppColorsExtension.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Core Search Row Item Showcase')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(CoreSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recent Search', style: typography.titleMediumSemiBold),
            const SizedBox(height: CoreSpacing.space3),
            CoreSearchRowItem.recentSearch(
              text: '#Carpentry',
              onTap: () {},
              onTrailingTap: () {},
              trailingSemanticLabel: 'Use this search term',
            ),
            CoreSearchRowItem.recentSearch(
              text: '#Plumbing',
              onTap: () {},
              onTrailingTap: () {},
              trailingSemanticLabel: 'Use this search term',
            ),
            const SizedBox(height: CoreSpacing.space8),
            Text('Suggestion', style: typography.titleMediumSemiBold),
            const SizedBox(height: CoreSpacing.space3),
            CoreSearchRowItem.suggestion(
              text: '#Carpentry',
              query: 'Car',
              onTap: () {},
              onTrailingTap: () {},
              trailingSemanticLabel: 'Use this suggestion',
            ),
            CoreSearchRowItem.suggestion(
              text: 'Carparking cost',
              query: 'Car',
              onTap: () {},
              onTrailingTap: () {},
              trailingSemanticLabel: 'Use this suggestion',
            ),
            const SizedBox(height: CoreSpacing.space8),
            Text('Custom', style: typography.titleMediumSemiBold),
            const SizedBox(height: CoreSpacing.space3),
            CoreSearchRowItem(
              leadingIcon: CoreIcons.search,
              label: Text(
                'Custom label widget',
                style: typography.bodyLargeRegular
                    .copyWith(color: colors.textDark),
              ),
              onTap: () {},
              showTrailingIcon: false,
              semanticLabel: 'Custom row',
            ),
          ],
        ),
      ),
    );
  }
}
