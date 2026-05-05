import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

class SearchBoxShowcaseScreen extends StatefulWidget {
  const SearchBoxShowcaseScreen({super.key});

  @override
  State<SearchBoxShowcaseScreen> createState() =>
      _SearchBoxShowcaseScreenState();
}

class _SearchBoxShowcaseScreenState extends State<SearchBoxShowcaseScreen> {
  final TextEditingController _controller =
      TextEditingController(text: 'Roof cost');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final typography = Theme.of(context).coreTypography;

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Box', style: typography.bodyLargeSemiBold),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(CoreSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Default', style: typography.bodyLargeSemiBold),
            const SizedBox(height: CoreSpacing.space2),
            const CoreSearchBox(
              hintText: 'Search for Calculation and cost',
            ),
            const SizedBox(height: CoreSpacing.space6),
            Text('Active (with text)', style: typography.bodyLargeSemiBold),
            const SizedBox(height: CoreSpacing.space2),
            CoreSearchBox(
              controller: _controller,
              hintText: 'Search for Calculation and cost',
            ),
            const SizedBox(height: CoreSpacing.space6),
            Text('Disabled', style: typography.bodyLargeSemiBold),
            const SizedBox(height: CoreSpacing.space2),
            const CoreSearchBox(
              enabled: false,
              hintText: 'Search for Calculation and cost',
            ),
            const SizedBox(height: CoreSpacing.space6),
            Text('Disabled Active', style: typography.bodyLargeSemiBold),
            const SizedBox(height: CoreSpacing.space2),
            CoreSearchBox(
              enabled: false,
              controller: TextEditingController(text: 'Roof cost'),
              hintText: 'Search for Calculation and cost',
            ),
          ],
        ),
      ),
    );
  }
}
