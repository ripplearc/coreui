import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

/// A showcase screen demonstrating the available [CoreWritingDots] variants
/// and sizes.
class WritingDotsShowcaseScreen extends StatelessWidget {
  const WritingDotsShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Core Writing Dots Showcase')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(CoreSpacing.space5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Writing Dots Variants',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: CoreSpacing.space5),

            // Default size
            Text(
              'Default Size (space3 / 12px)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: CoreSpacing.space2),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(CoreSpacing.space8),
                child: Center(
                  child: CoreWritingDots(),
                ),
              ),
            ),

            const SizedBox(height: CoreSpacing.space8),

            // Chat bubble size
            Text(
              'Chat Bubble size (space5 / 20px)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: CoreSpacing.space2),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(CoreSpacing.space8),
                child: Center(
                  child: CoreWritingDots(size: CoreSpacing.space5),
                ),
              ),
            ),

            const SizedBox(height: CoreSpacing.space8),

            // Large size
            Text(
              'Large Size (space10 / 40px)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: CoreSpacing.space2),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(CoreSpacing.space8),
                child: Center(
                  child: CoreWritingDots(size: CoreSpacing.space10),
                ),
              ),
            ),

            const SizedBox(height: CoreSpacing.space12),

            // Chat context
            Text(
              'Inline with Text',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: CoreSpacing.space2),
            Row(
              children: [
                const Text('AI is composing message'),
                const SizedBox(width: CoreSpacing.space1),
                const CoreWritingDots(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
