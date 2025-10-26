import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

class TooltipShowcaseScreen extends StatelessWidget {
  const TooltipShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tooltip Components'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tooltip Variants',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),

            // Default Tooltip
            _buildTooltipSection(
              context,
              title: 'Default Tooltip',
              description: 'Standard tooltip with no arrow',
              child: CoreTooltip.none(
                message: 'This is a default tooltip',
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('Hover or tap me'),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Arrow Tooltip
            _buildTooltipSection(
              context,
              title: 'Tooltip with Arrow',
              description: 'Tooltip positioned above with arrow pointing down',
              child: CoreTooltip.top(
                message: 'This is a tooltip above the target',
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('Hover or tap me'),
                ),
              ),
            ),

            const SizedBox(height: 48),
            Text(
              'Tooltip Positions',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),

            // Position examples grid
            Center(
              child: SizedBox(
                width: 300,
                height: 300,
                child: Stack(
                  children: [
                    // Center Target
                    Positioned(
                      left: 125,
                      top: 125,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(child: Text('Target')),
                      ),
                    ),

                    // Top Tooltip (positioned above with arrow pointing down)
                    Positioned(
                      left: 125,
                      top: 50,
                      child: CoreTooltip.top(
                        message: 'Tooltip above',
                        child: Container(
                          width: 50,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade200,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Center(child: Text('Top')),
                        ),
                      ),
                    ),

                    // Bottom Tooltip (positioned below with arrow pointing up)
                    Positioned(
                      left: 125,
                      top: 220,
                      child: CoreTooltip.bottom(
                        message: 'Tooltip below',
                        child: Container(
                          width: 50,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.green.shade200,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Center(child: Text('Bottom')),
                        ),
                      ),
                    ),

                    // Left Tooltip (positioned left with arrow pointing right)
                    Positioned(
                      left: 50,
                      top: 135,
                      child: CoreTooltip.left(
                        message: 'Tooltip left',
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.orange.shade200,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Column(
                            children: [
                              const Center(child: Text('Left')),
                              const Center(child: Text('Left')),
                              const Center(child: Text('Left')),
                              const Center(child: Text('Left')),
                              const Center(child: Text('Left')),
                              const Center(child: Text('Left')),
                              const Center(child: Text('Left')),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Right Tooltip (positioned right with arrow pointing left)
                    Positioned(
                      left: 200,
                      top: 135,
                      child: CoreTooltip.right(
                        message: 'Tooltip right',
                        child: Container(
                          width: 50,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.purple.shade200,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Center(child: Text('Right')),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 48),
            Text(
              'Icon Tooltips',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),

            _buildTooltipSection(
              context,
              title: 'Common Use Case',
              description: 'Tooltips used with icons for helpful hints',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  _IconTooltip(
                      icon: Icons.info, color: Colors.blue, label: 'Info'),
                  _IconTooltip(
                      icon: Icons.help, color: Colors.green, label: 'Help'),
                  _IconTooltip(
                      icon: Icons.settings,
                      color: Colors.orange,
                      label: 'Settings'),
                  _IconTooltip(
                      icon: Icons.warning, color: Colors.red, label: 'Warning'),
                ],
              ),
            ),

            const SizedBox(height: 48),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Usage Notes:',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                      '• Use named constructors: .top(), .bottom(), .left(), .right(), .none()'),
                  const Text('• On desktop: Hover to show, move away to hide'),
                  const Text('• On mobile: Tap to show/hide'),
                  const Text(
                      '• Tooltips automatically position near their trigger'),
                  const Text('• Use sparingly for essential information only'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTooltipSection(
    BuildContext context, {
    required String title,
    required String description,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
        ),
        const SizedBox(height: 16),
        Center(child: child),
      ],
    );
  }
}

class _IconTooltip extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;

  const _IconTooltip({
    required this.icon,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return CoreTooltip.top(
      message: label,
      child: Icon(icon, color: color, size: 32),
    );
  }
}
