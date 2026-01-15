import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

class LoadingIndicatorShowcaseScreen extends StatelessWidget {
  const LoadingIndicatorShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Core Loading Indicator Showcase')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Loading Indicator Types',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),

            Text(
              'Default Size (80px)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            const SizedBox(
              height: 150,
              child: Center(
                child: CoreLoadingIndicator(),
              ),
            ),

            const SizedBox(height: 30),

            // Small Size Section
            Text(
              'Small Size (40px)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            const SizedBox(
              height: 100,
              child: Center(
                child: CoreLoadingIndicator(size: 40),
              ),
            ),

            const SizedBox(height: 30),

            // Large Size Section
            Text(
              'Large Size (120px)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            const SizedBox(
              height: 200,
              child: Center(
                child: CoreLoadingIndicator(size: 120),
              ),
            ),

            const SizedBox(height: 30),

            Text(
              'Custom BoxFit (cover)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            const SizedBox(
              height: 150,
              child: Center(
                child: CoreLoadingIndicator(
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 30),

            Text(
              'Custom BoxFit (fill)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            const SizedBox(
              height: 150,
              child: Center(
                child: CoreLoadingIndicator(
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
